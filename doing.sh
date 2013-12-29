#!/bin/bash

function help() {
    echo "Usage: doing [TASKNAME]"
    echo "  or:  doing [-f | -h | --help]"
    echo "A simple utility to time what tasks you're working on."
    echo
    echo "Actions:"
    echo "  <none>      If TASKNAME is empty, print current task name."
    echo "              Otherwise, finish the current task and start"
    echo "              a new one named TASKNAME."
    echo "  -f          Finish current task"
    echo "  -h, --help  Print this help message."
    echo "Variables:"
    echo "  DOING_FILE  Full path to task file, defaults to"
    echo "              \$HOME/.doing.txt"
    exit
}

if [[ $1 = "-h" ]] || [[ $1 = "--help" ]]; then
    help
fi

file=${DOING_FILE:=$HOME/.doing.txt}

[[ ! -e $file ]] && touch $file

lastline=$(tail -n 1 $file)
if [[ -z $lastline ]]; then
    taskname=""
    startime=""
    endtime=""
else
    taskname=$(echo $lastline  | cut -d : -f 1 -)
    starttime=$(echo $lastline | cut -d : -f 2 -)
    endtime=$(echo $lastline   | cut -d : -f 3 -)
fi
if [[ -z $1 ]]; then
    if [[ -z $lastline ]]; then
        echo "((no tasks recorded))"
    else
        echo -n "$taskname"
        [[ -n $endtime ]] && echo -n "  ((done))"
        echo
    fi
elif [[ $1 = "-f" ]]; then
    if [[ -n $taskname ]] && [[ -z $endtime ]]; then
        echo "$(head -n -1 $file)">$file
        endtime=$(date +'%s')
        echo "$lastline:$endtime">>$file
        timediff=$((endtime - starttime))
        hours=$((timediff / 60 / 60))
        [[ $hours < 10 ]] && hours="0$hours"
        timediff=$((timediff - (hours * 60 * 60)))
        minutes=$((timediff / 60))
        [[ $minutes < 10 ]] && minutes="0$minutes"
        seconds=$((timediff - (minutes * 60)))
        [[ $seconds < 10 ]] && seconds="0$seconds"
        echo "$hours:$minutes:$seconds spent on '$taskname'"
    else
        echo "No task to finish"
    fi
else
    echo "$*:$(date +'%s')">>$file
fi
