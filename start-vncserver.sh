#!/bin/bash

echo "starting VNC server ..."
export USER=root
vncserver :1 -geometry 1200x700 -depth 24 && tail -F /root/.vnc/*.log
