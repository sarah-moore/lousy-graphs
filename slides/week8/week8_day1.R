# based on guidance from: 
# https://plotly-r.com/overview.html
# codebook: 
# https://www.v-dem.net/documents/1/codebookv12.pdf

# Week 8, Day 1: Interactive Visualizations 
# install.packages(c("plotly", "ggridges"))
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont",
              "colorspace", "sf", "rnaturalearth", "ggmap",
              "rnaturalearthdata", "paletteer", "stringr", "haven",
              "plotly", "ggridges")

lapply(packages, require, character.only = TRUE)

# Here we are going to use all of those visualizations we had from the Bigfoot dataset  

bigfoot <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv")
############################

ggplot(bigfoot, aes(x = season)) +
  geom_bar(fill = "#009E73") + 
  labs(y = "Number of Observations", x = "Season", 
       title = "Number of Bigfoot Observations by Season") + 
  scale_x_discrete(limits = c("Summer", "Fall", "Spring", "Winter", "Unknown")) + 
  ylim(0, 2000) + 
  theme(legend.position = "none", title = element_text(size = 9)) -> plot_bar


# add a plotly element!

ggplotly(plot_bar)
############################

bigfoot$date<- as.Date(bigfoot$date, format = "%Y-%m-%d")
bigfoot$year <- year(bigfoot$date)

bigfoot %>%
  group_by(season) %>%
  count() %>%
  mutate(percent_season = (n/dim(bigfoot)[1])*100) -> seasonal_percentage

ggplot(seasonal_percentage, aes(y = round(percent_season), x = season)) +
  geom_bar(stat = "identity", fill = "#009E73")  + 
  labs(y = "Percent of Total Observations", x = "Season", 
       title = "Percentage of Bigfoot Observations\nAccounted for by Season") + 
  scale_x_discrete(limits = c("Summer", "Fall", "Spring", "Winter", "Unknown")) + 
  ylim(0,100)+
  theme(legend.position = "none", title = element_text(size = 11))-> plot_prop 

ggplotly(plot_prop)
#######################

bigfoot %>% 
  mutate(
    # Create categories
    humidity_cat = dplyr::case_when(
      humidity <= 0.25            ~ "Low",
      humidity > 0.25 & humidity <= 0.5 ~ "Moderate",
      humidity > 0.5 & humidity <= 0.75 ~ "Medium",
      humidity > 0.75             ~ "High"
    ),
    # Convert to factor
    humidity_cat = factor(
      humidity_cat,
      level = c("Low", "Moderate", "Medium", "High")
    ), 
    cloud_cover_cat = dplyr::case_when(
      cloud_cover <= 0.25            ~ "Low",
      cloud_cover > 0.25 & cloud_cover <= 0.5 ~ "Moderate",
      cloud_cover > 0.5 & cloud_cover <= 0.75 ~ "Medium",
      cloud_cover > 0.75             ~ "High"
    ),
    # Convert to factor
    cloud_cover_cat = factor(
      cloud_cover_cat,
      level = c("Low", "Moderate", "Medium", "High")
    )
  )->bigfoot

bigfoot %>% 
  filter(!is.na(humidity_cat), !is.na(cloud_cover_cat))%>%
  group_by(humidity_cat, cloud_cover_cat) %>%
  count() %>%
  ggplot(aes(x = humidity_cat, y = , cloud_cover_cat, fill = n))+
  geom_tile() + 
  scale_fill_paletteer_c("grDevices::Temps", name = "Number of Sightings")  +
  labs(x = "Extent of Cloud Cover", 
       y = "Humidity Level", 
       title = "Cloud Cover and Humidity Given Bigfoot Sighting Frequency") +
  theme(text = element_text(family = "Didot")) -> heatmap_bigfoot

ggplotly(heatmap_bigfoot)
###############################

