#!/bin/bash

set -e

# Define the repository details
REPO_OWNER="siefkenj"
REPO_NAME="IBLLinearAlgebra-pretext"
BRANCH_NAME="main"

# Create the directory and navigate into it
rm -rf book-pretext
mkdir -p book-pretext
cd book-pretext

# Download the repository zip
curl -LJO "https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/heads/$BRANCH_NAME.zip"


# Extract the zip file
unzip $REPO_NAME-$BRANCH_NAME.zip

# Navigate into the extracted directory
cd $REPO_NAME-$BRANCH_NAME

# Run npm ci
npm ci

# Convert the textbook
npx vite-node src/convert-textbook.ts -i ../../book/linearalgebra.tex

# File is now written to tmp.out.ptx
mkdir -p pretext-output/source

echo "Moving tmp.out.ptx to pretext-output/source/main.ptx"
mv tmp.out.ptx pretext-output/source/main.ptx

# Move the output to the root level
echo "Moving source files to book-pretext/pretext-output/"
mv pretext-output/ ..
