#!/bin/bash

while true 
do
	makoctl mode | grep -q 'do-not-disturb' && echo '{"alt":"dnd-none"}' || echo '{"alt":"none"}'
	sleep 2
done

