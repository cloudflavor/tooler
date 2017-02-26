FROM opensuse:42.2

RUN zypper --non-interactive in -y bind-utils \
    nmon \
    ncdu \
    htop \
    nload \
    gdb \
    && zypper clean
