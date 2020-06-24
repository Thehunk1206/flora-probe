#!/bin/bash
MAIN_PUBSPEC="org.floraprobe/pubspec.yaml"
CURRENT_VERSION="$(sed -n -e 's/^.*version: //p' ${MAIN_PUBSPEC})"

echo "Current version: v$CURRENT_VERSION"
echo "Latest release: $(git describe --abbrev=0)"
echo
printf "Current contributors: \n"
contributors=$(git shortlog -sne --all)
echo "$contributors"
echo
echo "Flutter project size: $(du -sh ./org.floraprobe)"
git gc --quiet
git_object_count=$(git count-objects -vH)
SIZE_PACK=$(sed -n -e 's/^.*size-pack: //p' <<< "$git_object_count")
echo "Repository size: $SIZE_PACK (exact disk space consumed)"