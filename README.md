# Cura noVNC Docker Container

## Overview

This is a super basic noVNC build using supervisor to serve Cura in your favorite web browser. This was primarily built for users using the [popular unraid NAS software](https://unraid.net), to allow them to quickly hop in a browser, slice, and upload their favorite 3D prints. 

This is super similar to my [prusaslicer-novnc](https://github.com/helfrichmichael/prusaslicer-novnc) container and basically just adapts that for using Cura via VNC.

Please note: This is a work-in-progress and the Docker image is larger than I'd like it to be. More updates to come soon. Specifically the image is using the extracted AppImage version which results in extra copies of dependencies that might already exist.

## How to use

**In unraid**

If you're using unraid, open your Docker page and under `Template repositories`, add `https://github.com/helfrichmichael/unraid-templates` and save it. You should then be able to Add Container for cura-novnc. For unraid, the template will default to 6080 for the noVNC web instance.

**Outside of unraid**

To run this image, you can run the following command: `docker run --detach --volume=cura-novnc-data:/home/cura/ --volume=cura-novnc-prints:/prints/ -p 8080:8080 --name=cura-novnc cura-novnc`

This will bind `/home/cura/` in the container to a local volume on my machine named `cura-novnc-data`. Additionally it will bind `/prints/` in the container to `cura-novnc-prints` locally on my machine. Finally it will bind port `8080` to `8080`.

**Using a VNC Viewer**

To use a VNC viewer with the container, the default port for X TigerVNC is 5900. You can add this port by adding `-p 5900:5900` to your command to start the container to open this port for access.


**GPU Acceleration/Passthrough**

Like other Docker containers, you can pass your Nvidia GPU into the container using the `NVIDIA_VISIBLE_DEVICES` and `NVIDIA_DRIVER_CAPABILITIES` envs. You can define these using the value of `all` or by providing more narrow and specific values. This has only been tested on Nvidia GPUs.

In unraid you can set these values during set up. For containers outside of unraid, you can set this by adding the following params or similar  `-e NVIDIA_DRIVER_CAPABILITIES="all" NVIDIA_VISIBLE_DEVICES="all"`


## Links

[Cura](https://github.com/Ultimaker/Cura)

[Supervisor](http://supervisord.org/)

[GitHub Source](https://github.com/helfrichmichael/cura-novnc)

[Docker](https://hub.docker.com/r/mikeah/cura-novnc)

<a href="https://www.buymeacoffee.com/helfrichmichael" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>