#! /bin/bash
#
# Script to clone, build and copy the official web client to serve it from
# bitwardenx and be able to use the web vault
#

set -e

rm -rf ./tmp/web
git clone  --recurse-submodules https://github.com/bitwarden/web.git ./tmp/web
cd ./tmp/web
npm install && npm run dist
cp -r build ../../priv/static
