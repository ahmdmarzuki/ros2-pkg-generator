#!/bin/bash

generate_interfaces() {
  local robot_name="$1"

  if [ -z "$robot_name" ]; then
    echo -e "  \033[1;31m✗\033[0m Error: Robot name is required."
    return 1
  fi

  local pkg_name="${robot_name}_interfaces"

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local templates_dir="${script_dir}/../../templates/interfaces"

  if [ ! -d "$templates_dir" ]; then
    echo -e "  \033[1;31m✗\033[0m Error: Template directory not found at $templates_dir"
    return 1
  fi

  if ! command -v ros2 &> /dev/null; then
    echo -e "  \033[1;31m✗\033[0m Error: 'ros2' command not found. Please source ROS 2 first."
    return 1
  fi

  echo "Generating ${pkg_name}..."

  ros2 pkg create "$pkg_name" \
    --build-type ament_cmake \
    --dependencies rosidl_default_generators std_msgs action_msgs \
    --description "Custom interfaces (msg, srv, action) for ${robot_name}" > /dev/null 2>&1

  cp -r "${templates_dir}/msg" "$pkg_name/"
  cp -r "${templates_dir}/srv" "$pkg_name/"
  cp -r "${templates_dir}/action" "$pkg_name/"

  sed -i '/<\/package>/i \  <exec_depend>rosidl_default_runtime<\/exec_depend>\n  <member_of_group>rosidl_interface_packages<\/member_of_group>' "${pkg_name}/package.xml"

  local cmake_snippet="rosidl_generate_interfaces(\${PROJECT_NAME}\n  \"msg/Sample.msg\"\n  \"srv/TriggerService.srv\"\n  \"action/Task.action\"\n  DEPENDENCIES std_msgs action_msgs\n)\n"
  sed -i "/ament_package()/i ${cmake_snippet}" "${pkg_name}/CMakeLists.txt"

  echo -e "  \033[1;32m✓\033[0m Created package: \033[1m${pkg_name}\033[0m"
}