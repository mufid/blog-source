---
layout: post
title: "Benchmarking ActiveRecord Load: #find_in_batches (or #find_each) and #each For Processing Bulk Records"
date: 2016-12-15 15:00
comments: true
lang: en
---

Currently i am building a small enough Rails application, but somehow on some
endpoints, we process and iterate 10k records on a single request. Sure i am 
caching all of those requests, but 870ms response time for first request is 
still unacceptable for me.

Some says it is problem with the JSON rendering. Then i installed oj gem, but
the request didn't get a noticable faster rendering. And then i deleted all
JSON rendering, the request still on 800-ish ms response time. All of these
findings suggest me that the problem is in the model / query itself.

When processing much records, it would be very easy to get out of memory
problem if it is being done incorrectly. By default, when using `#each` method,
Rails will load *all records* with specified filters (`where`, scope, etc)
*into memory*. Thus, Rails' recommendation is to use `find_each` command,
which internally using `find_in_batches` method. `find_in_batches` will not
try to load all matched records in memory. Instead, it will load records by
batch.

The thing is, i was using `find_each`, but somehow, i was stuck on 2 seconds
request. I think the problem was the `find_in_batches` so i changed the
implementation to use `find_in_batches`. However, this way didn't help me.
I still got 800-ish ms response time.

Somehow, i was curious, was the problem is inside the find_in_batches? Or
is it in the Ruby yield and loop? I am not sure since computer nowadays have
gigahertz of computing power. However, i did the benchmark and the benchmark
looks like this:

    class Metadata < ApplicationRecord
      def build_summary
        points = Metadata.where('retrieved_at > \'2000-01-01 00:00:00\'')

        logger.info 'Benchmark: #find_in_batches'
        logger.info begin
          Benchmark.measure do
            points.find_in_batches do |dp|
              logger.info "End finding batches. Found: #{dp.count}"
            end
          end
        end
  
        logger.info 'Benchmark: #all'
        logger.info begin
          Benchmark.measure do
            points.each do |dp|
              # yield nothing
            end
          end
        end
  
        logger.info 'Benchmark: 10k loop'
        logger.info begin
          Benchmark.measure do
            (1..10_000).each do |i|
              # yield no one
            end
          end
        end
      end
    end

I added 'normal' loop, just curious if the problem is inside the
Ruby's interpreter.

Here is the result. I did this on Dual Core 4 GB RAM Virtualbox inside Intel
Core i5 with 16 GB RAM. I used Ruby 2.3.1 and Rails 5.0.0.1. For database, i
use PostgreSQL 9.6.

    I, [2016-12-15T14:56:37.463516 #28376]  INFO -- : Benchmark: #find_in_batches
    I, [2016-12-15T14:56:37.511837 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.516353 #28376] DEBUG -- :   Metadata Load (3.2ms)
    I, [2016-12-15T14:56:37.550252 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.553774 #28376] DEBUG -- :   Metadata Load (2.8ms)
    I, [2016-12-15T14:56:37.596984 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.603011 #28376] DEBUG -- :   Metadata Load (5.4ms)
    I, [2016-12-15T14:56:37.645731 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.652892 #28376] DEBUG -- :   Metadata Load (6.5ms)
    I, [2016-12-15T14:56:37.692978 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.696923 #28376] DEBUG -- :   Metadata Load (3.1ms)
    I, [2016-12-15T14:56:37.738265 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.742807 #28376] DEBUG -- :   Metadata Load (3.5ms)
    I, [2016-12-15T14:56:37.787560 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.792086 #28376] DEBUG -- :   Metadata Load (3.1ms)
    I, [2016-12-15T14:56:37.828058 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.836220 #28376] DEBUG -- :   Metadata Load (7.2ms)
    I, [2016-12-15T14:56:37.907940 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.911302 #28376] DEBUG -- :   Metadata Load (2.8ms)
    I, [2016-12-15T14:56:37.943847 #28376]  INFO -- : End finding batches. Found: 1000
    D, [2016-12-15T14:56:37.945335 #28376] DEBUG -- :   Metadata Load (0.9ms)
    I, [2016-12-15T14:56:37.949258 #28376]  INFO -- : End finding batches. Found: 157
    I, [2016-12-15T14:56:37.949421 #28376]  INFO -- :   0.330000   0.010000   0.340000 (  0.485759)
    I, [2016-12-15T14:56:37.949613 #28376]  INFO -- : Benchmark: #all
    D, [2016-12-15T14:56:37.991020 #28376] DEBUG -- :   Metadata Load (40.9ms)
    I, [2016-12-15T14:56:38.218292 #28376]  INFO -- :   0.220000   0.000000   0.220000 (  0.268597)
    I, [2016-12-15T14:56:38.218840 #28376]  INFO -- : Benchmark: 10k loop
    I, [2016-12-15T14:56:38.219272 #28376]  INFO -- :   0.000000   0.000000   0.000000 (  0.000362)

Sure it is not the Ruby's interpreter problem since vanilla 10k loop only took
0.3 msec. Comparable to native speed, huh? But we found several interesting
findings:

- using #each is faster than using #find_in_batches (480 ms to 260 ms)
- ... What "{Model} Load (some ms)" means? It does not even reflect the real
  load time. "Metadata Load 40.9 ms", meanwhile the real load time is 268 ms.
  If we compare from logger timestamp, it is also around 268 ms (38.218 - 37.949).
  Seems like internally they use different measurement tip.
- For each group in find_in_batches, the "Metadata Load" itself does not reflect
  the real time to yield the method. If we compare each DEBUG line, it will be
  around 40ms (e.g.: Look 37.550252 - 37.516353), pretty far from 3.2ms.

So what is my solution for processing 10k records? I don't know. The page itself
will rarely change, so caching the request will help it much. But i am still
curious, why processing only 10k records can took up to 800ms.

Also, i am still curious why "Model Load" says faster than the time it is
actually need. It took 40ms between yield but it says loaded in 3.2ms.
