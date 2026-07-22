#!/usr/bin/env bash

# This script installs projects from GitHub (using Bash to use arrays)

PROJECTS_DIR="$HOME/Developer/src/gripep"

# Create the projects directory if it doesn't exist
mkdir -p "$PROJECTS_DIR"

# List of projects to clone
projects=(
    drf-simple-api-errors
    leetCode
)

# Clone the repos if they don't exist, otherwise update them
cd "$PROJECTS_DIR" || return
for project in "${projects[@]}"; do
    if [ ! -d "$PROJECTS_DIR/$project" ]; then
        git clone "https://github.com/gripep/$project.git"
    else
        echo "Updating $project..."
        git -C "$PROJECTS_DIR/$project" pull --ff-only || true
    fi
done
cd || return
