#!/usr/bin/env bash

srcExt=$1
destExt=$2

srcDir=$3

count=`find $srcDir -type f -name "*.$srcExt" | wc -l`

doneCount=0
errorsCount=0
okCount=0

shopt -s globstar
for file in "$srcDir"/**/*."$srcExt"; do
  echo "WORKING: ${file}"
  destFile="${file//.$srcExt/.mp4}"
  ffmpeg -y -loglevel warning -hide_banner -stats -i "$file" "$destFile"
  result=$?
  if [ $result == 0 ]; then
    okCount=$((okCount+1))
    echo "SUCCESS: ${file} to ${destFile}"
    rm "$file"
    echo "REMOVED: ${file}"
  else
    errorsCount=$((errorsCount+1))
    echo "FAILED: ${file}"
  fi
  doneCount=$((doneCount+1))
  echo "DONE: ${doneCount} out of ${count}"
done

nextcloud.occ files:scan --all

echo "TOTAL: ${doneCount} out of ${count}"
echo "FAILED: ${errorsCount}"
echo "PASSED: ${okCount}"
echo "Conversion from ${srcExt} to ${destExt} complete!"