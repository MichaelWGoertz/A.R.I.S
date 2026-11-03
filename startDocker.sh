
#!/bin/bash

#Docker image
IMAGE_NAME="aris-ros2-jazzy"

#Local workspace directory
# Change this to the location of your project on your computer.
LOCAL_DIR="/home/$(id -un)/ARIS"

#Check that the workspace exists
if [ ! -d "$LOCAL_DIR" ]; then
    echo "Error: Workspace directory does not exist:"
    echo "$LOCAL_DIR"
    exit 1
fi

#Check that the Docker image exists
if ! docker image inspect "$IMAGE_NAME:latest" > /dev/null 2>&1; then
    echo "Docker image not found. Build it first using:"
    echo "docker build -t $IMAGE_NAME ."
    exit 1
fi

#Launch Docker container
docker run -it --rm \
    --name amr-dev \
    --network host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$LOCAL_DIR":/mnt/docker_ws \
    -w /mnt/docker_ws \
    -e DISPLAY="${DISPLAY:-}" \
    -e WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
    -e XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-}" \
    -e PULSE_SERVER="${PULSE_SERVER:-}" \
    "$IMAGE_NAME:latest"
