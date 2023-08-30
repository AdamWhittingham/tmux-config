#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=colour208]#[fg=color254,bg=colour172,bold]󰇅 $ssh_host#[nobold]"
else
  echo "#[fg=colour25]#[fg=color254,bg=colour25] $(hostname -s)"
fi
