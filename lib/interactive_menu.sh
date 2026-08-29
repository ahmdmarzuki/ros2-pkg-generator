#!/bin/bash

ALL_PACKAGES=(
  "description"
  "hardware"
  "bringup"
  "interfaces"
  "vision"
  "simulation"
)

PRESET_BASIC=("description" "hardware" "bringup")
PRESET_FULL=("${ALL_PACKAGES[@]}")

NAV_BACK="< Back"
NAV_EXIT="Exit"

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "${LIB_DIR}/options_menu" ]; then
  for option_file in "${LIB_DIR}/options_menu"/*/*.sh; do
    [ -f "$option_file" ] && source "$option_file"
  done
fi

run_single_select() {
  local prompt="$1"
  shift
  local -a options=("$@")
  local cur=0

  tput civis
  trap "tput cnorm; echo ''; exit 1" INT SIGINT SIGTERM

  echo -e "\033[1;36m? $prompt\033[0m \033[2m(↑/↓: Navigate, [Enter]: Select)\033[0m"

  while true; do
    for ((i=0; i<${#options[@]}; i++)); do
      local item="${options[i]}"

      if [[ "$item" == *"Back"* || "$item" == *"Exit"* ]]; then
        if [ $i -eq $cur ]; then
          echo -e " \033[1;33m❯ $item\033[0m\033[K"
        else
          echo -e "   \033[2m$item\033[0m\033[K"
        fi
        continue
      fi

      if [ $i -eq $cur ]; then
        echo -e " \033[1;36m❯ \033[1;37m$item\033[0m\033[K"
      else
        echo -e "   $item\033[K"
      fi
    done

    IFS= read -rsn1 key
    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 -t 0.05 key
      case "$key" in
        '[A') ((cur--)); [ $cur -lt 0 ] && cur=$((${#options[@]} - 1)) ;;
        '[B') ((cur++)); [ $cur -ge ${#options[@]} ] && cur=0 ;;
      esac
    elif [[ -z "$key" || "$key" == $'\n' || "$key" == $'\r' ]]; then
      break
    fi

    echo -en "\033[${#options[@]}A"
  done

  tput cnorm
  echo ""
  SELECTED_SINGLE_INDEX=$cur
}

run_multi_select() {
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
  BACK_CLICKED=false

  echo -e "\033[1;36m? $prompt\033[0m \033[2m(↑/↓: Navigate, [Space]: Select, [Enter]: Confirm)\033[0m"

  while true; do
    for ((i=0; i<${#options[@]}; i++)); do
      local item="${options[i]}"
      
      if [[ "$item" == *"Back"* ]]; then
        if [ $i -eq $cur ]; then
          echo -e " \033[1;33m❯ $item\033[0m\033[K"
        else
          echo -e "   \033[2m$item\033[0m\033[K"
        fi
        continue
      fi

      local mark="[ ]"
      [ "${selected[i]}" = true ] && mark="\033[1;32m[x]\033[0m"

      if [ $i -eq $cur ]; then
        echo -e " \033[1;36m❯\033[0m $mark \033[1m$item\033[0m\033[K"
      else
        echo -e "   $mark $item\033[K"
      fi
    done

    IFS= read -rsn1 key
    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 -t 0.05 key
      case "$key" in
        '[A') ((cur--)); [ $cur -lt 0 ] && cur=$((${#options[@]} - 1)) ;;
        '[B') ((cur++)); [ $cur -ge ${#options[@]} ] && cur=0 ;;
      esac
    elif [[ "$key" == $' ' ]]; then
      if [[ "${options[cur]}" != *"[ Back"* ]]; then
        [ "${selected[cur]}" = true ] && selected[cur]=false || selected[cur]=true
      fi
    elif [[ -z "$key" || "$key" == $'\n' || "$key" == $'\r' ]]; then
      if [[ "${options[cur]}" == *"Back"* ]]; then
        BACK_CLICKED=true
      fi
      break
    fi

    echo -en "\033[${#options[@]}A"
  done

  tput cnorm
  echo ""

  if [ "$BACK_CLICKED" = false ]; then
    for ((i=0; i<${#options[@]}; i++)); do
      if [ "${selected[i]}" = true ]; then
        SELECTED_RESULT+=("${options[i]}")
      fi
    done
  fi
}

run_tree_menu() {
  ROBOT_NAME="$1"
  CURRENT_SCREEN="LAYER_MAIN"

  while true; do
    case "$CURRENT_SCREEN" in
      "LAYER_MAIN")     layer_1_main ;;
      "LAYER_PRESETS")  layer_2_presets ;;
      "LAYER_CUSTOM")   layer_2_custom ;;
      "DONE")           return 0 ;;
    esac
  done
}