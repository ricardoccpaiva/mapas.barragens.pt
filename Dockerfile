# Extend tileserver-gl with startup logic for MBTiles download/pre-check
FROM maptiler/tileserver-gl:latest

COPY startup.sh /startup.sh
# Use /app/data to avoid Coolify/default mounts that may overlay /data
COPY config.json /app/data/
COPY fonts/ /app/data/fonts/
COPY styles/ /app/data/styles/

# Run startup as root so we can create/download files in the volume, then chown for the node user
USER root

ENTRYPOINT ["/bin/sh", "/startup.sh"]
