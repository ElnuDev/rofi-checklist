#!/bin/bash

# Setup constants
NL=$'\n'
FILE=~/.rofi-checklist
EMPTY=
EMPTY_RAW="- [ ]"
FILLED=
FILLED_RAW="- [x]"
CLEAR=" Clear all"
clear="${CLEAR}${NL}"
CLEAR_COMPLETED=" Clear completed"
clear_completed="${CLEAR_COMPLETED}${NL}"

# Read checlist file
touch $FILE
list_raw=`cat $FILE`
IFS=$'\n' # split by newlines instead of spaces
list_raw_array=($list_raw)

# Format checklist for display in rofi
list=$list_raw
list=${list//"$EMPTY_RAW"/"$EMPTY"} # empty checkboxes
list=${list//"$FILLED_RAW"/"$FILLED"} # filled checkboxes

# Don't show clear all option if task list is empty
if [[ $list == "" ]]; then
	clear=""
fi

# Don't show clear completed option if there are no completed tasks
count=${#list_raw_array[*]}
i=0
completed_tasks="n"
while [ $i -lt $count ]; do
	# %q escapes string, otherwise there are issues with square brackets
	if [[ ${list_raw_array[$i]} == `printf "%q" "$FILLED_RAW"`* ]]; then
		completed_tasks="y"
		break
	fi
	i=$(($i + 1))
done
if [[ $completed_tasks == "n" ]]; then
	clear_completed=""
fi

# Run rofi, replace display checkmarks with raw syntax
selection=`printf "%s%s%s\n" "$clear" "$clear_completed" "$list" | rofi -dmenu -i -selected-row 2 -p " Task:"`
selection=${selection//"$EMPTY"/"$EMPTY_RAW"}
selection=${selection//"$FILLED"/"$FILLED_RAW"}

# Selection logic
if [[ $selection == $CLEAR ]]; then
	list_raw=""
elif [[ $selection == $CLEAR_COMPLETED ]]; then
	list_raw_array=($list_raw)
	count=${#list_raw_array[*]}
	i=0
	while [ $i -lt $count ]
	do
		if [[ ${list_raw_array[$i]} == `printf "%q" "$FILLED_RAW"`* ]]; then
			unset 'list_raw_array[$i]'
		fi
		i=$(($i + 1))
	done
	list_raw="${list_raw_array[*]}"
elif [[ $selection == `printf "%q" "$FILLED_RAW"`* ]]; then
	replace="${selection}${NL}"
	list_raw=${list_raw//"$replace"/""}
	list_raw=${list_raw//"$selection"/""}
elif [[ $selection == `printf "%q" "$EMPTY_RAW"`* ]]; then
	selection_filled=${selection//"$EMPTY_RAW"/"$FILLED_RAW"}
	list_raw=${list_raw//"$selection"/"$selection_filled"}
elif [[ $selection != "" ]]; then
	if [[ $list_raw != "" ]]; then
		list_raw="${list_raw}${NL}"
	fi
	list_raw=`printf "%s%s %s\n" "$list_raw" "$EMPTY_RAW" "$selection"`
fi

printf "%s\n" "$list_raw" >| $FILE
