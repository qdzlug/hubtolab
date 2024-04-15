#!/bin/bash

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT

# Description:
# This script automates the process of creating a new project in GitLab
# via the GitLab API. It takes a project name as an input argument,
# checks if the necessary environment variables are set, constructs the
# API request, and sends it to the specified GitLab instance.
#
# Usage:
# This script requires four environment variables to be set:
# GITLAB_INSTANCE - URL of the GitLab instance
# ACCESS_TOKEN - Personal access token for authentication with the GitLab API
# PROJECT_NAME - The name of the project to create (passed as the first script argument)
# NAMESPACE_ID - Optional GitLab namespace/group ID under which to create the project
#
# To run this script, use:
#   ./script_name.sh "ProjectName"
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

# We take the first argument as the project to create
PROJECT_NAME="$1"

# Function to check if variables are set
check_variables() {
    if [ -z "$GITLAB_INSTANCE" ]; then
        echo "Error: GITLAB_INSTANCE is not set."
        exit 1
    fi

    if [ -z "$ACCESS_TOKEN" ]; then
        echo "Error: ACCESS_TOKEN is not set."
        exit 1
    fi

    if [ -z "$PROJECT_NAME" ]; then
        echo "Error: PROJECT_NAME is not set. Please provide it as the first argument."
        exit 1
    fi

    if [ -z "$NAMESPACE_ID" ]; then
        echo "Warning: NAMESPACE_ID is not set. Defaulting to user's namespace."
        # You may choose to default to a specific ID, or handle this as an error:
        # exit 1
    fi
}

# Run the variable check
check_variables

# API URL construction
API_URL="https://$GITLAB_INSTANCE/api/v4/projects/"

# Data for creating the project
DATA="name=$PROJECT_NAME"
if [ -n "$NAMESPACE_ID" ]; then
    DATA="$DATA&namespace_id=$NAMESPACE_ID"
fi

# Make the API request
response=$(curl --header "Private-Token: $ACCESS_TOKEN" --data "$DATA" "$API_URL")

# Output the response
echo $response
