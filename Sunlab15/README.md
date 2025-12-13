# build 
build sunlab15.love `rm /var/home/be/Dev/def/Out-of-the-game/Sunlab15.love && cd /var/home/be/Dev/def/Out-of-the-game && zip -r Sunlab15.zip Sunlab15 && mv Sunlab15.zip Sunlab15.love`

build sunlab15.exe `cat resources/love-11.5-win64/love.exe Sunlab15.love  > Sunlab15.exe`

run on linux `love Sunlab15.love`