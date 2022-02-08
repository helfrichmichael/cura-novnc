# Cura noVNC Docker Container

### This is a work-in-progress and the Docker image is larger than I'd like it to be. More updates to come soon!

## Overview

This is a super basic noVNC build using supervisor to serve Cura in your favorite web browser. This was primarily built for users using the [popular unraid NAS software](https://unraid.net), to allow them to quickly hop in a browser, slice, and upload their favorite 3D prints. 

This is super similar to my [prusaslicer-novnc](https://github.com/helfrichmichael/prusaslicer-novnc) container and basically just adapts that for using Cura via VNC.

## How to use

**In unraid**

If you're using unraid, open your Docker page and under `Template repositories`, add `https://github.com/helfrichmichael/unraid-templates` and save it. You should then be able to Add Container for cura-novnc. For unraid, the template will default to 6080 for the noVNC web instance.

**Outside of unraid**

To run this image, you can run the following command: `docker run --detach --volume=cura-novnc-data:/home/cura/ -p 8080:8080 --name=cura-novnc cura-novnc`

This will bind `/home/cura/` in the container to a local volume on my machine named `cura-novnc-data`, and finally, it will bind port `8080` to `8080`.

## Links

[Cura](https://github.com/Ultimaker/Cura)

[Supervisor](http://supervisord.org/)

[GitHub Source](https://github.com/helfrichmichael/cura-novnc)

[Docker](https://hub.docker.com/r/mikeah/cura-novnc)