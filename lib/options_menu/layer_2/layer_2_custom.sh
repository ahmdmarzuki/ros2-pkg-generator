#!/bin/bash

layer_2_custom() {
  local options=("${ALL_PACKAGES[@]}" "$NAV_BACK")
  run_multi_select "Select packages to create:" "${options[@]}"

  if [ "$BACK_CLICKED" = true ]; then
    CURRENT_SCREEN="LAYER_MAIN" 
  else
    SELECTED_MODE="custom"
    CURRENT_SCREEN="DONE"
  fi
}