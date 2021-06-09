#!/bin/bash

opening_screen(){
    clear
    DATA=`cat open_screen.screen`
    printf '%s\n' "$DATA"
    sleep 3
}

menu_screen() {
    pointer="▶"
    DATA=`cat menu.screen`
    
    choose=true
    current_choose=0
    cursor_y=23
    cursor_x=83

    while $choose
    do
        clear
        printf '%s\n' "$DATA"
        tput cup $cursor_y $cursor_x
        echo "$pointer"
        tput cup 55 0

        read -r -sn1 t
        case $t in
            A) let "current_choose = (current_choose - 1)";
                if [[ $current_choose -lt 0 ]]
                then
                    let "current_choose = 3 + current_choose"
                fi;
                let "cursor_y = 23 + 2 * current_choose";;
            B) let "current_choose = (current_choose + 1) % 3";
                let "cursor_y = 23 + 2 * current_choose";;
            '')  ;;
        esac
    done
    

}

hello_cycle(){
    x='';while [[ "$x" != "a" ]]; do read -n1 x; done
}

arrow_cycle(){
    choose=true
    current_choose=0
    while $choose
    do
        read -r -sn1 t
        case $t in
            A) let "current_choose = (current_choose - 1)";
                if [[ $current_choose -lt 0 ]]
                then
                    let "current_choose = 3 + current_choose"
                fi;
                echo "up $current_choose" ;;
            B) let "current_choose = (current_choose + 1) % 3" ; echo "down $current_choose"  ;;
            C) echo right ;;
            D) echo left ;;
            '') echo [CHOISE] ;;
            'q') echo QUITTING ; choose=false ;;
        esac
    done
}


opening_screen
menu_screen

# read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo
exit 0