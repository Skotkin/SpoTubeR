
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SpoTubeR

<!-- badges: start -->

<!-- badges: end -->

SpoTubeR is a package which combines data from the R wrappers spotifyr
and tuber to match a given Spotify song with an associated YouTube music
video. When given a Spotify Song or YouTube Music video, SpoTubeR
generates a ‘match score’ equating to its confidence that the songs are
a match. SpoTuber can also be used to explore compelling questions about
how songs across different genres, by different artists, associated with
different record labels, or released on different years may generate
more or less popular music videos on YouTube in comparison with the
song’s popularity on Spotify.

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

## SpoTubeR Function Example

This is a basic example of a SpoTubeR function and its output:

``` r
library(SpoTubeR)
library(knitr)
artist_comp('https://open.spotify.com/artist/6BRxQ8cD3eqnrVj6WKDok8?si=eS8ItlNFTtmtUOE5z5WwbA')
#> Retrieving Spotify statistics associated with Ella Langley and matching their top songs to YouTube videos.
#> Retrieving YouTube subscriber count associated with Ella Langley - Topic.
#> [[1]]
#> [[1]]$`Artist's Spotify popularity score (0-100)`
#> [1] 89
#> 
#> [[1]]$`Artist's Spotify follower count`
#> [1] 1438951
#> 
#> [[1]]$`Artist's YouTube channel subscriber count`
#> [1] 2610
#> 
#> 
#> $`Artist's top Spotify songs`
#>                                        song_name spotify_popularity_score
#> 1                                 Choosin' Texas                       85
#> 2                                         Be Her                       82
#> 3                           weren't for the wind                       88
#> 4             Hell At Night (feat. Ella Langley)                       82
#> 5                              Loving Life Again                       80
#> 6                                      Dandelion                       79
#> 7                           Bottom Of Your Boots                       84
#> 8  you look like you love me (feat. Riley Green)                       82
#> 9                       Country Boy's Dream Girl                       82
#> 10                       girl you're taking home                       81
#>    youtube_view_count match_confidence_score spotify_popularity_rank
#> 1             1314629                      8                       2
#> 2              496585                      8                       4
#> 3            17797245                      7                       1
#> 4             5444048                      7                       4
#> 5              327955                      8                       9
#> 6             3356652                      8                      10
#> 7              934095                      8                       3
#> 8            18856418                      7                       4
#> 9             5010778                      4                       4
#> 10            6471388                      7                       8
#>    youtube_views_rank
#> 1                  10
#> 2                   5
#> 3                   9
#> 4                   3
#> 5                   7
#> 6                   6
#> 7                   1
#> 8                   8
#> 9                   4
#> 10                  2
```

## License

Scripts are released under the MIT License
