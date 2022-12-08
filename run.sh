#! /usr/bin/bash

COLUMNS=$(tput cols)
LINES=$(tput lines)
# echo "$COLUMNS by $LINES"
# read

if [ "$COLUMNS" -lt 40 ]
then if [ "$COLUMNS" -gt 21 ]
    then
echo "
 __   __   __   __ __
/  \ /  \ |__) (_  \/
\__/ \__/ |    __) ()
your screen is too small! make sure it is larger than 40 columns by 26 lines"
    else
echo "OOPS!
your screen is too small! make sure it is larger than 40 columns."
    fi
    exit 1
fi

if [ "$LINES" -lt 26 ]
then
echo "
 __   __   __   __ __
/  \ /  \ |__) (_  \/
\__/ \__/ |    __) ()
your screen is too small! make sure it is larger than 40 columns by 26 lines"
exit 1
fi


# fill the screen
lines=0
while [ $lines -le $LINES ]
do echo ''
((lines++))
done
clear

# vars

data="$(dirname $0)"
ani=ani

# some other stuff

cd "$data"
startdt="$(date +'%a-%d-%b-%T')"
touch "logs/$startdt"
echo "ititializing logging" >> "logs/$startdt"
function log {
    [ "$disable_logging" == false ] && echo "[$1]: $2" >> "logs/$startdt"
}
function logs.clean {
    for file in $(ls logs)
    do
        [ "$file" == $startdt ] || rm logs/$file
    done
    next=menu.main
}
log "game.log" "logging started"

[ -f settings.txt ] || {
    log setup "no settings file found, running ./install.sh"
    chmod +x install.sh
    ./install.sh
}

log settings "loading settings"
source settings.txt && log settings "successfull"
[ "$watch_log" == true ] && $terminal tail -f $data/logs/$startdt

# generators
# log game.generator-system "starting generators"

# coins
log game.coin-system "coin system"
function coins.add {
    ((coins=$coins+$1))
}
function coins.remove {
    ((coins=$coins-$1))
}
function coins.check {
    if [ "$coins" -ge "$1" ]
    then return 0
    else echo "not enough coins!"
    return 1
    fi
}

