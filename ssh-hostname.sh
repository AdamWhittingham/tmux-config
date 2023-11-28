#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=color254,bg=colour172,bold]󰇅 $ssh_host#[nobold]#[fg=colour172,bg=default]"
else
  echo "#[fg=color254,bg=colour25]  $(hostname -s)#[fg=colour25,bg=default]"
fi
