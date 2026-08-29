#!/bin/bash

layer_2_presets() {
  local options=(
    "Basic Setup (description, hardware, bringup)"
    "Full Stack (all packages)"
    "$NAV_BACK"
  )
  run_single_select "Choose a preset bundle:" "${options[@]}"

  case $SELECTED_SINGLE_INDEX in
    0)
      SELECTED_MODE="basic"
      SELECTED_RESULT=("${PRESET_BASIC[@]}")
      CURRENT_SCREEN="DONE"
      ;;
    1)
      SELECTED_MODE="full"
      SELECTED_RESULT=("${PRESET_FULL[@]}")
      CURRENT_SCREEN="DONE"
      ;;
    2)
      CURRENT_SCREEN="LAYER_MAIN" 
      ;;
  esac
}