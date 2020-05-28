#!/usr/bin/env bash
#
# sshrc
# version: 0.2.0
# Author: Steve Harsant

# Set liniting rules
# shellcheck disable=SC2059
# shellcheck disable=SC2091
# shellcheck disable=SC2162
# shellcheck disable=SC2164

# Enable debug messages
enable_debug=1

debug() {
  if [[ $enable_debug == 1 ]]; then
    printf "$1\n"
  fi
}

# If no arguments are passed, execute ssh with no arguments and exit
host=$1
if [[ -z $host ]]; then
  ssh
  exit 0
fi

# If the .sshrc_ignoredhosts file exists in the home directory and the hostname/ip
# matchces the $host to connect to, then do not copy rc files. Useful for ssh with mfa
ignored_hosts_list="${HOME}/.sshrc_ignoredhosts"
if [[ -f "$ignored_hosts_list" ]]; then
  ignored_hosts=$(cat "${ignored_hosts_list}")

  for ignored in $ignored_hosts; do
    if [[ $host == *$ignored* ]]; then
      ssh "$host"
      exit 0
    fi
  done
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

files=$(cat "${files_list}")
for file in $files; do
  if [[ -f $file ]]; then
    debug "Copying $file over scp to $host:/tmp/"
    scp -q "$file" "$host":/tmp/
  fi
done

debug "Initaiting ssh connection"
ssh -t "$host" "bash --rcfile /tmp/.bashrc"
