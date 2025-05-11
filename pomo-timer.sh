#!/bin/bash

# printf "\x1b[48;2;255;100;0m\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
# printf "\x1b[{bg};2;{r};{g};{b}m\x1b[{fg};2;r;g;bmTRUECOLOR\x1b[0m\n"

get-rgb-gradient() {
    local color1=($(echo "$1" | tr ',' '\n'))
    local color2=($(echo "$2" | tr ',' '\n'))
    local colorfactor=$3
    local color_result=($(echo "$1" | tr ',' '\n'))
    for i in $(seq 0 2); do
	color_result[$i]="$(echo "${color_result[$i]} + $colorfactor * (${color2[$i]} - ${color1[$i]})" | bc | awk '{printf("%d\n",$1 + 0.5)}' )"
    done
    echo "${color_result[@]}"
}

total=100
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

color1="244,208,63" 
color2="22,160,133"

printBar() {
    totalString=""
    currentPercent=$(echo "scale=4; $SECONDS / $totalTimeInSec" | bc)
    totalHalf=$((total/2))
    for i in $(seq 0 $totalHalf); do
	local result=$(echo "scale=4; $i / $totalHalf" | bc)
	local result_p1=$(echo "scale=4; $i / $total" | bc)
	local result_p2=$(echo "scale=4; ($i + 1) / $total" | bc)
	local rdb_1=($(get-rgb-gradient "$color1" "$color2" "$result_p1"))
	local rdb_2=($(get-rgb-gradient "$color1" "$color2" "$result_p2"))
	totalString+="\e[38;2;${rdb_1[0]};${rdb_1[1]};${rdb_1[2]}m"
	if (( $(echo "$result > $currentPercent" | bc -l) )) ; then
	    totalString+="\e[48;2;100;100;100m \e[0m"
	else
	    if (( $(echo "$result_p1 < $currentPercent" | bc -l) )); then
	        totalString+="\e[48;2;${rdb_2[0]};${rdb_2[1]};${rdb_2[2]}m"
	    else
	        totalString+="\e[48;2;100;100;100m"
	    fi
	    totalString+="▌\e[0m"
	fi
    done
    echo -e "$totalString"
}

printf "\e[?25l"
while ((SECONDS < totalTimeInSec)); do
    printTime
    printBar
    printf "\e[2A"
done
printTime
printBar
resetTerm
