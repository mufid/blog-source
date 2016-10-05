#!/bin/sh

if [ -d "gh" ]; then
else
  git clone git@github.com:mufid/mufid.github.com.git gh
fi


bundle exec rake generate
rm -rf gh/blog
cp -r public/* gh
cd gh
git add .
git commit -m "site updated at $(date)"
git push origin master
cd ..
