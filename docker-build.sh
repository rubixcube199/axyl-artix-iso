#!/bin/sh

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

## Change ownership variables.
_user=`echo ${SUDO_USER:-$(whoami)}`
_gid=`echo ${SUDO_GID}`
_group=`cat /etc/group | grep ${_gid} | cut -d: -f1 | head -1`
_path="$(pwd)/build/"
_iso="$(pwd)/Axyl-Iso/"

## iso filename format
_iso_name="axyl-runit"
_iso_version="$(date +%Y.%m.%d)"
_arch="x86_64"

_finalize_build() {
  ## Change iso filename to current format
  echo "+---------------------->>"
  echo "[*] Move Iso ${_iso} as ${_iso_name}-${_iso_version}-${_arch}.iso..."
  mkdir -p ${_iso}
  find ${_path} -type f -name "*.iso" -exec mv {} ${_iso}${_iso_name}-${_iso_version}-${_arch}.iso \;
  
  ## Change ownership 
  echo "+---------------------->>"
  echo "[*] Change ${_iso} ownership to '${_user}'..."
  chown -R ${_user}:${_group} ${_iso}

  ## Remove empty build directory
  rm -rf ./build
}

## Delete existing Axyl-Iso directory from home user
echo "+---------------------->>"
echo "[*] Delete existing ${_iso}..."
if [[ -d ${_iso} ]]; then
  rm -rf ${_iso}
fi

## Build Docker Image
docker build -t axyl-artix-build ./

if [ "$?" -ne 0 ]; then
    exit 1
fi

## Run The Docker Image
mkdir -p ${_path} ./pacman-cache
docker run --privileged \
           --mount type=bind,source="$(pwd)"/build,target=/root/artools-workspace/iso \
           --mount type=bind,source="$(pwd)"/pacman-cache,target=/var/cache/pacman/pkg \
           -t axyl-artix-build &&\
           _finalize_build
