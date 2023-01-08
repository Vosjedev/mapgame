#! /usr/bin/bash

[[ "$debug" == 1 ]] && set -x

COLUMNS=$(tput cols)
LINES=$(tput lines)
# echo "$COLUMNS by $LINES"
# read

if [[ "$COLUMNS" -lt 40 ]]
then if [[ "$COLUMNS" -gt 21 ]]
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

if [[ "$LINES" -lt 26 ]]
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
while [[ $lines -le $LINES ]]
do echo ''
((lines++))
done
clear


# vars
[[ "$data" > /dev/null ]] || {
file="$(which "$0")"
while :
do
    if [[ -L "$file" ]]
    then file=$(readlink "$file")
    elif [[ -d "$file" ]]
    then echo "error while finding appdata. export the datapath as variable 'data' to set it manualy."; exit 1
    elif [[ -f "$file" ]]
    then break
    fi
done
cd "$(dirname "$file")"
data="$(pwd)"
}

ani=ani

# some other stuff

cd "$data"
startdt="$(date +'%a-%d-%b-%T')"
touch "logs/$startdt"
prevar=true
echo -e "ititializing logging" >> "logs/$startdt"
function log {
    [[ "$(var.get disable_logging)" == false ]] && {
        while read logline
        do echo -e "[$1]: $logline" >> "logs/$startdt"
        done <<< "$2"
    }
    [[ "$prevar" == true ]] && echo "$1: $2" >> "logs/$startdt"
}
function logs.clean {
    for file in $(ls logs)
    do
        [[ "$file" == $startdt ]] || rm logs/$file
    done
    var.set next menu.main
}
echo "[game.log]: logging started" >> "logs/$startdt"

