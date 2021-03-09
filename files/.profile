# Enviromental variables
## Defaults Programs

export TERMINAL="st"
export TERM="st-256color"

export EDITOR="nvim"
export VISUAL="nvim"
export DIFFPROG="nvim -d"

export BROWSER="firefox"
#export WM="xmonad"
#export WM="bspwm"
export WM="dwm"
# export STATUSBAR="polybar"

## Path
export MY_BIN=$HOME/bin
export PATH="$PATH:$MY_BIN/misc:$HOME/.cabal/bin"

### AUX PATHS
export DMENU_BIN=$MY_BIN/dmenu
export I3_BIN=$MY_BIN/i3
export BSPWM_BIN=$MY_BIN/bspwm
export DWM_BIN=$MY_BIN/dwm
export TMUX_BIN=$MY_BIN/tmux
export AUTOSTART_BIN=$MY_BIN/autostart
export STATUSBAR_BIN=$MY_BIN/statusbar
export STATUSBAR_AUX_BIN=$MY_BIN/statusbar/aux
export BASH_LIB_BIN=$MY_BIN/lib

## XDG
export XDG_CONFIG_DIR="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

## Misc Configrations
export last_wd_file="$HOME/.local/share/last_wd"
export ranger_choosedir_file="$HOME/.cache/ranger-choosedir"
export QT_QPA_PLATFORMTHEME="qt5ct" # qt theming with qt5ct
export LESS="-RF"

# startx on login
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
