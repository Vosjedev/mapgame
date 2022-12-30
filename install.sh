#!/usr/bin/bash

clear
echo "running first-time-install"

echo -e "running git pull...\n > git pull"
git pull
echo -e "\> git pull\ndone."


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
((profile=1))
while [[ $profile -le 3 ]]
do
    if [ -f $profile.save ]
    then
        echo "profile $profile already here..."
    [ "$no_animations" == false ] && sleep 0.1
        source $profile.save
        rm $profile.save
    else
        map=map.1.1
        inv=' wood_pickaxe '
        holding=''
        coins=0
        gen_1_5_ticks=601
        gen_2_6_ticks=1201
        gen_1_5_left_stone=3
        gen_2_6_left_iron=6
    fi
    touch $profile.save
    echo -n "
# this is your gamesave.
# please don't modify it, that's called cheating.
# and, you wont have the right stuff to get to the end...

profile=$profile
map=$map
inv='$inv'
holding='$holding'
coins=$coins
achivements=' $achivements '
((gen_1_5_ticks=$gen_1_5_ticks))
gen_1_5_left_stone=$gen_1_5_left_stone
((gen_2_6_ticks=$gen_2_6_ticks))
gen_2_6_left_iron=$gen_2_6_left_iron
" >> $profile.save
    ((profile++))
done
cd ..
echo "done"

echo "making logs folder..."
mkdir logs
echo "done"

read -p "press enter to enter the game." -s
clear