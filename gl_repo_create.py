#!/usr/bin/env python3

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT License

# Description:
# This Python script automates the process of creating a new project in a specified
# GitLab instance via the GitLab API. It uses environment variables to retrieve the
# necessary configuration and accepts the new project name via the command line.
# It requires users to set environment variables for the GitLab instance URL,
# access token, and optionally a namespace ID under which to create the project.
# By default, this script creates projects as public, but visibility can be adjusted
# in the script.
#
# Usage:
# Ensure the following environment variables are set:
#   GITLAB_INSTANCE - URL of your GitLab instance
#   ACCESS_TOKEN - Your GitLab personal access token with 'api' scope
#   NAMESPACE_ID - Optional GitLab namespace/group ID under which to create the project
#
# Run the script by providing the project name as a command-line argument:
#   python gl_repo_create.py "NewProjectName"
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

import requests
import os
import sys

def create_project(new_project_name):
    # Fetch environment variables
    access_token = os.getenv('ACCESS_TOKEN')
    gitlab_instance = os.getenv('GITLAB_INSTANCE')
    namespace_id = os.getenv('NAMESPACE_ID')  # This can be None if not set

    # Ensure environment variables are set
    if not access_token or not gitlab_instance:
        print("Error: Required environment variables are not set.")
        sys.exit(1)

    # API URL construction
    url = f'https://{gitlab_instance}/api/v4/projects/'
    headers = {'PRIVATE-TOKEN': access_token}
    data = {'name': new_project_name, 'visibility': 'public'}

    # Add namespace ID to data if it exists
    if namespace_id:
        data['namespace_id'] = namespace_id

    # Make the API request to create the project
    response = requests.post(url, headers=headers, data=data)

    # Process the response
    if response.status_code == 201:
        print(f"Project '{new_project_name}' created successfully.")
        print(response.json())  # Prints the new project details
    else:
        print("Failed to create project.")
        print(response.json())  # Prints the error details

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python gl_repo_create.py 'ProjectName'")
        sys.exit(1)
    create_project(sys.argv[1])
