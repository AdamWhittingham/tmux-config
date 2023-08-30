#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" -o args | grep "ssh" | cut -f2 -d' ')

if [[ -n $ssh_host ]]; then
  echo "#[fg=colour214]#[fg=color234,bg=colour214]󰇅 $ssh_host"
else
  echo "#[fg=colour61]#[fg=color234,bg=colour61] $(hostname -s)"
fi
