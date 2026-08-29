#!/bin/bash

generate_hardware() {
  local robot_name=$1
  local PKG_NAME="${robot_name}_hardware"

  echo "Generating ${PKG_NAME}..."
  ros2 pkg create ${PKG_NAME} --build-type ament_cmake \
    --dependencies hardware_interface pluginlib rclcpp rclcpp_lifecycle > /dev/null
  mkdir -p ${PKG_NAME}/include/${PKG_NAME} ${PKG_NAME}/src
}