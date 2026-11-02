# ============================================================
# A.R.I.S. Robotics Development Environment
# ROS 2 Humble / Ubuntu 22.04
# ============================================================

# Use the official ROS 2 Humble desktop image
FROM osrf/ros:humble-desktop-full

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# ============================================================
# 1. Install development dependencies
# ============================================================

RUN apt-get update && apt-get install -y \
    # General development tools
    build-essential \
    cmake \
    git \
    curl \
    wget \
    nano \
    vim \
    gdb \
    python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-argcomplete \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# 2. Create a non-root development user
# ============================================================

# These values are passed in during the Docker build
ARG USERNAME=robot
ARG USER_UID=1000
ARG USER_GID=1000

RUN if ! getent group ${USER_GID} > /dev/null; then \
        groupadd --gid ${USER_GID} ${USERNAME}; \
    fi && \
    useradd --uid ${USER_UID} \
            --gid ${USER_GID} \
            --create-home \
            --shell /bin/bash \
            ${USERNAME}

# ============================================================
# 3. Configure the ROS 2 environment
# ============================================================

ENV ROS_DISTRO=humble

# Automatically source ROS 2 whenever a Bash terminal opens
RUN echo "source /opt/ros/humble/setup.bash" >> /home/${USERNAME}/.bashrc && \
    echo "if [ -f /workspace/aris/install/setup.bash ]; then source /workspace/aris/install/setup.bash; fi" >> /home/${USERNAME}/.bashrc

# ============================================================
# 4. Configure the workspace
# ============================================================

WORKDIR /workspace/aris

# Give the development user ownership of its home directory
RUN chown -R ${USERNAME}:$(id -gn ${USERNAME}) /home/${USERNAME}

# Run the container as the development user instead of root
USER ${USERNAME}

# Start in Bash when the container is launched
CMD ["bash"]