#!/bin/sh

trap 'clear' EXIT

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
