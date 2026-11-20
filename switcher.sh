#!/usr/bin/env bash
# Pick a session or window with fzf, then switch to it.
# Press ? to toggle a preview of the highlighted window.
# Run from a popup: bind-key w display-popup -E ~/.tmux-config/switcher.sh

dim=$'\e[38;5;244m'
bold=$'\e[1m'
session_colour=$'\e[38;5;33m'
current_colour=$'\e[38;5;205m'
reset=$'\e[0m'

current_window=$(tmux display-message -p '#{session_name}:#{window_index}')
current_session=${current_window%%:*}

# Each line is "target<TAB>label", fzf only shows the label
list_targets() {
  local session=""
  while IFS=$'\t' read -r sess win name panes cmd; do
    if [[ $sess != "$session" ]]; then
      session=$sess
      local colour=$session_colour
      [[ $sess == "$current_session" ]] && colour=$current_colour
      printf '%s\t%s%s%s\n' "$sess" "$colour$bold" "$sess" "$reset"
    fi

    local target="$sess:$win"
    local marker=" "
    [[ $target == "$current_window" ]] && marker="${current_colour}●${reset}"
    local detail="$cmd"
    [[ $panes -gt 1 ]] && detail="$panes panes"
    printf '%s\t  %s %s%2s%s  %-24s %s%s%s\n' \
      "$target" "$marker" "$bold" "$win" "$reset" "$name" "$dim" "$detail" "$reset"
  done < <(tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{pane_current_command}')
}

targets=$(list_targets)
start=$(awk -F'\t' -v w="$current_window" '$1 == w { print NR }' <<<"$targets")

choice=$(fzf <<<"$targets" \
  --ansi --delimiter='\t' --with-nth=2 --no-sort --layout=reverse \
  --border=none --info=hidden --prompt='  ' --pointer='▌' \
  --color='bg+:236,pointer:205,prompt:33,hl:205,hl+:205' \
  --bind="load:pos($start)" \
  --preview='tmux capture-pane -ep -t {1}' \
  --preview-window='right,55%,border-left,follow,hidden' \
  --bind='?:toggle-preview' \
  | cut -f1)

[[ -z $choice ]] && exit 0

tmux switch-client -t "$choice"
