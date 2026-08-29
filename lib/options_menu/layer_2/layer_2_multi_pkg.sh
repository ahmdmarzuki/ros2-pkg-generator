#!/bin/bash

layer_2_multi_pkg() {
  local ROBOT_NAME=""
  local LAYER_NAME="[Multi Packages]"
    
  echo -en "\033[1;33m${LAYER_NAME} \033[1;36mEnter package name:\033[0m "
  read -r ROBOT_NAME

  if [ -z "$ROBOT_NAME" ]; then
    echo -e "Project name cannot be empty. Aborted."
    exit 1
  fi

  DO_DESC=false
  DO_HW=false
  DO_BRINGUP=false
  DO_INTERFACES=false
  DO_VISION=false
  DO_SIMULATION=false
  ANY_FLAG_SET=false

  local options=("${ALL_PACKAGES[@]}" "$NAV_BACK")
  run_multi_select "\033[1;33m${LAYER_NAME} \033[1;37mSelect packages to create:" "${options[@]}"

  if [ "$BACK_CLICKED" = true ]; then
    CURRENT_SCREEN="LAYER_MAIN" 
  else
    if [ ${#SELECTED_RESULT[@]} -eq 0 ]; then
      echo "⚠️ No package selected. Installation cancelled."
      exit 0
    fi

    for pkg in "${SELECTED_RESULT[@]}"; do
      case $pkg in
        description) DO_DESC=true ;;
        hardware)    DO_HW=true ;;
        bringup)     DO_BRINGUP=true ;;
        interfaces)  DO_INTERFACES=true ;;
        vision)      DO_VISION=true ;;
        simulation)  DO_SIMULATION=true ;;
      esac
    done
    CURRENT_SCREEN="DONE"
  fi

  echo "Scaffolding ROS 2 Packages for: ${ROBOT_NAME}..."

  if [ "$DO_DESC" = true ]; then
    generate_description "$ROBOT_NAME"
  fi

  if [ "$DO_HW" = true ]; then
    generate_hardware "$ROBOT_NAME"
  fi

  if [ "$DO_BRINGUP" = true ]; then
    generate_bringup "$ROBOT_NAME"
  fi

  if [ "$DO_INTERFACES" = true ]; then
    generate_interfaces "$ROBOT_NAME"
  fi

  if [ "$DO_VISION" = true ]; then
    generate_vision "$ROBOT_NAME"
  fi

  if [ "$DO_SIMULATION" = true ]; then
    generate_simulation "$ROBOT_NAME"
  fi

  for pkg in $(ls -d ${ROBOT_NAME}_*/ 2>/dev/null); do
    sed -i '/ament_package()/d' ${pkg}CMakeLists.txt
    echo "ament_package()" >> ${pkg}CMakeLists.txt
  done

  echo "✅ Done!"
}