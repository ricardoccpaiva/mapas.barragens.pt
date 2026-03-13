#!/bin/sh
set -e
MBTILES_DIR="/data/mbtiles"
MBTILES_FILE="osm-2020-02-10-v3.11_europe_spain.mbtiles"
MBTILES_PATH="$MBTILES_DIR/$MBTILES_FILE"

mkdir -p "$MBTILES_DIR"

if [ -n "$MBTILES_URL" ] && [ ! -f "$MBTILES_PATH" ]; then
  echo "Downloading MBTiles from $MBTILES_URL..."
  node -e "
    const u=process.env.MBTILES_URL;
    const f='osm-2020-02-10-v3.11_europe_spain.mbtiles';
    const fs=require('fs');
    const path=require('path');
    const dir='/data/mbtiles';
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    const dest=path.join(dir, f);
    const p=u.startsWith('https')?require('https'):require('http');
    const fstream=fs.createWriteStream(dest);
    p.get(u,r=>{r.pipe(fstream);fstream.on('finish',()=>fstream.close());}).on('error',e=>{console.error(e);process.exit(1);});
  "
  chown -R node:node "$MBTILES_DIR"
fi

if [ ! -f "$MBTILES_PATH" ]; then
  echo "ERROR: MBTiles file not found at $MBTILES_PATH"
  echo "To fix: place the .mbtiles file in the mbtiles volume/directory, or set MBTILES_URL to download it."
  echo "Download free OpenMapTiles from: https://data.maptiler.com/downloads/europe/portugal/ or https://data.maptiler.com/downloads/europe/spain/"
  exit 1
fi

# Ensure tileserver (node user) can read the mbtiles
chown -R node:node "$MBTILES_DIR"

exec /usr/src/app/docker-entrypoint.sh -c /app/data/config.json
