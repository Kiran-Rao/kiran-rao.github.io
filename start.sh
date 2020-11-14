#!/bin/zsh

rm -rf _site/
bundler exec jekyll serve --source docs --incremental