#!/bin/bash

echo "Installing ros2gen CLI..."

SHARE_DIR="/usr/local/share/ros2gen"
BIN_DIR="/usr/local/bin"
REPO_TARBALL="https://github.com/ahmdmarzuki/ros2-pkg-generator/archive/refs/heads/main.tar.gz"

IS_LOCAL=false
if [ -d "lib" ] && [ -f "bin/ros2gen" ]; then
  IS_LOCAL=true
fi

if [ "$IS_LOCAL" = true ]; then
  SIZE_KB=$(du -sk . 2>/dev/null | cut -f1)
else
  SIZE_KB=$(curl -s "https://api.github.com/repos/${REPO}" | grep '"size":' | awk '{print $2}' | tr -d ',')
fi

if [ -z "$SIZE_KB" ] || ! [[ "$SIZE_KB" =~ ^[0-9]+$ ]]; then
  SIZE_STR="~1.5 MB" 
else
  if [ "$SIZE_KB" -ge 1024 ]; then
    SIZE_MB=$(awk "BEGIN {printf \"%.2f\", $SIZE_KB/1024}")
    SIZE_STR="${SIZE_MB} MB"
  else
    SIZE_STR="${SIZE_KB} KB"
  fi
fi

echo "Total installation size: ${SIZE_STR}"
echo -n "Do you want to proceed with the installation? [Y/n]: "

read -r CONFIRM < /dev/tty

CONFIRM=${CONFIRM:-Y}

case "$CONFIRM" in
  [yY][eE][sS]|[yY])
    echo "Proceeding with installation..."
    ;;
  *)
    echo "❌ Installation cancelled by user."
    exit 0
    ;;
esac

sudo mkdir -p "${SHARE_DIR}"

if [ "$IS_LOCAL" = true ]; then
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