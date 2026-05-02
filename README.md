# Crux tools
This repository collects scripts and settings I use in day to day Crux operations.

## check_libs.zsh
I forgot that `revdep` exist and prepare the script which do virtually the same, but using only prt-get and zsh globing.

## git_sync.zsh
The script which helps to keep forks of official Crux ports repositories up to date.

## ports_daily.sh
the script to run in one go `prtsweep`, `prtwash` and `ports -u`.
It dumps output to a log file.
Good base for daily cron job, to keep you port collection fresh, but empty of clutter.

## prt-get.bash_completion
Translation of `_prt-get` from the Crux zsh package for bash done by AI (Gemini).

## update_port.sh
Something for a ports maintainer.
The script runs crucial steps for a port build and uses rootlesskit to keep the right footprint.
It also can commit changes to git.

