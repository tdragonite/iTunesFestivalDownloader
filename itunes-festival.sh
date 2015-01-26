#!/bin/bash
# iTunes Festival 2014 - Show Downloader
# Variables 
cookie="token=$(curl -s http://itunes.apple.com/apps1b/authtoken/token.txt)"
tag=$1
artist=$2
counter=1
output=${artist}_itf${tag}092014.ts

# Making temp directory
mkdir -p $artist
cd $artist

# Search artist id
if [[ -z "$3" ]]; then
api=$(curl -s "https://itunes.apple.com/search?term=$artist&entity=musicArtist&attribute=artistTerm&limit=1")
idartist=$(expr "$api" : '.*"artistId":\([^"]*\),')
else
idartist=$3
fi

# Fetching parts links
     echo "iTunes Festival 2014 - Start download of ${artist} show ($tag/09/2014)"
index=$(curl -s -b "$cookie" http://streaming.itunesfestival.com/auth/eu6/vod/201409$tag/v1/${idartist}_${artist}_desktop_vod.m3u8 | tail -n1)

# Check if the input data are right.
if [[ $index =~ "</Message></Error>" ]]; then
    echo "Error! Wrong day or artist name. Check the input parameters and remember: NO SPACE IN ARTIST NAME!"
    cd ..
    rm -r $artist
    exit 1;
fi

# Fetching parts links
files=$(curl -s -b "$cookie" http://streaming.itunesfestival.com/auth/eu6/vod/201409$tag/v1/$index)
items=$(grep -o song <<< ${files[*]} | wc -l | tr -d ' ')

# Download parts
for i in $files; do
  if [[ "$i" =~ "song" ]]; then
      # Check if file already exist
      if [[ ! -f $counter.ts ]]; then
         echo "Downloading part $counter of $items"
         # Check download status and exit if fail
         until curl -m 600 -b "$cookie" http://streaming.itunesfestival.com/auth/eu6/vod/201409$tag/v1/8500_256/$i > $counter.ts; do
         rm -f $counter.ts
         echo "Failed to download. Try re-run the script for resume."
         exit 1;
         done
      fi
  counter=$((counter+1))
  fi
done


# Merging parts and move in parent directory
echo "Building: $output"
cat $( ls -1 *.ts | sort -n  ) > $output
mv $output ../
cd ..
rm -r $artist
echo "Done."