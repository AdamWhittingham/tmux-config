#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=color254,bg=colour162,bold]󰇅 $ssh_host#[nobold]#[fg=colour162,bg=default]"
else
  echo "#[fg=#{@BAR_FG},bg=#{@BAR_BG}]  $(hostname -s)#[fg=#{@BAR_BG},bg=default]"
fi
