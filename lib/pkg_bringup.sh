#!/bin/bash

generate_bringup() {
  local robot_name=$1
  local pkg_dir="${robot_name}_bringup"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake \
    --dependencies rclcpp controller_manager > /dev/null
  mkdir -p ${pkg_dir}/{launch,config,worlds}
  cat << EOF >> ${pkg_dir}/CMakeLists.txt

install(DIRECTORY launch config worlds DESTINATION share/\${PROJECT_NAME})
EOF
}