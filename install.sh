#!/bin/bash

echo "Installing ros2gen CLI..."

sudo curl -fsSL https://raw.githubusercontent.com/ahmdmarzuki/ros2-pkg-generator/main/bin/ros2gen -o /usr/local/bin/ros2gen

sudo chmod +x /usr/local/bin/ros2gen

echo "✅ Installed! You can now run 'ros2gen <robot_name>' from anywhere."