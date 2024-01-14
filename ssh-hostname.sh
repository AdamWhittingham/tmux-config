#!/bin/bash

fg=$2
bg=$3
current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=$fg,bg=$bg,bold]󰇅 $ssh_host#[fg=$bg,bg=default,nobold]"
else
  echo "#[fg=#{@BAR_FG},bg=#{@BAR_BG}]  $(hostname -s)#[fg=#{@BAR_BG},bg=default]"
fi
