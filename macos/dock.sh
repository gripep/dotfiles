#!/usr/bin/env bash

# This script is used to set up the macOS Dock with a specific configuration

echo "Setting up the macOS Dock..."

if ! is-executable dockutil; then
    echo "Command 'dockutil' not installed. Installing dockutil..."
    brew install dockutil
fi

dockutil --no-restart --remove all

dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/Applications/Notion.app"
dockutil --no-restart --add "/Applications/Todoist.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add "/Applications/ExpressVPN.app"

dockutil --no-restart --add "/Users/$USER/Downloads" --view list

killall Dock

echo "macOS Dock setup complete."
