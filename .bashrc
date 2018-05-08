# ------------------------------------------------
# ~/.bashrc: executed by bash for non-login shells
# customizations for cgoldberg
# ------------------------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# source shell aliases and functions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# export environment variables
export PAGER="less"
export VISUAL="vim"
export EDITOR="vim"

# set shell variables
SQUEEZEBOX_SERVER='localhost:9000'
SQUEEZEBOX_PLAYER='00:04:20:23:82:6f'
SQUEEZEBOX_ENDPOINT="http://${SQUEEZEBOX_SERVER}/jsonrpc.js"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable bash command completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# enable git command completion
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/bin/git-completion.bash ]; then
    . ~/bin/git-completion.bash
fi

# show current git branch name in the prompt when inside a repo directory
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f ~/bin/git-prompt.sh ]; then
    . ~/bin/git-prompt.sh
fi

# enable auto-completion for git commands
__git_complete g _git

# enable auto-completion of package names for apt-* aliases
_pkg_completion () {
    _init_completion || return
    mapfile -t COMPREPLY < <(apt-cache --no-generate pkgnames "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _pkg_completion apt-install
complete -F _pkg_completion apt-remove
complete -F _pkg_completion apt-show
complete -F _pkg_completion apt-policy

# set the title on terminals to user@host:dir
# this gets executed just before the prompt is displayed
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# customize and colorize the prompt
PS1='\[$(tput bold)\]\[\033[38;5;10m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\[\033[38;5;14m\][\w]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\[$(__git_ps1 "(%s)")\]\[$(tput sgr0)\]\$ '

# disable suspend and resume feature in terminal
stty -ixon

# enable line wrapping in terminal
tput smam

# disable the 'Caps Lock' key in terminals (map an extra Escape key instead)
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# better command history handling
# -------------------------------
# append to the history file, don't overwrite it
shopt -s histappend
# edit a recalled history line before executing
shopt -s histverify
# save each line of a multi-line command in the same history entry
shopt -s cmdhist
# don't show duplicate commands in history
HISTCONTROL=ignoredups
# immediately add commands to history instead of waiting for end of session
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# number of previous commands stored in history file
HISTSIZE=10000
# number of previous commands stored in memory for current session
HISTFILESIZE=10000
# don't store these commands in history
HISTIGNORE='ls:exit:h:history:pwd'

# display Ubuntu logo and system info
# https://raw.githubusercontent.com/cgoldberg/screenfetch-ubuntu/master/screenfetch-ubuntu.sh
if [ -f  ~/bin/screenfetch-ubuntu ]; then
    ~/bin/screenfetch-ubuntu
fi
