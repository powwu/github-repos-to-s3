#!/usr/bin/env bash

read -p "GitHub username: " USER < /dev/tty
read -p "Upload location (s3://my-bucket/folder-navigation/): " LOC < /dev/tty

echo "Downloading repos"
mkdir -p /tmp/github-$(date --iso-8601=s) && cd $_
gh repo list --limit 2 "$USER" --json nameWithOwner -q '.[].nameWithOwner' | xargs -L1 gh repo clone
find . -mindepth 1 -maxdepth 1 -type d -exec 7z a -mx=9 {}.7z {} \;
find . -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \; # would usually use && but find is picky
echo "Copying to S3"
aws s3 cp $(pwd) $LOC --recursive
echo "Cleaning up"
rm -rf /tmp/github*
echo "Done"
