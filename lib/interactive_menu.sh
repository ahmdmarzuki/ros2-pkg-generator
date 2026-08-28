#!/bin/bash

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
      
      # Handle tampilan opsi spesial [ Back ]
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
      # Jangan centang tombol Back
      if [[ "${options[cur]}" != *"[ Back"* ]]; then
        [ "${selected[cur]}" = true ] && selected[cur]=false || selected[cur]=true
      fi
    elif [[ -z "$key" || "$key" == $'\n' || "$key" == $'\r' ]]; then
      # Jika tekan enter di opsi Back
      if [[ "${options[cur]}" == *"Back"* ]]; then
        BACK_CLICKED=true
      fi
      break
    fi

    echo -en "\033[${#options[@]}A"
  done

  tput cnorm
  echo ""

  # Simpan hasil centang jika tidak klik Back
  if [ "$BACK_CLICKED" = false ]; then
    for ((i=0; i<${#options[@]}; i++)); do
      if [ "${selected[i]}" = true ]; then
        SELECTED_RESULT+=("${options[i]}")
      fi
    done
  fi
}

run_tree_menu() {
  local robot_name="$1"

  while true; do
    # LAYER 1: Main Categories
    local layer1_options=(
      "Preset Bundles (Basic / Full Stack)"
      "Individual Packages (Custom Selection)"
      "Exit"
    )

    run_single_select "Select setup mode for [${robot_name}]:" "${layer1_options[@]}"

    case $SELECTED_SINGLE_INDEX in
      0)
        # LAYER 2A: Preset Bundles
        local preset_options=(
          "Basic Setup (description, hardware, bringup)"
          "Full Stack (all packages)"
          "< Back to Main Menu"
        )
        run_single_select "Choose a preset bundle:" "${preset_options[@]}"
        
        if [ $SELECTED_SINGLE_INDEX -eq 0 ]; then
          SELECTED_MODE="basic"
          return 0
        elif [ $SELECTED_SINGLE_INDEX -eq 1 ]; then
          SELECTED_MODE="full"
          return 0
        fi
        # Jika indeks 2 ([ Back ]), loop akan berulang ke Layer 1
        ;;

      1)
        # LAYER 2B: Custom Package Multi-Select
        local pkg_options=(
          "description"
          "hardware"
          "bringup"
          "interfaces"
          "vision"
          "simulation"
          "< Back to Main Menu"
        )
        run_multi_select "Select packages to create:" "${pkg_options[@]}"

        if [ "$BACK_CLICKED" = false ]; then
          SELECTED_MODE="custom"
          # SELECTED_RESULT sudah berisi array paket yang dicentang
          return 0
        fi
        ;;

      2)
        echo "Aborted."
        exit 0
        ;;
    esac
  done
}