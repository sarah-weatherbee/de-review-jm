#!/bin/bash

# Update package list
sudo apt-get update -y

# Step 1: Install Git (if not already installed)
if ! command -v git &> /dev/null
then
    echo "Git not found. Installing..."
    sudo apt-get install git -y
else
    echo "Git is already installed."
fi

# Step 2: Install make (if not already installed)
if ! command -v make &> /dev/null
then
    echo "Make not found. Installing..."
    sudo apt-get install make -y
else
    echo "Make is already installed."
fi

# Step 3: Install Docker and Docker Compose
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing..."
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the Docker repository
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Start Docker and enable it to start on boot
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "Docker is already installed."
fi

# Step 4: Add the current user to the Docker group (to allow non-root access to Docker)
sudo usermod -aG docker $USER

# Step 5: Clone the repository
REPO_URL="https://github.com/josephmachado/de_project.git"
TARGET_DIR="$HOME/de_project"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "Repository already cloned."
fi

# Step 6: Change directory to the repository
cd "$TARGET_DIR" || exit

# Step 7: Run 'make up' if Makefile is present
if [ -f "Makefile" ]; then
    echo "Running 'make up'..."
    make up
else
    echo "Makefile not found. Skipping 'make up'."
fi
