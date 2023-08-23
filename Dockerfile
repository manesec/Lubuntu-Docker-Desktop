# As RDP sound work, It need to do some patch.
# Pathch: https://github.com/neutrinolabs/pulseaudio-module-xrdp
# In the builder and main container, using apt-fast to speed up apt download.
# by manesec.

# ---------------------------------------------------------------------------
#                                   Builder
# ---------------------------------------------------------------------------

FROM ubuntu:mantic as builder

ENV DEBIAN_FRONTEND=noninteractive

# Uncommand deb-sfc
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Install apt-fast
RUN apt update; apt-get install -y software-properties-common; add-apt-repository ppa:apt-fast/stable -y; apt-get install -y apt-fast aria2;

# Config apt-fast
RUN echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
RUN echo debconf apt-fast/dlflag boolean true | debconf-set-selections
RUN echo debconf apt-fast/aptmanager string apt-get | debconf-set-selections

# Install Pre-Build Pulseaudio package
RUN apt-fast install -y git autoconf pkg-config libssl-dev libpam0g-dev libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex bison libxml2-dev dpkg-dev libcap-dev libpulse-dev

WORKDIR /tmp
RUN apt-get source pulseaudio ; \
    apt-get build-dep -yy pulseaudio ; \
    mv pulseaudio-* pulseaudio

# Build Audio
WORKDIR /tmp/pulseaudio
RUN dpkg-buildpackage -rfakeroot -uc -b

# Build XRDP
WORKDIR /tmp
RUN git clone --branch devel --recursive https://github.com/neutrinolabs/xrdp.git

WORKDIR /tmp/xrdp
RUN ./bootstrap; ./configure; make && make install;

# Build Module
WORKDIR /tmp
RUN git clone --recursive https://github.com/neutrinolabs/pulseaudio-module-xrdp.git

WORKDIR /tmp/pulseaudio-module-xrdp
RUN ./bootstrap && ./configure PULSE_DIR=/tmp/pulseaudio ; make
RUN mkdir -p /tmp/output; cp src/.libs/*.so /tmp/output


# ---------------------------------------------------------------------------
#                                   Container
# ---------------------------------------------------------------------------

FROM ubuntu:mantic

ENV DEBIAN_FRONTEND=noninteractive

# Uncommand deb-sfc
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Install apt-fast
RUN apt update; apt-get install -y software-properties-common; add-apt-repository ppa:apt-fast/stable -y; apt-get install -y apt-fast aria2;

# Config apt-fast
RUN echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
RUN echo debconf apt-fast/dlflag boolean true | debconf-set-selections
RUN echo debconf apt-fast/aptmanager string apt-get | debconf-set-selections

# Install Basic Packages
RUN apt-fast -y install lubuntu-desktop xrdp dbus-x11 uuid-runtime xauth xautolock  xorgxrdp xprintidle 

# PATCH XRDP
RUN mkdir -p /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/output/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer
COPY --from=builder /tmp/output/module-xrdp-sink.so /var/lib/xrdp-pulseaudio-installer

# Install Pulse Audio
RUN apt-fast install -y pulseaudio 

RUN cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
  sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
  sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
  echo "xfce4-session" >> /etc/skel/.Xclients && \
  cp -r /etc/ssh /ssh_orig && \
  rm -rf /etc/ssh/* && \
  rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem; \
  xrdp-keygen xrdp auto 2048;

# Finally Setup
COPY RunOnce.sh /bin/RunOnce.sh
COPY bin/* /bin/

RUN chmod +x /bin/RunOnce.sh; chmod -R +x /bin/*

# Install Custom software
COPY software /opt/software
RUN chmod -R +x /opt/software/* ;run-parts /opt/software --regex=".sh"

# Copy custon theme
RUN mkdir -p /home/users/
COPY theme /home/users/.config

EXPOSE 3389 
CMD ["bash","/bin/RunOnce.sh"]

