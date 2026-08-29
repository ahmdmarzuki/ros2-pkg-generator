#!/bin/bash

layer_2_presets() {
  local ROBOT_NAME=""

  echo -en "\033[1;36m? Enter package name:\033[0m "
  read -r ROBOT_NAME

  if [ -z "$ROBOT_NAME" ]; then
    echo -e "Project name cannot be empty. Aborted."
    exit 1
  fi

  local options=(
    "Basic Setup (description, hardware, bringup)"
    "Full Stack (all packages)"
    "$NAV_BACK"
  )
  run_single_select "Choose a preset bundle:" "${options[@]}"

  case $SELECTED_SINGLE_INDEX in
    0)
      PRESET="basic"
      CURRENT_SCREEN="DONE"
      ;;
    1)
      PRESET="full"
      CURRENT_SCREEN="DONE"
      ;;
    2)
      CURRENT_SCREEN="LAYER_MAIN" 
      ;;
  esac

  case "$PRESET" in
    "basic")
      generate_description "$ROBOT_NAME"
      generate_hardware "$ROBOT_NAME"
      generate_bringup "$ROBOT_NAME"
      ;;
    "full")
      generate_description "$ROBOT_NAME"
      generate_hardware "$ROBOT_NAME"
      generate_bringup "$ROBOT_NAME"
      generate_interfaces "$ROBOT_NAME"
      generate_vision "$ROBOT_NAME"
      generate_simulation "$ROBOT_NAME"
      
      ;;
  esac
}