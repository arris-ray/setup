#!/usr/bin/env zsh

###############################################################################
# Required scopes for Github Personal Access Token
# - repo:status
# - repo:repo_deployment
# - repo:public_repo
# - repo:invite
# - repo:security_events
# - admin:org:read:org
# - admin:public_key:write:public_key
# - admin:public_key:read:public_key
# - admin:gpg_key:write:gpg_key
# - admin:gpg_key:read:gpg_key
###############################################################################

###############################################################################
# IMPORT
###############################################################################

source "shared.sh"

###############################################################################
# CREATE
###############################################################################

# Create SSH config file
touch ~/.ssh/config

for i in {1.."${SSH_NUM_KEYS}"}; do
	# Create user keys
	SSH_USER=SSH_USER__"${i}"
	HOST=SSH_HOST__"${i}"
	ALGORITHM=SSH_ALGORITHM__"${i}"
	NUM_BITS=SSH_NUM_BITS__"${i}"
	EMAIL=SSH_USER_EMAIL__"${i}"
	PASSPHRASE=SSH_PASSPHRASE__"${i}"
	FILEPATH=~/.ssh/"${(P)SSH_USER}"_"${(P)ALGORITHM}"
	if [[ ! -f "${FILEPATH}" ]]; then
		ssh-keygen -t "${(P)ALGORITHM}" -C "${(P)EMAIL}" -b "${(P)NUM_BITS}" -f "${FILEPATH}" -N "${(P)PASSPHRASE}"
	fi

	# Configure user entries in SSH config 
	SSH_CONFIG_FILE=~/.ssh/config
	grep "Host ${(P)SSH_USER}@${(P)HOST}" "${SSH_CONFIG_FILE}" >/dev/null 2>&1
	if [[ $? == 1 ]]; then
		cat >> "${SSH_CONFIG_FILE}" <<SSHCFG
Host ${(P)SSH_USER}@${(P)HOST} 
    AddKeysToAgent yes
    IgnoreUnknown UseKeychain
    UseKeychain yes
    IdentitiesOnly yes
    IdentityFile ~/.ssh/${(P)SSH_USER}_${(P)ALGORITHM}

SSHCFG
	fi

	# Register user keys in Github
	GITHUB_PAT=GITHUB_PAT__"${i}"
	echo "${(P)GITHUB_PAT}" | gh auth login --with-token
	gh ssh-key add ${FILEPATH}.pub -t "$(whoami)@$(hostname)"
done
