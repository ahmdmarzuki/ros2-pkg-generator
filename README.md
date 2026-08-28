# ROS 2 Package Generator CLI (`ros2gen`)

![Status](https://img.shields.io/badge/status-In%20Development-orange)

**`ros2gen`** is a lightweight Command Line Interface (CLI) tool designed to instantly scaffold standardized ROS 2 robot packages (`description`, `hardware`, `bringup`, and `vision`) with auto-configured `CMakeLists.txt` installation rules.

Fully compatible with **ROS 2 Humble, Iron, and Jazzy**.

---

## Installation

Install instantly via `curl` in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ahmdmarzuki/ros2gen/main/install.sh | bash
```

Alternatively, clone the repository locally and run the installer:

```bash
git clone [https://github.com/](https://github.com/)ahmdmarzuki/ros2gen.git
cd ros2gen
./install.sh
```

## Usage

Navigate to the src/ directory of your ROS 2 workspace:

```bash
cd ~/ros2_ws/src
```

### 1. Interactive Mode (Default)

Simply pass your robot name to launch the terminal UI menu. Use ↑ / ↓ to navigate, `[Space]` to select/unselect packages, and `[Enter]` to confirm.

```bash
ros2gen {robot-name}
```

```text
? Select ROS 2 packages to create for [my_robot]: (↑/↓: Navigate, [Space]: Select, [Enter]: Confirm)
 ❯ [x] description
   [x] hardware
   [ ] bringup
   [ ] interfaces
   [x] vision
   [ ] simulation
```

### 2. Fast-Track Flags (Non-Interactive)

Bypass the interactive prompt by passing flags directly. Useful for power users or automated CI/CD scripts:

```bash
# Basic Setup: Generates description, hardware, and bringup packages
ros2gen <robot-name> --basic

# Full Stack: Generates all available packages
ros2gen <robot-name> --full
```

### 3. Individual Package Flags

You can also combine specific package flags:

```bash
# Example: Generate only description and vision packages
ros2gen <robot-name> --description --vision

# Example: Generate hardware interface and custom messages
ros2gen <robot-name> --hardware --interfaces
```

## Generated Package Structure

Running `ros2gen {robot-name} --vision` will instantly generate the following structure:

```text
src/
├── {robot-name}_bringup/          # Controller YAML configs, launch files, & worlds
│   ├── config/
│   ├── launch/
│   └── worlds/
├── {robot-name}_description/      # URDF/Xacro models, 3D meshes, & RViz configs
│   ├── meshes/
│   ├── rviz/
│   └── urdf/
├── {robot-name}_hardware/         # C++ ros2_control Hardware Interface boilerplate
│   ├── include/diffbot_hardware/
│   └── src/
└── {robot-name}_vision/           # OpenCV / YOLO Perception nodes
    ├── include/
    └── src/
```

## Key Features

- **Auto-Configured CMakeLists:** Automatically injects install(DIRECTORY ...) rules into CMakeLists.txt for launch, config, urdf, and asset directories. No manual CMakeLists.txt edits needed when adding new launch or mesh files.

- **ros2_control Ready:** The hardware package comes pre-loaded with core C++ dependencies (hardware_interface, pluginlib, rclcpp_lifecycle).

- **Clean Terminal CLI:** Built without file extensions (.sh) to seamlessly feel like a native ROS 2 tool.

## Updating `ros2gen`

To update `ros2gen` to the latest release directly from GitHub, simply run:

```bash
ros2gen --update
```

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

## Uninstall

```bash
sudo rm /usr/local/bin/ros2gen
sudo rm -rf /usr/local/share/ros2gen
```
