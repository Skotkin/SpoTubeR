## Overview

SpoTubeR is a package which combines data from the R wrappers spotifyr and tuber to match a given Spotify song with an associated YouTube music video. When given a Spotify Song or YouTube Music video, SpoTubeR generates a 'match score' equating to its confidence that the songs are a match. SpoTuber can also be used to explore compelling questions about how songs across different genres, by different artists, associated with different record labels, or released on different years may generate more or less popular music videos on YouTube in comparison with the song's popularity on Spotify.

## Installation
devtools::install_github('Skotkin/SpoTubeR')

## Authentication
For Spotify API: 

First, set up a Dev account with Spotify to access their Web API (see <https://developer.spotify.com/my-applications/#!/applications>). This will give you your Client ID and Client Secret. Once you have those, you can pull your access token into R with get_spotify_access_token().

The easiest way to authenticate is to set your credentials to the System Environment variables SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET. The default arguments to get_spotify_access_token() (and all other functions in this package) will refer to those. Alternatively, you can set them manually and make sure to explicitly refer to your access token in each subsequent function call.

Sys.setenv(SPOTIFY_CLIENT_ID = 'xxxxxxxxxxxxxxxxxxxxx')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'xxxxxxxxxxxxxxxxxxxxx')

access_token <- get_spotify_access_token()

For YouTube API: 

First, get the application id and password from the Google Developer Console (see https://developers.google.com/youtube/v3/getting-started). Enable all the YouTube APIs. Then set the application id and password via the yt_oauth function. For more information about YouTube OAuth, see YouTube OAuth Guide (<https://developers.google.com/youtube/v3/guides/authentication>).

yt_oauth("app_id", "app_password")

## Examples




## License
Scripts are released under the MIT License
