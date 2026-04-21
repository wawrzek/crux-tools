#!/bin/bash
# Simple script to automate port update. It requires rootlesskit
# The script:
# - downloads source and build the package (ignoring footprint &
#   signature)
# - updates footprint (ignoring signature)
# - updates signature

command="rootlesskit pkgmk"

$command -d -if -is && \
 $command -uf -is && \
 $command -us
