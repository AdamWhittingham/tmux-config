#!/usr/bin/env bash
# Pick a session or window with fzf, then switch to it.
# Press 1-9, 0, - or = to jump straight to the first twelve windows.
# Press ? to toggle a preview of the highlighted window.
# Run from a popup: bind-key w display-popup -E ~/.tmux-config/switcher.sh

dim=$'\e[38;5;244m'
bold=$'\e[1m'
session_colour=$'\e[38;5;33m'
current_colour=$'\e[38;5;205m'
reset=$'\e[0m'

jump_keys=(1 2 3 4 5 6 7 8 9 0 - "=")

waiting_colour=$'\e[38;5;40m'
busy_colour=$'\e[38;5;220m'

current_window=$(tmux display-message -p '#{session_name}:#{window_index}')
current_session=${current_window%%:*}

# Claude Code records each running session's status and tmux pane in
# ~/.claude/sessions/<pid>.json. Each line is "session:window<TAB>state", where
# state is "waiting" if any Claude pane in the window waits for input, else "busy".
claude_states=$(
  while IFS=$'\t' read -r pid pane status; do
    kill -0 "$pid" 2>/dev/null && printf '%s\t%s\n' "$pane" "$status"
  done < <(jq -r '[.pid, (.tmux // "" | split(".") | last), .status] | @tsv' ~/.claude/sessions/*.json 2>/dev/null) |
    awk -F'\t' '
      NR == FNR { session[$1] = $2; next }
      !($1 in session) { next }
      $2 == "busy" || $2 == "shell" { if (state[session[$1]] != "waiting") state[session[$1]] = "busy"; next }
      { state[session[$1]] = "waiting" }
      END { for (s in state) print s "\t" state[s] }
    ' <(tmux list-panes -a -F '#{pane_id}	#{session_name}:#{window_index}') -
)

# Each line is "target<TAB>label<TAB>jump key", fzf only shows the label
list_targets() {
  local session=""
  local count=0
  while IFS=$'\t' read -r sess win name panes cmd; do
    if [[ $sess != "$session" ]]; then
      session=$sess
      local colour=$session_colour
      [[ $sess == "$current_session" ]] && colour=$current_colour
      printf '%s\t%s%s%s\t\n' "$sess" "$colour$bold" "$sess" "$reset"
    fi

    local target="$sess:$win"
    local dot=" "
    if [[ $target == "$current_window" ]]; then
      dot="${current_colour}●${reset}"
    else
      case $(awk -F'\t' -v t="$target" '$1 == t { print $2 }' <<<"$claude_states") in
        waiting) dot="${waiting_colour}●${reset}" ;;
        busy) dot="${busy_colour}●${reset}" ;;
      esac
    fi
    local detail="$cmd"
    [[ $panes -gt 1 ]] && detail="$panes panes"
    local key=${jump_keys[count]}
    count=$((count + 1))
    printf '%s\t  %s%1s%s %s %-24s %s%s%s\t%s\n' \
      "$target" "$session_colour$bold" "$key" "$reset" "$dot" "$name" "$dim" "$detail" "$reset" "$key"
  done < <(tmux list-windows -a -F '#{session_name}	#{window_index}	#{window_name}	#{window_panes}	#{pane_current_command}')
}

targets=$(list_targets)
start=$(awk -F'\t' -v w="$current_window" '$1 == w { print NR }' <<<"$targets")

expect_keys=$(IFS=,; echo "${jump_keys[*]}")

result=$(fzf <<<"$targets" \
  --ansi --delimiter='\t' --with-nth=2 --no-sort --layout=reverse \
  --border=none --info=hidden --prompt='  ' --pointer='▌' \
  --color='bg+:236,pointer:205,prompt:33,hl:205,hl+:205' \
  --bind="load:pos($start)" \
  --preview='tmux capture-pane -ep -t {1}' \
  --preview-window='right,55%,border-left,follow,hidden' \
  --bind='?:toggle-preview' \
  --expect="$expect_keys")

# fzf prints the key pressed (empty for enter), then the selected line
key=$(head -n1 <<<"$result")
if [[ -n $key ]]; then
  choice=$(awk -F'\t' -v k="$key" '$3 == k { print $1 }' <<<"$targets")
else
  choice=$(sed -n 2p <<<"$result" | cut -f1)
fi

[[ -z $choice ]] && exit 0

tmux switch-client -t "$choice"