bigfoot %>%
  filter(season!= "Unknown") %>%
  ggplot(aes(x = uv_index, fill = season))+ 
  geom_density(alpha = 0.65) +
  scale_fill_paletteer_d("palettetown::bulbasaur", name = "Season") +
  scale_x_continuous(breaks = seq(min(bigfoot$uv_index, na.rm = T),
                                  max(bigfoot$uv_index, na.rm = T)+1, 2))+
  theme(panel.background = element_rect(color = "black")) + 
  labs(x = "Recorded UV Index at Time of Bigfoot Sighting", 
       y = "Probability Density",
       title = "UV Index Given Seasonal Sightings\nof Bigfoot, All-Time")-> uv_index_plot

ggplotly(uv_index_plot) # less useful for density plots 
###############################

bigfoot %>%
  filter(season!= "Unknown") %>%
  ggplot(aes(y = uv_index, x = season, fill = season))+ 
  geom_boxplot(alpha = 1) +
  geom_hline(yintercept = mean(bigfoot$uv_index, na.rm = T), 
             color = "black", 
             lty = "dotted", lwd = 2)+  #line type, line width 
  scale_fill_paletteer_d("lisa::FernandoBotero", name = "Season") +
  scale_y_continuous(breaks = seq(0, 13, 3) )+
  labs(y = "Recorded UV Index at\nTime of Bigfoot Sighting", 
       x = "Season of Sighting",
       title = "Distribution of Reported UV Index",
       subtitle = "Given Seasonal Sightings of Bigfoot, All-Time") + 
  scale_x_discrete(position = "top") + 
  theme(axis.text.x = element_text(size = 12), 
        panel.background = element_rect(fill = "white", color = "black"), 
        panel.grid.major = element_line(color= "tan"), 
        text = element_text(family = "Georgia"))->uv_index_box

ggplotly(uv_index_box) # especially informative? 
###############################

bigfoot %>%
  filter(season!= "Unknown", dew_point > 0) %>%
  ggplot(aes(x = dew_point, y = pressure, color = season)) +
  geom_point(alpha = 0.65) + 
  labs(y = "Atmospheric Pressure", x = "Dewpoint", 
       title = "Atmospheric Presure Given Dewpoint")+
  scale_color_paletteer_d("nationalparkcolors::Hawaii", 
                          name = "Season") -> plot_point

ggplotly(plot_point)

###############################

bigfoot %>%
  filter(season!= "Unknown", dew_point > 0) %>%
  ggplot(aes(x = dew_point, y = pressure, color = season)) +
  geom_point(alpha = 0.65) + 
  geom_smooth(color = "black") + 
  labs(y = "Atmospheric Pressure", x = "Dewpoint", 
       title = "Atmospheric Presure Given Dewpoint")+
  facet_wrap(~season)+ 
  theme(legend.position = "none")+
  scale_color_paletteer_d("nationalparkcolors::Hawaii", 
                          name = "Season") -> plot_point_2 

ggplotly(plot_point_2)
###############################

bigfoot %>% 
  group_by(state) %>%
  count() %>%
  arrange(desc(n))

bigfoot %>%
  filter(state == "Washington" |state == "California") %>%
  group_by(state) %>%
  summarize(avg_high = mean(temperature_high, na.rm = T), 
            avg_low = mean(temperature_low, na.rm = T)) %>% 
  #high temp
  ggplot(aes(x = state, y = avg_high, group = state, color = state)) +
  geom_line(aes(x = state, group = 1), color = "black") +
  #low temp 
  geom_line(aes(y = avg_low, group = 1), color = "black") +
  geom_point(aes(y = avg_low, x = state), size = 4) +
  geom_point(aes(color = state), size = 4) + 
  labs(y = "Average Temperature at Time of Sighting", x = "State", 
       title = "Comparison of Average High and Low Temperatures (F)\nAmong States with Highest All-Time Bigfoot Sightings") +
  scale_color_manual(values = c("#8092B0FF", "#BBA24CFF"), 
                     name = "State") +
  scale_x_discrete(position = "top")+
  ylim(0, 100)+ 
  annotate("label", x = "Washington", y = 68, 
           label ="Average High Temp.", 
           hjust = 0.2, color = "black", size = 4) +
  annotate("label", x = "Washington", y = 35, 
           label ="Average Low Temp.", 
           hjust = 0.2, color = "black", size = 4)+
  theme(
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank()) -> slope_graph_bigfoot 

