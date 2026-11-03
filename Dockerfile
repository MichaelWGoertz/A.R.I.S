
# ROS 2 Jazzy (Ubuntu 24.04 LTS)
FROM osrf/ros:jazzy-desktop-full

# ── System dependencies ────────────────────────────────────────────────────────
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    # Build tools
    build-essential \
    cmake \
    git \
    # Python development and ROS build tools
    python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    # ROS visualization and robot state
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-xacro \
    ros-jazzy-tf2-tools \
    # ROS navigation (Nav2)
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup \
    ros-jazzy-nav2-map-server \
    ros-jazzy-nav2-amcl \
    # Localization and mapping
    ros-jazzy-slam-toolbox \
    ros-jazzy-robot-localization \
    # Gazebo simulation (Gazebo Harmonic)
    ros-jazzy-ros-gz \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-ros2-control \
    ros-jazzy-ros2-controllers \
    # Additional ROS utilities
    ros-jazzy-backward-ros \
    # C++ libraries
    libgflags-dev \
    nlohmann-json3-dev \
    # Handy utilities
    bash-completion \
    curl \
    nano \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# ── Initialize rosdep ─────────────────────────────────────────────────────────
RUN rosdep update

# ── Auto-source ROS on every shell ────────────────────────────────────────────
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc \
    && echo "export ROS_DOMAIN_ID=0" >> /root/.bashrc

# ── Default shell entrypoint ──────────────────────────────────────────────────
CMD ["/bin/bash"]
