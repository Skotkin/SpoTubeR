
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

For Spotify API:

First, set up a Dev account with Spotify to access their Web API (see
<https://developer.spotify.com/my-applications/#!/applications>). This
will give you your Client ID and Client Secret. Once you have those, you
can pull your access token into R with get_spotify_access_token().

The easiest way to authenticate is to set your credentials to the System
Environment variables SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET. The
default arguments to get_spotify_access_token() (and all other functions
in this package) will refer to those. Alternatively, you can set them
manually and make sure to explicitly refer to your access token in each
subsequent function call.

Sys.setenv(SPOTIFY_CLIENT_ID = ‘xxxxxxxxxxxxxxxxxxxxx’)
Sys.setenv(SPOTIFY_CLIENT_SECRET = ‘xxxxxxxxxxxxxxxxxxxxx’)

access_token \<- get_spotify_access_token()

For YouTube API:

First, get the application id and password from the Google Developer
Console (see
<https://developers.google.com/youtube/v3/getting-started>). Enable all
the YouTube APIs. Then set the application id and password via the
yt_oauth function. For more information about YouTube OAuth, see YouTube
OAuth Guide
(<https://developers.google.com/youtube/v3/guides/authentication>).

yt_oauth(“app_id”, “app_password”)

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SpoTubeR)
## basic example code
```

## License

Scripts are released under the MIT License

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
