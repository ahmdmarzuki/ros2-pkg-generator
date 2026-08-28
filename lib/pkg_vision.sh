#!/bin/bash

generate_vision() {
  local robot_name=$1
  local pkg_dir="${robot_name}_vision"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake \
    --dependencies rclcpp sensor_msgs cv_bridge image_transport > /dev/null
  mkdir -p ${pkg_dir}/{include,src,launch}
}