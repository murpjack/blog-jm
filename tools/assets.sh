#!/usr/bin/env bash

# Copy App manifest - used by Chrome ext
cp ./src/manifest.json ./dist

# Copy Assets
cp -r ./src/images ./dist/images
cp -r ./src/fonts ./dist/fonts
