#!/bin/bash

generate_bringup() {
  local robot_name=$1
  local PKG_NAME="${robot_name}_bringup"

  echo "Generating ${PKG_NAME}..."
  ros2 pkg create ${PKG_NAME} --build-type ament_cmake \
    --dependencies rclcpp controller_manager > /dev/null
  mkdir -p ${PKG_NAME}/{launch,config,worlds}
  cat << EOF >> ${PKG_NAME}/CMakeLists.txt

install(DIRECTORY launch config worlds DESTINATION share/\${PROJECT_NAME})
EOF

  echo -e "  \033[1;32m✓\033[0m Created package: \033[1m${PKG_NAME}\033[0m"
}