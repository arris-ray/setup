###############################################################################
#
# [Read every time]
# 
# This file is always sourced, so it should set environment variables which 
# need to be updated frequently. 
#
# PATH (or its associated counterpart path) is a good example because you 
# probably don't want to restart your whole session to make it update. 
# By setting it in that file, reopening a terminal emulator will start a 
# new Zsh instance with the PATH value updated.
# 
# But be aware that this file is read even when Zsh is launched to run a 
# single command (with the -c option), even by another tool like make. 
# You should be very careful to not modify the default behavior of standard 
# commands because it may break some tools (by setting aliases for example).
#
# See: https://unix.stackexchange.com/a/487889
#
###############################################################################

###############################################################################
# ENV
###############################################################################

set -a
source ~/.env
set +a

# User-specific

export PATH="/usr/local/bin:$PATH"

# Go

export GOPATH=/Users/aray/Code
export PATH="$GOPATH/bin:$PATH"

# General

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
export DEV_ROOT=~/Code/src
export PATH="/usr/local/bin:$PATH"

