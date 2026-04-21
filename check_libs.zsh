#!/usr/bin/env zsh
# The script looks for ports which contain libraries or binaries with 
# missing shared libraries.


# Files to store temporary results
FILE=/tmp/ports_to_rebuild

# Ports with private libraries
PORTS=(
	"firefox-bin"
	"thunderbird-bin"
)

check_files(){
# check_files takes a globbing pattern to run ldd on all the matching files.
# If there are any 'not found' linked libraries it uses the `prt-get fsearch`
# to find the package containing the library with missing links. Each package
# is saved into the temporary file $FILE. 
	echo "$1"
	print "List files where ldd found not fulfilled dependencies:"
	for file in ${(e)~1}
	do
		ldd $file 2>/dev/null \
			| grep -q "not found" \
			&& ( \
			echo $file; \
			prt-get fsearch --full $file >> $FILE \
		)
	done
}

check_port(){
# skips ports which has private libraries (e.g. firefox)
	if ! (( ${PORTS[(I)$1]} ))
	then
		echo ${1}
		return 0
	else
		return 1
	fi
}

print_ports(){
# print_ports uses the list saved in the $FILE to print the ports they are 
# part of.
# First the awk filter the lines with ports and prints only ports path.
# For each port path the function extracts the port name and checks if it 
# is installed. It helps with situation when two ports provide the same
# files (e.g. firefox and firefox-bin). Then the ports with known private
# libraries (e.g. firefox-bin) are filterd out, and the rest is printed out.
# If the file does not exists or there are only ports with private libraries
# the function prints the appropriate message.
	_tmp_ports=0
	echo "Print ports which should be rebuild:"
	[ -f $FILE ] \
		&& awk '/Found/ { sub(":","", $3); ports[$3]++} END{for(p in ports){print p}}' $FILE \
		| while read entry; do
			port=$(echo "$entry"| awk -F/ '{print $NF}')
			prt-get isinst "$port" &>/dev/null && check_port "$port" && ((_tmp_ports++))
		done \
		|| \
		echo "No ports to rebuild"
	if [[ $_tmp_ports -eq 0 && ! -e $FILE ]]
	then
		echo "No ports to rebuild"
	fi
#	echo "Ports:  ${_tmp_ports}"
# keep for now for potential debugging
}

# Check if the temporary files exists
[ -f $FILE ] && rm $FILE

# Look for libraries
echo -n "Check libraries - "
check_files "/usr/lib/**/*.so(.)"
echo "======="

# Look for binaries
echo -n "Check binaries - "
check_files "/usr/bin/**(.x)"
echo "======="

# Use the raw output of port search to print nice and checked list
print_ports

# vim: set noet ts=4 sw=4:
