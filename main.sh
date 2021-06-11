#!/bin/bash

opening_screen(){
    clear
    DATA=`cat open_screen.screen`
    printf '%s\n' "$DATA"
    sleep 3
}

menu_screen() {
    opening_screen

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
                    0) new_game ;;
                    1) join_ ;;
                    2) choose=false ;;
                esac
                ;;
        esac
    done
}

new_game(){
	if ! [[ -e pipe ]]
	then
		mknod pipe p	
		
	fi
	your_move=true
	main_symbol=1
	tic_tac_toe
}

join_(){
	your_move=false
	main_symbol=2
	tic_tac_toe
}


tic_tac_toe(){
	tpointer="+"
	tDATA=`cat tic.screen`

	tchoose=true
	field=(0 0 0 0 0 0 0 0 0)
	end_game=true
	tcurrent_choose=0
	tcursor_x=80
	tcursor_y=15

	while $tchoose
	do
	clear
	printf '%s\n' "$tDATA"
	step=$main_symbol
	print_field
	print_information

	tput cup $tcursor_y $tcursor_x
	echo "$tpointer"
	tput cup 55 0

	if "$your_move"
	then
		move
		
	else

		temp=$tcurrent_choose
		read -a tcurrent_choose <<< $( cat pipe )
		if [[ $main_symbol -eq 1 ]]
		then
		    step=2
		else
		    step=1
		fi
		field[$tcurrent_choose]=$step
		print_field
		print_information
		win_analizer
		tcurrent_choose=$temp
		your_move=true
	fi
	done
}

move(){
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
}

tchoose_checker() {
    if [[ ${field[$tcurrent_choose]} -eq 0 ]]
    then
	step=$main_symbol
        field[$tcurrent_choose]=$step
        print_field
        win_analizer
	echo "$tcurrent_choose" > pipe
	your_move=false
        
    fi
}

print_cross() {
    printcross_x=$1
    printcross_y=$2
    while IFS= read -r LINE
    do 
        tput cup $printcross_y $printcross_x
        echo "$LINE"
        let "printcross_y = printcross_y + 1"
    done < cross.screen
}


print_circle() {
    printcircle_x=$1
    printcircle_y=$2
    while IFS= read -r LINE
    do 
        tput cup $printcircle_y $printcircle_x;
        echo "$LINE";
        let "printcircle_y = printcircle_y + 1" ;
    done < circle.screen
}

print_field() {
    prcursor_x=76
    prcursor_y=12
    pr_counter=0
    for i in ${field[@]}
    do
        if [[ $i -eq 1 ]]
        then
            let "x = prcursor_x + (pr_counter % 3) * 21"
            let "y = prcursor_y + (pr_counter / 3) * 10"
            print_cross $x $y
        fi

        if [[ $i -eq 2 ]]
        then
            let "x = prcursor_x + (pr_counter % 3) * 21"
            let "y = prcursor_y + (pr_counter / 3) * 10"
            print_circle $x $y
        fi
        let "pr_counter = pr_counter + 1"
    done
}

print_information() {
    tput cup 5 183
    if [[ $main_symbol -eq 1 ]]
    then
        echo "Крестики"
    else
        echo "Нолики"
    fi
    tput cup 6 183
    echo "Ваш ход"
}

print_endscreen() {
    tput cup 45 94
    case $1 in
    0) echo "Ничья" ;;
    1) echo "Крестики победили" ;;
    2) echo "Нолики победили" ;;
    esac
    sleep 2
}

win_analizer(){
    draw_end=0
    for i in ${field[@]}
    do
        if [[ $i -eq 0 ]]
        then
            draw_end=1
        fi
    done
    if [[ $draw_end -eq 0 ]]
    then
        tchoose=false
        print_endscreen 0
        return
    fi
    
    # Horizontal 
    if [[ ${field[0]} -eq $step ]] && [[ ${field[1]} -eq $step ]] && [[ ${field[2]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    if [[ ${field[3]} -eq $step ]] && [[ ${field[4]} -eq $step ]] && [[ ${field[5]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    if [[ ${field[6]} -eq $step ]] && [[ ${field[7]} -eq $step ]] && [[ ${field[8]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    # Vertical
    if [[ ${field[0]} -eq $step ]] && [[ ${field[3]} -eq $step ]] && [[ ${field[6]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    if [[ ${field[1]} -eq $step ]] && [[ ${field[4]} -eq $step ]] && [[ ${field[7]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    if [[ ${field[2]} -eq $step ]] && [[ ${field[5]} -eq $step ]] && [[ ${field[8]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi

    # Diagonal 
    if [[ ${field[0]} -eq $step ]] && [[ ${field[4]} -eq $step ]] && [[ ${field[8]} -eq $step ]]
    then
    print_endscreen $step
        tchoose=false
        return
    fi

    if [[ ${field[2]} -eq $step ]] && [[ ${field[4]} -eq $step ]] && [[ ${field[6]} -eq $step ]]
    then
        tchoose=false
        print_endscreen $step
        return
    fi
}


menu_screen


# read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
rm pipe
echo
exit 0
