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

-----
Usage
-----
Ensure all configuration options are set correctly, then just
run the script as the same user that runs Kodi. 
No arguments need

------------
Dependencies
------------
bash shell environment
sqlite3 (most distro's will have this in their repo)
youtube-dl (available at https://rg3.github.io/youtube-dl/ )


 
Copyright © 2015 Category <do-not-spam@yourmum.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
