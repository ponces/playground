#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

tmpDir="$TMPDIR/tdupdate"
baseBranch="android-16.0"
oldBranch="${baseBranch}.0_r1"
newBranch="${baseBranch}.0_r2"
manifest1="https://github.com/TrebleDroid/treble_manifest/raw/$baseBranch/manifest.xml"
manifest2="https://github.com/TrebleDroid/treble_manifest/raw/$baseBranch/replace.xml"

updateBranch() {
    curl -s -o /dev/null \
        -H "Authorization: token $GITHUB_API_TOKEN" \
        -X PATCH \
        -d "{ \"default_branch\": \"$2\" }" \
        "https://api.github.com/repos/TrebleDroid/$1"
}

updateRepo() {
    git clone ssh://git@github.com/TrebleDroid/"$1" -b "${oldBranch}-td" --single-branch
    pushd "$1" >/dev/null
    repo="$(git remote get-url origin | sed -nE 's;.*/[Tt]reble[Dd]roid/(.*);\1;p' | tr _ /)"
    git remote add aosp https://android.googlesource.com/"$repo"
    git fetch --tags aosp
    if [ -d "$tmpDir/treble_aosp" ]; then
        git checkout -b "${newBranch}-td" "${newBranch}" || git checkout "${newBranch}-td"
        git am "$tmpDir/treble_aosp/patches/trebledroid/$1/"*.patch
    else
        git checkout -b "${newBranch}-td" || git checkout "${newBranch}-td"
        GIT_SEQUENCE_EDITOR=: git rebase --autostash -i "$newBranch"
    fi
    git push -f origin "${newBranch}-td"
    updateBranch "$1" "${newBranch}-td"
    popd >/dev/null
}

validateRepo() {
    git clone -q ssh://git@github.com/TrebleDroid/"$1" -b "${newBranch}-td" --single-branch
    pushd "$1" >/dev/null
    repo="$(git remote get-url origin | sed -nE 's;.*/[Tt]reble[Dd]roid/(.*);\1;p' | tr _ /)"
    git remote add aosp https://android.googlesource.com/"$repo"
    git fetch --tags aosp >/dev/null
    tag="$(git describe --abbrev=0 --match=android-1*)"
    printf "%-45s %-20s\n" "$1" "$tag"
    popd >/dev/null
}

rm -rf "$tmpDir"
mkdir -p "$tmpDir"
pushd "$tmpDir" >/dev/null

#git clone -q https://github.com/ponces/treble_aosp -b wip

#curl -sfSL "$manifest1" -o manifest.xml
#grep -oP "platform_\w+" manifest.xml | while read repo; do
#    #updateRepo "$repo"
#    validateRepo "$repo"
#done

curl -sfSL "$manifest2" -o manifest.xml
grep -oP "platform_\w+" manifest.xml | while read repo; do
    #updateRepo "$repo"
    validateRepo "$repo"
done

popd >/dev/null
rm -rf "$tmpDir"
