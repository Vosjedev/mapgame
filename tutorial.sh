#! /bin/bash

startdt="$1"

. libs/lib_var.sh

function log {
    echo "[$1]: $2" >> "logs/tutorial"
}

function wrong {
    echo oops! wrong action! lets try again.
    var.set next menu.$1
}


clear

function tuto.1 {
echo "welcome to the tutorial."
sleep 0.5
echo "i am going to learn you navigate trough this game."
sleep 0.5
echo "let's first open up our profile's menu."
read -p "(press [enter] to continue)" -s
var.set next menu.main
}

function title {
    echo "               __    ___  ___  ___ ___"
    echo " /\  /\   /\  |__)    |  |___ (__   | "
    echo "/  \/  \ /--\ |       |  |___ ___)  |"
    echo "               tutorial               "
}

function teleport {
    clear
    log teleport "drawing teleport"
    echo '
          `  .  ,
         `\\||/|//:
         .== () =<
          /|/\|\\,`
          " `  ,

        teleporting...
'
sleep $1
}

# menu's
log game "setting menu's"

function menu.pauze {
    log menu "drawing pauze menu"
    title
    echo "  -=[ 1. return to game ]=-"
    sleep 0.1
    echo "  -=[ q. save and quit  ]=-"
    sleep 0.1
    echo "nice! now save and quit the game"
    sleep 0.1
    echo "[task] save and quit the game using the menu"
    echo -e "\n  type an option: "
    sleep 0.1
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next tuto.map.4.2
    elif [ "$in" == q ]
    then var.set next menu.save
    fi
}

function menu.save {
    title
    echo "what profile do you want to load?"
    echo "  -=[ 1. profile 1 -> ]=-"
    sleep 0.1
    echo "  -=[ q. <<-  go back ]=-"
    sleep 0.1
    echo "well done! your profile is now saved."
    sleep 0.1
    echo "[task] go back to the main menu"
    echo -e "type an option: "
    sleep 0.1
    read -p "   > " -n 1 in
    if [ "$in" == q ]
    then var.set next "menu.main.2"
    ani=''
    fi
}

function menu.main {
    log menu "drawing main menu"
    title
    echo -e "\n\n"
    echo "  -=[  1. go! ->>  ]=-"
    sleep 0.1
    echo "  -=[ q. []<- exit ]=-"
    sleep 0.1
    echo -e "\n\n"
    echo -e "type an option: "
    sleep 0.1
    echo "hi there! would you like to follow the tutorial? nice!"
    sleep 0.1
    echo "you can use the menu's by typing the letter in front of the button's name."
    sleep 0.1
    echo "[task] open up the save menu. (hint: use [1])"
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next menu.load
    elif [ "$in" == q ]
    then var.set next "menu.confirmclose"
    fi
}

function menu.confirmclose {
    echo "
    
    would you like to exit the tutorial?
    "
    read -p " [y/n] > " in
    if [ "$in" == y ]
    then var.set next exit
    else var.set next menu.main
    fi

}

function menu.main.2 {
    title
    echo -e "\n\n"
    echo "  -=[  1. go! ->>  ]=-"
    sleep 0.1
    echo "  -=[ q. []<- exit ]=-"
    sleep 0.1
    echo -e "\n\n"
    echo -e "type an option: "
    sleep 0.1
    echo "we are done with the tutorial! you can now quit."
    echo "[task] close the game using the menu"
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next menu.load
    elif [ "$in" == q ]
    then var.set next "exit"
    fi
}

