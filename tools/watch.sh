#!/usr/bin/env bash

echo "Watching files..." 
inotifywait --monitor --recursive \
  --event modify --format "%w %f" \
  ./src/styles/ |
while read filename; do
  
  rm -rf dist
  mkdir dist

  ./tools/build.sh

done
