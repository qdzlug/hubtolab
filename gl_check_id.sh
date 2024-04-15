#!/bin/bash

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT

# Description:
# This Bash script is designed to fetch a list of all namespaces/groups
# the user can access on a specified GitLab instance. It utilizes the GitLab API
# to perform this action, requiring a personal access token for authentication.
#
# Usage:
# To use this script, you must set two environment variables:
# GITLAB_INSTANCE - URL of your GitLab instance (e.g., "gitlab.example.com")
# ACCESS_TOKEN - Your GitLab personal access token with 'read_api' scope
#
# Set environment variables in your terminal session:
# export GITLAB_INSTANCE="gitlab.example.com"
# export ACCESS_TOKEN="your_access_token"
#
# Run the script in a Bash shell:
# ./list_gitlab_groups.sh
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

# Check if required environment variables are set
if [ -z "$GITLAB_INSTANCE" ] || [ -z "$ACCESS_TOKEN" ]; then
    echo "Error: GITLAB_INSTANCE and ACCESS_TOKEN must be set."
    exit 1
fi

# Fetch the list of groups
curl --header "Private-Token: $ACCESS_TOKEN" \
     "https://$GITLAB_INSTANCE/api/v4/groups"
