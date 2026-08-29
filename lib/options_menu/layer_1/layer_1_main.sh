#!/bin/bash

layer_1_main() {
  local options=(
    "Preset Bundles (Quick Setup)"
    "Individual Packages (Custom Selection)"
    "$NAV_EXIT"
  )
  run_single_select "Select setup mode for [${ROBOT_NAME}]:" "${options[@]}"

  case $SELECTED_SINGLE_INDEX in
    0) CURRENT_SCREEN="LAYER_PRESETS" ;;
    1) CURRENT_SCREEN="LAYER_CUSTOM" ;;
    2) echo "Aborted."; exit 0 ;;
  esac
}