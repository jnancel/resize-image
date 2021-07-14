# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LANG="en_US.UTF-8"
export LC_ALL="C.UTF-8"
export rm="rm -i"
export mv="mv -i"
export cp="cp -i"
export GOPATH="/home/jeremy/go"
export SHELL="/bin/bash"

# Useful
#alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="curl https://ipinfo.io/ip"

# Gros doigts
alias grpe="grep"
alias grepe="grep"
alias vmi="vim"
alias ivm="vim"
alias shs="ssh"
alias pign="ping"
alias bim="vim"
alias im="vim"
alias tailf="tail -f"
alias vp="cp"
alias vm="vim"

# Git aliases
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gco="git checkout"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gp="git push"
alias gpu="git pull"
alias gpf="git push --force-with-lease"
alias gb="git branch"
alias gl="git log"
alias glp="git log --pretty=oneline"
alias gcam="ga -A; gc -a -m"
alias store_creds="git config credential.helper store"
alias onevpn="/usr/bin/openfortivpn -c /etc/openfortivpn/onevpn-config"
alias sudo="sudo "

# Terraform aliases
alias gba="../../../../"
#export gba="../../../../"
#alias awsauth="echo jeremy.nancel@fr.clara.net | aws-adfs login --adfs-host=sso.eu.clara.net --ssl-verification --session-duration 14400 --role-arn='arn:aws:iam::612688033368:role/AWS.CustomerAdmins'"
alias awsauth="aws-adfs login --adfs-host=sso.eu.clara.net --ssl-verification --session-duration 14400 --role-arn='arn:aws:iam::612688033368:role/AWS.CustomerAdmins'"
alias tfclean="egrep --color=never '\[33m|\[31m|\[32m|^$| #' | cat -s"

# Vault aliases
alias vault-login='vault login -method=oidc -path=auth0-oidc -address=https://vault.fr.clara.net'
export VAULT_ADDR="https://vault.fr.clara.net"

source ~/.nexity-ssm

#export LANG="fr_FR.ISO-8859"

export PATH=/home/jeremy/.local/bin:/home/jeremy/.tgenv/bin:/home/jeremy/.tfenv/bin:$PATH:/home/jeremy/Android/Sdk/tools/bin:/home/jeremy/bin:/usr/local/go/bin:/home/jeremy/Perso/Git/home/bin:/home/jeremy/go/bin:/home/jeremy/.pulumi/bin
export LESSCHARSET=utf-8
source <(awless completion bash)

function _update_ps1() {
    #PS1="$(/usr/local/go/bin/powerline-go -error $? -colorize-hostname -cwd-max-depth 6 -mode compatible)"
    PS1="$(/home/jeremy/go/bin/powerline-go -error $? -colorize-hostname -cwd-max-depth 6)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

export EDITOR=vim

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /tmp/node/node_modules/tabtab/.completions/serverless.bash ] && . /tmp/node/node_modules/tabtab/.completions/serverless.bash

complete -C '/usr/local/bin/aws_completer' aws

complete -C /home/jeremy/Vault/versions/0.11.4/vault vault

# Promod
# k8S
#alias kubectlpromodint="kubectl --kubeconfig ~/.kube/config-promod-int"
#alias kubectlpromodpreprod="kubectl --kubeconfig ~/.kube/config-promod-preprod"
