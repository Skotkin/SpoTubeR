
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/logo.png" align="right" height="139" alt="" />

# SpoTubeR

<!-- badges: start -->

<!-- badges: end -->

SpoTubeR is a package which combines data from the R wrappers spotifyr
and tuber to match a given Spotify song with an associated YouTube music
video. When given a Spotify song or YouTube Music video, SpoTubeR
generates a ‘match score’ equating to its confidence that the songs are
a match. SpoTubeR can also be used to explore compelling questions about
how songs across different artists and associated with different record
labels may generate more or less popular music videos on YouTube in
comparison with the song’s popularity on Spotify.

## Installation

You can install the development version of SpoTubeR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Skotkin/SpoTubeR")
```

## Authentication

Users must create a Spotify API (only available on Premium accounts) and
a YouTube API, then authenticate with the \[auth_creds()\] function,
before they can use the other functions provided.

Example:

``` r
library(SpoTubeR)

#auth_creds(spotify_id = "YOUR ID HERE", spotify_secret = "YOUR SECRET HERE", yt_key = "YOUR SECRET HERE")
```

## SpoTubeR Function Example

This is a basic example of a SpoTubeR function and its output:

``` r
library(SpoTubeR)

spotify_artist_comp('https://open.spotify.com/artist/6BRxQ8cD3eqnrVj6WKDok8?si=eS8ItlNFTtmtUOE5z5WwbA')
#> Retrieving Spotify statistics associated with Ella Langley and matching their top songs to YouTube videos.
#> Retrieving YouTube subscriber count associated with Ella Langley - Topic.
#> [[1]]
#> [[1]]$`Artist's Spotify popularity score (0-100)`
#> [1] 89
#> 
#> [[1]]$`Artist's Spotify follower count`
#> [1] 1499627
#> 
#> [[1]]$`Artist's YouTube channel subscriber count`
#> [1] 2610
#> 
#> 
#> $`Artist's top Spotify songs`
#>                                        song_name spotify_popularity_score
#> 1                                 Choosin' Texas                       87
#> 2                                         Be Her                       84
#> 3                           weren't for the wind                       88
#> 4             Hell At Night (feat. Ella Langley)                       83
#> 5                              Loving Life Again                       81
#> 6                           Bottom Of Your Boots                       85
#> 7                                      Dandelion                       80
#> 8  you look like you love me (feat. Riley Green)                       82
#> 9                       I Can't Love You Anymore                       74
#> 10                      Country Boy's Dream Girl                       82
#>    youtube_view_count match_confidence_score spotify_popularity_rank
#> 1             2141375                      8                       2
#> 2             5520370                      6                       4
#> 3            18394422                      7                       1
#> 4             5935452                      7                       5
#> 5              463974                      8                       8
#> 6             1241933                      8                       3
#> 7             3667929                      8                       9
#> 8            19435154                      7                       6
#> 9             1699509                      7                      10
#> 10            5095740                      4                       6
#>    youtube_views_rank
#> 1                   6
#> 2                   2
#> 3                   8
#> 4                   1
#> 5                   4
#> 6                  10
#> 7                   5
#> 8                   7
#> 9                   9
#> 10                  3
```

## License

Scripts are released under the MIT License

## Authors

Made by Úna Gogstetter and Samantha Kotkin
