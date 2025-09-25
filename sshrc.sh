#!/usr/bin/env bash

host=$1

if [ $# -eq 0 ]; then
  ssh
  exit 0
fi

sshrc_files=(
  "$HOME/.bashrc"
  "$HOME/.bash_aliases"
)

cat "${sshrc_files[@]}" | ssh "$host" 'cat > ~/.bashrc'
ssh "$@"
