#!/bin/bash

generate_simulation() {
  local robot_name=$1
  local pkg_dir="${robot_name}_simulation"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake \
    --dependencies rclcpp ros_gz_sim > /dev/null
  mkdir -p ${pkg_dir}/{launch,worlds,models}
  cat << EOF >> ${pkg_dir}/CMakeLists.txt

install(DIRECTORY launch worlds models DESTINATION share/\${PROJECT_NAME})
EOF
}