# functions
log game "setting functions"
function fx.type { input="$1"; for (( i=0; i<${#input}; i++ )); do echo -n "${input:$i:1}"; [ "$no_animations" == false ] && sleep 0.1; done; [ "$no_animations" == false ] && sleep 0.5 ; echo '' ; }
function fx.typeq { input="$1"; for (( i=0; i<${#input}; i++ )); do echo -n "${input:$i:1}"; [ "$no_animations" == false ] && sleep 0.01; done; [ "$no_animations" == false ] && sleep 0.05 ; echo '' ; }

function close {
    log game "==============="
    log game "closing..."
    [ "$disable_logging" == true ] && rm logs/$startdt
    echo -e "\n\n\n\n"
    title #ani
    echo -e "\n\n\n\n"
    sleep 1
    next="break"
    exit=0
    log game "trying to exit"
}

function title {
    if [ "$1" == ani ]
    then
    fx.typeq "               __     ___                 ___"
    fx.typeq " /\  /\   /\  |__)   /  __  /\   /\  /\  |___"
    fx.typeq "/  \/  \ /--\ |      \___/ /--\ /  \/  \ |___"
    [ "$no_animations" == false ] && sleep 0.2
    else
    echo "               __     ___                 ___"
    echo " /\  /\   /\  |__)   /  __  /\   /\  /\  |___"
    echo "/  \/  \ /--\ |      \___/ /--\ /  \/  \ |___"
    fi
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

function tutorial {
    [ ! -x tutorial.sh ] && chmod +x tutorial.sh
    [ ! -f logs/tutorial ] && touch logs/tutorial
    ./tutorial.sh
    next=menu.main
}

# inventory
log game "inventory manager"

function inv.add {
    inv="$inv$1 "
}
function inv.remove {
    done=false
    oldinv="$inv"
    inv=' '
    for item in $oldinv
    do
    if [ "$item" == $1 ]
    then if [ "$done" == true ]
        then inv="$inv$item "
        else done=true
        fi
    else inv="$inv$item "
    fi
    done
}
function inv.check {
    if [[ "$inv" == *" $1 "* ]]
    then return 0
    else return 1
    fi
}

# menu's
log game "setting menu's"

function menu.pauze {
    log menu "drawing pauze menu"
    title
    echo "  -=[ 1. return to game ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo -n "  -=[ 2. quit"
    [ "$no_animations" == false ] && sleep 0.01
    echo -n " | "
    [ "$no_animations" == false ] && sleep 0.01
    echo "s. save ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "  -=[ q. save and quit  ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo -e "\n  type an option: "
    [ "$no_animations" == false ] && sleep 0.1
    read -s -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then next=$map
    elif [ "$in" == s ]
    then next=save
    elif [ "$in" == 2 ]
    then next=quit
    elif [ "$in" == q ]
    then next=save.quit
    fi
}

function menu.main {
    log menu "drawing main menu"
    title $ani
    echo -e "\n\n"
    echo "  -=[  1. go! ->>  ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    [ ! -f logs/tutorial ] && echo "  -=[ t. tutorial ]=-"
    echo "  -=[ q. []<- exit ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    if [ "$more" == true ]
    then
            log menu "drawing more menu"
        echo "  -=[  t. tutorial  ]=-"
        [ "$no_animations" == false ] && sleep 0.1
        echo "  -=[ 4. clean logs ]=-"
        [ "$no_animations" == false ] && sleep 0.1
        echo "  -=[  5. settings  ]=-"
        [ "$no_animations" == false ] && sleep 0.1
    else
        echo "[ 2. more ]"
        [ "$no_animations" == false ] && sleep 0.1
    fi
    echo -e "\n\n"
    echo -e "type an option: "
    [ "$no_animations" == false ] && sleep 0.1
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then next=menu.load
        more=false
    elif [ "$in" == 2 ]
    then more=true
    elif [ "$in" == t ]
    then next=tutorial
        more=false
    elif [ "$in" == q ]
    then next=close
    fi
    if [ "$more" == true ]
    then
        if [ "$in" == 4 ]
        then next=logs.clean
        elif [ "$in" == 5 ]
        then next=menu.options
        fi
    fi
    ani=false
}

function menu.more {
    log menu "drawing more menu"
    title
    echo ''
    echo "-=[  1. tutorial  ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "-=[ 2. clean logs ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "-=[  3. settings  ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "-=[ q. []<- back  ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    read -p " > " -n 1 in
    if [ "$in" == 1 ]
    then next=tutorial
    elif [ "$in" == 2 ]
    then next=logs.clean
    elif [ "$in" == 3 ]
    then next=menu.options
    elif [ "$in" == q ]
    then next=menu.main
    fi
    ani=false
}

function menu.load {
    log menu "drawing load menu"
    title
    fx.typeq "what profile do you want to load?"
    echo "  -=[ 1. profile 1 -> ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "  -=[ 2. profile 2 -> ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "  -=[ 3. profile 3 -> ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo "  -=[ q. <<-  go back ]=-"
    [ "$no_animations" == false ] && sleep 0.1
    echo -e "type an option: "
    [ "$no_animations" == false ] && sleep 0.1
    read -p "   > " -n 1 in
    if [ "$in" == 1 ]
    then next=load.profile1
    elif [ "$in" == 2 ]
    then next=load.profile2
    elif [ "$in" == 3 ]
    then next=load.profile3
    elif [ "$in" == q ]
    then next=menu.main
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
    if [ "$nw" == 1 ]
    then log teleport "network 1 interface"
    echo "you are connected to network 1
    choose an option:
        1. (1.9) [3 seconds]
        2. (1.7) [4 seconds]
        3. (2.1) [9 seconds]

        q. cancel teleport
        
        see you soon!"
        read -p " > " -n 1 in
        if [ "$in" == '' ]
        then next=$map
        elif [ "$in" == 1 ]
        then next=map.1.9
        log teleport "sending to map 1.9"
        teleport 4
        elif [ "$in" == 2 ]
        then next=map.1.7
        log teleport "sending to map 1.7"
        teleport 3
        elif [ "$in" == 3 ]
        then next=map.2.1
        log teleport "sending to map 2.1"
        teleport 9
        elif [ "$in" == q ]
        then next=$map
        log menu "close"
        fi

    else log teleport "oops! network $nw does not exist! " 
        echo -e "\n\n/!\ failed to connect to network $nw /!\. 
        use q to exit"
        read -p " > " -n 1 in
        if [ "$in" ==  q ]
        then next=$map
        fi
    fi
}


function menu.options {
    log menu "drawing options menu"
    title
    echo "-=[ 1. disable logging : $disable_logging ]=-"
    [ "$discriptions" == true ] && echo "      this disables sending log data to the log files. it still makes the log file, but removes it before closing."
    echo "-=[ 2. watch log in seperate gui : $watch_log ]=-"
    [ "$discriptions" == true ] && echo "      start a seperate terminal window to display the log in real time using watch. the terminal is defined at option 4."
    echo "-=[ 3. disable animations : $no_animations ]=-"
    [ "$discriptions" == true ] && echo "      disables all animations, making ui's apear quicker. note that you can already type the option you want before the prompt has apeared."
    echo "-=[ 4. terminal : $terminal ]=-"
    [ "$discriptions" == true ] && echo "      set the terminal used for option 2."
    echo ''
    echo "-=[ d. descriptions ]=-"
    [ "$discriptions" == true ] && echo "      makes discriptions apear below options"
    echo "-=[ a. make options persistent ]=-"
    [ "$discriptions" == true ] && echo "      save your options to a file that gets loaded at start."
    echo "-=[ q. back ]=-"
    [ "$discriptions" == true ] && echo "      go back to the 'more' screen"
    read -p " > " -n 1 in
    if [ "$in" == 1 ]
    then 
        if [ "$disable_logging" == true ]
        then disable_logging=false
        else disable_logging=true
        fi
    elif [ "$in" == 2 ]
    then 
        if [ "$watch_log" == true ]
        then watch_log=false
        else watch_log=true
        fi
    elif [ "$in" == 3 ]
    then
        if [ "$no_animations" == true ]
        then no_animations=false
        else no_animations=true
        fi
    elif [ "$in" == 4 ]
    then read -p " enter a terminal launch command: > " terminal
    elif [ "$in" == d ]
    then 
        if [ "$discriptions" == true ]
        then discriptions=false
        else discriptions=true
        fi
    elif [ "$in" == a ]
    then
        rm settings.txt
        touch settings.txt
        echo "disable_logging=$disable_logging
watch_log=$watch_log
no_animations=$no_animations
terminal='$terminal'" >> settings.txt
    elif [ "$in" == q ]
    then next=menu.main
        more=true
    fi
}

function menu.inventory {
    echo " INVENTORY "
    echo "balance: C$coins"
    index=1
    for item in $inv
    do
    echo "-=[ $index: $item ]=-"
    ((index++))
    done
    [ $index == 1 ] && echo "it's very emty in here!"
    echo "holding: $holding | use the number in front of the item then Enter to select an item"
    read -p " > " -n 2 in
    if [ "$in" == q ]
    then next=$map
    elif [ "$in" == '' ]
    then next=menu.inventory
    else
        index=1
        for item in $inv
        do
            if [ "$index" == "$in" -o "$index" == "0$in" ]
            then holding=$item
            fi
            ((index++))
        done
    fi
}

function menu.merchant {
    if [ "$1" == 1 ]
    then
        echo "MERCHANT --- your balance: C$coins
"
        [ "$no_animations" == false ] && sleep 0.1
        echo "1. stone >> C10"
        [ "$no_animations" == false ] && sleep 0.1
        echo ""
        echo "2. C20 >> stone_pickaxe"
        [ "$no_animations" == false ] && sleep 0.1
        echo "
[$inv]"
        read -p " > " -n 1 in
        if [ "$in" == 1 ]
        then inv.check stone && inv.remove stone && coins.add 10
        elif [ "$in" == 2 ]
        then [ "stone_mined" -ge 3 ] && {
        coins.check 20 && coins.remove 20 && inv.add stone_pickaxe ; }
        [ "stone_mined" -ge 3 ] || { echo "you have mined $stone_mined out of 3 stone." ; sleep 1 ; }
        fi
    fi
    if [ "$in" == q ]
    then next=$map
    fi
}

function quit {
    log menu "drawing quit without saving menu"
    echo "
    are you sure you want to quit?
     ...................................
    /! this will not save your progres !\ 
   '''''''''''''''''''''''''''''''''''''''"
   in=''
   read -p " [yes/n] > " in
   if [ "$in" == yes ]
   then next=menu.main
   elif [ "$in" == n ]
   then next=menu.pauze
   else next=menu.pauze
   fi

}

# loading/saving profiles
log game "setting profile saving/loading functions"

function load.profile1 {
    log profile "loading profile 1"
    source profiles/1.save
    next=$map
}
function load.profile2 {
    log profile "loading profile 2"
    source profiles/2.save
    next=$map
}
function load.profile3 {
    log profile "loading profile 3"
    source profiles/3.save
    next=$map
}

function save.quit {
save
next=menu.main
}
function save {
    log save/load "saving profile $profile..."
    echo "saving as profile $profile..."
    rm $data/profiles/$profile.save
    [ "$no_animations" == false ] && sleep 0.1
    touch $data/profiles/$profile.save
    [ "$no_animations" == false ] && sleep 0.1
    echo -n "
# this is your gamesave.
# please don't modify it, that's called cheating.
# and, you wont have the right stuff to get to the end...

profile=$profile
map=$map
inv='$inv'
holding='$holding'
coins=$coins
stone_mined=$stone_mined
iron_mined=$iron_mined
" >> profiles/$profile.save
echo done
next=menu.pauze
log save/load done
}

log game "setting key listener"

function keypad {
    echo "holding: $holding | use i for inventory"
    echo " use 1-9 to travel the paths. use q for the menu"
    read -s -p " > " -n 1 in
    if [ $1 == 1 ]
    then
        if [ $2 == 1 ]
        then
            map=map.1.1
            if [ "$in" == '' ]
            then next=map.1.1
            elif [ "$in" == 2 ]
            then next=map.1.2
            sleep 0.3
            elif [ "$in" == q ]
            then next=menu.pauze
                map=map.1.1
            fi
        fi
        if [ $2 == 2 ]
        then
            map=map.1.2
            if [ "$in" == '' ]
            then next=map.1.2
            elif [ "$in" == 1 ]
            then next=map.1.1
            sleep 0.3
            elif [ "$in" == 3 ]
            then next=map.1.3
            sleep 0.4
            elif [ "$in" == 4 ]
            then next=map.1.4
            0.15
            elif [ "$in" == q ]
            then next=menu.pauze
                map=map.1.2
            fi
        fi
        if [ $2 == 3 ]
        then
            map=map.1.3
            if [ "$in" == '' ]
            then next=map.1.3
            elif [ "$in" == 2 ]
            then next=map.1.2
            sleep 0.4
            elif [ "$in" == q ]
            then next=menu.pauze
                map=map.1.3
            fi
        fi
        if [ $2 == 4 ]
        then
            map=map.1.4
            if [ "$in" == '' ]
            then next=map.1.4
            elif [ "$in" == 2 ]
            then next=map.1.2
            sleep 0.15
            elif [ "$in" == 6 ]
            then next=map.1.6
            sleep 0.2
            elif [ "$in" == 8 ]
            then next=map.1.8
            sleep 0.55
            elif [ "$in" == q ]
            then next=menu.pauze
                map=map.1.4
            fi
        fi
        if [ $2 == 5 ]
        then
            map=map.1.5
            if [ "$in" == '' ]
            then next=map.1.5
            elif [ "$in" == 6 ]
            then next=map.1.6
            sleep 0.2
            elif [ "$in" == q ]
            then next=menu.pauze
                map=map.1.5
            fi
        fi
        if [ $2 == 6 ]
        then
            map=map.1.6
            if [ "$in" == '' ]
            then next=map.1.6
            elif [ "$in" == 5 ]
            then next=map.1.5
            sleep 0.2
            elif [ "$in" == 4 ]
            then next=map.1.4
            sleep 0.2
            elif [ "$in" == 7 ]
            then next=map.1.7
            sleep 0.4
            elif [ "$in" == q ]
            then next=menu.pauze
            fi
        fi
        if [ $2 == 7 ]
        then
            map=map.1.7
            if [ "$in" == '' ]
            then next=map.1.7
            elif [ "$in" == 6 ]
            then next=map.1.6
            sleep 0.4
            elif [ "$in" == t ]
            then next=menu.teleport
                nw=1
            elif [ "$in" == q ]
            then next=menu.pauze  
            fi
        fi
        if [ $2 == 8 ]
        then
            map=map.1.8
            if [ "$in" == '' ]
            then next=map.1.8
            elif [ "$in" == 4 ]
            then next=map.1.4
            sleep 0.4
            elif [ "$in" == 9 ]
            then next=map.1.9
            sleep 0.45
            elif [ "$in" == e ]
            then next="menu.merchant 1"
            elif [ "$in" == q ]
            then next=menu.pauze  
            fi
        fi
        if [ $2 == 9 ]
        then
            map=map.1.9
            if [ "$in" == '' ]
            then next=map.1.9
            elif [ "$in" == 8 ]
            then next=map.1.8
            sleep 0.45
            elif [ "$in" == t ]
            then next=menu.teleport
                nw=1
            elif [ "$in" == q ]
            then next=menu.pauze  
            fi
        fi
    fi
    if [ "$1" == 2 ]
    then
        if [ "$2" == 1 ]
        then
            map=map.2.1
            if [ "$in" == "2" ]
            then next=map.2.2
            sleep 0.3
            elif [ "$in" == t ]
            then next="menu.teleport"
            nw=1
            fi
        fi
        if [ "$2" == 2 ]
        then
            map=map.2.2
            if [ "$in" == 1 ]
            then next=map.2.1
            sleep 0.3
            elif [ "$in" == 3 ]
            then next=map.2.3
            sleep 0.6
            elif [ "$in" == 4 ]
            then next=map.2.4
            sleep 0.9
            fi
        fi
        if [ "$2" == 3 ]
        then
            map=map.2.3
            if [ "$in" == 2 ]
            then next=map.2.2
            sleep 0.6
            fi
        fi
        if [ "$2" == 4 ]
        then
            map=map.2.4
            if [ "$in" == 2 ]
            then next=map.2.2
            sleep 0.9
            elif [ "$in" == 6 ]
            then next=map.2.6
            sleep 0.6
            elif [ "$in" == 5 ]
            then next=map.2.5
            sleep 0.6
            fi
        fi
        if [ "$2" == 5 ]
        then
            map=map.2.5
            if [ "$in" == 4 ]
            then next=map.2.4
            sleep 0.6
            elif [ "$in" == 6 ]
            then next=map.2.6
            sleep 0.6
            elif [ "$in" == 0 ]
            then next=$map
            fi
        fi
        if [ "$2" == 6 ]
        then
            map=map.2.6
            if [ "$in" == 4 ]
            then next=map.2.4
            sleep 0.6
            elif [ "$in" == 5 ]
            then next=map.2.5
            sleep 0.6
            fi
        fi
    fi
    if [ "$in" == i ]
    then next=menu.inventory
    fi
    if [ "$in" == q ]
    then next=menu.pauze
    fi
    if [ "$in" == u ]
    then
        if [[ "$holding" == *"_pickaxe" ]]
        then
            if [ "$map" == map.1.5 ]
            then echo "digging..."
                if [ "$holding" == wood_pickaxe ] ; then sleep 0.9 && inv.add stone && ((stone_mined++))
                elif [ "$holding" == stone_pickaxe ] ; then sleep 0.5 && inv.add stone && ((stone_mined++))
                else echo "oops! not the right tool!"
                fi
            elif [ "$map" == map.2.6 ]
            then
                if [ "$holding" == stone_pickaxe ] ; then sleep 0.7 && inv.add iron && ((iron_mined++))
                else echo "oops! not the right tool!"
                fi
            else echo "you cant use that here!"
                sleep 0.5
            fi
        fi
        # if [[ "$holding" == *"_axe" ]]
        # then
        #     if [ "$map" == map.disabled ]
        #     then echo "digging..."
        #         sleep 0.2
        #         inv.add "wood"
        #     else echo "you cant use that here!"
        #         sleep 0.5
        #     fi
        # fi
    else echo "can't use $holding here!"
    fi
}

# maps
log game "loading maps"
source maps.sh

log game "main loop:"
log game ===============
exit=1
next="menu.main"
while true ; do
$next
clear
done

exit $exit