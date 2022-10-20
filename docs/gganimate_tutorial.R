packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont")
lapply(packages, require, character.only = TRUE)


bigfoot <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv")
bigfoot$year <- year(bigfoot$date)
bigfoot$month<- month(bigfoot$date, label = T, abbr = F)

bigfoot %>%
  group_by(year) %>%
  count() %>%
  arrange(desc(n))-> obs_time 

obs_time %>% 
  filter(!is.na(year), year > 1950) %>%
  ggplot(aes(x = year, y = n, group = year)) +
  geom_line(aes(group = 1), color = "#27221FFF") +
  labs(x = "Year of Report", 
       y = "Number of Reported Sightings", 
       title = "Reported Sightings of Bigfoot, 1950-2021") +
  scale_x_continuous(breaks = c(seq(1950, 2020, 10))) + 
  theme(panel.background = element_rect(fill = "#EADAC5FF", 
                                        color = "#6A6A54FF"), 
        text = element_text(family = "Georgia", 
                            color = "#8F5144FF", face = "bold"), 
        rect = element_rect(fill = "#C9AA82FF")) -> plot_time


plot_time + transition_reveal(year)-> transition_plot

anim_save("images/transition_plot", transition_plot)
