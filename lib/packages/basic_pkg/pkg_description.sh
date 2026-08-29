#!/bin/bash

generate_description() {
  local robot_name=$1
  local PKG_NAME="${robot_name}_description"

  echo "Generating ${PKG_NAME}..."
  ros2 pkg create ${PKG_NAME} --build-type ament_cmake > /dev/null
  mkdir -p ${PKG_NAME}/{urdf,meshes,rviz}
  cat << EOF >> ${PKG_NAME}/CMakeLists.txt

install(DIRECTORY urdf meshes rviz DESTINATION share/\${PROJECT_NAME})
EOF
}