echo "[libs]: loadings libs..." >> "logs/$startdt"
for lib in libs/*
do
    echo "[libs]: |- lib 'libs/$lib'" >> "logs/$startdt"
    . "$lib"
done
echo "[libs]: done" >> "logs/$startdt"

[[ -f settings.txt ]] || {
    log setup "no settings file found, running ./install.sh"
    chmod +x install.sh
    ./install.sh
}

# shared vars
log "vars" "var lib init"
var.init mapgame
log vars "splitting varsys:
VARSYS='$VARSYS'"
varsys.split
log vars "VARFILE='$VARFILE'"
log vars "settings some normal variables to shared variables"
var.set data "$data"
var.set startdt "$startdt"
prevar=false

echo "[settings]: loading settings" >> "logs/$startdt"
. settings.txt && log settings "successfull"
[[ "$(var.get watch_log)" == true ]] && {
    nohup $(var.get terminal) tail -f $data/logs/$startdt || $(var.get terminal) tail -f $data/logs/$startdt >> $data/logs/$startdt &
}

# var.set 

# generators
# log game.generator-system "starting generators"

# coins
log game.coin-system "coin system"
function coins.add {
    var.math coins coins=$coins+$1
}
function coins.remove {
    var.math coins coins=$coins-$1
}
function coins.check {
    if [[ "$coins" -ge "$1" ]]
    then return 0
    else echo "not enough coins!"
    return 1
    fi
}

# functions
log game "setting functions"
function fx.type { input="$1"; for (( i=0; i<${#input}; i++ )); do echo -n "${input:$i:1}"; [[ "$(var.get no_animations)" == false ]] && sleep 0.1; done; [[ "$(var.get no_animations)" == false ]] && sleep 0.5 ; echo '' ; }
function fx.typeq { input="$1"; for (( i=0; i<${#input}; i++ )); do echo -n "${input:$i:1}"; [[ "$(var.get no_animations)" == false ]] && sleep 0.01; done; [[ "$(var.get no_animations)" == false ]] && sleep 0.05 ; echo '' ; }

function calc {
((answer=$1))
echo $answer
}

function close {
    log game "==============="
    log game "closing..."
    [[ "$(var.get disable_logging)" == true ]] && rm logs/$startdt
    echo -e "\n\n\n\n"
    title #ani
    echo -e "\n\n\n\n"
    sleep 1
    var.set next "break"
    exit=0
    log game "trying to exit"
}

function title {
    if [[ "$1" == ani ]]
    then
    fx.typeq "               __     ___                 ___"
    fx.typeq " /\  /\   /\  |__)   /  __  /\   /\  /\  |___"
    fx.typeq "/  \/  \ /--\ |      \___/ /--\ /  \/  \ |___"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.2
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
    [[ ! -x tutorial.sh ]] && chmod +x tutorial.sh
    [[ ! -f logs/tutorial ]] && touch logs/tutorial
    ./tutorial.sh
    var.set next menu.main
}

# loops
log game "loading infinite loops"

function loop.save {
    until [[ "$(var.get break_in_game_loop)" == true ]]
    do
        [[ "$(var.get autosave_time)" == none ]] || {
            sleep $(var.get autosave_time)
            save
        }
    done
}
function loop.ingame {
    log "loop" "ingame: started"
    until [[ "$(var.get break_in_game_loop)" == true ]]
    do # log loop "looped! '$(var.get break_in_game_loop)'"
        # var.math IGL_tps IGL_tps++
        #
        if [[ "$(var.get gen_1_5_ticks)" -ge 600 ]]
        then var.set gen_1_5_left_stone 3; var.set gen_1_5_ticks 0
        else var.math gen_1_5_ticks gen_1_5_ticks++
        fi
        if [[ "$(var.get gen_2_6_ticks)" -ge 1200 ]]
        then var.set gen_2_6_left_iron 6; var.set gen_2_6_ticks 0
        else var.math gen_2_6_ticks gen_2_6_ticks++
        fi
        sleep 0.1
    done
    log "loop" "ingame: stopped"
    # var.math IGL_tps IGL_tps=0
}
function loop.nongame {
    while :
    do
        # var.math NGL_tps NGL_tps++
        sleep 0.1
        [[ $(var.get break) == true ]] && {
            echo "breaking nongame loop..."
            var.math LOOP_broken LOOP_broken++
            break
        }
    done
}

function loop.flush {
    while :
    do
        # log "vars" "flush..."
        var.flush && sleep 1
                [[ $(var.get break) == true ]] && {
            echo "breaking varflush loop..."
            var.math LOOP_broken LOOP_broken++
            break
        }
    done
}

# function loop.tps {
#     while :
#     do
#         sleep 1
#         info.push   &
#         var.math NGL_tps NGL_tps=0
#         var.math IGL_tps IGL_tps=0
#     done
#     [[ $(var.get break) == true ]] && {
#         var.math LOOP_broken LOOP_broken++
#         break
#     }
# }

# info
# rm info.txt
# function info.push {
#     # set -x
#     echo "--==== $(date) ====--
# tps:        $(($(($(var.get IGL_TPS)+$(var.get NGL_TPS)))/2))
# IGL_tps:    $(var.get IGL_TPS)
# NGL_tps:    $(var.get NGL_TPS)
# map:        $(var.get map)
# current:    $(var.get next)
# not ingame: $(var.get break_in_game_loop)

# " >> info.txt
#     # set +x
# }

# mining

function mine.1.5.stone {
    if [[ "$(var.get gen_1_5_left_stone)" -ge 0 ]]
    then var.math gen_1_5_left_stone gen_1_5_left_stone--
        if [[ "$(var.get holding)" == wood_pickaxe ]]
        then sleep 0.9 && inv.add stone && achivement.give stone
        elif [[ "$(var.get holding)" == stone_pickaxe ]] ; then sleep 0.5 && inv.add stone
        else echo "oops! not the right tool!"; var.math gen_1_5_left_stone gen_1_5_left_stone++
        fi
    else echo "you can not mine yet! $((600-$(var.get gen_1_5_ticks)))/600 ticks left"
    fi
}

function mine.2.6.iron {
    if [[ "$(var.get gen_2_6_left_iron)" -ge 0 ]]
    then var.math gen_2_6_left_iron gen_2_6_left_iron--
        if [[ "$(var.get holding)" == stone_pickaxe ]] ; then sleep 0.7 && inv.add iron && achivement.give iron
        else echo "oops! not the right tool!"; var.math gen_2_6_left_iron gen_2_6_left_iron++
        fi
    else echo "you can not mine yet! $((1200-$(var.get gen_2_6_ticks)))/1200 ticks left"
    fi
}

# inventory
log game "inventory manager"

function inv.add {
    var.set inv "$(var.get inv) $1 "
}
function inv.remove {
    done=false
    oldvar.set inv "$(var.get inv)"
    var.set inv ' '
    for item in $oldinv
    do
    if [[ "$item" == $1 ]]
    then if [[ "$done" == true ]]
        then var.set inv "$(var.get inv)$item "
        else done=true
        fi
    else var.set inv "$(var.get inv)$item "
    fi
    done
}
function inv.check {
    if [[ "$(var.get inv)" == *" $1 "* ]]
    then return 0
    else return 1
    fi
}

# menu's
log game "setting menu's"

function menu.pauze {
    [[ "$(var.get save_on_pauze)" == true ]] && save
    log menu "drawing pauze menu"
    title
    echo "  -=[ q. return to game ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo -n "  -=[ 2. quit"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.01
    echo -n " | "
    [[ "$(var.get no_animations)" == false ]] && sleep 0.01
    echo "s. save ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "  -=[    3. settings    ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "  -=[ 1. save and quit  ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo -e "\n  type an option: "
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    read -s -p "   > " -n 1 in
    if [[ "$in" == q ]]
    then var.set next $(var.get map)
    elif [[ "$in" == s ]]
    then var.set next save
    elif [[ "$in" == 2 ]]
    then var.set next quit
    elif [[ "$in" == 3 ]]
    then var.set next menu.options
        var.set back menu.pauze
    elif [[ "$in" == 1 ]]
    then var.set next save.quit
    fi
}

function menu.main {
    var.set back menu.main
    log menu "drawing main menu"
    title $ani
    echo -e "\n\n"
    echo "  -=[  1. go! ->>  ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    [[ ! -f logs/tutorial ]] && echo "  -=[ t. tutorial ]=-"
    echo "  -=[ q. []<- exit ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    if [[ "$more" == true ]]
    then
            log menu "drawing more menu"
        echo "  -=[  t. tutorial  ]=-"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        echo "  -=[ 4. clean logs ]=-"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        echo "  -=[  5. settings  ]=-"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    else
        echo "[ 2. more ]"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    fi
    echo -e "\n\n"
    echo -e "type an option: "
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    read -p "   > " -n 1 in
    if [[ "$in" == 1 ]]
    then var.set next menu.load
        more=false
    elif [[ "$in" == 2 ]]
    then more=true
    elif [[ "$in" == t ]]
    then var.set next tutorial
        more=false
    elif [[ "$in" == q ]]
    then var.set next close
    fi
    if [[ "$more" == true ]]
    then
        if [[ "$in" == 4 ]]
        then var.set next logs.clean
        elif [[ "$in" == 5 ]]
        then var.set next menu.options
            var.set back menu.main
        fi
    fi
    ani=false
}

function menu.more {
    log menu "drawing more menu"
    title
    echo ''
    echo "-=[  1. tutorial  ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "-=[ 2. clean logs ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "-=[  3. settings  ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "-=[ q. []<- back  ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    read -p " > " -n 1 in
    if [[ "$in" == 1 ]]
    then var.set next tutorial
    elif [[ "$in" == 2 ]]
    then var.set next logs.clean
    elif [[ "$in" == 3 ]]
    then var.set next menu.options
            var.set back menu.more
    elif [[ "$in" == q ]]
    then var.set next menu.main
    fi
    ani=false
}

function menu.load {
    log menu "drawing load menu"
    title
    fx.typeq "what profile do you want to load?"
    echo "  -=[ 1. profile 1 -> ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "  -=[ 2. profile 2 -> ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "  -=[ 3. profile 3 -> ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo "  -=[ q. <<-  go back ]=-"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo -e "type an option: "
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    read -p "   > " -n 1 in
    if [[ "$in" == 1 ]]
    then var.set next load.profile1
    elif [[ "$in" == 2 ]]
    then var.set next load.profile2
    elif [[ "$in" == 3 ]]
    then var.set next load.profile3
    elif [[ "$in" == q ]]
    then var.set next menu.main
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
    if [[ "$nw" == 1 ]]
    then log teleport "network 1 interface"
    echo "you are connected to network 1
    choose an option:
        1. (1.9) [3.0 seconds]
        2. (1.7) [4.0 seconds]
        3. (2.1) [3.5 seconds]

        q. cancel teleport
        
        see you soon!"
        read -p " > " -n 1 in
        if [[ "$in" == '' ]]
        then var.set next $(var.get map)
        elif [[ "$in" == 1 ]]
        then var.set next map.1.9
        log teleport "sending to map 1.9"
        teleport 4
        elif [[ "$in" == 2 ]]
        then var.set next map.1.7
        log teleport "sending to map 1.7"
        teleport 3
        elif [[ "$in" == 3 ]]
        then var.set next map.2.1
        log teleport "sending to map 2.1"
        teleport 3.5
        elif [[ "$in" == q ]]
        then var.set next $(var.get map)
        log menu "close"
        fi

    else log teleport "oops! network $nw does not exist! " 
        echo -e "\n\n/!\ failed to connect to network $nw /!\. 
        use q to exit"
        read -p " > " -n 1 in
        if [[ "$in" ==  q ]]
        then var.set next $(var.get map)
        fi
    fi
}


function menu.options {
    log menu "drawing options menu"
    title
    echo "-=[ 1. disable logging : $(var.get disable_logging) ]=-"
    [[ "$discriptions" == true ]] && echo "      this disables sending log data to the log files. it still makes the log file, but removes it before closing."
    echo "-=[ 2. watch log in seperate gui : $(var.get watch_log) ]=-"
    [[ "$discriptions" == true ]] && echo "      start a seperate terminal window to display the log in real time using watch. the terminal is defined at option 4."
    echo "-=[ 3. disable animations : $(var.get no_animations) ]=-"
    [[ "$discriptions" == true ]] && echo "      disables all animations, making ui's apear quicker. note that you can already type the option you want before the prompt has apeared."
    echo "-=[ 4. terminal : $(var.get terminal) ]=-"
    [[ "$discriptions" == true ]] && echo "      set the terminal used for option 2."
    echo "-=[ 5. save on pauze : $(var.get save_on_pauze) ]=-"
    [[ "$discriptions" == true ]] && echo "     save the game when pauzing"
    echo "-=[ 6. autosave time: $(var.get autosave_time) ]=-"
    [[ "$discriptions" == true ]] && echo "autosave time in seconds. the order is:\n10|20|60|120|none"
    echo ''
    echo "-=[ d. descriptions ]=-"
    [[ "$discriptions" == true ]] && echo "      makes discriptions apear below options"
    echo "-=[ a. make options persistent ]=-"
    [[ "$discriptions" == true ]] && echo "      save your options to a file that gets loaded at start."
    echo "-=[ q. back ]=-"
    [[ "$discriptions" == true ]] && echo "      go back"
    read -p " > " -n 1 in
    if [[ "$in" == 1 ]]
    then 
        if [[ "$(var.get disable_logging)" == true ]]
        then var.set disable_logging false
        else var.set disable_logging true
        fi
    elif [[ "$in" == 2 ]]
    then 
        if [[ "$(var.get watch_log)" == true ]]
        then var.set watch_log false
        else var.set watch_log true
        fi
    elif [[ "$in" == 3 ]]
    then
        if [[ "$(var.get no_animations)" == true ]]
        then var.set no_animations false
        else var.set no_animations true
        fi
    elif [[ "$in" == 4 ]]
    then read -p " enter a terminal launch command: > " terminal && var.set terminal "$terminal"
    elif [[ "$in" == 5 ]]
    then
        if [[ "$(var.get save_on_pauze)" == true ]]
        then var.set save_on_pauze false
        else var.set save_on_pauze true
        fi
    elif [[ "$in" == 6 ]]
    then
        case $(var.get autosave_time) in
            10   ) var.set autosave_time 20   ;;
            20   ) var.set autosave_time 60   ;;
            60   ) var.set autosave_time 120  ;;
            120  ) var.set autosave_time none ;;
            none ) var.set autosave_time 10   ;;
            *    ) var.set autosave_time 20   ;;
        esac
    elif [[ "$in" == d ]]
    then 
        if [[ "$discriptions" == true ]]
        then discriptions=false
        else discriptions=true
        fi
    elif [[ "$in" == a ]]
    then
        rm settings.txt
        touch settings.txt
        echo "
var.set disable_logging '$(var.get disable_logging)'
var.set watch_log '$(var.get watch_log)'
var.set no_animations '$(var.get no_animations)'
var.set terminal '$(var.get terminal)'
var.set save_on_pauze '$(var.get save_on_pauze)'
var.set autosave_time '$(var.get autosave_time)'
" >> settings.txt
    elif [[ "$in" == q ]]
    then var.set next "$(var.get back)"
        more=true
    fi
}

function menu.inventory {
    echo " INVENTORY "
    echo "balance: C$(var.get coins)"
    index=1
    for item in $(var.get inv)
    do
    echo "-=[ $index: $item ]=-"
    ((index++))
    done
    [[ $index == 1 ]] && echo "it's very emty in here!"
    echo "holding: $(var.get holding) | use the number in front of the item then Enter to select an item"
    read -p " > " -n 2 in
    if [[ "$in" == q ]]
    then var.set next $(var.get map)
    elif [[ "$in" == '' ]]
    then var.set next menu.inventory
    else
        index=1
        for item in $(var.get inv)
        do
            if [[ "$index" == "$in"]] || [["$index" == "0$in" ]]
            then var.set holding $item && inv.remove "$item"
            fi
            ((index++))
        done
    fi
}

function menu.merchant {
    if [[ "$1" == 1 ]]
    then
        echo "MERCHANT --- your balance: C$(var.get coins)
"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        echo "1. stone >> C5"
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        achivement.has iron && echo "2. iron >> C15"
        achivement.has iron && [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        echo ""
        echo "3. C20 >> stone_pickaxe"
        [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        achivement.has iron && echo "4. C500 >> iron_pickaxe"
        achivement.has iron && [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        echo -e "\n[$(var.get inv)]"
        read -p " > " -n 1 in
        if [[ "$in" == 1 ]]
        then inv.check stone && inv.remove stone && coins.add 5
        elif [[ "$in" == 2 ]] && achivement.has "iron"
        then inv.check iron && inv.remove iron && coins.add 15
        # 
        elif [[ "$in" == 3 ]] && achivement.has "stone"
        then coins.check 20 && coins.remove 20 && inv.add stone_pickaxe
        elif [[ "$in" == 4 ]] && achivement.has iron
        then coins.check 50 && coins.remove 50 && inv.add iron_pickaxe
        fi
    fi
    if [[ "$in" == q ]]
    then var.set next $(var.get map)
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
   if [[ "$in" == yes ]]
   then var.set next menu.main
   elif [[ "$in" == n ]]
   then var.set next menu.pauze
   else var.set next menu.pauze
   fi

}
# achivements
log game "achivements"
# 
# stone     = stone!
# iron      = iron!
# teleport  = the telescope of the port
# 
# 
function achivement.resolve {
    case $1 in
        stone   ) echo "stone!"     ;;
        iron    ) echo "iron!"      ;;
        *       ) log ERR "achivement $1 not found!"
    esac
}
function achivement.give {
    achivement.has "$1" || {
        var.set achivements "$(var.get achivements) $1 " && tput cup 1 1 && {
            echo " ACHIVEMENT: $(achivement.resolve $1)!"
            echo ".___________"
            nr=1
            until [[ "$nr" -ge $(echo "$(achivement.resolve $1)" | wc -c) ]]
            do echo -n "_"; ((nr++))
            done
            echo "_."
        }
    }
}
function achivement.revoke {
    var.set achivements "$(var.get achivements)"
}
function achivement.has {
    if [[ "$(var.get achivements)" == *" $1 "* ]]
    then return 0
    else return 1
    fi
}

# loading/saving profiles
log game "setting profile saving/loading functions"

function load {
    var.set break_in_game_loop false
    loop.ingame &
    loop.save &
}

function load.profile1 {
    log profile "loading profile 1"
    source profiles/1.save
    var.set next $(var.get map)
    load
}
function load.profile2 {
    log profile "loading profile 2"
    source profiles/2.save
    var.set next $(var.get map)
    load
}
function load.profile3 {
    log profile "loading profile 3"
    source profiles/3.save
    var.set next $(var.get map)
    load
}

function save.quit {
save
var.set next menu.main
var.set break_in_game_loop true
}
function save {
    log save/load "saving profile $(var.get profile)..."
    echo "saving as profile $(var.get profile)..."
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    rm $data/profiles/$(var.get profile).save
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    touch $data/profiles/$(var.get profile).save
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
    echo -n "
# this is your gamesave.
# please don't modify it, that's called cheating.
# and, you wont have the right stuff to get to the end...

var.set profile $(var.get profile)
var.set map $(var.get map)
var.set inv '$(var.get inv)'
var.set holding '$(var.get holding)'
var.set coins $(var.get coins)
var.set achivements ' $(var.get achivements) '
var.set gen_1_5_ticks $(var.get gen_1_5_ticks)
var.set gen_1_5_left_stone $(var.get gen_1_5_left_stone)
var.set gen_2_6_ticks $(var.get gen_2_6_ticks)
var.set gen_2_6_left_iron $(var.get gen_2_6_left_iron)
" >> profiles/$(var.get profile).save
echo done
var.set next menu.pauze
log save/load done
}

log game "setting key listener"

function keypad {
    echo "holding: $(var.get holding) | use i for inventory"
    echo " use 1-9 to travel the paths. use q for the menu"
    read -s -p " > " -n 1 in
    if [[ $1 == 1 ]]
    then
        if [[ $2 == 1 ]]
        then
            var.set map map.1.1
            if [[ "$in" == '' ]]
            then var.set next map.1.1
            elif [[ "$in" == 2 ]]
            then var.set next map.1.2
            sleep 0.3
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
                var.set map map.1.1
            fi
        fi
        if [[ $2 == 2 ]]
        then
            var.set map map.1.2
            if [[ "$in" == '' ]]
            then var.set next map.1.2
            elif [[ "$in" == 1 ]]
            then var.set next map.1.1
            sleep 0.3
            elif [[ "$in" == 3 ]]
            then var.set next map.1.3
            sleep 0.4
            elif [[ "$in" == 4 ]]
            then var.set next map.1.4
            0.15
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
                var.set map map.1.2
            fi
        fi
        if [[ $2 == 3 ]]
        then
            var.set map map.1.3
            if [[ "$in" == '' ]]
            then var.set next map.1.3
            elif [[ "$in" == 2 ]]
            then var.set next map.1.2
            sleep 0.4
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
                var.set map map.1.3
            fi
        fi
        if [[ $2 == 4 ]]
        then
            var.set map map.1.4
            if [[ "$in" == '' ]]
            then var.set next map.1.4
            elif [[ "$in" == 2 ]]
            then var.set next map.1.2
            sleep 0.15
            elif [[ "$in" == 6 ]]
            then var.set next map.1.6
            sleep 0.2
            elif [[ "$in" == 8 ]]
            then var.set next map.1.8
            sleep 0.55
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
                var.set map map.1.4
            fi
        fi
        if [[ $2 == 5 ]]
        then
            var.set map map.1.5
            if [[ "$in" == '' ]]
            then var.set next map.1.5
            elif [[ "$in" == 6 ]]
            then var.set next map.1.6
            sleep 0.2
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
                var.set map map.1.5
            fi
        fi
        if [[ $2 == 6 ]]
        then
            var.set map map.1.6
            if [[ "$in" == '' ]]
            then var.set next map.1.6
            elif [[ "$in" == 5 ]]
            then var.set next map.1.5
            sleep 0.2
            elif [[ "$in" == 4 ]]
            then var.set next map.1.4
            sleep 0.2
            elif [[ "$in" == 7 ]]
            then var.set next map.1.7
            sleep 0.4
            elif [[ "$in" == q ]]
            then var.set next menu.pauze
            fi
        fi
        if [[ $2 == 7 ]]
        then
            var.set map map.1.7
            if [[ "$in" == '' ]]
            then var.set next map.1.7
            elif [[ "$in" == 6 ]]
            then var.set next map.1.6
            sleep 0.4
            elif [[ "$in" == t ]]
            then var.set next menu.teleport
                nw=1
            elif [[ "$in" == q ]]
            then var.set next menu.pauze  
            fi
        fi
        if [[ $2 == 8 ]]
        then
            var.set map map.1.8
            if [[ "$in" == '' ]]
            then var.set next map.1.8
            elif [[ "$in" == 4 ]]
            then var.set next map.1.4
            sleep 0.4
            elif [[ "$in" == 9 ]]
            then var.set next map.1.9
            sleep 0.45
            elif [[ "$in" == e ]]
            then var.set next "menu.merchant 1"
            elif [[ "$in" == q ]]
            then var.set next menu.pauze  
            fi
        fi
        if [[ $2 == 9 ]]
        then
            var.set map map.1.9
            if [[ "$in" == '' ]]
            then var.set next map.1.9
            elif [[ "$in" == 8 ]]
            then var.set next map.1.8
            sleep 0.45
            elif [[ "$in" == t ]]
            then var.set next menu.teleport
                nw=1
            elif [[ "$in" == q ]]
            then var.set next menu.pauze  
            fi
        fi
    fi
    if [[ "$1" == 2 ]]
    then
        if [[ "$2" == 1 ]]
        then
            var.set map map.2.1
            if [[ "$in" == "2" ]]
            then var.set next map.2.2
            sleep 0.3
            elif [[ "$in" == t ]]
            then var.set next "menu.teleport"
            nw=1
            fi
        fi
        if [[ "$2" == 2 ]]
        then
            var.set map map.2.2
            if [[ "$in" == 1 ]]
            then var.set next map.2.1
            sleep 0.3
            elif [[ "$in" == 3 ]]
            then var.set next map.2.3
            sleep 0.6
            elif [[ "$in" == 4 ]]
            then var.set next map.2.4
            sleep 0.9
            fi
        fi
        if [[ "$2" == 3 ]]
        then
            var.set map map.2.3
            if [[ "$in" == 2 ]]
            then var.set next map.2.2
            sleep 0.6
            fi
        fi
        if [[ "$2" == 4 ]]
        then
            var.set map map.2.4
            if [[ "$in" == 2 ]]
            then var.set next map.2.2
            sleep 0.9
            elif [[ "$in" == 6 ]]
            then var.set next map.2.6
            sleep 0.6
            elif [[ "$in" == 5 ]]
            then var.set next map.2.5
            sleep 0.6
            fi
        fi
        if [[ "$2" == 5 ]]
        then
            var.set map map.2.5
            if [[ "$in" == 4 ]]
            then var.set next map.2.4
            sleep 0.6
            elif [[ "$in" == 6 ]]
            then var.set next map.2.6
            sleep 0.6
            elif [[ "$in" == 0 ]]
            then var.set next $(var.get map)
            fi
        fi
        if [[ "$2" == 6 ]]
        then
            var.set map map.2.6
            if [[ "$in" == 4 ]]
            then var.set next map.2.4
            sleep 0.6
            elif [[ "$in" == 5 ]]
            then var.set next map.2.5
            sleep 0.6
            fi
        fi
    fi
    if [[ "$in" == i ]]
    then var.set next menu.inventory
    fi
    if [[ "$in" == q ]]
    then var.set next menu.pauze
    fi
    if [[ "$in" == u ]]
    then
        if [[ "$(var.get holding)" == *"_pickaxe" ]]
        then
            if [[ "$(var.get map)" == map.1.5 ]]
            then mine.1.5.stone
            elif [[ "$(var.get map)" == map.2.6 ]]
            then mine.2.6.iron
            else echo "you cant use that here!"
                sleep 0.5
            fi
        fi
        # if [[ "$(var.get holding)" == *"_axe" ]]
        # then
        #     if [[ "$(var.get map)" == map.disabled ]]
        #     then echo "digging..."
        #         sleep 0.2
        #         inv.add "wood"
        #     else echo "you cant use that here!"
        #         sleep 0.5
        #     fi
        # fi
    fi
}

# maps
log game "loading maps"
source maps.sh

log game "main loop:"
log game "==============="
exit=1
# IGL_tps=0
# NGL_tps=0
# loop.tps &
var.set break false
loop.nongame &
loop.flush   &
var.set next "menu.main"
clear
while true ; do
$(var.get next)
echo "flushing variables..."
var.flush && echo "done!" || echo "error!"
clear
done

var.math LOOP_broken LOOP_broken=0
var.set break true
var.set break_in_game_loop true
echo "waiting for loops to stop... "
until [[ $(var.get LOOP_broken) -ge 2 ]]
do sleep 0.1
done && echo "done. "
var.end mapgame
set +x
exit $exit