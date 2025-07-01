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

# Clone the repos if they don't exist
cd $PROJECTS_DIR || exit
for project in "${projects[@]}"; do
    if [ ! -d "$PROJECTS_DIR/$project" ]; then
        git clone "https://github.com/gripep/$project.git"
    fi
done
cd || exit
