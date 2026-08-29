#!/bin/bash

generate_simulation() {
  local robot_name=$1

  if [ -z "$robot_name" ]; then
    echo -e "  \033[1;31m✗\033[0m Error: Robot name is required."
    return 1
  fi

  local PKG_NAME="${robot_name}_simulation"

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local templates_dir="${script_dir}/../../../templates/basic_pkg/simulation"

  if [ ! -d "$templates_dir" ]; then
    echo -e "  \033[1;31m✗\033[0m Error: Template directory not found at $templates_dir"
    return 1
  fi

  echo "Generating ${PKG_NAME}..."

  ros2 pkg create "$PKG_NAME" \
    --build-type ament_cmake \
    --dependencies rclcpp ros_gz_sim ros_gz_bridge \
    --description "Gazebo simulation package for ${robot_name}" > /dev/null 2>&1

  if [ ! -d "$PKG_NAME" ]; then
    echo -e "  \033[1;31m✗\033[0m Error: Package directory '$PKG_NAME' was not created."
    return 1
  fi

  rm -rf "${PKG_NAME}/src" "${PKG_NAME}/include"

  [ -d "${templates_dir}/launch" ] && cp -r "${templates_dir}/launch" "$PKG_NAME/"
  [ -d "${templates_dir}/worlds" ] && cp -r "${templates_dir}/worlds" "$PKG_NAME/"
  [ -d "${templates_dir}/models" ] && cp -r "${templates_dir}/models" "$PKG_NAME/"

  local cmake_snippet="install(DIRECTORY launch worlds models\n  DESTINATION share/\${PROJECT_NAME}\n)\n"
  sed -i "/ament_package()/i ${cmake_snippet}" "${PKG_NAME}/CMakeLists.txt"

  echo -e "  \033[1;32m✓\033[0m Created package: \033[1m${PKG_NAME}\033[0m"
}