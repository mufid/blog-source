#!/bin/sh

if [ -d "gh" ]; then
  echo 'Continuing..'
else
  git clone git@github.com:mufid/mufid.github.com.git gh
fi


bundle exec rake generate
rm -rf gh/blog
cp -r public/* gh
cp -r source/.well-known gh
cd gh

git config user.name "Mufid - Codeship Deployer"
git config user.email "mufid@outlook.com"

git add .
git commit -m "site updated at $(date)"
git push origin master
cd ..
