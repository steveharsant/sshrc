# sshrc

An simple ssh wrapper to copy rc files to /tmp and source them as the connection is established.

`version 0.3.0`

## Features

- Copies 1 or more `rc` files over to a remote host and sources them upon connection.
- Only affects the session that `sshrc` initiates. Others are not affected.
- `rc` files are stored in `/tmp` so therefore are not permanent.
- Hash matching, so only newer/updated/missing `rc` files are copied, increasing connection speed.
- Debugging option

## Usage

- Download or clone to your desired location.
- Execute `chmod +x /path/to/sshrc.sh`
- (Optional but recommended) Symlink to user binaries path with `sudo ln -s /path/to/sshrc.sh /usr/bin/sshrc`
- Run with `sshrc` (or `/path/to/sshrc.sh` if not installed to `/usr/bin`)
- First run prompts to install `~/.sshrc_files`. Populate this file with a list of file paths to be copied to remote hosts. If there is more than just the `.bashrc` file being copied, ensure the `.bashrc` file _sources_ the other files using relative paths.

### Note

the `.sshrc_files` file contains [my personal set of `dotfiles`](https://github.com/steveharsant/dotfiles). Replace entires in this file as required.

### Debugging

To enable debugging, set the `enable_debug` variable (found at the top of the script) to `1`

## TODO

Improve argument passthru to ssh binary.
