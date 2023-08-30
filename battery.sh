#!/bin/bash

GRAPH=( ! ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ )
NERD_GRAPH=( 󰂃 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰁹 )

shell_colours=(
"31"
"31"
"31"
"33"
"33"
"32"
"32"
"32"
"32"
)

shell_bg_colours=(
"41"
"41"
"41"
"43"
"43"
"42"
"42"
"42"
"42"
)


tmux_colors=(
"colour196"
"colour202"
"colour208"
"colour214"
"colour184"
"colour190"
"colour22"
"colour28"
"colour34"
)

osx_battery() {
  if [ "$(pmset -g batt | grep -o 'AC Power')" ]; then
    BATT_STATUS=1
  else
    BATT_STATUS=0
  fi
  BATT_PERCENT=$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)
}

linux_battery(){
  local batt_dev_path="/sys/class/power_supply/BAT0"
  local full=''
  local current=''
  local status=''

  case $(cat /etc/*-release) in
    *"Arch Linux"*|*"Ubuntu"*|*"openSUSE"*)
      full=$batt_dev_path/energy_full
      current=$batt_dev_path/energy_now
      staus=$(cat $batt_dev_path/energy_now)
      ;;
    *)
      full=$batt_dev_path/charge_full
      current=$batt_dev_path/charge_now
      staus=$(cat $batt_dev_path/status)
      ;;
  esac

  if [ $staus == 'Discharging' ]; then
    BATT_STATUS=0
  else
    BATT_STATUS=1
  fi

  now=$(cat $current)
  full=$(cat $full)
  BATT_PERCENT=$((100 * $now / $full))
}

battery_level(){
  ((BATT_PERCENT>=0 && BATT_PERCENT<=5))    && LEVEL=0
  ((BATT_PERCENT>5  && BATT_PERCENT<=13))   && LEVEL=1
  ((BATT_PERCENT>13 && BATT_PERCENT<=25))   && LEVEL=2
  ((BATT_PERCENT>25 && BATT_PERCENT<=37))   && LEVEL=3
  ((BATT_PERCENT>37 && BATT_PERCENT<=50))   && LEVEL=4
  ((BATT_PERCENT>50 && BATT_PERCENT<=62))   && LEVEL=5
  ((BATT_PERCENT>62 && BATT_PERCENT<=75))   && LEVEL=6
  ((BATT_PERCENT>75 && BATT_PERCENT<=87))   && LEVEL=7
  ((BATT_PERCENT>87 && BATT_PERCENT<=100))  && LEVEL=8
}

###############################
#     MAIN SCRIPT TIME
###############################

TMUX=false
COLOR_BG=false
SHOW_ICON=true
SHOW_PERCENT=true
LIGHT_TEXT=false
spacer=""

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t)
      TMUX=true
      ;;
    -b)
      COLOR_BG=true
      ;;
    -i)
      SHOW_ICON=true
      SHOW_PERCENT=false
      ;;
    -p)
      SHOW_ICON=false
      SHOW_PERCENT=true
      ;;
    -l)
      LIGHT_TEXT=true
  esac
  shift
done


case $(uname -s) in
  "Darwin")
    osx_battery
    ;;
  "Linux")
    linux_battery
    ;;
esac

battery_level
if [[ ! $BATT_PERCENT ]]; then
  exit 1
fi

if $TMUX; then
  spacer=" "
  batt_color="#[fg=${tmux_colors[LEVEL]}]"
  if $COLOR_BG; then
    fg="color234"
    if $LIGHT_TEXT; then
      fg="color254"
    fi
    batt_color="#[fg=${fg},bg=${tmux_colors[LEVEL]}]"
  fi
  reset="#[fg=default,bg=default]"
else
  batt_color="\033[${shell_colours[LEVEL]}m"
  if $COLOR_BG; then
    batt_color="\033[0;1;${shell_bg_colours[LEVEL]}m"
  fi
  reset="\033[0m"
fi

if [[ $BATT_STATUS == 1 ]] ; then
  BATT_ICON='󰂄'
elif [[ $NERDFONT ]]; then
  BATT_ICON="${NERD_GRAPH[$LEVEL]}"
else
  BATT_ICON="${GRAPH[$LEVEL]}"
fi

icon=""
if $SHOW_ICON; then
  icon="${BATT_ICON}"
fi

percent=""
if $SHOW_PERCENT; then
  percent="${BATT_PERCENT}%"
fi

echo -e "${batt_color}${spacer}${icon} ${percent}${spacer}${reset}"
