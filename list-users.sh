#!/bin/bash

########################
#date:27-06-2026
#Author:Likhitha
#purpose:this script will connect you to github acnt  and through github API Url and list users of the repo
#######################

#Github API url
API_URL="https://api.github.com"

#Github Username and personal access token
read -p "Enter Github Username:" USERNAME
read -sp "Enter Github Personal Access Token:" TOKEN
echo

#User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

#Function to make a GET request to the GitHub API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	#send a GET request to the GitHub API with authentication
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list users with read access to the repository

function list_users_with_read_access {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	#Fetch the list of collaborators on the repository
	collaborators="$(github_api_get "$endpoint"|jq -r '.[]|select(.permissions.pull==true)|.login')"

	#Display the list of collaborators with read access
	if [[ -z "$collaborators" ]]; then
		echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
		echo "$collaborators"
	fi
}

#Main Script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access