ggplotly(slope_graph_bigfoot) # some issues with some of the functions here?

# NOW Let's try it with the vdem data 
library(vdemdata)

dim(vdem) #27,380 observations of 4170 variables 

summary(vdem$year) #1789 to 2021 

# let's filter the years only to consider the new millenia 

vdem %>%
  filter(year >= 2000)-> recent_vdem

# count of regime types, where 0 is most closed to 3 being liberal democracy 
plot_ly(recent_vdem, y = ~v2x_regime)

# let's compare the occurrence against another variable 
recent_vdem %>% 
  filter(year == 2020, !is.na(v2x_regime), !is.na(e_v2x_gender_4C))%>%
  group_by(v2x_regime, e_v2x_gender_4C) %>%
  count() %>%
  ggplot(aes(x = v2x_regime, y = , e_v2x_gender_4C, fill = n))+
  geom_tile() -> gender_regime

ggplotly(gender_regime)-> gender_plotly


# see here: 
# https://rstudio-pubs-static.s3.amazonaws.com/379188_3a2e3e316c604840a53c73151713d7a7.html
# https://pokgak.xyz/citf-graphs/

# install.packages("htmlwidgets")
library(htmlwidgets)
saveWidget(gender_plotly, "data/gender_regime.html", selfcontained = F, libdir = "lib")


### NOW INTERACTIVE MAPS 
# https://ladal.edu.au/motion.html#3_Interactive_Maps 
# https://rstudio.github.io/leaflet/map_widget.html

#install.packages("leaflet")
library(leaflet)

chicago <- leaflet() %>% 
  addTiles() %>% 
  setView(lng = -87.6298 , lat = 41.8781, zoom = 10)

chicago # a nice map of chicago 


# back to brazil voting data
 
brazil_states <-st_read("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/brazilshape/bra_admbnda_adm1_ibge_2020.shp")

brazil_mun <-st_read("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/brazilshape/bra_admbnda_adm2_ibge_2020.shp")

mg_mun_data <- read_csv2("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/votacao_2018_MG.csv",
                         locale = readr::locale(encoding = "latin1"))

names(mg_mun_data) <- tolower(names(mg_mun_data))
brazil_mun %>%
  filter(ADM1_PT == "Minas Gerais") -> mg_shape
names(mg_shape)<- tolower(names(mg_shape))

mg_shape$adm2_pt<- toupper(mg_shape$adm2_pt)

mg_mun_data %>%
  filter(ds_cargo == "Governador", nr_turno == 1) %>%
  group_by(nm_municipio, nm_partido) %>%
  summarize(sum_votes = qt_votos_nominais) %>%
  group_by(nm_municipio) %>%
  mutate(proportion_votes =
           sum_votes / sum(sum_votes, na.rm = T)) %>%
  group_by(nm_municipio) %>%
  mutate(vote_win =
           if_else(proportion_votes == max(proportion_votes, na.rm = T),
                   1, 0)) -> mg_data_first

voting_shape_mg <- inner_join(mg_shape, mg_data_first,
                                    by = c("adm2_pt"="nm_municipio"))



voting_shape_mg$popUp <-
  paste0(
    "<strong>",voting_shape_mg$adm2_pt,"</strong><br>", "First Round Winner: ", voting_shape_mg$nm_partido
    
  )

voting_shape_mg %>% 
  filter(vote_win == 1) %>%
  leaflet() %>%
  addTiles() %>%
  setView(lat = -17.9302, lng= -43.7908, zoom =6) %>%
  addPolygons(
    fillColor = ~ nm_partido,
    fillOpacity = 0.35,
    color = "white",
    weight = 1, 
    popup = ~ popUp
  )


