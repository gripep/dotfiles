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

# Source .env file
source "${DOTFILES_DIR}/system/.env"

# Generate SSH Key
echo "Generating SSH key(s)..."

PUB_KEY_NAME="id_ed25519"

ssh-keygen -t ed25519 -C "$MY_EMAIL" -f "${HOME}/.ssh/${PUB_KEY_NAME}" -q -N ""
echo "SSH key generated for personal account with email: ${MY_EMAIL}..."

echo "SSH key(s) generated."

# Deploy the public key to GitHub
echo "Deploying personal public key to GitHub..."


if [ -z "${GITHUB_TOKEN}" ]; then
    echo "GITHUB_TOKEN environment variable is not set. Please set it to your GitHub Fine-grained Token."
    exit 1
fi

# Args for the GitHub API request
if [ "$IS_WORK_MACHINE" = false ]; then
    # If not setting up a work account, use the hostname as the title
    TITLE=$(hostname)" (Personal)"
else
    # If setting up a work account, use the hostname and company name as the title
    TITLE=$(hostname)" (${WORK_COMPANY_NAME})"
fi
PUBKEY=$(cat "${HOME}/.ssh/${PUB_KEY_NAME}.pub")

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


# Modify SSH config file
echo "Modifying SSH config for GitHub..."

eval "$(ssh-agent -s)"

SSH_CONFIG="$HOME/.ssh/config"

if [ -f "$SSH_CONFIG" ]; then
    # If the SSH config file already exists, warn the user and do not overwrite it
    echo "${SSH_CONFIG} already exists, please amend it manually to avoid overwriting any custom settings!"
else
    # If the SSH config file does not exist and WORK_EMAIL is not set,
    # create it with default settings
    echo "Creating SSH config file for personal GitHub account..."
    touch "$SSH_CONFIG"
    echo -e "Host github.com\n  IgnoreUnknown UseKeychain\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/${PUB_KEY_NAME}" > "$SSH_CONFIG"
fi

echo "SSH config updated."

# Add SSH Key to the local ssh-agent
echo "Adding SSH key to the ssh-agent..."

if is-macos; then
    ssh-add --apple-use-keychain "${HOME}/.ssh/${PUB_KEY_NAME}"
else
    ssh-add "${HOME}/.ssh/${PUB_KEY_NAME}"
fi

echo "Added SSH key to the ssh-agent."

# Test the SSH connection
echo "Testing SSH connection to GitHub..."
ssh -o StrictHostKeyChecking=accept-new -T git@github.com || true

# Final message
echo "GitHub SSH key setup completed!"
