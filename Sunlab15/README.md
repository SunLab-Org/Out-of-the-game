# build 
build sunlab15.love `rm -f Sunlab15.love && cd Sunlab15 && zip -r ../Sunlab15.love main.lua conf.lua assets/ libs/ games/ -q && cd .. && ls -lh Sunlab15.love`

build sunlab15.exe `rm Sunlab15.exe && cat resources/love-11.5-win64/love.exe Sunlab15.love  > Sunlab15.exe`

run on linux `love Sunlab15.love`

build web `https://schellingb.github.io/LoveWebBuilder/` (not working now)