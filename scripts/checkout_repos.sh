#!/usr/bin/env bash

###############################################################################
# IMPORT
###############################################################################

source "shared.sh"

##################################################################
# VALIDATE
##################################################################

SSH_KEY=~/.ssh/id_${SSH_ALGORITHM}
eval "$(ssh-agent -s)"
ssh-add -K

if [[ ! -f "${SSH_KEY}" ]]; then
	echo
	echo "Please run generate_ssh.sh first."
	echo "This will generate an SSH key and walk you through getting it registered with Github."
	echo
	exit 1
fi

##################################################################
# CHECKOUT
##################################################################

CODE_DIR="${HOME}/Code/src"
REPO_HOST="git.dev.pardot.com"
REPO_BASE_DIR="${CODE_DIR}/${REPO_HOST}"

if [[ ! -d "${REPO_BASE_DIR}" ]]; then
  mkdir -p "${REPO_BASE_DIR}"
fi

REPOS=(
	"aray/dotfiles"
	"Pardot/pardot"
	"Pardot/infrastructure"
)

for REPO in "${REPOS[@]}"; do
  REPO_DIR="${REPO_BASE_DIR}/${REPO}"
  if [[ ! -d "${REPO_DIR}" ]]; then
    mkdir -p "${REPO_DIR}"
    cd "${REPO_BASE_DIR}" || exit 1
	  git clone "git@${REPO_HOST}:${REPO}.git" "${REPO_DIR}"
	else
	  cd "${REPO_DIR}" || exit 1
	  git pull
	fi
done
