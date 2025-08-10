if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
fi

##########
# termux #
##########

if ! ls / &>/dev/null ; then
  termux-chroot
  exit 0
fi

if [ "$(cat /etc/hostname)" = "Termux" ] ; then
  GPG_TTY=$(tty)
  unset LD_PRELOAD
fi


###########
# Plugins #
###########
#{{{

if [ ! -f "$HOME/.zinit/bin/zinit.zsh" ]; then
    print -P "%F{33}▓▒░ %F{220}Installing zinit…%f"
    command mkdir -p $HOME/.zinit
    command git clone https://github.com/zdharma-continuum/zinit $HOME/.zinit/bin && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%F" || \
        print -P "%F{160}▓▒░ The clone has failed.%F"
fi

source "$HOME/.zinit/bin/zinit.zsh"

zinit ice wait lucid
zinit light "kutsan/zsh-system-clipboard"

zinit ice wait lucid
zinit light "zsh-users/zsh-completions"

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

#}}}

###########
# General #
###########
#{{{

# TERM

source ~/.profile

[ -f /.dockerenv ] && TERM="xterm-256color"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Colors 
autoload -U colors && colors

# PS
if [ "$(cat /etc/hostname)" = "server" ] ; then
  PS1="%B%{$fg[red]%}[ %{$fg[white]%}%~ %{$fg[red]%}]$%b "
else
  PS1="%B%{$fg[green]%}[ %{$fg[white]%}%~ %{$fg[green]%}]$%b "
fi

# Man pager
# export MANPAGER="nvim +'nnoremap <leader>f :Lines<cr>' +'set laststatus=0' +'set ft=man' -"

# Less delay on escape
KEYTIMEOUT=1
export ESCDELAY=1

# History search
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Disable pausing with c-s and resuming with c-q
stty -ixon

# Enable correction
setopt correct

# autocomplete
##  Enable 
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

## Include hidden files in autocomplete:
_comp_options+=(globdots)

## Also complete aliases
setopt COMPLETE_ALIASES

## Search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# ranger changing directory
ranger_cd() {
  ranger --choosedir="$ranger_choosedir_file" $@
  lwd save "$(cat "$ranger_choosedir_file")"
  . lwd load
}
alias ranger=ranger_cd

#}}}

#######
# fzf #
#######
#{{{

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind=ctrl-f:preview-down,ctrl-b:preview-up"

fzf-find() {
  local sel="$(sf $1)"
  if [ -e "$sel" ]; then
    . open "$sel"
    local ret=$?
    zle reset-prompt
    echo -ne '\e[5 q'
  fi
  return $ret
}

fzf-find-widget1() { fzf-find 1 }
zle     -N   fzf-find-widget1
bindkey '' fzf-find-widget1


fzf-find-widget() { fzf-find }
zle     -N   fzf-find-widget
bindkey '^P' fzf-find-widget

#}}}

################
# Key bindings #
################
#{{{

# Misc
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey '^R' history-incremental-search-backward
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


fzf-lwd-widget() {
  . lwd history_cd
  local ret=$?
  zle reset-prompt
  echo -ne '\e[5 q'
  return $ret
}
zle     -N   fzf-lwd-widget
bindkey '^@' fzf-lwd-widget

#}}}

###########
# vi mode #
###########
#{{{

# Config 
## enable Vi mode 
bindkey -v

## Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

## Use beam shape cursor on startup
echo -ne '\e[5 q'

## initiate `vi insert` and set  use beam shape cursor 
zle-line-init() {
    zle -K viins  
    echo -ne "\e[5 q"
}
zle -N zle-line-init

## exec on preexec hook
function vi_preexec() {
	# ^X to ^C
	# stty intr '^C' 
	# re set beam
	echo -ne '\e[5 q'
}

## exec on precmd hook
function vi_precmd() {
  # starting window title
  set_terminal_title
# 	# ^C to ^X
# 	stty intr '^X'
}

# keybindings
# bindkey -M viins '^C' vi-cmd-mode

bindkey "^[[A"   up-line-or-beginning-search
bindkey "^[[B"  down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

#}}}

#########
# hooks #
#########
#{{{

# cd hook
function chpwd() {
  lwd save
  set_terminal_title
}

# precm and preexec hooks
function precmd(){ 
  vi_precmd
}

function preexec(){ 
  vi_preexec

	# title change
	echo -ne "\e]0;"$1"\a" 

  # title change for tmux
  [ -z $TMUX ] || echo -ne "\033k"$1"\033\\"
}

#}}}

##############
# enviroment #
##############
#{{{

# ROS
function source_ros1(){ 
  [ -f "/opt/ros/noetic/setup.zsh" ] && source "/opt/ros/noetic/setup.zsh"
  [ -f "$HOME/catkin_ws/devel/setup.zsh" ] && source "$HOME/catkin_ws/devel/setup.zsh"
}

function source_ros2(){ 
  [ -f "/opt/ros/foxy/setup.zsh" ] && source "/opt/ros/foxy/setup.zsh"
  [ -f "$ROS2WS/install/setup.zsh" ] && source "$ROS2WS/install/setup.zsh"
}

# GHCUP
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# Load aliases
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"

#}}}

####################
# execute at start #
####################
#{{{

# when running `zsh -is [CMD]` CMD is executed and then 
# it returns to intereactive mode
if (( $# )) ; then
  . lwd load
  eval "$@"
  set --
fi

# cd to last working directoy
. lwd load

[ -f ~/.zshrc-custom ] && source ~/.zshrc-custom
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

#}}}

