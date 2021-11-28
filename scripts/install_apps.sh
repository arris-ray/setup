#!/usr/bin/env zsh

###############################################################################
# IMPORT
###############################################################################

source "shared.sh"

##################################################################
# XCODE
##################################################################

xcode-select -p > /dev/null 2>&1
if [ $? -eq 2 ]; then
  echo "INSTALL XCODE TOOLS"
  xcode-select --install
EOD
fi

##################################################################
# HOMEBREW
##################################################################

# Install Homebrew

brew help > /dev/null 2>&1
if [[ $? != 0 ]] ; then
  echo "INSTALL HOMEBREW"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to path

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Disable Homebrew Analytics

if [ "$(brew analytics)" != "Analytics are disabled." ]; then
  echo "Disable Homebrew analytics"
  brew analytics off
fi

# Install Taps

# https://docs.google.com/document/d/1wR4FUs-Do0agYGnf4xEwKpNvPn5bjAxedV8x4vMqQAQ/edit
# brew tap --force-auto-update Pardot/pardot git@git.dev.pardot.com:Pardot/homebrew-pardot.git

# Install Packages

PACKAGES=(
  jq
  gh
  go
  gpg
  mas
  tree
  wget
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

for PACKAGE in "${PACKAGES[@]}"; do
  brew list $PACKAGE &>/dev/null
  if [[ $? == 1 ]] ; then
    # echo "INSTALL BREW - ${PACKAGE}"
    brew install "${PACKAGE}"
  fi
done

# Install Casks

CASKS=(
  docker
  dropbox
  google-chrome
  google-drive
  iterm2
  rectangle
  slack
  spotify
  visual-studio-code
)

for CASK in "${CASKS[@]}"; do
  brew list --casks | grep "${CASK}" &>/dev/null
  if [[ $? == 1 ]] ; then
    echo "INSTALL BREW CASK - ${CASK}"
    brew install --cask "${CASK}"
  fi
done

###
# POST INSTALL
###
# To activate the autosuggestions, add the following at the end of your .zshrc:
# 
#   source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# 
# You will also need to force reload of your .zshrc:
# 
#   source ~/.zshrc
# 
# ###
# 
# To activate these completions, add the following to your .zshrc:
# 
#   if type brew &>/dev/null; then
#     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
# 
#     autoload -Uz compinit
#     compinit
#   fi
# 
# You may also need to force rebuild `zcompdump`:
# 
#   rm -f ~/.zcompdump; compinit
# 
# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
# to load these completions, you may need to run this:
# 
#   chmod -R go-w '/opt/homebrew/share/zsh'
# 
# ###
# 
# To activate the syntax highlighting, add the following at the end of your .zshrc:
#   source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 
# If you receive "highlighters directory not found" error message,
# you may need to add the following to your .zshenv:
#   export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

##################################################################
# MAC APP STORE
##################################################################

mas install 1333542190 # 1Password 7
mas install 545519333  # Amazon Prime Video
mas install 411643860  # DaisyDisk
mas install 405399194  # Kindle
mas install 634148309  # Logic Pro

##################################################################
# CONFIGURE APPS
##################################################################

# VISUAL STUDIO CODE #############################################

# Install extensions
EXTENSIONS=(
  vscodevim.vim
  timonwong.shellcheck
  foxundermoon.shell-format
)

for EXTENSION in "${EXTENSIONS[@]}"; do
  vscode --list-extensions | grep "${EXTENSION}" &>/dev/null
  if [[ $? == 1 ]] ; then
    echo "INSTALL VISUAL STUDIO CODE EXTENSION - ${EXTENSION}"
    code --install-extension "${EXTENSION}"
  fi
done

# Disable press-and-hold (AKA enable key-repeat)
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false