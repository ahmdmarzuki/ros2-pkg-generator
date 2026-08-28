#!/bin/bash

generate_bringup() {
  local robot_name=$1
  local pkg_dir="${robot_name}_description"

  echo "Generating ${pkg_dir}..."
  ros2 pkg create ${pkg_dir} --build-type ament_cmake > /dev/null
  mkdir -p ${pkg_dir}/{urdf,meshes,rviz}
  cat << EOF >> ${pkg_dir}/CMakeLists.txt

install(DIRECTORY urdf meshes rviz DESTINATION share/\${PROJECT_NAME})
EOF
}