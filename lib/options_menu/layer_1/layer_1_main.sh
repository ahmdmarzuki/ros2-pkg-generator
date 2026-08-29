#!/bin/bash

layer_1_main() {
  local options=(
    "Preset Bundles (Quick Setup)"
    "Multi Packages (Custom Selection)"
    "Create Custom Package"
    "$NAV_EXIT"
  )
  run_single_select "Select setup mode:" "${options[@]}"

  case $SELECTED_SINGLE_INDEX in
    0) CURRENT_SCREEN="LAYER_2_PRESETS" ;;
    1) CURRENT_SCREEN="LAYER_2_MULTI_PKG" ;;
    2) CURRENT_SCREEN="LAYER_2_CREATE_CUSTOM" ;;
    3) echo "Aborted."; exit 0 ;;
  esac
}