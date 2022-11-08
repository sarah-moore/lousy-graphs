
# spotifyr tutorial: https://www.rcharlie.com/spotifyr/

# install.packages(c("plotly", "spotifyr"))
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont",
              "colorspace", "sf", "rnaturalearth", "ggmap",
              "rnaturalearthdata", "paletteer", "stringr", "haven",
              "plotly", "spotifyr")

lapply(packages, require, character.only = TRUE)

#Sys.setenv(SPOTIFY_CLIENT_ID = "")
#Sys.setenv(SPOTIFY_CLIENT_SECRET = "")
access_token <- get_spotify_access_token()

playlists <- get_user_playlists("")
View(playlists)

tracks <- get_playlist_tracks("4IjJzasm799xpJ1ihwOUEA")
features <- get_track_audio_features(tracks$track.id)
names(tracks)
names(features)
left_join(tracks, features, by = c("track.uri" = "uri"))->playlist_data

write_rds(playlist_data, "data/baila_playlist.rds")
