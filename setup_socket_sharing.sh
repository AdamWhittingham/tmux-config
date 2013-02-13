#!/bin/bash

# This script sets up a tmux user group and /var/tmux so that you can share tmux sessions by:
# 1. Add users to the tmux group
#  usermod -aG tmux <username>
# 2. Start tmux with a socket instead of a named session
#  tmux -S /var/tmux/pairing-session
# 3. Have the other users connect their tmux to the socket
#  tmux -S /var/tmux/pairing-session attach

if [[ `id -g` -ne 0 ]]; then
  echo "Please run this script as root"
  exit 1
fi

addgroup tmux

mkdir /var/tmux
chown root:tmux /var/tmux
chmod a=rX,g+ws /var/tmux
