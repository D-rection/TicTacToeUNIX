#!/bin/bash

opening_screen(){
    clear
    DATA=`cat open_screen.screen`
    printf '%s\n' "$DATA"
    sleep 3
}

menu_screen() {
    clear
    DATA=`cat menu.screen`
    printf '%s\n' "$DATA"
}


opening_screen
menu_screen
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo
exit 0