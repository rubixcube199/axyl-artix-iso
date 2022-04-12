# Dockerfile for building the Artix ISO
FROM angelofallaria/artix-base

RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm --needed artools iso-profiles archlinux-keyring archlinux-mirrorlist 

RUN pacman-key --init
RUN pacman-key --populate

WORKDIR /axyl-artix-iso
COPY . .

RUN ln -sf "$(pwd)/artixiso/artools-workspace" ~/
RUN mkdir ~/.config
RUN ln -sf "$(pwd)/config/artools" ~/.config/

CMD cd /root/artools-workspace/iso-profiles ; ./build.sh