function menu.load {
    log menu "drawing load menu"
    title
    echo "what profile do you want to load?"
    echo "  -=[ 1. profile 1 -> ]=-"
    sleep 0.1
    echo "  -=[ q. <<-  go back ]=-"
    sleep 0.1
    echo "here are your profile's. for simplicity, we disabled all exept profile 1."
    sleep 0.1
    echo "[task] open profile 1"
    echo -e "type an option: "
    sleep 0.1
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next tuto.map.1
    elif [ "$in" == q ]
    then var.set next "wrong load"
    ani=''
    fi
}
function menu.teleport {
    log menu "drawing teleport menu"
    echo "
    ,___, ,___,  _   ,___,  _  _  ,___,,___,
      |   (__,   |   (__,   (\ |  (__,   |
     ,|   (___, ,\_, (___, ,| \)  (___, ,|
     "
    log teleport "network 1 interface"
    echo "you are connected to network 1
    choose an option:
        4. (4) [1 seconds]
        5. (5) [1 seconds]

        
        see you soon!"
        [ "$1" == f ] && echo "this is the teleportation ui."
        [ "$1" == f ] && echo "[task] teleport to 5"
        read -p " > " -n 1 in
        if [ "$in" == '' ]
        then var.set next $map
        elif [ "$in" == 4 ]
        then var.set next tuto.map.4.2
        log teleport "sending to map tuto.map.4"
        [ "$1" == f ] && var.set next tuto.map.4
        teleport 1
        elif [ "$in" == 5 ]
        then var.set next tuto.map.5
        log teleport "sending to map tuto.map.5"
        teleport 1
        log menu "close"
        fi
}

# maps
function map.1 {
    echo "
               *
               |
        #------2    &-*
                \ 
                 \ 
                  &
--------------------------"
# keypad
}
function map.2 {
    echo "
               3
               |
        1------#    &-*
                \ 
                 \ 
                  4
--------------------------"
# keypad
}
function map.3 {
    echo "
               #
               |
        *------2    &-*
                \ 
                 \ 
                  *
--------------------------"
# keypad
}
function map.4 {
    echo "
               *
               |
        *------2    t-*
                \ 
                 \ 
                  #
--------------------------"
# keypad
}
function map.5 {
    echo "
               *
               |
        *------*    #-6
                \ 
                 \ 
                  t
--------------------------"
# keypad
}
function map.6 {
    echo "
               *
               |
        *------*    &-#
                \ 
                 \ 
                  &
--------------------------"
# keypad
}

# keypad

function keypad {
:
}
function kp.map.1 {
    map.1
    read -p " > " -n 1 in
    if [ "$in" == "2" ]
    then var.set next kp.map.2
    fi
}
function kp.map.2 {
    map.2
    read -p " > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next kp.map.1
    elif [ "$in" == 3 ]
    then var.set next kp.map.3
    elif [ "$in" == 4 ]
    then var.set next tuto.map.4
    fi
}
function kp.map.2.2 {
    map.2
    echo "HE! you should not be here!"
    sleep 0.1
    echo "lets get you back"
    read -p "press any key"
    var.set next tuto.map.4.2
}
function kp.map.3 {
    map.3
    read -p " > " -n 1 in
    if [ "$in" == "2" ]
    then var.set next kp.map.2
    fi
}
function kp.map.4 {
    map.4
    read -p " > " -n 1 in
    if [ "$in" == "2" ]
    then var.set next kp.map.2
    elif [ "$in" == "t" ]
    then var.set next "menu.teleport f"
    fi
}
function kp.map.6 {
    map.6
    read -p " > " -n 1 in
    if [ "$in" == "5" ]
    then var.set next tuto.map.5
    fi
}


# tutomaps

function tuto.map.1 {
    map.1
    echo "this is the in game menu."
    sleep 0.1
    echo "you are at the #. the numbers are options you can travel to."
    sleep 0.1
    echo "[task] travel to (2) using the number keys"
    read -p " > " -n 1 in
    if [ "$in" == 2 ]
    then var.set next tuto.map.2
    fi
}
function tuto.map.2 {
    map.2
    echo "well done! the # moved! this means you are now at (2)."
    sleep 0.1
    echo "you can see that 3 more numbers appeared. lets move again."
    sleep 0.1
    echo "[task] travel the map"
    read -p " > " -n 1 in
    if [ "$in" == 1 ]
    then var.set next kp.map.1
    elif [ "$in" == 3 ]
    then var.set next kp.map.3
    elif [ "$in" == 4 ]
    then var.set next tuto.map.4
    fi
}
function tuto.map.4 {
    map.4
    echo "ah! there is something here! it is an teleportation machine. "
    sleep 0.1
    echo "they work with networks. this is network 1."
    sleep 0.1
    echo "[task] open the teleportation gui using [t]"
    read -p " > " -n 1 in
    if [ "$in" == t ]
    then var.set next "menu.teleport f"
    elif [ "$in" == "2" ]
    then var.set next kp.map.2
    fi
}
function tuto.map.4.2 {
    map.4
    echo "now that we are teleported back, let's save the game."
    sleep 0.1
    echo "[task] open the pauze menu using [q]"
    read -p " > " -n 1 in
    if [ "$in" == t ]
    then var.set next menu.teleport
    elif [ "$in" == "2" ]
    then var.set next kp.map.2.2
    elif [ "$in" == q ]
    then var.set next menu.pauze
    fi
}
function tuto.map.5 {
    map.5
    echo "now we are teleported!"
    sleep 0.1
    echo "you can have a look around here, or teleport back."
    sleep 0.1
    echo "[task] teleport back"
    read -p " > " -n 1 in
    if [ "$in" == t ]
    then var.set next menu.teleport
    elif [ "$in" == "6" ]
    then var.set next kp.map.6
    fi
}

var.set next "tuto.1"
while true ; do
$(var.get next)
clear
done