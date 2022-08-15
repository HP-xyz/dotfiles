#!/bin/bash

PRODCOMMAND="su - dss -c 'tmux attach'"

tmux new-session \; \
  rename-window 'DSSv2' \; \
  send-keys 'cd ~/projects/DSSv2 && clear && git status' C-m \; \
  new-window \; \
  rename-window 'NPM' \; \
  split-window -h \; \
  send-keys 'cd ~/projects/web-partner' C-m \; \
  send-keys 'npm run dev' C-m \; \
  select-pane -L \; \
  send-keys 'cd ~/projects/web-partner-visitor' C-m \; \
  send-keys 'sleep 10 && npm run dev' C-m \; \
  split-window -v \; \
  send-keys 'cd ~/projects/web-all' C-m \; \
  send-keys 'sleep 20 && npm run dev' C-m \; \
  new-window \; \
  rename-window 'BUILD' \; \
  send-keys 'ssh dss@172.16.71.126 -t -o RemoteCommand="tmux attach"' C-m \; \
  new-window \; \
  rename-window 'SCRATCH 1' \; \
  send-keys 'cd ~ && clear' C-m \; \
  new-window \; \
  rename-window 'SCRATCH 2' \; \
  send-keys 'cd ~ && clear' C-m \; \
  new-window \; \
  rename-window 'TEST05' \; \
  send-keys 'ssh dss@172.16.71.125 -t -o RemoteCommand="tmux attach"' C-m \; \
  new-window \; \
  rename-window 'PROD' \; \
  send-keys "ssh -p 2222 root@178.162.140.165 -t -o RemoteCommand=\"$PRODCOMMAND\"" C-m \; \
  select-window -t 0 \; \
