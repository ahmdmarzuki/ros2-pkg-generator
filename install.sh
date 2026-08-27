#!/bin/bash

echo "Installing ros2-gen CLI..."
sudo cp bin/ros2-gen /usr/local/bin/ros2-gen
sudo chmod +x /usr/local/bin/ros2-gen

echo "✅ Installed! You can now run 'ros2-gen <robot_name>' from anywhere."