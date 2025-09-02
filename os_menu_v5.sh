#!/bin/bash

BRAND="nobita-hosting"
VM_DATA="$PWD/vmdata"
mkdir -p "$VM_DATA"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not installed. Install Docker first."
    exit 1
fi

build_and_run() {
    local OS_NAME=$1
    local IMAGE_NAME="$BRAND/$2"
    local CONTAINER_NAME="$BRAND-$3"
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "Building $OS_NAME..."
        docker build -t $IMAGE_NAME ./$2
    else
        echo "$OS_NAME image exists. Skipping build."
    fi
    echo "Running $OS_NAME (auto-delete)..."
    docker run -it --rm --name $CONTAINER_NAME -v $VM_DATA:/vmdata $IMAGE_NAME
    echo "$OS_NAME container exited and auto-deleted."
}

run_prebuilt() {
    echo "Pre-built images:"
    docker images | grep "$BRAND"
    read -p "Enter image name to run (e.g., $BRAND/debian11): " IMAGE_NAME
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "Image not found. Build first using options 1-5."
    else
        CONTAINER_NAME="${IMAGE_NAME//\//-}"
        echo "Running $IMAGE_NAME (No auto-delete)..."
        docker run -it --name $CONTAINER_NAME -v $VM_DATA:/vmdata $IMAGE_NAME
        echo "Container exited. NOT auto-deleted."
    fi
}

while true; do
    echo "===================================="
    echo "       Nobita Hosting Menu"
    echo "===================================="
    echo "1) Debian"
    echo "2) Ubuntu"
    echo "3) Kali Linux"
    echo "4) Windows 10 (instructions)"
    echo "5) Exit"
    echo "6) Run Pre-built Container (No Auto-Delete)"
    read -p "Select option [1-6]: " os_choice

    case $os_choice in
        1) 
            echo "Debian version: 1) 11 2) 12"
            read -p "Choice [1-2]: " v
            [[ $v == 1 ]] && build_and_run "Debian 11" "debian11" "debian11"
            [[ $v == 2 ]] && build_and_run "Debian 12" "debian12" "debian12"
            ;;
        2)
            echo "Ubuntu version: 1) Server 22.04 2) Desktop 24.04"
            read -p "Choice [1-2]: " v
            [[ $v == 1 ]] && build_and_run "Ubuntu Server 22.04" "ubuntu22-server" "ubuntu22"
            [[ $v == 2 ]] && build_and_run "Ubuntu Desktop 24.04" "ubuntu24-desktop" "ubuntu24"
            ;;
        3) build_and_run "Kali Linux" "kali" "kali" ;;
        4) echo "See windows10/README.md for instructions." ;;
        5) exit 0 ;;
        6) run_prebuilt ;;
        *) echo "Invalid option." ;;
    esac
done
