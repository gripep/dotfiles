#!/usr/bin/env bash

# This script generates an SSH key pair and deploys the public key to GitHub using a personal access token

# Requirements:
#   - Set MY_EMAIL and WORK_EMAIL (optional) environment variables to your email addresses
#   - Set WORK_COMPANY_NAME environment variable to your company name (optional)
#   - Have a GitHub Fine-grained Token with "Git SSH keys" user permissions (write) and set it as GITHUB_TOKEN environment variable (see Source section below)
# 
# Source:
#   - https://gist.github.com/petersellars/c6fff3657d53d053a15e57862fc6f567
#   - https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-user-access-token-for-a-github-app
#   - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
#   - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
#   - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection
#   - https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#create-a-public-ssh-key-for-the-authenticated-user
#   - https://gist.github.com/petersellars/c6fff3657d53d053a15e57862fc6f567
#   - https://nathanielhoag.com/blog/2014/05/26/automate-ssh-key-generation-and-deployment/

set -eu -o pipefail

# Generate SSH Key
echo "Generating SSH key(s)..."

ssh-keygen -t ed25519 -C "$MY_EMAIL" -f "${HOME}/.ssh/github_rsa"
if [ ! -z $WORK_EMAIL ]; then
    WORK_DOMAIN_NAME=$(echo -n "$WORK_EMAIL" | cut -d '@' -f 2 | cut -d '.' -f 1)
    ssh-keygen -t ed25519 -C "$WORK_EMAIL" -f "${HOME}/.ssh/${WORK_DOMAIN_NAME}_github_rsa"
fi

echo "SSH key(s) generated."

# Deploy the public key to GitHub
echo "Deploying personal public key to GitHub..."

TITLE=$(hostname)
PUBKEY=$(cat "${HOME}/.ssh/github_rsa.pub")

# https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#create-a-public-ssh-key-for-the-authenticated-user
RESPONSE=$(
    curl -s -L -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/user/keys \
        -d "{\"title\":\"${TITLE}\",\"key\":\"${PUBKEY}\"}"
    )

echo "$RESPONSE"
KEYID=$(echo "$RESPONSE" |
    grep -o '\"id.*' |
    grep -o "[0-9]*" |
    grep -m 1 "[0-9]*")

echo "Public key deployed to remote service."

if [ ! -z $WORK_COMPANY_NAME ]; then
    echo "Deploying ${WORK_COMPANY_NAME} public key to GitHub..."

    TITLE=$(hostname)" (${WORK_COMPANY_NAME})"
    PUBKEY=$(cat "${HOME}/.ssh/${WORK_DOMAIN_NAME}_github_rsa.pub")

    RESPONSE=$(
        curl -s -L -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/user/keys \
            -d "{\"title\":\"${TITLE}\",\"key\":\"${PUBKEY}\"}"
        )

    echo "$RESPONSE"
    KEYID=$(echo "$RESPONSE" |
        grep -o '\"id.*' |
        grep -o "[0-9]*" |
        grep -m 1 "[0-9]*")

    echo "Public key deployed to remote service."
fi

# Add SSH Key to the local ssh-agent
echo "Adding SSH key to the ssh-agent..."

eval "$(ssh-agent -s)"
if is-macos; then
    ssh-add --apple-use-keychain "${HOME}/.ssh/github_rsa"
else
    ssh-add "${HOME}/.ssh/github_rsa"
fi

if is-macos && [ ! -z $WORK_EMAIL ]; then
    ssh-add --apple-use-keychain "${HOME}/.ssh/${WORK_DOMAIN_NAME}_github_rsa"
else
    ssh-add "${HOME}/.ssh/${WORK_DOMAIN_NAME}_github_rsa"
fi

echo "Added SSH key to the ssh-agent."

# Modify SSH config file
echo "Modifying SSH config for GitHub..."

SSH_CONFIG="$HOME/.ssh/config"

# If the SSH config file already exists, warn the user and do not overwrite it
if [ -f "$SSH_CONFIG" ]; then
    echo "${SSH_CONFIG} already exists, please amend it manually to avoid overwriting any custom settings!"
fi
# If the SSH config file does not exist and WORK_EMAIL is not set, create it with default settings
if [ ! -f "$SSH_CONFIG" && -z $WORK_EMAIL]; then
    touch "$SSH_CONFIG"
    echo -e "Host github.com\n  IgnoreUnknown UseKeychain\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/github_rsa" > "$SSH_CONFIG"
fi
# If the SSH config file does not exist and WORK_EMAIL is set, create it with both personal and work settings
if [ ! -f "$SSH_CONFIG" && ! -z $WORK_EMAIL]; then
    echo -e "Host github-${WORK_DOMAIN_NAME}\n  HostName github.com\n  IgnoreUnknown UseKeychain\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/${WORK_DOMAIN_NAME}_github_rsa" > "$SSH_CONFIG"
    echo -e "\nHost github-gripep\n  HostName github.com\n  IgnoreUnknown UseKeychain\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/github_rsa" >> "$SSH_CONFIG"
fi

echo "SSH config updated."

# Test the SSH connection
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com || true

# Final message
echo "GitHub SSH key setup completed successfully!"
