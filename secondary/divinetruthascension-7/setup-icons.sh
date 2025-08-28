#!/bin/bash
echo "Generating placeholder icons..."
if command -v python3 &> /dev/null; then
python3 - <<END
from PIL import Image, ImageDraw
icons = {"icon-192x192.png":192,"icon-512x512.png":512,"icon-maskable.png":512,"apple-touch-icon.png":180}
colors = ["#ff9800","#ff5722","#ffc107","#ffeb3b"]
import os
for i,(f,s) in enumerate(icons.items()):
  path = f"assets/icons/{f}"
  if not os.path.isfile(path):
    img=Image.new("RGB",(s,s),colors[i%len(colors)])
    draw=ImageDraw.Draw(img)
    draw.text((s//4,s//3),"DTA",fill="white")
    img.save(path)
END
else
echo "Python3 not found; skipping icon generation"
fi
