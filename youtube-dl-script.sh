#!/bin/bash
#this a first attempt at a self-made youtube downloader without a gui.
#the purpose is to create a base for zenity to be applied in the second attempt at a videodownloader with zenity as a gui interface

#first, update youtube-dl: comment out for testing
youtube-dl -U
#define variables
#vidoraud=${vidoraud:-""} #variables are no longer needed, but syntaxing is correct and can be used again
#singplaypart=${singplaypart:-""} #!!
#define functions that will be used:
function video-or-audio {
read -p "select whether to download video with audio, or audio only and press [Enter]:
[1] Video with audio
[2] Audio file only
" va
}

function single-playlist-partial {
read -p "Single file, playlist or partial playlist?

[1] Single file
[2] Whole playlist
[3] Partial playlist
" spp
}
#### SINGLE-FILE ####
function single-file {
echo ""
case $va in

1)
echo "video formats available"
youtube-dl -F $url
read -p "Please enter the number corresponding to the format and press [Enter]:
" formatID
clear
youtube-dl -o '~/Videos/%(uploader)s/%(title)s' -f $formatID $url
;;

2)
echo "audio only"
youtube-dl -o '~/Music/%(uploader)s/%(title)s' -x --audio-format mp3 $url
;;

*)
read -p "Please select a valid option and press [Enter]"
single-file
;;
esac
}
#### PLAYLIST ####
function playlist {
echo ""

case $va in

1)
youtube-dl -o '~/Videos/%(uploader)s/%(playlist)s/%(playlist_index)s-%(title)s' -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -ci --recode-video mp4 $url
;;

2)
youtube-dl -o '~/Music/%(uploader)s/%(playlist)s/%(playlist_index)s-%(title)s' -x --audio-format mp3 $url
;;

*)
read -p "Please select a valid option and press [Enter]"
playlist
;;
esac
}

#### PARTIAL - PLAYLIST ####
function partial-playlist {
echo ""
case $va in

1)
read -p "Enter the starting number and press [Enter]:
" num_start

read -p "Enter the ending number and press [Enter]:
" num_end

clear

echo "Downloading items from number $num_start to number $num_end
"
youtube-dl -o '~/Music/%)uploader)s/%(playlist)s/%(playlist_index)s-%(title)s' -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -ci --playlist-start $num_start --playlist-end $num_end --recode-video mp4 $url
;;

2)
read -p "Enter the starting number and press [Enter]:
" num_start

read -p "Enter the ending number and press [Enter]:
" num_end

clear

echo "Downloading items from number $num_start to number $num_end
"
youtube-dl -o '~/Videos/%(uploader)s/%(playlist)s/%(playlist_index)s-%(title)s' -ci --playlist-start $num_start --playlist-end $num_end -x --audio-format mp3 $url
;;

*)
read -p "Please select a valid option and press [Enter]"
;;
esac
}


#########################################################################################################
#=initiate by pasting URL:
read -p "Please enter video URL and press [Enter]:
" url
clear
echo "$url will be downloaded
"
#call function for asking video or audio
video-or-audio
case $va in

1)
echo "Video and audio will be downloaded"
;;

2)
echo "Audio file will be downloaded"
;;

*)
echo "Please select a valid option"
;;
esac

single-playlist-partial
case $spp in

1)
single-file
;;

2)
playlist
;;

3)
partial-playlist
;;

*)
echo "Please select a valid option and press [Enter]"
single-playlist-partial
;;
esac




