# ROS 2 Package Generator CLI (`ros2gen`)

**`ros2gen`** is a lightweight Command Line Interface (CLI) tool designed to instantly scaffold standardized ROS 2 robot packages (`description`, `hardware`, `bringup`, and `vision`) with auto-configured `CMakeLists.txt` installation rules.

Fully compatible with **ROS 2 Humble, Iron, and Jazzy**.

---

## Installation

Install instantly via `curl` in your terminal:

```bash
curl -fsSL [https://raw.githubusercontent.com/](https://raw.githubusercontent.com/)ahmdmarzuki/ros2-pkg-generator/main/install.sh | bash
```

Alternatively, clone the repository locally and run the installer:

```bash
git clone [https://github.com/](https://github.com/)ahmdmarzuki/ros2-pkg-generator.git
cd ros2-pkg-generator
./install.sh
```

## Usage

Navigate to the src/ directory of your ROS 2 workspace:

```bash
cd ~/ros2_ws/src
```

### 1. Basic Setup

Generates the 3 standard packages: `description`, `hardware` (ros2_control), and `bringup`.

```bash
ros2gen {robot-name}
```

### 2. Vision Setup

Generates the standard packages plus a dedicated `vision` package pre-configured with `sensor_msgs`, `cv_bridge`, and `image_transport` dependencies.

```bash
ros2gen {robot-name} --vision
```

### 3. Full Stack Setup

Generates all packages including hardware, bringup, description, and vision.

```bash
ros2gen {robot-name} --full
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
