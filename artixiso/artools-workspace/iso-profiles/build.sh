#!/usr/bin/env bash

non_root_user=artix # since makepkg doesn't run as root, we need a non root user for aur package building ( make sure the user has no password )
#init=dinit
#init=openrc
init=runit
#init=s6
#init=suite66

buildiso -i $init -p base -x

artix-chroot /var/lib/artools/buildiso/base/artix/rootfs bash -c "pacman-key --init; pacman-key --populate artix;pacman-key --populate archlinux; pacman -Syy"

buildiso -i $init -p base -sc
buildiso -i $init -p base -bc
buildiso -i $init -p base -zc || exit 1
