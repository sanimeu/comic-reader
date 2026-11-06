#!/usr/bin/env bash
# Rebuilds the fixtures used by archive_spike.py. Needs: p7zip/7z, python3+Pillow, curl.
set -e
mkdir -p fx/pages && cd fx
python3 - <<'PY'
from PIL import Image
import random
random.seed(1)
for i in range(1,13):
    w,h=(800,1200) if i<11 else (800,9000)   # two tall webtoon-style strips
    im=Image.new('RGB',(w,h),(i*20%255,80,160)); px=im.load()
    for y in range(0,h,7):
        for x in range(0,w,11): px[x,y]=(random.randint(0,255),)*3
    im.save(f'pages/page{i}.jpg' if i%2 else f'pages/page{i}.png')
PY
(cd pages && 7z a -bso0 -bsp0 ../t_zip.zip * && 7z a -bso0 -bsp0 -mx=9 -ms=on ../t_solid.7z * && 7z a -bso0 -bsp0 -ms=off ../t_nonsolid.7z *)
B=https://raw.githubusercontent.com/libarchive/libarchive/master/libarchive/test
for n in rar5_stored rar5_compressed rar5_solid rar5_unicode; do
  curl -sO $B/test_read_format_$n.rar.uu
  python3 -c "import uu;uu.decode('test_read_format_$n.rar.uu','test_read_format_$n.rar',quiet=True)"
done
