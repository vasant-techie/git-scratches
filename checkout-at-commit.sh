#!/bin/bash

# Variables
commit_id=$1
output_dir="../all_files_at_commit"

# Create output directory
mkdir -p $output_dir

# Checkout the specific commit
git checkout $commit_id

# Copy all files from the commit to the output directory
git ls-tree -r --name-only $commit_id | xargs -I {} cp --parents {} $output_dir

# Copy uncommitted files (modified, added, deleted, renamed, copied, updated but not committed)
git status --porcelain | grep '^[ MADRCU]' | awk '{print $2}' | xargs -I {} cp --parents {} $output_dir

# Create and apply patch for staged changes
git diff --cached > ../staged_changes.patch
cd $output_dir
git apply ../staged_changes.patch

# Move back to the original directory
cd -

# Checkout the original branch to leave the repository in its original state
git checkout -
