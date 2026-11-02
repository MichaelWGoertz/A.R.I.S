Setup:




Folder Structure:

.devcontainer/ - VS Code Docker Development Configuration

    - devcontainer.json -> This tells VS Code:
        - Which Docker Compose configuration to use.
        - Which container to connect to.
        - Which directory to open.
        - Which user to operate as.
        - Which VS Code extensions to install inside the container.



src/ - All ROS2 packages and robot software

config/ - sensor, motor, navigation, and robot configruation

documentation/ - wiring diagrams, design documents, setup instructions

scripts/ - setup scripts, utilities and automation


Files:

.dockerignore -> includes any unnecessary files from being included in the Docker build context

compose.yaml -> Bind mount. Makes entire repsositroy accessbile inside Docker and changes on either side are reflected to other side

Dockerfile -> development environment setup