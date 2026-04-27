#!/bin/bash
# The script to automate ports update, including cleaning following a build

LOGFILE=/var/log/ports_daily.log

echo "$(date)" >> ${LOGFILE}
echo "<=====================================================================>" >> ${LOGFILE}

# update ports
ports -u >>${LOGFILE} 2>&1
echo "<=====================================================================>" >> ${LOGFILE}

# automatic removal of drooped backages
prtsweep -a >>${LOGFILE} 2>&1
echo "<=====================================================================>" >> ${LOGFILE}

# automatic (-p) clean of all packages (current -p, and older -b) as well as sources (-s)
prtwash -a -p -b -s >>${LOGFILE} 2>&1
echo "<=====================================================================>" >> ${LOGFILE}
