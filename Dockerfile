# Extend tileserver-gl with config, fonts, and styles
FROM maptiler/tileserver-gl:latest

COPY config.json /app/data/
COPY fonts/ /app/data/fonts/
COPY styles/ /app/data/styles/

CMD ["-c", "/app/data/config.json"]
