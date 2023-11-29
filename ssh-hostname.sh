#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=color254,bg=colour162,bold]󰇅 $ssh_host#[nobold]#[fg=colour162,bg=default]"
else
  echo "#[fg=color254,bg=colour23]  $(hostname -s)#[fg=colour23,bg=default]"
fi
