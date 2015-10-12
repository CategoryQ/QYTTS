# QYTTS

QsYouTubeTrailerScraper - QYTTS
v0.2 - complete reworking of proof of concept version

This script will scrape your Kodi library for movie titles, then search
YouTube for it's trailer. It'll download the trailers to a specified
directory, which is used by the Cinema Experience script for Kodi to
load trailers. This way you can see the trailers for films you own, 
withought having to dea with all the buffering that comes from streaming.

I know there are other tools out there to get trailers for your library,
but most were windows based. The ones that weren't would just grab trailers
for any film, whether you have it or not.

This was designed for my original Raspberry Pi Model B, running OSMC.
As such, it'll probably run on any Linux Kodi setup.


----
Usage
-----
Ensure all configuration options are set correctly, then just
run the script as the same user that runs Kodi. 
No arguments needed, just make sure the Kodi user has write access to 
temp & trailer directories.


------------
Dependencies
------------
bash shell environment

sqlite3
- install with "sudo apt-get install sqlite3"

youtube-dl
- install with "sudo curl https://yt-dl.org/latest/youtube-dl -o /usr/local/bin/youtube-dl ; sudo chmod a+rx /usr/local/bin/youtube-dl"


------------
Known Issues
------------
-Grabbing entire films-
Due to the simplicity of this script, it will grab the first YouTube result
after searching for the movie name + "trailer". In the case of some films
- mostly older or independent films - the first result on youtube will be
the complete film. In that case, this script currently downloads the entire
film, checks if it is larger than the maximum file size (default is 100MB),
and if it is too large then deletes the file. I currently have no way to 
check the file size before downloading, so I'm trying to think of another
way around that to avoid unneccesary bandwidth usage....
 
If you encounter any other issues, please raise an issue on github
(https://github.com/CategoryQ/QYTTS)
 
 
 
Copyright © 2015 Category <spankyNO-SPAMquinton@googlemail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
