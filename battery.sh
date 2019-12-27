#!/bin/bash

GRAPH=( ! ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ )

shell_colours_0="\033[31m"
shell_colours_1="\033[31m"
shell_colours_2="\033[31m"
shell_colours_3="\033[33m"
shell_colours_4="\033[33m"
shell_colours_5="\033[32m"
shell_colours_6="\033[32m"
shell_colours_7="\033[32m"
shell_colours_8="\033[32m"

tmux_colours_0="#[fg=colour196]"
tmux_colours_1="#[fg=colour202]"
tmux_colours_2="#[fg=colour208]"
tmux_colours_3="#[fg=colour214]"
tmux_colours_4="#[fg=colour184]"
tmux_colours_5="#[fg=colour154]"
tmux_colours_6="#[fg=colour34]"
tmux_colours_7="#[fg=colour76]"
tmux_colours_8="#[fg=colour40]"

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
EMOJI=false

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t)
      TMUX=true
      ;;
    -e)
      EMOJI=true
      ;;
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
  var=tmux_colours_$LEVEL
  reset="#[fg=default,bg=default]"
else
  var=shell_colours_$LEVEL
  reset="\033[0m"
fi
colour=${!var}

if [[ $BATT_STATUS == 0 ]] ; then
  BATT_ICON=''
elif $EMOJI; then
  BATT_ICON='⚡'
else
  BATT_ICON='↯'
fi

echo -e "${colour}${BATT_ICON} ${GRAPH[$LEVEL]} ${BATT_PERCENT}%${reset}"
