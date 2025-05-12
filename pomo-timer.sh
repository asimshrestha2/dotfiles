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
totaltime=2
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

gradientColors=()
for i in $(seq 0 $total); do
    color_f=$(echo "scale=2; $i / $total" | bc)
    gradientColors+=("$(get-rgb-gradient "$color1" "$color2" "$color_f")")
done

printBar() {
    local totalString=""
    local currentPercent=$(echo "scale=4; $SECONDS / $totalTimeInSec" | bc)
    local totalHalf=$(((total/2) - 1))
    for i in $(seq 0 $totalHalf); do
	local result=$(echo "scale=2; $i / $totalHalf" | bc)
	local rgbIndex=$(($i * 2))
	local rgb_1=(${gradientColors[$rgbIndex]})
	totalString+="\e[38;2;${rgb_1[0]};${rgb_1[1]};${rgb_1[2]}m"
	if (( $(echo "$result > $currentPercent" | bc -l) )) ; then
	    totalString+="\e[48;2;100;100;100m \e[0m"
	else
	    local result_p1=$(echo "scale=4; ($rgbIndex + 1) / $total" | bc)
	    if (( $(echo "$result_p1 <= $currentPercent" | bc -l) )); then
		local tempI=$(($rgbIndex + 1))
		local rgb_2=(${gradientColors[$tempI]})
	        totalString+="\e[48;2;${rgb_2[0]};${rgb_2[1]};${rgb_2[2]}m"
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
    startTimeForDiff="$(date +%s.%N)"
    printTime
    printBar
    currentTimeForDiff="$(date +%s.%N)"
    diff=$(echo "scale=2; $currentTimeForDiff-$startTimeForDiff" | bc)
    printf "\e[2A"
    # echo "diff: $diff"
    sleep 1
done
printTime
printBar
resetTerm
