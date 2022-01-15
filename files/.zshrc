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
export TERM="st-256color" # otherwise it defaults to screen when using `zsh -is`

# GPG Agent
# GPG_TTY=`tty`
# export GPG_TTY

# Set autocd
# setopt autocd

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
HISTSIZE=1000
SAVEHIST=1000

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
  ranger --choosedir="$ranger_choosedir_file"
  lwd save "$(cat "$ranger_choosedir_file")"
  . lwd load
}
alias ranger=ranger_cd

#}}}

#######
# fzf #
#######
#{{{

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -maxdepth $1 \\( -path '*/' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3- | tail -n +2"}" # tail is used to remove an empty line
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf --height=100%"
}

# maxdepth 5
fzf-find() {
  . open $(__fsel $1)
  local ret=$?
  zle reset-prompt
  echo -ne '\e[5 q'
  return $ret
}

fzf-find-widget1() {
  fzf-find 1
}

zle     -N   fzf-find-widget1
bindkey '' fzf-find-widget1


fzf-find-widget5() {
  fzf-find 5
}

zle     -N   fzf-find-widget5
bindkey '^@' fzf-find-widget5

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
bindkey '^P' fzf-lwd-widget

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
	stty intr '^C' 
	# re set beam
	echo -ne '\e[5 q'
}

## exec on precmd hook
function vi_precmd() {
	# ^C to ^X
	stty intr '^X'
}

# keybindings
bindkey -M viins '^C' vi-cmd-mode

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
    # pwd > "$last_wd_file"
    lwd save
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

# starting window title
print -Pn "\e]0;`pwd`\a" 

#}}}
