#!/bin/bash

generate_hardware() {
  local robot_name=$1
  local pkg_dir="${robot_name}_hardware"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake \
    --dependencies hardware_interface pluginlib rclcpp rclcpp_lifecycle > /dev/null
  mkdir -p ${pkg_dir}/include/${pkg_dir} ${pkg_dir}/src
}