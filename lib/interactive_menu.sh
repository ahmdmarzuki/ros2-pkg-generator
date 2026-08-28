#!/bin/bash

run_interactive_menu() {
  local prompt="$1"
  shift
  local -a options=("$@")
  local -a selected=()
  local cur=0

  for ((i=0; i<${#options[@]}; i++)); do
    selected[i]=false
  done

  tput civis
  trap "tput cnorm; echo ''; exit 1" INT SIGINT SIGTERM

  SELECTED_RESULT=()

  echo -e "\033[1;36m? $prompt\033[0m \033[2m(↑/↓: Navigate, [Space]: Select, [Enter]: Confirm)\033[0m"

  while true; do
    for ((i=0; i<${#options[@]}; i++)); do
      local mark="[ ]"
      if [ "${selected[i]}" = true ]; then
        mark="\033[1;32m[x]\033[0m"
      fi

      if [ $i -eq $cur ]; then
        echo -e " \033[1;36m❯\033[0m $mark \033[1m${options[i]}\033[0m\033[K"
      else
        echo -e "   $mark ${options[i]}\033[K"
      fi
    done

    IFS= read -rsn1 key

    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 -t 0.05 key
      case "$key" in
        '[A') ((cur--)); [ $cur -lt 0 ] && cur=$((${#options[@]} - 1)) ;; # Arrow Up
        '[B') ((cur++)); [ $cur -ge ${#options[@]} ] && cur=0 ;;           # Arrow Down
      esac

    elif [[ "$key" == $' ' ]]; then
      if [ "${selected[cur]}" = true ]; then
        selected[cur]=false
      else
        selected[cur]=true
      fi

    elif [[ -z "$key" || "$key" == $'\n' || "$key" == $'\r' ]]; then
      break
    fi

    echo -en "\033[${#options[@]}A"
  done

  tput cnorm
  echo ""

  for ((i=0; i<${#options[@]}; i++)); do
    if [ "${selected[i]}" = true ]; then
      SELECTED_RESULT+=("${options[i]}")
    fi
  done
}