#!/bin/bash

autoNewLine=false

function block() {
    titleLength=${#2}
    echo -en "\n\033[$1m\033[1;37m    "
    for x in $(seq 1 $titleLength); do echo -en " "; done ;
    echo -en "\033[0m\n"

    echo -en "\033[$1m\033[1;37m  $2  \033[0m\n"
    echo -en "\033[$1m\033[1;37m    "
    for x in $(seq 1 $titleLength); do echo -en " "; done ;
    echo -en "\033[0m\n\n"
}

function echoOk() {
    echo -en "\n[\033[32m OK \033[00m]\n";
}

function execCmd() {
    if [[ ( "$3" == "" && $autoNewLine == true ) || $3 == true ]]; then
        echo ""
    fi
    echo -en "\033[45m\033[1;37m$ $1\033[0m\n"
    execCmdNoEcho "$1" "$2" false
}

function execCmdNoEcho() {
    $1
    [ "$?" != "0" ] && cancelScript "$2"

    autoNewLine=true
}

function smallBlock() {
    if [ "$3" == "" ]; then
        fontColor="37"
    else
        fontColor="$3"
    fi
    echo -en "\033[$1m\033[1;${fontColor}m  $2  \033[0m\n"
}

function title() {
    block 46 "$1"
    autoNewLine=false
}

function getGitBranch() {
    echo "$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(//g' -e 's/)//g')"
}

function ask() {
    echo -en "\033[44m\033[1;37m $1 \033[0m "
}

function cancelScript() {
    if [ "$1" = "" ]; then
        message="Script canceled, error occured."
    else
        message=$1
    fi
    echo -en "\n\n"
    block 41 "$message"
    exit 1
}
