#!/bin/bash

set -ex

if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
    echo "Usage: bash unshare_blocks.sh /path/to/shared_blocks/image"
    exit 1
fi

inputFile="$1"
outputFile="${inputFile%.img}-unshared.img"

simg2img "$inputFile" "$outputFile" || cp "$inputFile" "$outputFile"

e2fsck -y -f "$outputFile"
resize2fs "$outputFile" 5000M
e2fsck -E unshare_blocks -y -f "$outputFile"

e2fsck -f -y "$outputFile" || true
resize2fs -M "$outputFile"

blockCount=$(dumpe2fs -h "$outputFile" 2>/dev/null | grep "Block count:" | awk '{print $3}')
blockSize=$(dumpe2fs -h "$outputFile" 2>/dev/null | grep "Block size:" | awk '{print $3}')

newSize=$(( blockCount + (50*1024*1024 / blockSize) ))
e2fsck -f -y "$outputFile" || true
resize2fs "$outputFile" $newSize
