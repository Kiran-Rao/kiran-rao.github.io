#!/bin/zsh

rm -rf _site/
bundle exec jekyll serve --source docs --incremental
