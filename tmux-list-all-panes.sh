#!/usr/bin/env bash

while IFS= read -r session; do
  while IFS= read -r window; do
    tmux list-panes -t "$session:$window" -F "session=${session} window=${window} pane_index=#{pane_index} pane_pid=#{pane_pid} pane_current_command=#{pane_current_command} pane_current_path=#{pane_current_path} pane_id=#{pane_id} pane_path=#{pane_path} pane_start_command=#{pane_start_command} pane_start_path=#{pane_start_path} pane_tty=#{pane_tty}"
  done < <(tmux list-windows -t "$session" -F "#{window_index}")
done < <(tmux list-sessions -F "#{session_name}")

