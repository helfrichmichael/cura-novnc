# Get and install Easy noVNC.
FROM golang:bullseye AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

# Get TigerVNC and Supervisor for isolating the container.
FROM debian:bullseye
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openbox tigervnc-standalone-server supervisor gosu && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

# Get all of the remaining dependencies for the OS, VNC, and Cura (additionally Firefox-ESR to sign-in to Ultimaker if you'd like).
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends lxterminal nano wget openssh-client rsync ca-certificates xdg-utils htop tar xzip gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

RUN apt update && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
        freeglut3 libgtk2.0-dev libwxgtk3.0-gtk3-dev libwx-perl libxmu-dev libgl1-mesa-glx libgl1-mesa-dri  \
        xdg-utils locales locales-all pcmanfm jq curl git firefox-esr qtbase5-dev \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install Cura!
ADD get_release_info.sh cura/
WORKDIR /cura

RUN chmod +x /cura/get_release_info.sh \
  && latestCura=$(/cura/get_release_info.sh url) \
  && curaReleaseName=$(/cura/get_release_info.sh name) \
  && curl -sSL ${latestCura} > ${curaReleaseName} \
  && rm -f /cura/releaseInfo.json \
  && chmod +x /cura/${curaReleaseName} \
  && /cura/${curaReleaseName} --appimage-extract \
  # Below, we adjust the platform theme to GTK3 per https://github.com/Ultimaker/Cura/issues/12266#issuecomment-1274861668.
  # Without this, the file dialog is never functional/visible with Cura due to the uncompiled App Image.
  && sed -i 's/QT_QPA_PLATFORMTHEME=xdgdesktopportal/QT_QPA_PLATFORMTHEME=gtk3/' /cura/squashfs-root/AppRun \
  && rm /cura/${curaReleaseName} \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoclean \
  && groupadd cura \
  && useradd -g cura --create-home --home-dir /home/cura cura \
  && mkdir -p /cura \
  && mkdir -p /prints/ \
  && chown -R cura:cura /cura/ /home/cura/ /prints/ \
  && mkdir -p /home/cura/.config/ \
  # We can now set the Download directory for Firefox and other browsers.
  # We can also add /prints/ to the file explorer bookmarks for easy access.
  && echo "XDG_DOWNLOAD_DIR=\"/prints/\"" >> /home/cura/.config/user-dirs.dirs \
  && echo "file:///prints prints" >> /home/cura/.gtk-bookmarks

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY menu.xml /etc/xdg/openbox/
COPY supervisord.conf /etc/
EXPOSE 8080

VOLUME /home/cura/
VOLUME /prints/

# It's time! Let's get to work! We use /home/cura/ as a bindable volume for Cura and its configurations. We use /prints/ to provide a location for STLs and GCODE files.
CMD ["/bin/bash", "-c", "chown -R cura:cura /home/cura/ /prints/ /dev/stdout && exec gosu cura supervisord"]