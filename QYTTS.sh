#!/bin/bash
#
# #####################################################
# QsYouTubeTrailerScraper - QYTTS - v0.3
# #####################################################
#
# This script will scrape your Kodi library for movie titles, then search
# YouTube for it's trailer. It'll download the trailers to a specified
# directory, which is used by the Cinema Experience script for Kodi to
# load trailers. This way you can see the trailers for films you own, 
# withought having to dea with all the buffering that comes from streaming.
#
# I know there are other tools out there to get trailers for your library,
# but most were windows based. The ones that weren't would just grab trailers
# for any film, whether you have it or not.
#
# This was designed for my original Raspberry Pi Model B, running OSMC.
# As such, it'll probably run on any Linux Kodi setup.
#
#
# Please see the included README.md file for more information
#
#
# 
# Copyright © 2015 Category <spankyNO-SPAMquinton@googlemail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.



#################
#               #
# CONFIGURATION #
#               #
#################


ts_database="$HOME/.kodi/userdata/Database/MyVideos93.db"
# Location of your database file, normally "$HOME/.kodi/userdata/Database/MyVideos93.db"

ts_trailerdir="/path/to/your/trailer/folder/"
# Location to save trailers

ts_tempdir="/path/to/your/temporary/folder"
# Location to store temporary woking files

ts_maxsize=104857600
# Maximum filesize of Trailers in bytes (to prevent full films being saved as trailers)
# Default 100MB is 104857600


#############
#           #
# FUNCTIONS #
#           #
#############

function trailer_dl {
	# Clear temp files
	cat /dev/null > $ts_tempdir"YTSearchList"
	cat /dev/null > $ts_tempdir"TopResult"
	YTCode=""
	
	# Prepare search target
	YTTarget=${1// /+}+"trailer"
	# Prepare new filename
	YTNewName=${YTTarget//+/-}
	YTNewName=${YTNewName//\'/-}
	YTNewName=${YTNewName//:/-}".avi"
	
	
	# Check if local trailer already exists
	if [ -e $ts_trailerdir$YTNewName ]
	then
		# File found
		echo Trailer for $1 already exists, skipping download
		return
	else
		# No file found
		echo Searching YouTube for $1 trailer
		
		# Scrape top result from YouTube search
		curl -s https://www.youtube.com/results\?search_query\=$YTTarget | grep yt-uix-tile-link > $ts_tempdir"YTSearchList"
		head -n 3 $ts_tempdir"YTSearchList" | tail -n 1 > $ts_tempdir"TopResult"


		# Check if first result is a trailer
		if [ $(cat $ts_tempdir"TopResult" | grep -i TRAILER | wc -l) ]
		then
			echo First result is a trailer, proceeding

			
			# Extract YouTube ID from result
			YTCode=$(cut -c85-95 $ts_tempdir"TopResult")
			echo YouTube ID: $YTCode
		
			echo Downloading trailer for $1
			youtube-dl -q --restrict-filenames http://www.youtube.com/watch?v=$YTCode
		
			#Rename file for CinemaExperience trailers
			YTFileName=$(youtube-dl --restrict-filenames --get-filename http://www.youtube.com/watch?v=$YTCode)
			YTFileSize=$(wc -c <"$YTFileName")
		
			# Check size and remove if too large
			if [ $YTFileSize -gt $ts_maxsize ]
			then
				echo File too large, removing
				rm "$YTFileName"
				FailedDL=$FailedDL+1
				return
			else
				cp "$YTFileName" $ts_trailerdir$YTNewName
				rm "$YTFileName"
				echo Saved as $YTNewName
			fi
			
			
		else
			echo Top YouTube result is not a trailer, skipping download
			FailedDL=$FailedDL+1
			return
		fi
		
		
	fi
	
	
}





#            #
# INITIALIZE #
#            #
echo QsYouTubeTrailerScraper - QYTTS
echo v0.3 - added better trailer detection
echo

# Create clean temp files
echo Initializing...
cat /dev/null > $ts_tempdir"CurrentMovie"
cat /dev/null > $ts_tempdir"MovieList"
cat /dev/null > $ts_tempdir"YTSearchList"
cat /dev/null > $ts_tempdir"TopResult"
FailedDL=0


# Extract movie names from Kodi DB
echo Extracting MovieList from Kodi database
sqlite3 $ts_database "select c00 from movie;" >> $ts_tempdir"MovieList"

LineCount=$(wc -l < $ts_tempdir"MovieList")
echo $LineCount movies found

#           #
# MAIN LOOP #
#           #


# Loop through the Movie list
COUNTER=0
while [ $COUNTER -lt $LineCount ]; do
	# Cut a single film out of the list based on the Counter
	let COUNTER=$COUNTER+1
	head -n$COUNTER $ts_tempdir"MovieList" > $ts_tempdir"CurrentMovie"
	ScanFilm=$(tail -n1 $ts_tempdir"CurrentMovie")
	
	
	# Pass movie name to the download handler
	trailer_dl "$ScanFilm"
		
	
done


echo All Movies checked.
echo Failed to find suitable trailer for $FailedDL films

#          #
# CLEANING #
#          #

# Remove temp files
echo Cleaning up...
rm $ts_tempdir"CurrentMovie"
rm $ts_tempdir"MovieList"
rm $ts_tempdir"YTSearchList"
rm $ts_tempdir"TopResult"


echo Thanks for using QYTTS
