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

hello_cycle(){
    x='';while [[ "$x" != "a" ]]; do read -n1 x; done
}

arrow_cycle(){
    choose=true
    while $choose
    do
        read -r -sn1 t
        case $t in
            A) echo up ;;
            B) echo down ;;
            C) echo right ;;
            D) echo left ;;
            '') echo [CHOISE] ;;
            'q') echo QUITTING ; choose=false ;;
        esac
    done
}


# opening_screen
# menu_screen
# read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
arrow_cycle
echo
exit 0