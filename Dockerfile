# Dockerfile for building the Artix ISO
FROM angelofallaria/artix-base

RUN pacman -Syyu --noconfirm --needed artools iso-profiles archlinux-keyring archlinux-mirrorlist
RUN pacman-key --init
RUN pacman-key --populate

WORKDIR /axyl-artix-iso
COPY ./artixiso/ ./artixiso/

CMD cd ./artixiso/artools-workspace/iso-profiles/ ; ./build.sh
