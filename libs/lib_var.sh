#!/bin/bash

CH_nl="$(printf "\n")"

function varsys.split {
    IFS=':' read VARFILE <<< $VARSYS
}
function varsys.check {
    case $1 in
        VAR | VARFILE | VARSYS ) log vars`` "var.set: error: name '$1' not allowed."; return 1
    esac
}

function var.init {
    [[ "$1" == '' ]] && return 2
    [[ ! -d "/dev/shm/vosjedev/" ]] && mkdir "/dev/shm/vosjedev/"
    [[ ! -d "/dev/shm/vosjedev/lib_var.sh/" ]] && mkdir "/dev/shm/vosjedev/lib_var.sh"
    [[ ! -d "/dev/shm/vosjedev/lib_var.sh/$1/" ]] && mkdir "/dev/shm/vosjedev/lib_var.sh/$1"
    [[ ! -f "/dev/shm/vosjedev/lib_var.sh/$1/vars.sh" ]] && touch "/dev/shm/vosjedev/lib_var.sh/$1/vars.sh"
    #        path to varfile                       
    VARSYS="/dev/shm/vosjedev/lib_var.sh/$1/vars.sh"
}

function var.set {
    varsys.split
    [[ "$1" == '' ]] && return 2
    varsys.check "$1" || return 1
    eval "$1=$(var.get \"$1\")"
    eval "echo \"$1=$2\"" >> "$VARFILE"
}

function var.math {
    [[ "$1" == '' ]] && return 2
    varsys.check "$1" || return 1
    eval "$1=\"$(var.get "$1")\""
    eval "(($2))"
    eval "echo \"(($1=\$$1))\"" >> "$VARFILE"
}

function var.get {
    varsys.split
    . "$VARFILE"
    eval "echo \"\$$1\""
}

function var.flush {
    varsys.split
    mv "$VARFILE" "$VARFILE.tmp"
    touch "$VARFILE"
    . "$VARFILE.tmp"
    while read line
    do IFS='=' read VAR tmp <<< $line
        [[ "$(cat "$VARFILE")" == *"$VAR="* ]] || {
            eval "echo \"$VAR=\$$VAR\"" >> "$VARFILE"
        }
    done < "$VARFILE.tmp"
    rm "$VARFILE.tmp"
    unset line var tmp
}

function var.end {
    [[ "$1" == '' ]] && return 2
    rm -rf "/dev/shm/vosjedev/lib_var.sh/$1"
}

function var.load {
    varsys.split
    [[ ! -f "/dev/shm/vosjdev/lib_var.sh/$1/vars.sh" ]] && return 1
    VARSYS="/dev/shm/vosjdev/lib_var.sh/$1/vars.sh"
}