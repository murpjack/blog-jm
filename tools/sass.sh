#!/usr/bin/env bash

# Recompile styles
echo "Compiling css now."  
sass --no-source-map ./styles/index.scss ./public/style.css |
# Prettier doesn't work in the editor w/o a local instance 
# prettier --write ./styles/
# TODO: Add an error check before echo says "success"
echo "CSS compiled successfully."
