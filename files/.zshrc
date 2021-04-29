###########
# Plugins #
###########
source /usr/share/zsh/share/antigen.zsh

antigen bundle "unixorn/autoupdate-antigen.zshplugin"

antigen bundle "MichaelAquilina/zsh-you-should-use"

antigen bundle "kutsan/zsh-system-clipboard"
# antigen bundle "Federico-Ciuffardi/zsh-system-clipboard"

antigen bundle "zsh-users/zsh-completions"
antigen bundle "zsh-users/zsh-autosuggestions"

antigen apply

###########
# General #
###########
# GPG Agent
GPG_TTY=`tty`
export GPG_TTY

# Set autocd
setopt autocd

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


# less delay on escape
KEYTIMEOUT=1
export ESCDELAY=1

# History search
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# autocomplete
#  Enable 
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

## Include hidden files in autocomplete:
_comp_options+=(globdots)

# Enable correction
setopt correct

## also complete aliases
setopt COMPLETE_ALIASES

# search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# disable pausing with c-s and resuming with c-q
stty -ixon

####################
# Custom functions #
####################
# ranger changing directory
ranger_cd() {
  ranger --choosedir="$ranger_choosedir_file"
  lwd save "$(cat "$ranger_choosedir_file")"
  . lwd load
  # ranger --choosedir="$last_wd_file"
  # last_working_dir="$(lwd load)"
  # [ -z "$last_working_dir" ] || cd "$last_working_dir"
}

alias ranger=ranger_cd

# Colored man
# function man() {
# 	env \
# 		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
# 		LESS_TERMCAP_me=$(tput sgr0) \
# 		LESS_TERMCAP_mb=$(tput blink) \
# 		LESS_TERMCAP_us=$(tput setaf 2) \
# 		LESS_TERMCAP_ue=$(tput sgr0) \
# 		LESS_TERMCAP_so=$(tput smso) \
# 		LESS_TERMCAP_se=$(tput rmso) \
# 		PAGER="${commands[less]:-$PAGER}" \
# 		man "$@"
# }

export MANPAGER="nvim +'nnoremap <leader>f :Lines<cr>' +'set laststatus=0' +'set ft=man' -"

# sync wd
function cwd() {
  . lwd fzf
}

#######
# fzf #
#######
# enable fzf completion with **
source /usr/share/fzf/completion.zsh

#  Opts
FZF_DEFAULT_OPTS='--bind=ctrl-d:preview-down,ctrl-u:preview-up'


# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -maxdepth 5 \\( -path '*/' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
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

fzf-file-widget() {
  # LBUFFER="${LBUFFER} $(__fsel)"
  . open $(__fsel)
  local ret=$?
  zle reset-prompt
  echo -ne '\e[5 q'
  return $ret
}
zle     -N   fzf-file-widget
bindkey '^@' fzf-file-widget

################
# Key bindings #
################
# Others
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey '^R' history-incremental-search-backward
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


fzf-lwd-widget() {
  # LBUFFER="${LBUFFER} $(__fsel)"
  . lwd history_cd
  local ret=$?
  zle reset-prompt
  echo -ne '\e[5 q'
  return $ret
}
zle     -N   fzf-lwd-widget
bindkey '^P' fzf-lwd-widget

###########
# vi mode #
###########
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

#########
# hooks #
#########
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

##############
# enviroment #
##############
# ROS
[ -f "/opt/ros/noetic/setup.zsh" ] && source "/opt/ros/noetic/setup.zsh"
[ -f "$HOME/catkin_ws/devel/setup.zsh" ] && source "$HOME/catkin_ws/devel/setup.zsh"

# GHCUP
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# Load aliases
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"

###########
# execute #
###########
# cd to last working directoy
. lwd load
# [ ! -z $last_wd_file ] && cd "`cat $last_wd_file`"

# execute tmuxkd to kill detached sessions so there ar only 5 of them
[ -z $TMUX ] || tmuxkd 5

# starting window title
# print -Pn "\e]0;`pwd`\a" 
# echo  -ne "\033k`pwd`\033\\"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

