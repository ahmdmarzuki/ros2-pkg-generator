#!/bin/bash

generate_vision() {
  local robot_name=$1
  local PKG_NAME="${robot_name}_vision"

  echo "Generating ${PKG_NAME}..."
  ros2 pkg create ${PKG_NAME} --build-type ament_cmake \
    --dependencies rclcpp sensor_msgs cv_bridge image_transport > /dev/null
  mkdir -p ${PKG_NAME}/{include,src,launch}
}