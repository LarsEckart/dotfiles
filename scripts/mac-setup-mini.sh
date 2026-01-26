#!/usr/bin/env bash

# Mac Mini specific setup script
# Based on mac-setup.sh but tailored for desktop use

# Ask for the administrator password upfront
sudo -v

###############################################################################
# Finder                                                                      #
###############################################################################

# Icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop     -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool false

# Visibility of hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# New window target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string 'PfHm'

# Show Path Bar.
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar.
defaults write com.apple.finder ShowStatusBar -bool true

# Preferred view style
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'

# Arrange by
defaults write com.apple.finder FXPreferredGroupBy -string "Date Modified"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# don't write DS_Store files on usb
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

killall Finder


###############################################################################
# Dock
###############################################################################

# Icon size of Dock items
defaults write com.apple.dock tilesize -int 42

# Lock the Dock size
defaults write com.apple.dock size-immutable -bool true

# Dock magnification
defaults write com.apple.dock magnification -bool false

# Minimization effect: 'genie', 'scale', 'suck'
defaults write com.apple.dock mineffect -string 'scale'

# Prefer tabs when opening documents: 'always', 'fullscreen', 'manual'
defaults write NSGlobalDomain AppleWindowTabbingMode -string 'always'

# Dock orientation: 'left', 'bottom', 'right'
defaults write com.apple.dock 'orientation' -string 'bottom'

# Double-click a window's title bar to:
# None
# Mimimize
# Maximize (zoom)
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

# Minimize to application
defaults write com.apple.dock minimize-to-application -bool true

# Animate opening applications
defaults write com.apple.dock launchanim -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

killall Dock


###############################################################################
# Text Input
###############################################################################

# disable auto correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# Disables auto capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disables "smart" dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disables automatic period substitutions
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disables smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false


###############################################################################
# Keyboard
###############################################################################

# enable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true

# Set key repeat rate (minimum 1)
defaults write NSGlobalDomain KeyRepeat -int 6

# Set delay until repeat (in milliseconds)
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Full Keyboard Access
# In windows and dialogs, press Tab to move keyboard focus between:
# 1 : Text boxes and lists only
# 3 : All controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use F1, F2, etc. keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Set Double and Single quotes
defaults write NSGlobalDomain NSUserQuotesArray -array '"\""' '"\""' '"'\''"' '"'\''"'


###############################################################################
# Mouse
###############################################################################

# disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false


###############################################################################
# Notifications
###############################################################################

# Notification banner on screen time (seconds)
defaults write com.apple.notificationcenterui bannerTime 2


###############################################################################
# Sharing
###############################################################################

# Set computer name
sudo scutil --set ComputerName "lars-mac-mini"
sudo scutil --set HostName "lars-mac-mini"
sudo scutil --set LocalHostName "lars-mac-mini"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server \
   NetBIOSName -string "lars-mac-mini"


###############################################################################
# Security & Privacy
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Turn on Firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Allow signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool true

# Firewall logging
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool false

# Stealth mode
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true


###############################################################################
# Mission Control
###############################################################################

# Mission Control animation duration
defaults write com.apple.dock expose-animation-duration -float 0.1

# Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# When switching to an application, switch to a Space with open windows for the application
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool false

# Displays have seperate Spaces
defaults write com.apple.spaces spans-displays -bool false

# Reset Launchpad (may not exist on fresh install)
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete 2>/dev/null || true

# Hot corners - all disabled
defaults write com.apple.dock wvous-tl-corner   -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner   -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner   -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner   -int 0
defaults write com.apple.dock wvous-br-modifier -int 0


###############################################################################
# Users & Groups
###############################################################################

# Display login window as: Name and password
sudo defaults write /Library/Preferences/com.apple.loginwindow "SHOWFULLNAME" -bool true

# Allow guests to login to this computer
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false


###############################################################################
# Screen                                                                      #
###############################################################################

# Save screen captures in `Pictures` instead of `Desktop`.
defaults write com.apple.screencapture location ~/Pictures
killall SystemUIServer

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"


###############################################################################
# App Store
###############################################################################

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Automatically check for updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in the background
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install app updates
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

# Install macOS updates
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool false

# Install system data files and security updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true


###############################################################################
# Displays
###############################################################################

# Subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Show mirroring options in the menu bar when available
defaults write com.apple.airplay showInMenuBarIfPresent -bool true


###############################################################################
# Desktop & Screen Saver
###############################################################################

# Start after begin idle for time (in seconds)
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Show with clock
defaults -currentHost write com.apple.screensaver showClock -bool true


###############################################################################
# Date & Time
###############################################################################

# Set the timezone
sudo systemsetup -settimezone "Europe/Tallinn" > /dev/null

# Set date and time automatically (may fail without Full Disk Access)
sudo systemsetup -setusingnetworktime on 2>/dev/null || true

# Set time server
sudo systemsetup -setnetworktimeserver "time.apple.com" 2>/dev/null || true

# Set time zome automatically using current location
sudo defaults write /Library/Preferences/com.apple.timezone.auto.plist Active -bool true

# Menu bar clock format (24-hour)
defaults write com.apple.menuextra.clock DateFormat -string "HH"

# Flash the time separators
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

# Analog menu bar clock
defaults write com.apple.menuextra.clock IsAnalog -bool false


###############################################################################
# Safari & WebKit                                                             #
# Note: Safari is sandboxed; these may fail. Enable Develop menu manually:    #
# Safari > Settings > Advanced > Show features for web developers             #
###############################################################################

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# The following require Safari to have been opened at least once
# and may still fail due to sandboxing on modern macOS
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true 2>/dev/null || true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true 2>/dev/null || true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false 2>/dev/null || true
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null || true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true 2>/dev/null || true


###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4


###############################################################################
# Activity Monitor
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 100

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Update Frequency (2 seconds)
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

# Show Data in the Disk graph (instead of IO)
defaults write com.apple.ActivityMonitor DiskGraphType -int 1

# Show Data in the Network graph (instead of packets)
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1


echo "Done. Note that some of these changes require a logout/restart to take effect."
