Our package, SpoTubeR, will attempt to match Spotify and YouTube song data, then compare Spotify song characteristics with YouTube music video characteristics (e.g. number of plays). Thus, we will explore compelling questions about how a song may be matched between Spotify and YouTube using Spotify API data (retrieved through the spotifyr package) and YouTube API data (retrieved through the tuber package), generating match scores to provide the confidence with which a song is matched between Spotify and YouTube. We will also explore compelling questions about how songs across different genres, by different artists, associated with different record labels, or released on different years may generate more or less popular music videos on YouTube in comparison with the song's popularity on Spotify.

Our package will be helpful for people learning to use R who are interested in music and wanting to explore data relevant to this interest. It will also be useful for more serious scholars of music data science, those who want to explore user engagement with different platforms, and music industry executives interested in evaluating the success of different music videos. Finally, SpoTubeR could be inspiring for those developing match algorithms similar to our algorthm matching YouTube music videos with their corresponding Spotify songs.

Outline:

match_yt_song() - This function will take a YouTube music video URL as an argument and return its most likely corresponding Spotify song URL, a match confidence score representing SpoTubeR's confidence in the accuracy of the match, and the song's number of views on YouTube and plays on Spotify.

match_spotify_song() - This function will take a Spotify song URL as an argument and return its most likely corresponding YouTube music video URL, a match confidence score representing SpoTubeR's confidence in the accuracy of the match, and the song's number of views on YouTube and plays on Spotify.

genre_comp() - This function will compare number of plays on Spotify for songs in the user-provided genre with number of YouTube music video views for songs in that genre.

artist_comp() - This function will compare number of plays on Spotify for songs by the user-provided artist with number of YouTube music video views for songs by that artist.

label_comp() - This function will compare number of plays on Spotify for songs by the user-provided record label, or songs not associated with a record label, with number of YouTube music video views for songs with the same record label (or also unassociated with a label).

year_comp() - This function will compare number of plays on Spotify for songs released in the user-provided year with number of YouTube music video views for songs released in that year.

Jericho's feedback: I think the theme to this package is great... as someone who enjoys music myself! The APIs will be the biggest initial hurdle, but once you're able to access the data from both sources successfully, then all of those functions you've described will need to be fleshed out. For the comp() functions, it's possible you might have them displayed in some sort of table (through the use of some tidyr functions inside your functions.) It might be interesting to look at the play counts of these songs over time, if that variable does exist. 

I think there's a lot of potential with this package, and the functions you've specified are a good start. You are all good to continue!
