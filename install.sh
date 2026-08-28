#!/bin/bash

echo "Installing ros2gen CLI..."

SHARE_DIR="/usr/local/share/ros2gen"
BIN_DIR="/usr/local/bin"
REPO_TARBALL="https://github.com/ahmdmarzuki/ros2-pkg-generator/archive/refs/heads/main.tar.gz"

sudo mkdir -p "${SHARE_DIR}"

if [ -d "lib" ] && [ -f "bin/ros2gen" ]; then
  echo "Installing from local source..."
  sudo cp -r lib/ templates/ "${SHARE_DIR}/" 2>/dev/null || sudo cp -r lib/ "${SHARE_DIR}/"
  sudo cp bin/ros2gen "${BIN_DIR}/ros2gen"
else
  echo "Downloading latest modules from GitHub..."
  TMP_DIR=$(mktemp -d)
  
  curl -fsSL "${REPO_TARBALL}" | tar -xz -C "${TMP_DIR}"
  EXTRACTED_DIR="${TMP_DIR}/ros2-pkg-generator-main"
  
  sudo cp -r "${EXTRACTED_DIR}/lib" "${EXTRACTED_DIR}/templates" "${SHARE_DIR}/" 2>/dev/null || sudo cp -r "${EXTRACTED_DIR}/lib" "${SHARE_DIR}/"
  sudo cp "${EXTRACTED_DIR}/bin/ros2gen" "${BIN_DIR}/ros2gen"
  
  rm -rf "${TMP_DIR}"
fi

sudo chmod +x "${BIN_DIR}/ros2gen"

echo "✅ Installed successfully! You can now run 'ros2gen <robot_name>' from anywhere."