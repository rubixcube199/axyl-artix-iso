#!/usr/bin/env bash

non_root_user=artix # since makepkg doesn't run as root, we need a non root user for aur package building ( make sure the user has no password )
#init=dinit
#init=openrc
init=runit
#init=s6
#init=suite66

## paths
chroot_dir="/var/lib/artools/buildiso/base/artix/rootfs"

## Set color characters
set_color() {
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

## Show an INFO message
_msg_info() {
    local _msg="${1}"
    printf '%s[ARTIX-CHROOT] INFO:%s %s...%s\n' "${YELLOW}${BOLD}" "${RESET}" "${BOLD}${_msg}" "${RESET}"
}

set_color
buildiso -i $init -p base -x

## Update System
_msg_info "Live environment pacman system update & populate keyrings"
artix-chroot ${chroot_dir} bash -c "pacman-key --init; pacman-key --populate artix; pacman-key --populate archlinux; pacman -Syy"

## Run customize_chroot.sh
if [[ -e $(pwd)/base/root-overlay/root/customize_chroot.sh ]]; then
  _msg_info "Running customize_chroot.sh in '${chroot_dir}' chroot"
  chmod +x "${chroot_dir}/root/customize_chroot.sh"
  artix-chroot "${chroot_dir}" "/root/customize_chroot.sh"
  rm -f "${chroot_dir}/root/customize_chroot.sh"
  _msg_info "Done! customize_chroot.sh run successfully."
fi

buildiso -i $init -p base -sc
buildiso -i $init -p base -bc
buildiso -i $init -p base -zc || exit 1
