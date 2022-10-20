# install.packages("paletteer", "scales", "lubridate", "ggrepel")
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont")
lapply(packages, require, character.only = TRUE)
loadfonts(device = "all")

bigfoot <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv")
############################

ggplot(bigfoot, aes(x = season)) +
  geom_bar(fill = "#009E73") + 
  labs(y = "Number of Observations", x = "Season", 
       title = "Number of Bigfoot Observations by Season") + 
  scale_x_discrete(limits = c("Summer", "Fall", "Spring", "Winter", "Unknown")) + 
  ylim(0, 2000) + 
  theme(legend.position = "none", title = element_text(size = 9)) -> plot_bar

############################

bigfoot$date<- as.Date(bigfoot$date, format = "%Y-%m-%d")
bigfoot$year <- year(bigfoot$date)

bigfoot %>%
  group_by(season) %>%
  count() %>%
  mutate(percent_season = (n/dim(bigfoot)[1])*100) -> seasonal_percentage

ggplot(seasonal_percentage, aes(y = percent_season, x = season)) +
  geom_bar(stat = "identity", fill = "#009E73")  + 
  labs(y = "Percent of Total Observations", x = "Season", 
       title = "Percentage of Bigfoot Observations\nAccounted for by Season") + 
  scale_x_discrete(limits = c("Summer", "Fall", "Spring", "Winter", "Unknown")) + 
  ylim(0,100)+
  theme(legend.position = "none", title = element_text(size = 11))-> plot_prop 

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
  ggplot(aes(x = humidity_cat, y = , cloud_cover_cat, fill = temperature_high))+
  geom_tile() + 
  scale_fill_paletteer_c("grDevices::Temps", name = "High Temperature")  +
  labs(x = "Extent of Cloud Cover", 
       y = "Humidity Level", 
       title = "Cloud Cover, Humidity, and High Temperatures\nRecorded at Time of Bigfoot Sighting") +
  theme(text = element_text(face = "bold", family = "Didot")) -> heatmap_bigfoot

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

###############################

bigfoot %>%
  filter(season!= "Unknown") %>%
  ggplot(aes(y = uv_index, x = season, fill = season))+ 
  geom_boxplot(alpha = 1) +
  geom_hline(yintercept = mean(bigfoot$uv_index, na.rm= T), 
             color = "black", 
             lty = "dotted", lwd = 2)+ 
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

###############################

bigfoot %>%
  filter(season!= "Unknown", !is.na(dew_point), dew_point > 0) %>%
  ggplot(aes(x = dew_point, y = season, fill = season))+ 
  geom_violin() +
  geom_vline(xintercept = mean(bigfoot$dew_point, na.rm = T), 
             color = "black", lwd = 1, lty = "dotted") + 
  scale_fill_paletteer_d("rockthemes::alice", name = "Season") +
  theme(panel.background = element_rect(color = "white")) + 
  labs(x = "Recorded Dew Point on Date of Bigfoot Sighting", 
       y = "Season",
       title = "Dew Point Given Seasonal Sightings of Bigfoot, All-Time") + 
  theme(panel.background = element_rect(fill = "tan", color = "black"), 
        panel.grid.major.y = element_blank(), 
        text = element_text(family = "Palatino")) 

###############################

bigfoot %>%
  filter(season!= "Unknown", dew_point > 0) %>%
  ggplot(aes(x = dew_point, y = pressure, color = season)) +
  geom_point(alpha = 0.65) + 
  labs(y = "Atmospheric Pressure", x = "Dewpoint", 
       title = "Atmospheric Presure Given Dewpoint")+
  scale_color_paletteer_d("nationalparkcolors::Hawaii", 
                          name = "Season") -> plot_point


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
    panel.grid.minor.x = element_blank())


###############################

ggpairs(bigfoot, columns = c(15:21)) 
