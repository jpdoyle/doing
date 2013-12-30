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

function timeprint() {
    timediff=$1
    hours=$((timediff / 60 / 60))
    [[ $hours -lt 10 ]] && hours="0$hours"
    timediff=$((timediff - (hours * 60 * 60)))
    minutes=$((timediff / 60))
    [[ $minutes -lt 10 ]] && minutes="0$minutes"
    seconds=$((timediff - (minutes * 60)))
    [[ $seconds -lt 10 ]] && seconds="0$seconds"
    echo "$hours:$minutes:$seconds"
}

if [[ $1 = "-h" ]] || [[ $1 = "--help" ]]; then
    help
fi

file=${DOING_FILE:=$HOME/doing.txt}

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
now=$(date +'%s')
if [[ -z $1 ]]; then
    if [[ -z $lastline ]]; then
        echo "((no tasks recorded))"
    else
        echo -n "$taskname"
        if [[ -n $endtime ]]; then
            echo
            echo -n "((completed after "
            echo -n "$(timeprint $((endtime - starttime))) "
            fancytime=$(date -d "@$starttime")
            echo -n "at $fancytime))"
        else
            echo -n " (($(timeprint $((now - starttime)))))"
        fi
        echo
    fi
elif [[ $1 = "-f" ]]; then
    if [[ -n $taskname ]] && [[ -z $endtime ]]; then
        echo "$(head -n -1 $file)">$file
        endtime=$now
        echo "$lastline:$endtime">>$file
        echo "$(timeprint $((endtime - starttime))) spent on '$taskname'"
    else
        echo "No task to finish"
    fi
elif [[ $1 = "-l" ]]; then
    shift
    taskname="$*"
    if [[ -n $taskname ]]; then
        escaped=$(printf %s "$taskname" | sed 's/[][()\.^$?*+]/\\&/g')
        lines=$(grep "^$escaped" "$DOING_FILE")
        total=0
        while read -r line; do
            starttime=$(echo $line | cut -d : -f 2 -)
            endtime=$(echo $line   | cut -d : -f 3 -)
            total=$((total + endtime - starttime))
        done <<< "$lines"
        echo "$(timeprint $total) spent on '$taskname'"
    else
        declare -A totals
        current=""
        currenttotal=0
        while read -r line; do
            taskname=$(echo $line  | cut -d : -f 1 -)
            starttime=$(echo $line | cut -d : -f 2 -)
            endtime=$(echo $line   | cut -d : -f 3 -)
            if [[ -n $endtime ]]; then
                [[ -z ${totals["$taskname"]} ]] && totals["$taskname"]=0
                totals["$taskname"]=$((totals["$taskname"] + endtime - starttime))
            else
                current="$taskname"
                currenttotal=$((now - starttime))
            fi
        done <$file
        for task in "${!totals[@]}"; do
            echo "$task: $(timeprint ${totals["$task"]})"
        done
        if [[ -n current ]]; then
            echo "$current: $(timeprint $currenttotal)  ((current))"
        fi
    fi
else
    line="$*:$(date +'%s')"
    if [[ -n $lastline ]]; then
        echo $line>>$file
    else
        echo $line>$file
    fi
fi
