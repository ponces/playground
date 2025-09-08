#!/bin/bash

echo
echo "---------------------------------"
echo "      Magisk Module Builder      "
echo "               by                "
echo "             ponces              "
echo "---------------------------------"

set -e

moduleName="$1"
moduleId=$(echo $moduleName | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
contentDir="$PWD/content"
outDir="$PWD/out"

if [ "$#" -ne 1 ]; then
    echo
    echo "Usage: bash magisk.sh <module name>"
    exit 1
fi

if [ -z "$contentDir" ] || [ ! -d "$contentDir" ] || [ -z "$(ls -A $contentDir)" ]; then
    echo
    echo "Content directory does not exist or is empty!"
    echo
    exit 1
fi

if [ -z "$moduleName" ]; then
    echo
    echo "No module name was provided!"
    echo
    exit 1
fi

mkdir -p "$outDir"/META-INF/com/google/android
cp -r "$contentDir"/* "$outDir"

echo "#MAGISK" > "$outDir"/META-INF/com/google/android/updater-script
curl -sfSL https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh -o "$outDir"/META-INF/com/google/android/update-binary

{
    echo "id=$moduleId"
    echo "name=$moduleName"
    echo "version=1.0.0"
    echo "versionCode=100"
    echo "author=ponces"
    echo "description=$moduleName"
} > "$outDir"/module.prop

pushd "$outDir" >/dev/null
zip -qr "$outDir"/../"$moduleId".zip *
popd >/dev/null

rm -rf $outDir
