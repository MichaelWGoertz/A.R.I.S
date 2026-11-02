# A.R.I.S. — Robotics Software

ROS 2 development environment and software repository for the A.R.I.S. autonomous mobile robot.

This repository uses Docker to provide a consistent development environment for all team members. Rather than installing ROS 2 and its dependencies directly on each computer, developers use a shared Docker configuration.

This ensures that everyone develops using the same ROS 2 distribution, Ubuntu version, and software dependencies.

---

# Table of Contents

1. [Development Environment Overview](#development-environment-overview)
2. [Initial Computer Setup](#initial-computer-setup)
   - [Windows Requirements](#windows-requirements)
   - [Install WSL 2 and Ubuntu](#1-install-wsl-2-and-ubuntu)
   - [Install Docker Desktop](#2-install-docker-desktop)
   - [Install Visual Studio Code](#3-install-visual-studio-code)
   - [Install Git and GitHub CLI](#4-install-git-and-github-cli)
3. [Download the Repository](#download-the-repository)
4. [Configure Your Development Environment](#configure-your-development-environment)
5. [Building and Running Docker](#building-and-running-docker)
6. [Working in VS Code](#working-in-vs-code)
7. [ROS 2 Workspace Setup](#ros-2-workspace-setup)
8. [Daily Development Workflow](#daily-development-workflow)
9. [Git and Team Collaboration](#git-and-team-collaboration)
10. [Common Docker Commands](#common-docker-commands)
11. [Troubleshooting](#troubleshooting)

---

# Development Environment Overview

The development environment consists of:

| Component | Purpose |
|---|---|
| Ubuntu 22.04 | Operating system inside Docker |
| ROS 2 Humble | Robotics middleware |
| Docker | Runs the development environment |
| Docker Compose | Manages the development container |
| VS Code | Code editor and development interface |
| Git | Version control |
| GitHub | Shared repository and team collaboration |

The Docker container provides all required ROS 2 dependencies and development tools.

The project repository is mounted directly into the container. This means that files edited inside Docker are automatically saved to your computer.

## Repository Structure

```text
A.R.I.S/
│
├── .devcontainer/
│   └── devcontainer.json
│
├── src/
│   ├── robot_description/
│   ├── robot_control/
│   ├── robot_navigation/
│   └── ...
│
├── config/
│
├── documentation/
│
├── scripts/
│
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── .gitignore
└── README.md
```

| Directory | Contents |
|---|---|
| `.devcontainer/` | VS Code Docker configuration |
| `src/` | ROS 2 packages and robot software |
| `config/` | Configuration files for sensors, motors, and navigation |
| `documentation/` | Technical documentation, diagrams, and instructions |
| `scripts/` | Utility and automation scripts |

---

# Initial Computer Setup

Follow these instructions when setting up a new computer for the first time.

## Windows Requirements

For Windows development, the following software is required:

- Windows 10 or 11 with WSL 2 support
- Ubuntu 22.04 or another compatible WSL 2 distribution
- Docker Desktop
- Visual Studio Code

You do NOT need to install ROS 2 directly on Windows or inside your Ubuntu WSL installation. ROS 2 is installed inside Docker.

## 1. Install WSL 2 and Ubuntu

Open PowerShell as Administrator.

Install WSL and Ubuntu 22.04:

```powershell
wsl --install -d Ubuntu-22.04
```

Restart your computer if prompted.

Open Ubuntu and create a Linux username and password.

Update WSL:

```powershell
wsl --update
```

Verify your installation:

```powershell
wsl -l -v
```

Make sure your Ubuntu distribution is running using WSL version 2.

If necessary:

```powershell
wsl --set-version Ubuntu-22.04 2
```

## 2. Install Docker Desktop

Download Docker Desktop:

https://www.docker.com/products/docker-desktop/

Install Docker Desktop for Windows.

After installation:

1. Open Docker Desktop.
2. Navigate to Settings.
3. Under General, enable **Use the WSL 2 based engine**.
4. Navigate to Resources → WSL Integration.
5. Enable integration for your Ubuntu distribution.
6. Apply the changes.

Make sure Docker Desktop is running before proceeding.

Do not separately install Docker Engine inside Ubuntu.

## 3. Install Visual Studio Code

Download Visual Studio Code:

https://code.visualstudio.com/

Install the following extensions:

| Extension | Publisher |
|---|---|
| Dev Containers | Microsoft |
| WSL | Microsoft |

These extensions allow VS Code to connect to Ubuntu and directly edit files inside the Docker container.

## 4. Install Git and GitHub CLI

Open your Ubuntu terminal.

Update Ubuntu:

```bash
sudo apt update
```

Install Git:

```bash
sudo apt install git -y
```

Install GitHub CLI:

```bash
sudo apt install gh -y
```

Verify both installations:

```bash
git --version
gh --version
```

### Configure Git

Set your Git identity:

```bash
git config --global user.name "Your Name"

git config --global user.email "your-github-email@example.com"
```

Use the email associated with your GitHub account.

### Authenticate with GitHub

Run:

```bash
gh auth login
```

Select:

- GitHub.com
- HTTPS
- Yes, authenticate Git with your GitHub credentials
- Login with a web browser

Follow the browser instructions and authorize GitHub CLI.

Verify authentication:

```bash
gh auth status
```

You should now be authenticated with GitHub.

---

# Download the Repository

Once all required software is installed, download the A.R.I.S. repository.

Open your Ubuntu terminal.

Create a directory for your projects:

```bash
mkdir -p ~/ARIS

cd ~/ARIS
```

Clone the repository:

```bash
git clone https://github.com/USERNAME/REPOSITORY.git
```

Replace `USERNAME/REPOSITORY` with the actual GitHub repository address.

Navigate into the project:

```bash
cd REPOSITORY
```

Verify that the repository was downloaded:

```bash
ls -la
```

You should see the Dockerfile, Compose configuration, and project directories.

---

# Configure Your Development Environment

The Docker configuration uses Linux user and group IDs to prevent file permission problems when working with files shared between Ubuntu and Docker.

Find your user and group IDs:

```bash
id -u

id -g
```

Create a `.env` file in the repository root:

```bash
nano .env
```

Enter your actual user and group IDs:

```text
LOCAL_UID=1000
LOCAL_GID=1000
```

Replace these values with the results of the commands above if they differ.

Save the file.

The `.env` file is local to your computer and should NOT be committed to GitHub.

Make sure `.env` is listed in `.gitignore`.

---

# Building and Running Docker

Docker provides the complete ROS 2 development environment.

All commands in this section should be run from the repository root, outside the Docker container, unless otherwise specified.

## 1. Build the Docker image

The first time you download the repository, build the Docker image:

```bash
docker compose build
```

This will:

- Download the ROS 2 Humble Desktop Full base image.
- Install development dependencies.
- Configure the ROS 2 environment.
- Create the development user.
- Build the A.R.I.S. development image.

The initial build may take several minutes.

You only need to rebuild the image when the Dockerfile or installed dependencies change.

## 2. Start the Docker container

Start the development container:

```bash
docker compose up -d
```

The container will run in the background.

## 3. Enter the Docker container

To open an interactive terminal:

```bash
docker compose exec robot-dev bash
```

You are now working inside the Docker environment.

Verify the environment:

```bash
whoami

echo $ROS_DISTRO

pwd
```

Expected output:

```text
robot
humble
/workspace/aris
```

All project files are accessible from:

```text
/workspace/aris
```

## 4. Exit the Docker container

To leave the container terminal:

```bash
exit
```

This does NOT stop the container.

## 5. Stop the Docker container

When finished working:

```bash
docker compose down
```

This stops and removes the container.

Your source code and repository files are not deleted.

---

# Working in VS Code

VS Code can connect directly to the Docker container, allowing you to edit and run code without manually entering Docker commands.

From your Ubuntu terminal, navigate to the repository:

```bash
cd ~/ARIS/REPOSITORY
```

Open VS Code:

```bash
code .
```

Make sure VS Code is connected to WSL.

Press:

```text
Ctrl + Shift + P
```

Search for:

```text
Dev Containers: Reopen in Container
```

Select the command.

VS Code will build or start the Docker environment and connect to it.

The first connection may take a few minutes.

Once connected, open a new VS Code terminal.

You should automatically be inside:

```text
/workspace/aris
```

Verify:

```bash
whoami
```

Expected:

```text
robot
```

You can now edit, build, and execute ROS 2 software directly inside VS Code.

**Important:** VS Code may automatically start or stop the Docker Compose service when connecting or disconnecting. If the container is not running, you can always start it manually with `docker compose up -d`.

---

# ROS 2 Workspace Setup

The ROS 2 workspace is located at:

```text
/workspace/aris
```

ROS 2 packages are stored inside:

```text
/workspace/aris/src
```

## Install ROS dependencies

After downloading new ROS 2 packages, install their dependencies:

```bash
rosdep update

rosdep install --from-paths src --ignore-src -r -y
```

This checks package.xml files and installs missing system dependencies.

## Build the ROS 2 workspace

From the workspace root:

```bash
colcon build
```

To build a specific package:

```bash
colcon build --packages-select PACKAGE_NAME
```

After building, source the workspace:

```bash
source install/setup.bash
```

The Docker environment automatically sources ROS 2 Humble when opening a Bash terminal. You must also source the workspace after building it in a new terminal.

## Run ROS 2 packages

List available packages:

```bash
ros2 pkg list
```

Run a node:

```bash
ros2 run PACKAGE_NAME EXECUTABLE_NAME
```

Launch a system:

```bash
ros2 launch PACKAGE_NAME LAUNCH_FILE.launch.py
```

---

# Daily Development Workflow

This section describes the recommended workflow for everyday development.

The most important thing to understand is the difference between Docker and Git.

**Docker manages the development environment. Git manages the source code and collaboration.**

Your source code is stored on your computer and mounted into Docker. Therefore, changes made inside Docker are automatically saved to your repository.

You do NOT need to commit, push, or rebuild Docker every time you modify a source file.

## 1. Start your development environment

Open Ubuntu and navigate to your repository:

```bash
cd ~/ARIS/REPOSITORY
```

Start Docker:

```bash
docker compose up -d
```

Connect VS Code:

```bash
code .
```

Select:

```text
Dev Containers: Reopen in Container
```

Alternatively, enter Docker manually:

```bash
docker compose exec robot-dev bash
```

## 2. Get the latest code from GitHub

Before beginning work, synchronize your local repository with GitHub.

Run this from the Ubuntu terminal outside Docker:

```bash
git pull
```

If you are using a shared development branch, make sure you are on the correct branch before pulling.

## 3. Create a branch for your work

Avoid having everyone make changes directly to the main branch.

Create a separate branch for each feature or task.

Example:

```bash
git switch -c feature/lidar-integration
```

Other examples:

```bash
git switch -c feature/motor-control

git switch -c feature/nav2-setup

git switch -c bugfix/encoder-feedback
```

Each developer should work on their own branch.

## 4. Develop and test your code

Edit files using VS Code.

For ROS 2 development, use the Docker terminal.

Example:

```bash
cd /workspace/aris

colcon build

source install/setup.bash

ros2 run PACKAGE_NAME EXECUTABLE_NAME
```

You can modify source files directly in VS Code.

Changes are automatically saved to your Ubuntu repository through the Docker bind mount.

Normal source-code changes do NOT require rebuilding the Docker image.

However, you generally need to rebuild the ROS 2 workspace after changing package code:

```bash
colcon build
```

## 5. Check your changes

Before committing:

```bash
git status
```

Review the changes:

```bash
git diff
```

Make sure you are not committing unnecessary build files, temporary files, or personal configuration.

## 6. Commit your changes

From your Ubuntu terminal:

```bash
git add .
```

Commit:

```bash
git commit -m "Add LiDAR obstacle detection"
```

Use descriptive commit messages that explain what changed.

Examples:

```text
Add motor controller interface

Implement encoder feedback

Update robot URDF

Fix navigation launch configuration

Add emergency stop functionality
```

## 7. Push your branch to GitHub

```bash
git push -u origin feature/lidar-integration
```

Replace the branch name with your actual branch.

Your changes are now available on GitHub.

## 8. Create a Pull Request

On GitHub:

1. Open the A.R.I.S. repository.
2. Navigate to Pull Requests.
3. Select New Pull Request.
4. Select your feature branch as the source.
5. Select the main development branch as the destination.
6. Describe your changes.
7. Submit the Pull Request.

Have another team member review your changes before merging them.

Once approved, merge the Pull Request.

## 9. Update your local repository

After your changes have been merged, switch back to the shared development branch and pull the latest changes.

For example:

```bash
git switch main

git pull
```

Then create a new feature branch for your next task.

---

# Git and Team Collaboration

## Recommended Branch Structure

Use the following branch structure:

| Branch | Purpose |
|---|---|
| `main` | Stable, tested software |
| `feature/*` | New functionality |
| `bugfix/*` | Bug fixes |
| `development` | Shared integration branch, if needed |

For example:

```text
main
  |
  ├── feature/lidar-integration
  |
  ├── feature/motor-control
  |
  ├── feature/nav2-setup
  |
  └── bugfix/encoder-feedback
```

For a small team, you can also work directly from `main` with feature branches and Pull Requests. If you use a `development` branch, agree on that workflow as a team.

## Important Git Commands

| Command | Purpose |
|---|---|
| `git status` | Check modified files |
| `git pull` | Download latest changes |
| `git fetch` | Check for remote changes |
| `git branch` | List local branches |
| `git switch BRANCH` | Change branches |
| `git switch -c BRANCH` | Create and switch to a branch |
| `git add .` | Stage changes |
| `git commit -m "MESSAGE"` | Save a local commit |
| `git push` | Upload commits to GitHub |
| `git log --oneline -10` | View recent commits |
| `git diff` | Review modifications |

## Handling Merge Conflicts

A merge conflict occurs when two developers modify overlapping sections of the same file.

If this happens:

1. Stop and review the conflict.
2. Open the affected files in VS Code.
3. Find the conflict markers.
4. Decide which changes should be kept.
5. Remove the conflict markers.
6. Test the resulting code.
7. Commit the resolution.

Do not blindly accept all incoming or outgoing changes.

If you are unsure, ask the other developer who made the changes.

## Important Team Practices

- Always pull the latest code before beginning work.
- Use feature branches rather than committing directly to the stable branch.
- Commit frequently.
- Write descriptive commit messages.
- Test your changes before opening a Pull Request.
- Do not commit Docker build artifacts.
- Do not commit personal `.env` files or credentials.
- Coordinate changes to shared configuration files.
- Never force-push to shared branches unless the team explicitly agrees.

---

# Common Docker Commands

All commands below should be run from the repository root outside the container.

| Command | Description |
|---|---|
| `docker compose build` | Build the Docker image |
| `docker compose up -d` | Start the container |
| `docker compose down` | Stop and remove the container |
| `docker compose exec robot-dev bash` | Enter the running container |
| `docker compose ps` | Check container status |
| `docker compose logs` | View container logs |
| `docker compose restart` | Restart the container |
| `docker compose build --no-cache` | Rebuild the image without using cached build layers |

### When should I rebuild Docker?

You do NOT need to rebuild Docker when modifying normal ROS 2 source code.

| Change | Required action |
|---|---|
| Modify Python node | `colcon build` if needed |
| Modify C++ node | `colcon build` |
| Modify launch file | No Docker rebuild |
| Modify URDF | No Docker rebuild |
| Modify YAML configuration | No Docker rebuild |
| Add a ROS package | Install dependencies and `colcon build` |
| Add an Ubuntu system dependency | Update Dockerfile and rebuild |
| Modify Dockerfile | `docker compose build` |
| Modify Compose configuration | Restart/recreate container as appropriate |

---

# Troubleshooting

## Docker command not found

Make sure Docker Desktop is running and WSL integration is enabled for your Ubuntu distribution.

Test:

```bash
docker --version
```

## Cannot connect to Docker daemon

Open Docker Desktop and wait until the Docker engine has started.

Then try:

```bash
docker compose ps
```

## ROS 2 command not found

Source ROS 2 manually:

```bash
source /opt/ros/humble/setup.bash
```

If your workspace has already been built:

```bash
source install/setup.bash
```

## Package not found

Make sure the package exists inside `src/`.

Rebuild:

```bash
cd /workspace/aris

colcon build

source install/setup.bash
```

## Permission denied when editing files

Check file ownership:

```bash
ls -ln
```

The development user should match your local Ubuntu UID and GID.

Verify:

```bash
id
```

Check your `.env` values against:

```bash
id -u
id -g
```

If you change the IDs, rebuild the Docker image:

```bash
docker compose build
docker compose up -d --force-recreate
```

## GitHub asks for a username and password

GitHub does not accept normal account passwords for HTTPS Git operations.

Authenticate using GitHub CLI:

```bash
gh auth login
```

Then verify:

```bash
gh auth status
```

## Container is not running

Start it:

```bash
docker compose up -d
```

Check its status:

```bash
docker compose ps
```

## Changes are not appearing inside Docker

Verify that the repository is mounted:

```bash
ls /workspace/aris
```

Check that you are working in the correct repository and that the Compose bind mount points to the repository root.

