#!/bin/bash

generate_custom_pkg(){
    local PKG_NAME=""
    
    echo -en "\033[1;36m? Enter package name:\033[0m "
    read -r PKG_NAME
}