#!/bin/bash
# Apple Music Festival 2015 - Show Downloader
# Variables 
cookie="token=$(curl -s https://itunes.apple.com/apps1b/authtoken/token.txt)"
tag=$1
artist=$2
counter=1
output=${artist}_amf${tag}092015.ts

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
     echo "Apple Music Festival 2015 - Start download of ${artist} show ($tag/09/2015)"
# Fetching parts links
files2=$(curl -s --cookie "$cookie" "http://streaming.itunesfestival.com/auth/eu1/vod/201509$tag/v1/8500_256/{$idartist}_${artist}_vod.m3u8")
files=$(echo $files2 | tr -d '\r')
if [[ $files =~ "</Message></Error>" ]]; then
    echo "Error! Wrong day or artist name. Check the input parameters and remember: NO SPACE IN ARTIST NAME!"
    cd ..
    rm -r $artist
    exit 1;
fi

items=$(grep -o song <<< ${files[*]} | wc -l | tr -d ' ')

# Download parts
for i in $files; do
  if [[ "$i" =~ "song" ]]; then
      # Check if file already exist
      if [[ ! -f $counter.ts ]]; then
         echo "Downloading part $counter of $items"
         # Check download status and exit if fail
         #cat $i
         until curl -m 600 --cookie "${cookie}" http://streaming.itunesfestival.com/auth/eu1/vod/201509$tag/v1/8500_256/$i > $counter.ts; do
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
