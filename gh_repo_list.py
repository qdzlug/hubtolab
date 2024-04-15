#!/usr/bin/env python3

########################################################################
# Author: Jason Schmidt
# Created on: 15-Apr-2024
# Version: 1.0
# License: MIT License
#
# Description:
# This Python script automates the process of listing repositories hosted
# on GitHub. It requires both a GitHub Username and GitHub Access Token.
#
# Usage:
# Set the environment variables GITHUB_TOKEN and GITHUB_USER in your
# environment.
#
# Run the script in a Python environment:
#   python gh_repo_list.py
#
# Notes:
# This script will return up to 100 repositories; if you have more than 100
# repos, you will want to either adjust the number or look into how the
# GitHub API handles pagination. Or both.
#
# DISCLAIMER:
# This script is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability,
# whether in an action of contract, tort or otherwise, arising from, out of, or in
# connection with the software or the use or other dealings in the software.
########################################################################

import requests
import os

def list_all_github_repos(username, access_token):
    repos = []
    headers = {"Authorization": f"token {access_token}"}
    url = f"https://api.github.com/users/{username}/repos?per_page=100"

    while url:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            repos.extend(response.json())
            if 'next' in response.links.keys():
                url = response.links['next']['url']
            else:
                url = None
        else:
            print("Failed to retrieve repositories or finished pagination.")
            url = None
    return repos

def main():
    access_token = os.getenv('GITHUB_TOKEN')
    username = os.getenv('GITHUB_USER')

    if not access_token or not username:
        print("Error: GITHUB_TOKEN and GITHUB_USER environment variables must be set.")
        return

    all_repos = list_all_github_repos(username, access_token)
    for repo in all_repos:
        print(f"Repo name: {repo['name']} - Repo URL: {repo['html_url']}")

if __name__ == '__main__':
    main()
