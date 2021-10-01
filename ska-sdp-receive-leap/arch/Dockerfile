FROM archlinux:base

RUN pacman -Sy --needed --noconfirm sudo fakeroot binutils

# setup builduser for using `makepkg`
RUN useradd builduser -m && passwd -d builduser && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

RUN pacman -Sy --noconfirm git make pkg-config cmake gcc gcc-fortran boost boost-libs flex bison openblas lapack cfitsio wcslib

RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/casacore-git.git && cd casacore-git && makepkg --noconfirm .'

RUN pip3 install --no-binary python-casacore python-casacore