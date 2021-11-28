#!/usr/bin/env bash

###############################################################################
# IMPORT
###############################################################################

source "shared.sh"

###############################################################################
# MACHINE NAME
###############################################################################

# if [ "$COMPUTER_NAME" != "$ACTUAL_COMPUTER_NAME" ]; then
#   sudo scutil --set ComputerName "$COMPUTER_NAME"
#   sudo scutil --set HostName "$COMPUTER_NAME"
#   sudo scutil --set LocalHostName "$COMPUTER_NAME"
#   sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
#   sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
# fi

###############################################################################
# DOCK
###############################################################################

# Only display currently running apps
defaults write com.apple.dock static-only -bool true

# Apply changes
killall Dock

###############################################################################
# FINDER
###############################################################################

# List view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show hidden files
defaults write com.apple.Finder AppleShowAllFiles true

# Apply changes
killall Finder
