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
[[ -z $list ]] && clear=""

# Don't show clear completed option if there are no completed tasks
count=${#list_raw_array[*]}
i=0
completed_tasks="n"
while [ $i -lt $count ]; do
	# %q escapes string, otherwise there are issues with square brackets
	if [[ ${list_raw_array[$i]} = `printf "%q" "$FILLED_RAW"`* ]]; then
		completed_tasks="y"
		break
	fi
	i=$(($i + 1))
done
[[ $completed_tasks = "n" ]] && clear_completed=""

# Check for rofi/dmenu
if [[ -n $1 ]]; then
	menu=$1
elif [[ -f /usr/bin/rofi ]]; then
	menu=rofi
elif [[ -f /usr/bin/dmenu ]]; then
	menu=dmenu
else
	echo "Please install either rofi or dmenu"; exit 1
fi
case $menu in
	rofi)
		[[ -f /usr/bin/rofi ]] || { echo "rofi isn't installed"; exit 1; }
		command="rofi -dmenu"; options="-selected-row 2" ;;
	dmenu)
		[[ -f /usr/bin/dmenu ]] || { echo "dmenu isn't installed"; exit 1; }
		command=dmenu ;;
	*)
		echo "Please install either rofi or dmenu"; exit 1 ;;
esac

# Run rofi/dmenu, replace display checkmarks with raw syntax
selection=`printf "%s%s%s\n" "$clear" "$clear_completed" "$list" | eval "$command -i $options -p \" Task:\""`
selection=${selection//"$EMPTY"/"$EMPTY_RAW"}
selection=${selection//"$FILLED"/"$FILLED_RAW"}

# Selection logic
case $selection in
	$CLEAR) list_raw="" ;;
	$CLEAR_COMPLETED)
		list_raw_array=($list_raw)
		count=${#list_raw_array[*]}
		i=0
		while [ $i -lt $count ]
		do
			if [[ ${list_raw_array[$i]} = `printf "%q" "$FILLED_RAW"`* ]]; then
				unset 'list_raw_array[$i]'
			fi
			i=$(($i + 1))
		done
		list_raw="${list_raw_array[*]}" ;;
	`printf "%q" "$FILLED_RAW"`*)
		replace="${selection}${NL}"
		list_raw=${list_raw//"$replace"/""}
		list_raw=${list_raw//"$selection"/""} ;;
	`printf "%q" "$EMPTY_RAW"`*)
		selection_filled=${selection//"$EMPTY_RAW"/"$FILLED_RAW"}
		list_raw=${list_raw//"$selection"/"$selection_filled"} ;;
	*)
		if [[ -n $selection ]]; then
			[[ -n $list_raw ]] && list_raw="${list_raw}${NL}"
			list_raw=`printf "%s%s %s\n" "$list_raw" "$EMPTY_RAW" "$selection"`
		fi ;;
esac

printf "%s\n" "$list_raw" >| $FILE
