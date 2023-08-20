#!/usr/bin/bash

clear
echo "running first-time-install"

echo -e "running git pull...\n > git pull"
git pull
echo -e "\> git pull\ndone."

source libs/lib_var.sh

echo "making settings.txt..."
echo "disable_logging=false
watch_log=false
no_animations=false
terminal='echo \"set a terminal in the settings to watch the log.\"'
save_on_pauze=true
autosave_time=20
" >> settings.txt

echo "done"

echo "making game profiles..."
mkdir profiles
cd profiles
var.math profile profile=1
while [[ $(var.get profile) -le 3 ]]
do
    if [[ -f $(var.get profile).save ]]
    then
        echo "profile $(var.get profile) already here..."
    [[ "$(var.get no_animations)" == false ]] && sleep 0.1
        source $(var.get profile).save
        rm $(var.get profile).save
    else
        var.set map map.1.1
        var.set inv ' wood_pickaxe '
        var.set holding ''
        var.set coins 0
        var.set gen_1_5_ticks 601
        var.set gen_2_6_ticks 1201
        var.set gen_1_5_left_stone 3
        var.set gen_2_6_left_iron 6
    fi
    touch $(var.get profile).save
    echo -n "
# this is your gamesave.
# please don't modify it, that's called cheating.
# and, you wont have the right stuff to get to the end...

var.set profile $(var.get profile)
var.set map $map
var.set inv '$(var.get inv)'
var.set holding '$(var.get holding)'
var.set coins $(var.get coins)
var.set achivements' $(var.get achivements) '
var.set gen_1_5_ticks $(var.get gen_1_5_ticks)
var.set gen_1_5_left_stone $(var.get gen_1_5_left_stone)
var.set gen_2_6_ticks $(var.get gen_2_6_ticks)
var.set gen_2_6_left_iron $(var.get gen_2_6_left_iron)
" >> $(var.get profile).save
    var.math profile profile++
done
cd ..
echo "done"

echo "making logs folder..."
mkdir logs
echo "done"

read -p "press enter to enter the game." -s
clear