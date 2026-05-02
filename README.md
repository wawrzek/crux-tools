# Crux tools
This repository collects scripts and settings I use in day to day Crux operations.

## check_libs.zsh
I forgot that `revdep` exist and prepared the script which do virtually the same, but using only prt-get and zsh globing.

## git_sync.zsh
The script which helps to keep forks of official Crux ports repositories up to date.

## ports_daily.sh
the script to run in one go `prtsweep`, `prtwash` and `ports -u`.
It dumps output to a log file.
Good base for daily cron job, to keep you port collection fresh, but empty of clutter.

## prt-get.bash_completion
Translation of `_prt-get` from the Crux zsh package for bash done by AI (Gemini).

Copy the file to `/etc/bash_completion.d` and then ensure it loaded.

E.g. add following to `.bashrc`, `.bash_profile` and `.profile`.
```
# Load all completion files from the bash_completion.d directory
if [ -d /etc/bash_completion.d ]; then
  for completion_file in /etc/bash_completion.d/*; do
    # Check if it's a regular file and readable
    if [ -f "$completion_file" ] && [ -r "$completion_file" ]; then
      . "$completion_file"
    fi
  done
fi
```

## update_port.sh
Something for a ports maintainer.
The script runs crucial steps for a port build and uses rootlesskit to keep the right footprint.
It also can commit changes to git.

