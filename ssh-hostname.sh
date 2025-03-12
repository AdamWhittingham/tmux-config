#!/bin/bash

fg=$2
bg=$3
current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" |  grep -o "\w*@\w*")

if [[ -n $ssh_host ]]; then
  echo "#[fg=$bg,bg=default,nobold]#[fg=$fg,bg=$bg,bold]󰇅 $ssh_host#[fg=$bg,bg=default,nobold]"
else
  echo "#[fg=#{@BAR_BG},bg=default]#[fg=#{@BAR_FG},bg=#{@BAR_BG}] $(hostname -s)#[fg=#{@BAR_BG},bg=default]"
fi
