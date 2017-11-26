#!/bin/bash

current_tty="$(echo $1 | rev | cut -d'/' -f1 | rev)"
ssh_host=$(ps -t "$current_tty" | sed -n -e 's/^.*\(ssh\) //p')
mosh_host=$(ps -t "$current_tty" | sed -n -e 's/^.*\(mosh-client\) \(-# \)//p' | cut -d ' ' -f1)

if [[ -n $ssh_host ]]; then
  echo "#[fg=colour220]$ssh_host#[fg=default]"
elif [[ -n $mosh_host ]]; then
  echo "#[fg=colour220]$mosh_host#[fg=default]"
else
	hostname -s
fi
