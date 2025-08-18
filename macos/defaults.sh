#!/usr/bin/env bash

#  This script sets up macOS defaults settings

# Settings are set using the `defaults` command
# https://macos-defaults.com

# Computer name
if [ "$IS_WORK_MACHINE" = false ]; then
    COMPUTER_NAME="${MY_NAME}'s MacBook"
else
    COMPUTER_NAME="${MY_NAME}'s ${WORK_COMPANY_NAME} MacBook"
fi
# Locale and preferred languages
LOCALE="en_GB@currency=GBP"
PREFERRED_LANGUAGES=(en_GB it)
# Screenshots & screen recording folders
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

### Software Update ###
# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool "true"
# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool "true"
# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool "true"

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool "true"

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool "true"

### Date & Time ###
# Set time format to 12-hour
defaults write NSGlobalDomain AppleICUForce12HourTime -bool "true"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool "false"

# Set timezone automatically
sudo defaults write /Library/Preferences/com.apple.timezone.auto Active -bool "true"
sudo systemsetup -setusingnetworktime on

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
# TODO: Not working on more modern versions of macOS - many settings have been moved into the Control Center, making them less accessible via defaults
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# DO NOT show Spotlight in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Spotlight" -bool "false"

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable play sound on startup
defaults write com.apple.preferences.sound PlayStartupSound -bool "false"
# TODO: Might need to switch to the below if using Intel chip
# sudo nvram StartupMute=%01
# Disable play feedback when volume is changed
defaults write com.apple.sound.beep.feedback -bool "false"


###############################################################################
# Lock Screen                                                                 #
###############################################################################

# Set Start Screen Saver to Never
defaults write com.apple.screensaver idleTime -int "0"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int "1"
defaults write com.apple.screensaver askForPasswordDelay -int "0"


###############################################################################
# Keyboard                                                                    #
###############################################################################

# Set key repeat rate to blazing fast
defaults write NSGlobalDomain KeyRepeat -int "1"
defaults write NSGlobalDomain InitialKeyRepeat -int "15"
# Set adjust keyboard brightness to in low light
defaults write com.apple.BezelServices kDim -bool "true"
# Set turn keyboard backlight off after inactivity to 5 minutes
defaults write com.apple.BezelServices kDimTime -int "300"


###############################################################################
# Trackpad                                                                    #
###############################################################################

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int "1"
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int "1"


###############################################################################
# Dock                                                                        #
###############################################################################

# Set icon size
defaults write com.apple.dock "tilesize" -int "69"

# Disable show recent applications
defaults write com.apple.dock "show-recents" -bool "false"


###############################################################################
# Finder                                                                      #
###############################################################################

# Allow quit option (⌘Q)
defaults write com.apple.finder QuitMenuItem -bool "true"

# Show file extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool "true"

# Show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# Set default view style as list view
# Codes for all view styles: `clmv` (Column view), `Nlsv` (List view), `glyv` (Gallery View), `icnv` (Icon view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Set keep folders on top
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# Set default search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable changing file extension warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool "false"

# Save to disk by default (not to iCloud)
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool "false"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool "false"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"


###############################################################################
# Desktop                                                                     #
###############################################################################

# Set show hard disks
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "true"


###############################################################################
# Screenshot app (⌘⇧5)                                                        #
###############################################################################

# Set option to save screenshots to other location
mkdir -p $SCREENSHOTS_FOLDER
defaults write com.apple.screencapture location -string "${SCREENSHOTS_FOLDER}"
# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool "true"


###############################################################################
# Simulator                                                                   #
###############################################################################

# Set screenshot location
mkdir -p $SCREENSHOTS_FOLDER
defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "${SCREENSHOTS_FOLDER}"


###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool "true"

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int "5"

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int "0"

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int "0"


###############################################################################
# System Settings (not available thru GUI)                                    #
###############################################################################

# Restart automatically if the computer freezes (Error:-99 can be ignored)
sudo systemsetup -setrestartfreeze on 2> /dev/null

# Disable Sudden Motion Sensor (this is enabled in non-SSD Macs)
# https://malcolmplested.co.uk/2013/05/12/enable-disable-the-sudden-motion-sensor-on-a-mac/
sudo pmset -a sms 0

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool "true"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool "true"
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool "true"

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

for app in "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
    killall "${app}" &> /dev/null
done
