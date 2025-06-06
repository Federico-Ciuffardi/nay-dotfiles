# "ev" = "enviroment variables"

##########################
# Defaults Programs (ev) #
##########################
#{{{

export TERMINAL="st"
export TERM="st-256color" #"xterm-256color"

export EDITOR="nvim"
export VISUAL="nvim"
export DIFFPROG="nvim -d"

export WM="dwm"

export BROWSER="firefox"

#}}}

##############
# Paths (ev) #
##############
#{{{

# bin lookup
export MY_BIN="$HOME/.local/share/mybin"
export DOTNET_BIN="$PATH:/home/fede/.dotnet/tools"
export PATH="$PATH:$MY_BIN/path:$DOTNET_BIN:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/ruby/3.2.0/bin:$HOME/.fly/bin"

# others
export WALLPAPER_FILE="$HOME/.local/share/wallpaper/wallpaper"
export DMENU_BIN="$MY_BIN/dmenu"
export I3_BIN="$MY_BIN/i3"
export BSPWM_BIN="$MY_BIN/bspwm"
export DWM_BIN="$MY_BIN/dwm"
export TMUX_BIN="$MY_BIN/tmux"
export AUTOSTART_BIN="$MY_BIN/autostart"
export STATUSBAR_BIN="$MY_BIN/statusbar"
export STATUSBAR_AUX_BIN="$MY_BIN/statusbar/aux"
export BASH_LIB_BIN="$MY_BIN/lib"

#}}}

############
# XDG (ev) #
############
#{{{

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_DIR="$HOME/.config"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
# https://specifications.freedesktop.org/trash-spec/trashspec-latest.html
export XDG_HOME_TRASH="$XDG_DATA_HOME/Trash"

#}}}

################
# Configs (ev) #
################
#{{{

# lwd ($HOME/bin/misc/lwd)
export last_wd_file="$HOME/.local/share/last_wd"

# waff
export NS3DIR="$HOME/workspaces/ns3_ws/bake/source/ns-3.34"

# ros2build
export ROS2WS="$HOME/storage/workspaces/ros2_ws"

# fzf
export FZF_DEFAULT_OPTS='--bind="ctrl-d:preview-down,ctrl-u:preview-up,ctrl-l:accept"  --preview "preview {}" '

# ranger
export ranger_choosedir_file="$HOME/.cache/ranger-choosedir"

# qt
export QT_QPA_PLATFORMTHEME="qt5ct" # qt theming with qt5ct
export QT_STYLE_OVERRIDE="kvantum"

# less
export LESS="-RF"

# go
# export GOROOT="$HOME/.local/share/go"
# export GOPATH="$GOROOT/bin"

#}}}

###################
# startx on login #
###################
#{{{

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

#}}}
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
