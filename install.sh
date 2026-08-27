#!/bin/bash

echo "Installing ros2gen CLI..."
sudo cp bin/ros2gen /usr/local/bin/ros2gen
sudo chmod +x /usr/local/bin/ros2gen

echo "✅ Installed! You can now run 'ros2gen <robot_name>' from anywhere."