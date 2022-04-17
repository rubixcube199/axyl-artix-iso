#!/bin/bash

skeldir="/etc/skel"
rootdir="/root/.config"

if [[ ! -d ${rootdir} ]]; then 
    mkdir -p ${rootdir}
fi

declare -a rootdots=('.local' '.gtkrc-2.0' '.vim_runtime' '.vimrc' '.zshrc' '.zshrc-personal' '.dmrc' '.hushlogin')
for dfile in ${rootdots[@]}; do
    if [[ -e ${skeldir}/${dfile} ]]; then
        cp -rf ${skeldir}/${dfile} /root
    fi
done

declare -a rootconfig=('i3' 'geany' 'gtk-2.0' 'gtk-3.0' 'kvantum' 'neofetch' 'nvim' 'qt5ct' 'ranger' 'thunar' 'xfce4' 'conkeww' 'pulse' 'sxhkd' 'cava')
for cfg in ${rootconfig[@]}; do
    if [[ -e ${skeldir}/.config/${cfg} ]]; then
        cp -rf ${skeldir}/.config/${cfg} ${rootdir}
    fi
done
