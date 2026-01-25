#!/bin/bash

commit_data=$(git cherry main -v | head -n 1)
commit_array=( $commit_data )
commit_hash=${commit_array[1]}
commit_msg=$(git log --format=%s --no-merges -n 1 "$commit_hash")

echo "First commit: $commit_hash $commit_msg"

git reset --soft "$commit_hash"~1
git commit -m "$commit_msg"
