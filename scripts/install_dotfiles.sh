#!/usr/bin/env zsh

###############################################################################
# IMPORT
###############################################################################

source "shared.sh"

###############################################################################
# SECRETS
###############################################################################

# GPG

if [[ -n ${GPG_PUBLIC_KEY} && -n ${GPG_PRIVATE_KEY} ]]; then
  echo "${GPG_PUBLIC_KEY}" | gpg --import
  echo "${GPG_PRIVATE_KEY}" | gpg --import
else
  echo "Skipping GPG key import because the public and/or private key were not provided."
fi

# Install

rm -f ~/.env
echo "${SCRIPT_DIR}"
ln -s "${SCRIPT_DIR}/.env" ~/.env

###############################################################################
# DOTFILES
###############################################################################

# Create dotfile directories

DOTFILE_DIRS=(
  "${HOME}/.ssh"
)

for DOTFILE_DIR in "${DOTFILE_DIRS[@]}}"; do
  mkdir -p "${DOTFILE_DIR}"
done

# Install dotfiles

declare -A DOTFILES=(
  ["${SCRIPT_DIR}/../.env"]="${HOME}/.env"
  ["${SCRIPT_DIR}/../dotfiles/.ssh/config"]="${HOME}/.ssh/config"
  ["${SCRIPT_DIR}/../dotfiles/.gitconfig"]="${HOME}/.gitconfig"
  ["${SCRIPT_DIR}/../dotfiles/.vimrc"]="${HOME}/.vimrc"
  ["${SCRIPT_DIR}/../dotfiles/.zshenv"]="${HOME}/.zshenv"
  ["${SCRIPT_DIR}/../dotfiles/.zshrc"]="${HOME}/.zshrc"
)

for SRC DST in "${(kv)DOTFILES}"; do
  DST="${DOTFILES[${SRC}]}"
  rm -f "${DST}"
  ln -s "${SRC}" "${DST}"
done

