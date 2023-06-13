#!/bin/bash
BASEDIR=$(dirname "$0")
cd "$BASEDIR/.." || exit 1
PORTABLE=1 make shared_lib -j $(nproc) || exit 1
cp --no-dereference --preserve=links librocksdb.so* dist/rocksdb/usr/local/lib/
cp -r include/rocksdb dist/rocksdb/usr/local/include/
cd dist
strip -g rocksdb/usr/local/lib/librocksdb.so
rm rocksdb/usr/local/lib/.gitignore
rm rocksdb/usr/local/include/.gitignore
arch=$(uname -m)
if [ "$arch" == "aarch64" ]; then
  echo "Change architecture in control file"
  sed -i 's/amd64/arm64/g' rocksdb/DEBIAN/control
fi
dpkg-deb -Zxz -b rocksdb
