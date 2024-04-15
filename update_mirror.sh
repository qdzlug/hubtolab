#!/bin/bash

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT License

# Description:
# This Bash script updates the mirrors for specified repositories located within
# a data directory. Each repository mirror is fetched and then pushed to its target
# to synchronize changes. The script requires that the repository names be passed
# as command-line arguments.
#
# Usage:
# Ensure that each repository has been previously set up for mirroring.
# Run the script by providing the repository names as command-line arguments:
# ./update_mirror.sh repo1 repo2 repo3
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

# Directory where repositories are located
DATA_DIR="./data"

# Check if any repository names are provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 repo1 repo2 ..."
    exit 1
fi

# Loop through each repository provided as a command line argument
for repo in "$@"; do
    echo "Updating mirror for $repo..."
    REPO_DIR="$DATA_DIR/mirror-$repo.git"

    # Check if the repository directory exists
    if [ -d "$REPO_DIR" ]; then
        cd "$REPO_DIR" || exit
        git fetch --verbose -pPtfu --progress --show-forced-updates origin
        git push --verbose --progress --prune --follow-tags target
        cd - || exit
        echo "Mirror for $repo updated."
    else
        echo "Repository directory for $repo does not exist."
    fi
done

echo "All specified mirrors updated."
