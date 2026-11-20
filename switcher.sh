#!/usr/bin/env bash
# Pick a session, window or pane with fzf, then switch to it.
# Panes are only listed for windows which have more than one.
# Run from a popup: bind-key w display-popup -E ~/.tmux-config/switcher.sh

dim=$'\e[38;5;244m'
bold=$'\e[1m'
session_colour=$'\e[38;5;33m'
current_colour=$'\e[38;5;205m'
reset=$'\e[0m'

current=$(tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}')
current_window=${current%.*}
current_session=${current%%:*}

# Each line is "target<TAB>label", fzf only shows the label
list_targets() {
  local session=""
  while IFS=$'\t' read -r sess win name panes cmd path; do
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

    if [[ $panes -gt 1 ]]; then
      while IFS=$'\t' read -r pane pcmd ppath; do
        local pmarker=" "
        [[ "$target.$pane" == "$current" ]] && pmarker="${current_colour}›${reset}"
        printf '%s\t        %s %s %-16s %s%s%s\n' \
          "$target.$pane" "$pmarker" "$pane" "$pcmd" "$dim" "${ppath/#$HOME/\~}" "$reset"
      done < <(tmux list-panes -t "$target" -F '#{pane_index}	#{pane_current_command}	#{pane_current_path}')
    fi
  done < <(tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{pane_current_command}	#{pane_current_path}')
}

targets=$(list_targets)
start=$(awk -F'\t' -v w="$current_window" -v p="$current" '$1 == p || $1 == w { n = NR } END { print n }' <<<"$targets")

choice=$(fzf <<<"$targets" \
  --ansi --delimiter='\t' --with-nth=2 --no-sort --layout=reverse \
  --border=none --info=hidden --prompt='  ' --pointer='▌' \
  --color='bg+:236,pointer:205,prompt:33,hl:205,hl+:205' \
  --bind="load:pos($start)" \
  --preview='tmux capture-pane -ep -t {1}' \
  --preview-window='right,55%,border-left,follow' \
  | cut -f1)

[[ -z $choice ]] && exit 0

tmux switch-client -t "$choice"
