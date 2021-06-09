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
            '')  case $current_choose in
                    0) tic_tac_toe ;;
                    1) ;;
                    2) choose=false ;;
                esac
                ;;
        esac
    done
}

tic_tac_toe(){
    tpointer="+"
    tDATA=`cat tic.screen`
    
    step=1
    tchoose=true
    field=(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end_game=true
    tcurrent_choose=0
    tcursor_x=80
    tcursor_y=15
    
    while $tchoose
    do
        clear
        printf '%s\n' "$tDATA"

        tput cup $tcursor_y $tcursor_x
        echo "$tpointer"
        tput cup 55 0

        read -r -sn1 t
        case $t in
            A) let "tcurrent_choose = tcurrent_choose - 3";
                if [[ $tcurrent_choose -lt 0 ]]
                then
                    let "tcurrent_choose = 9 + tcurrent_choose"
                fi;
                let "y = tcurrent_choose / 3" ;
                let "tcursor_y = 15 + 10 * y";;

            B)  let "tcurrent_choose = (tcurrent_choose + 3) % 9";
                let "y = tcurrent_choose / 3" ;
                let "tcursor_y = 15 + 10 * y";;
            D)  let "tcurrent_choose = (tcurrent_choose - 1)";
                if [[ $tcurrent_choose -lt 0 ]]
                then
                    let "tcurrent_choose = 9 + tcurrent_choose"
                fi;
                let "x = tcurrent_choose % 3" ;
                let "tcursor_x = 80 + 21 * x";;

            C)  let "tcurrent_choose = (tcurrent_choose + 1) % 9";
                let "x = tcurrent_choose % 3" ;
                let "tcursor_x = 80 + 21 * x";;

            '')  tchoose_checker ;;

            'q') tchoose=false ;;
        esac
    done
}

tchoose_checker() {
    if [[ $field[{$tcurrent_choose}] -eq 0 ]]
    then
        $field[{$tcurrent_choose}]=$step
        if [[ $step -eq 1 ]]
        then
            $step=2
        else
            $step=1
        fi
    fi
}

print_field() {

}

analize_position() {

}


print_cross() {
    let "printcross_x = tcursor_x - 4"
    let "printcross_y = tcursor_y - 4"
    while read USER
    do 
        tput cup $printcross_y $printcross_x
        echo "$USER"
        let "printcross_y = printcross_y + 1"
    done < cross.screen
}


print_circle() {
    let "printcircle_x = tcursor_x - 4"
    let "printcircle_y = tcursor_y - 4"
    while read USER
    do 
        tput cup $printcircle_y $printcircle_x
        echo "$USER"
        let "printcircle_y = printcircle_y + 1"
    done < circle.screen
}



opening_screen
menu_screen

# read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo
exit 0