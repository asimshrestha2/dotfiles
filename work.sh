#!/bin/bash

# printf "\x1b[48;2;255;100;0m\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
# printf "\x1b[{bg};2;{r};{g};{b}m\x1b[{fg};2;r;g;bmTRUECOLOR\x1b[0m\n"

total=50
totaltime=25
totaltime=1
currentPercent="0.0"

totalTimeInSec=$(($totaltime * 60))
SECONDS=0
startTime=$(date +%T)

resetTerm() {
    printf "\e[?25h\n"
}

trap resetTerm EXIT

clearLine() {
    printf "\33[2K\r"
}

printTime() {
    clearLine
    timePastInMin=$(($SECONDS/60))
    timePastInSec=$(($SECONDS%60))
    echo "$startTime - ${timePastInMin}m ${timePastInSec}s"
}

printBar() {
    totalString=""
    currentPercent=$(echo "scale=4; $SECONDS / $totalTimeInSec" | bc)
    for i in $(seq 0 $total); do
	result=$(echo "scale=4; $i / $total" | bc)
	if (( $(echo "$result > $currentPercent" |bc -l) )) ; then
		totalString+=" "
	    else
		totalString+="█"
	fi
    done
    echo -e "\e[48;2;100;100;100m\e[38;2;255;100;10m$totalString\e[0m"
}

printf "\e[?25l"
while ((SECONDS < totalTimeInSec)); do
    printTime
    printBar
    printf "\e[2A"
    sleep 1
done
printTime
printBar
resetTerm
