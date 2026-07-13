#!/bin/sh

trap 'clear' EXIT

WORKDIR="/tmp/dialog-demo.$$"
mkdir -p "$WORKDIR"
trap 'rm -rf "$WORKDIR"; clear' EXIT

SAMPLE_FILE="$WORKDIR/sample.txt"
i=1
while [ "$i" -le 40 ]; do
	echo "This is line $i of the sample file." >> "$SAMPLE_FILE"
	i=$((i + 1))
done

dialog --clear \
    --backtitle "dialog" \
    --title "Menu" \
    --menu "A dialog menu example." 10 40 5 \
    "1" "Menu item 1" \
    "2" "Menu item 2" \
    "3" "Menu item 3" \

dialog --clear \
    --backtitle "dialog" \
    --title "Input box" \
    --inputbox "A dialog input box example" 7 40 5 \

dialog --clear \
    --backtitle "dialog" \
    --title "Yes/no" \
    --yesno "A dialog yes/no prompt example" 5 40

dialog --clear \
    --backtitle "dialog" \
    --title "Build list" \
    --buildlist "A dialog buildlist example." 15 50 6 \
    "1" "Item one" "off" \
    "2" "Item two" "on" \
    "3" "Item three" "off" \

dialog --clear \
    --backtitle "dialog" \
    --title "Calendar" \
    --calendar "A dialog calendar example." 0 0 13 7 2026 \

dialog --clear \
    --backtitle "dialog" \
    --title "Checklist" \
    --checklist "A dialog checklist example." 12 40 5 \
    "1" "Checklist item 1" "on" \
    "2" "Checklist item 2" "off" \
    "3" "Checklist item 3" "off" \

dialog --clear \
    --backtitle "dialog" \
    --title "Directory select" \
    --dselect "/tmp/" 10 50 \

dialog --clear \
    --backtitle "dialog" \
    --title "Edit box" \
    --editbox "$SAMPLE_FILE" 15 60 \

dialog --clear \
    --backtitle "dialog" \
    --title "Form" \
    --form "A dialog form example." 15 50 3 \
    "Name:"  1 1 "" 1 15 20 0 \
    "Rank:"  2 1 "" 2 15 20 0 \
    "Serial:" 3 1 "" 3 15 20 0 \

dialog --clear \
    --backtitle "dialog" \
    --title "File select" \
    --fselect "/tmp/" 10 50 \

dialog --clear \
    --backtitle "dialog" \
    --title "Info box" \
    --infobox "A dialog infobox example." 5 40 \

sleep 5

dialog --clear \
    --backtitle "dialog" \
    --title "Input menu" \
    --inputmenu "A dialog inputmenu example." 12 40 5 \
    "1" "Inputmenu item 1" \
    "2" "Inputmenu item 2" \
    "3" "Inputmenu item 3" \

dialog --clear \
    --backtitle "dialog" \
    --title "Mixed form" \
    --mixedform "A dialog mixedform example." 15 50 3 \
    "Name:"     1 1 ""  1 15 20 0 0 \
    "Password:" 2 1 ""  2 15 20 0 1 \
    "Note:"     3 1 ""  3 15 20 0 2 \

dialog --clear \
    --backtitle "dialog" \
    --title "Mixed gauge" \
    --mixedgauge "A dialog mixedgauge example." 15 50 60 \
    "Task one"   "Complete" \
    "Task two"   "20" \
    "Task three" "Pending" \

dialog --clear \
    --backtitle "dialog" \
    --title "Message box" \
    --msgbox "A dialog msgbox example." 6 40 \

dialog --clear \
    --backtitle "dialog" \
    --title "Password box" \
    --passwordbox "A dialog passwordbox example" 7 40 \

dialog --clear \
    --backtitle "dialog" \
    --title "Password form" \
    --passwordform "A dialog passwordform example." 15 50 2 \
    "Username:" 1 1 ""  1 15 20 0 \
    "Password:" 2 1 ""  2 15 20 0 \

dialog --clear \
    --backtitle "dialog" \
    --title "Pause" \
    --pause "A dialog pause example." 7 40 5 \

dialog --clear \
    --backtitle "dialog" \
    --title "Program box" \
    --prgbox "A dialog prgbox example." "ls -l /tmp" 15 50 \

ls -l /tmp | dialog --clear \
    --backtitle "dialog" \
    --title "Program box (stdin)" \
    --programbox "A dialog programbox example." 15 50 \

dialog --clear \
    --backtitle "dialog" \
    --title "Radio list" \
    --radiolist "A dialog radiolist example." 12 40 5 \
    "1" "Radiolist item 1" "on" \
    "2" "Radiolist item 2" "off" \
    "3" "Radiolist item 3" "off" \

dialog --clear \
    --backtitle "dialog" \
    --title "Range box" \
    --rangebox "A dialog rangebox example." 8 40 0 100 50 \

dialog --clear \
    --backtitle "dialog" \
    --title "Tail box" \
    --tailbox "$SAMPLE_FILE" 15 60 \

dialog --clear \
    --backtitle "dialog" \
    --title "Tail box (background)" \
    --tailboxbg "$SAMPLE_FILE" 15 60 \

sleep 2

dialog --clear \
    --backtitle "dialog" \
    --title "Text box" \
    --textbox "$SAMPLE_FILE" 15 60 \

dialog --clear \
    --backtitle "dialog" \
    --title "Time box" \
    --timebox "A dialog timebox example." 0 0 12 30 0 \

dialog --clear \
    --backtitle "dialog" \
    --title "Tree view" \
    --treeview "A dialog treeview example." 15 50 6 \
    "1" "Root item"   "on"  0 \
    "2" "Child item"  "off" 1 \
    "3" "Grandchild"  "off" 2 \
