###############################################################################
#
# [Read when interactive]
# 
# I put here everything needed only for interactive usage:
# 
# - prompt,
# - command completion,
# - command correction,
# - command suggestion,
# - command highlighting,
# - output coloring,
# - aliases,
# - key bindings,
# - commands history management,
# - other miscellaneous interactive tools (auto_cd, manydots-magic)...
#
# See: https://unix.stackexchange.com/a/487889
#
###############################################################################

###############################################################################
# PERSONALIZATION
###############################################################################

# EDIT MODE

EDITOR=vim
set -o vi

# PROMPT

# https://stackoverflow.com/a/2851964
parse_git_branch() {
    in_wd="$(git rev-parse --is-inside-work-tree 2>/dev/null)" || return
    test "$in_wd" = true || return
    state=''
    git update-index --refresh -q >/dev/null # avoid false positives with diff-index
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        git diff-index HEAD --quiet 2>/dev/null || state='*'
    else
        state='#'
    fi
    (
        d="$(git rev-parse --show-cdup)" &&
        cd "$d" &&
        test -z "$(git ls-files --others --exclude-standard .)"
    ) >/dev/null 2>&1 || state="${state}+"
    branch="$(git symbolic-ref HEAD 2>/dev/null)"
    test -z "$branch" && branch='<detached-HEAD>'
    echo "${branch#refs/heads/}${state}"
}

setopt PROMPT_SUBST
PROMPT='%*:%1d > '
RPROMPT='$PR_GREEN$(parse_git_branch)$PR_NO_COLOR'

# GIT

# Commit Signing
# See: https://juliansimioni.com/blog/troubleshooting-gpg-git-commit-signing/ 
# See: https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

###############################################################################
# SSH
###############################################################################

# https://help.github.com/enterprise/2.11/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
# https://confluence.dev.pardot.com/questions/15991414/answers/15991422
ssh-add

