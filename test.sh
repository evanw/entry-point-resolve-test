#!/bin/sh

cd src

run_tests () {
  echo
  echo
  echo
  echo ========== $1 ==========

  echo ----- $1: webpack -----
  ../node_modules/.bin/webpack build "$1" --mode production --no-stats || ../node_modules/.bin/webpack build "$1" --mode production && node dist/main.js

  echo ----- $1: rollup -----
  ../node_modules/.bin/rollup "$1" -p @rollup/plugin-node-resolve --silent | node

  echo ----- $1: parcel -----
  ../node_modules/.bin/parcel build "$1"

  echo ----- $1: esbuild -----
  ../node_modules/.bin/esbuild --bundle "$1" | node
}

run_tests 'pkg-import-require'
run_tests 'pkg-require'

run_tests 'pkg-module-main'
run_tests 'pkg-main'
