#!/bin/bash

desc() { echo "Sample invocation: memory_check -c 90 -w 60 -e email@mine.com" }

while getopts ":c:w:e:" arg
 do
    case "$arg" in
        c)
            critical=${OPTARG}
            ;;
        w)
            warning=${OPTARG}
            ;;
        e)
            email=${OPTARG}
            ;;
        *)
			desc
			exit 1
			;;
    esac
done

if [ $warning -ge $critical ]; then
	echo -e "Set the value of warning threshold less than $critical: \c "
	read warning
fi

TOTAL_MEMORY=$( free -m | grep Mem: | awk '{print $2}' )
USED_MEMORY=$( free -m | grep Mem: | awk '{print $3}' )

percent=$((100*$USED_MEMORY/$TOTAL_MEMORY))

if [ $percent -ge $critical ]; then
    echo "2: used memory is greater than or equal to critical threshold"
elif [ $percent -ge $warning ] && [ $percent -lt $critical ]; then
    echo "1: used memory is greater than or equal to warning threshold but less than critical threshold"
else
    echo "0: used memory is less than warning threshold"
fi
