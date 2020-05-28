# sshrc

An simple ssh wrapper to copy rc files to /tmp and source them as the connection is established

## TODO

Add hashing of remote rc files, compare to local and only copy to remote host if different. This is to help with connetion time to hosts, particually when rc files are large or numerous.
