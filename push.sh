#!/bin/sh

echo "Commiting..."
git add .
git commit -m "post article"

echo "Generating site..."
hugo -D

echo "Push to master..."
git push origin master

echo "sync to my site..."
rsync -auz --delete public/ root@101.42.23.128:/home/solejay/blog

echo "Finish"
