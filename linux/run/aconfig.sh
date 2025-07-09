#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

clean() {
    rm -rf "$TMPDIR"/repo.zip
    rm -rf "$TMPDIR"/repo
}

clean
url="https://github.com/$1/$2/archive/$3.zip"
if [ -z "$3" ]; then
    url="https://api.github.com/repos/$1/$2/zipball"
fi
curl -sfSL "$url" -o "$TMPDIR"/repo.zip
unzip -q "$TMPDIR"/repo.zip -d "$TMPDIR"/repo

pushd "$TMPDIR"/repo/*/release/aconfig/* >/dev/null
for dir in */; do
    if [ -d "$dir" ]; then
        pushd "$dir" >/dev/null
        sed -i 's/*.textproto/*_flag_values.textproto/g' Android.bp
        sed -i 's/aconfig-values-/aconfig-values-platform_build_release-/g' Android.bp
        sed -i 's/platform_build_release-platform_build_release/platform_build_release/g' Android.bp
        for file in *.textproto; do
            if [[ "$file" == *"_flag_values.textproto" ]]; then
                continue
            fi
            mv "$file" "${file%.textproto}_flag_values.textproto"
        done
        popd >/dev/null
    fi
done
popd >/dev/null

if [ -d aconfig ]; then
    cp -r "$TMPDIR"/repo/*/release/aconfig/* ./aconfig/
elif [ -d release ]; then
    cp -r "$TMPDIR"/repo/*/release/* ./release/
else
    cp -r "$TMPDIR"/repo/*/release ./release
fi

clean
