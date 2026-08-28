#!/bin/bash

generate_interfaces() {
  local robot_name=$1
  local pkg_dir="${robot_name}_interfaces"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake \
    --dependencies rosidl_default_generators > /dev/null
  mkdir -p ${pkg_dir}/{msg,srv,action}
}