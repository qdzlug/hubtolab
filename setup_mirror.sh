#!/bin/bash

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT License

# Description:
# This Bash script automates the process of mirroring repositories from GitHub
# to GitLab. It uses environment variables to define user credentials and
# instance details for both platforms. The script requires the names of the
# repositories to be passed as command-line arguments and performs a mirror
# clone of each, storing these in a structured data directory locally.
#
# Usage:
# Ensure the following environment variables are set:
# GITHUB_TOKEN - Your GitHub personal access token
# GITHUB_USER - Your GitHub username
# GITLAB_INSTANCE - URL of your GitLab instance
# ACCESS_TOKEN - Your GitLab personal access token
# NAMESPACE_ID - Optional GitLab namespace/group ID under which to create the project
#
# Run the script by providing the repository names as command-line arguments:
# ./setup_mirror.sh repo1 repo2 repo3
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

# Load environment variables
GITHUB_USER="${GITHUB_USER}"
GITLAB_INSTANCE="${GITLAB_INSTANCE}"
GITLAB_NAMESPACE="${NAMESPACE_ID}"

# Create a data directory if it doesn't exist
DATA_DIR="./data"
mkdir -p "$DATA_DIR"

# Check if repository names are provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 repo1 repo2 ..."
    exit 1
fi

# Loop through each repository provided as a command line argument
for repo in "$@"; do
    echo "Setting up mirroring for $repo..."

    # Step 1: Create a bare clone (middleman) in the data directory
    git clone --mirror --no-single-branch "git@github.com:$GITHUB_USER/$repo.git" "$DATA_DIR/mirror-$repo.git"

    # Step 2: Create a second clone for the public face in the data directory
    git clone --mirror --no-single-branch "git@$GITLAB_INSTANCE:$GITLAB_NAMESPACE/$repo.git" "$DATA_DIR/$repo.git"

    # Step 3: Add the public repo as a remote to the middleman
    cd "$DATA_DIR/mirror-$repo.git" || exit
    git remote add target --mirror=push "../$repo.git"
    cd - || exit

    # Step 4: Configure the middleman repository
    git config --local --add remote.origin.prune true
    git config --local --add remote.origin.pruneTags true
    git config --local --replace remote.origin.fetch "+refs/*:refs/remotes/origin/*"
    git config --local --replace remote.target.push "+refs/remotes/origin/*:refs/*"

    echo "Mirroring setup for $repo completed."
done

echo "All repositories are set up for mirroring."
