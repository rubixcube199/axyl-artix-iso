#!/bin/sh

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

docker build -t axyl-artix-build ./

if [ "$?" -ne 0 ]; then
    exit 1
fi

modprobe loop
mkdir build pacman-cache
docker run --privileged --mount type=bind,source="$(pwd)"/build,target=/root/artools-workspace/iso --mount type=bind,source="$(pwd)"/pacman-cache,target=/var/cache/pacman/pkg -t axyl-artix-build &&\
echo "Axyl ISO build successful! The ISO was placed in ./build."
