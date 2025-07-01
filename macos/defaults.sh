#!/usr/bin/env bash

#  This script sets up macOS defaults settings

# Settings are set using the `defaults` command
# https://macos-defaults.com

# Settings covered:
#   - General
#       - About
#       - Date & Time
#       - Language & Region
#       - Sharing
#   - Control Center
#   - Sound
#   - Lock Screen


# Computer name
if [ -z "${WORK_COMPANY_NAME:-}" ]; then
    COMPUTER_NAME="${NAME}'s MacBook"
else
    COMPUTER_NAME="${NAME}'s ${WORK_COMPANY_NAME} MacBook"
fi
# Locale and preferred languages
LOCALE="en_GB@currency=GBP"
PREFERRED_LANGUAGES=(en_GB it)
# Screenshots folder
SCREENSHOTS_FOLDER="${HOME}/Screenshots"

osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General                                                                     #
###############################################################################

### About ###
# Set computer name
sudo scutil --set ComputerName "$COMPUTER_NAME"

### Date & Time ###
# Set time format to 12-hour
defaults write NSGlobalDomain AppleICUForce12HourTime -bool "true"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool "false"

### Language & Region ###
# Set locale to UK (this will also set date and number formats)
defaults write NSGlobalDomain AppleLocale -string "$LOCALE"
# Set preferred languages
defaults write NSGlobalDomain AppleLanguages -array ${PREFERRED_LANGUAGES[@]}
# Set temperature unit to Celsius (°C)
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"
# Set measurement system to Metric
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool "true"

### Sharing ###
# Set host name
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
# Flush DNS cache
sudo dscacheutil -flushcache

###############################################################################
# Control Center                                                              #
###############################################################################

# Show Wi-Fi in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool "true"
# Show Bluetooth in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool "true"
# DO NOT show AirDrop in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool "false"
# DO NOT show Stage Manager in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible StageManager" -bool "false"

# Show battery percentage in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# DO NOT shoe Spotlight in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Spotlight" -bool "false"

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable the sound effects on boot
defaults write com.apple.preferences.sound PlayStartupSound -bool "false"


###############################################################################
# Lock Screen                                                                 #
###############################################################################

# Set Start Screen Saver to Never
defaults write com.apple.screensaver idleTime -int "0"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int "1"
defaults write com.apple.screensaver askForPasswordDelay -int "0"

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${SCREENSHOTS_FOLDER}"
# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool "true"
