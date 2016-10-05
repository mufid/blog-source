#!/bin/sh

bundle exec rake generate
rm -rf gh/blog
cp -r public/* gh
cd gh
git add .
git commit -m "site updated at $(date)"
git push origin master
cd ..
