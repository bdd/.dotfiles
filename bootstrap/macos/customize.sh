#!/usr/bin/env bash

# For macOS 12.0 Monterey
# Almost entirely based on https://github.com/mathiasbynens/dotfiles/blob/main/.macos

## Trackpad
for trackpad in AppleMultitouchTrackpad driver.AppleBluetoothMultitouch.trackpad; do
  # Silent Clicking -- do not play a fake click sound
  defaults write com.apple.${trackpad} ActuationStrength -bool false

  # Tap to click
  defaults write com.apple.${trackpad} Clicking -bool true

  # Two finger = right click
  defaults write com.apple.${trackpad} TrackpadRightClick -bool true

  # Drag with three fingers
  defaults write com.apple.${trackpad} TrackpadThreeFingerDrag -bool true
  defaults write com.apple.${trackpad} TrackpadThreeFingerTapGesture -int 2

  # Two finger swipe from right show notification center
  defaults write com.apple.${trackpad} TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
done


## Dock
# Remove all persistent app icons
defaults write com.apple.dock persistent-apps -array

# Hide automatically
defaults write com.apple.dock autohide -bool true

# Use smaller than default icons
defaults write com.apple.dock tilesize -int 42


## Safari
# Don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# New Tab/Window opens with Empty Page
defaults write com.apple.Safari NewTabBehavior -int 1
defaults write com.apple.Safari NewWindowBehavior -int 1

# about:blank everywhere
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide bookmarks bar
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Show overlay status bar
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true


## Finder
# Disable Tags on the sidebar
defaults write com.apple.finder ShowRecentTags -bool false

# Set Desktop as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Don't show hard drive on desktop but external, optical, and network disks will be showed
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Do not try to save things to iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Don't animate anything
defaults write com.apple.finder DisableAllAnimations -bool true

## Activity Monitor
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

## Time Machine
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

## Application Firewall
# Block all incoming connections except those required for basic internet services,
# such as DHCP, Bonjour, IPsec.
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2

## Misc
# Disable UI candy
# Less GPU usage
defaults write com.apple.universalaccess reduceTransparency -bool true
# Snappier transitions
defaults write com.apple.universalaccess reduceMotion -bool true

# Don't try to beautify or fix text
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Don't chime when power is plugged and lid is open.
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
sudo killall PowerChime

# Screenshots
SC_PATH="${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location "${SC_PATH}"
mkdir "${SC_PATH}"

### TODO
## Spotlight
# Keys and method employed upstream doesn't seem to work with Monterey.


