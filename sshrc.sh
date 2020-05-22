#!/usr/bin/env bash
#
# sshrc
# version: 0.1.0
# Author: Steve Harsant

# Set liniting rules
# shellcheck disable=SC2059
# shellcheck disable=SC2091
# shellcheck disable=SC2162
# shellcheck disable=SC2164

# Enable debug messages
enable_debug=0

debug() {
  if [[ $enable_debug == 1 ]]; then
    printf "$1\n"
  fi
}

host=$1
if [[ -z $host ]]; then
  ssh
  exit 0
fi

script_location="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
files_list="${HOME}/.sshrc_files"

if [[ -f "$files_list" ]]; then
  debug ".sshrc_files file found in homepath."

elif [[ -f "$script_location/.sshrc_files" ]]; then
  while true; do
    read -p "No .sshrc_files found in homepath. Would you like to install it? [y/n]" YN
    case $YN in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) echo "Please answer yes or no" ;;
    esac
  done

  debug "Installing .sshrc_files to homepath"
  cp "$script_location/.sshrc_files" "$files_list"

else
  # If .sshrc_files is not found found anywhere, exit 1
  printf "No .sshrc_files file found. Create one in your home path and try again. exit 1 \n"
  exit 1
fi

files=$(cat "${HOME}/.sshrc_files")
for file in $files; do
  if [[ -f $file ]]; then
    debug "Copying $file over scp to $host:/tmp/"
    scp -q "$file" "$host":/tmp/
  fi
done

debug "Initaiting ssh connection"
ssh -t "$host" "bash --rcfile /tmp/.bashrc"
