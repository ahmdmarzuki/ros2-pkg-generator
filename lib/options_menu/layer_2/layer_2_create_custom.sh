#!/bin/bash

layer_2_create_custom() {
    local PKG_NAME=""
    local DEPENDENCIES=""
    
    echo -en "\033[1;36m? Enter package name:\033[0m "
    read -r PKG_NAME

    if [ -z "$PKG_NAME" ]; then
        echo -e "Project name cannot be empty. Aborted."
        exit 1
    fi

    echo -en "\033[1;36m? Enter dependencies (space-separated, e.g., rclcpp std_msgs sensor_msgs):\033[0m "
    read -r DEPENDENCIES

    echo "Generating ${PKG_NAME}..."

    if [ -n "$DEPENDENCIES" ]; then
        ros2 pkg create "$PKG_NAME" --build-type ament_cmake --dependencies $DEPENDENCIES > /dev/null
    else
        ros2 pkg create "$PKG_NAME" --build-type ament_cmake > /dev/null
    fi
    
    echo -e "  \033[1;32m✓\033[0m Created package: \033[1m${PKG_NAME}\033[0m"

    CURRENT_SCREEN="DONE"
}