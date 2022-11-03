# WEEK 7, DAY 2 
# Putting things all together 

# load in all the packages that we probably want
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont",
              "colorspace", "sf", "rnaturalearth", "ggmap",
              "rnaturalearthdata", "paletteer", "stringr", "haven", "sp")

lapply(packages, require, character.only = TRUE)

# necessary to have access to the fonts we might want to use
loadfonts(device = "all")

# load in the ACLED Data 
# subset of East and Southeast Asian countries from 2010-2020
acled_asia <- read_csv("https://raw.githubusercontent.com/sarah-moore/lousy-graphs/main/data/20102020_ACLED_Asia2.csv")

# want to import only these countries for our map 
countries_acled <- unique(acled_asia$country)

# specify the map that we want to call
continent_asia <- ne_countries(country = print(countries_acled), returnclass = "sf")
# unique_map <- unique(continent_asia$geounit)

# can append this data if we want to add labels 
#asia_continent <- cbind(asia_continent, st_coordinates(st_centroid(asia_continent$geometry)))

# let's just take a look at the map that we specified: 

ggplot(data = continent_asia)+ 
  geom_sf(aes()) + 
  theme(
    panel.background = element_blank()
  )

#### Explore the ACLED Dataset, what are we working with? 

dim(acled_asia) # 71,053 events over 31 total observations of those events 

names(acled_asia) # var names 

unique(acled_asia$year) # 2010-2020

unique(acled_asia$event_type) # 6 different types of events 

# See the frequency of each event type per year, call this acled_asia_events
#acled_asia %>%
#  group_by(year, event_type) %>% 
#  count() -> acled_asia_events

# Create a line graph of each type of violent event over 2010-2020 
#acled_asia_events %>%
#  ggplot(aes(x = factor(year), y = n, 
#             color = event_type, group = event_type)) +
#  geom_line(stat='identity') + 
#  scale_color_paletteer_d("palettetown::charizard", 
#                          name = "Event Type") +
#  labs(y = "Frequency", x = "Year", 
#       title = "Frequency of Contentious or Violent Political Events, 2010-2020", 
#       subtitle = "East and Southeast Asia")


# Now try to do the same thing, but with regard to the frequency of total events per country, 
# and facet by region (East Asia v. SE Asia)
# I've set up the basis of the code, you should just put in the var names
# also choose a different palette you like, remember you can preview the palettes by just looking through these: 
#paletteer_d() # discrete var
#paletteer_c() # continuous var

#acled_asia %>%
#  group_by(#hint: you need three variables here to deal with the facet) %>% 
#  count() -> acled_country_events
#
#acled_country_events %>%
#  ggplot(aes(x = factor(), y = , 
#             color = , group = )) + 
#  geom_line(stat='identity') + 
#  facet_wrap(~) +  
#  scale_color_paletteer_d("", 
#                          name = "")
#  labs(x = "Year", y = "Number of Events", 
#       title = "Frequency of Contentious or Violent Political Events, 2010-2020", 
#       subtitle = "East and Southeast Asia")

# what is something you notices about the available data?? 

######

# create a bubble-line graph of the ratio of fatal events in Indonesia over time
#acled_asia %>% 
#    mutate(fatalities_bin = if_else(fatalities >= 1, 1, 0)) %>%
#    group_by() %>%
#    summarize(sum_events = n(),
#           ratio_fatal = sum()/n())-> acled_asia_fatal


#acled_asia_fatal %>% 
#  filter() %>% 
#  ggplot(aes(x = , y = )) + 
#  geom_point(aes(size = )) + 
#  geom_line() + 
#  theme(
#    # add stuff here to make it interesting 
#  )

################
# here is where we get to the mapping stuff 

inner_join(continent_asia, acled_asia, 
           by = c("geounit" = "country")) -> acled_mapping


# let's make a plot of the number of contentious political events for 2020 

#acled_mapping %>% 
#  filter() %>%
#  group_by(geounit) %>%
#  count() %>% 
#  ggplot(aes()) + 
#  geom_sf() + 
#  # now dress it up 



# now, let's map that fatalities geospatially. 
# calculate the overall, all-time ratio of fatal/non-fatal events per country 
# then map that where the fill is indicative of the ratio 

# since I gave a lot of this start up code above, you should do this one from scratch 



# now see what the most likely type of contentious political event is for each country 

#acled_mapping %>% 
#  group_by() %>% 
#  count() -> acled_map_count

#acled_map_count <- cbind(acled_map_count, st_coordinates(st_centroid(acled_map_count$geometry)))

#acled_map_count %>%
#  group_by() %>% 
#  mutate(most_likely = 
#           if_else(
#                   )) %>% 
#  filter() %>%
#  ggplot(aes(fill = )) + 
#  geom_sf(alpha = 0.85) + 
#  geom_label(#add geounit labels,
#    aes(x = X,
#        y = Y,
#        label = geounit),
#    fill = "white",
#    alpha = 0.25,
#    family ="Georgia", #change the font
#    size = 3.4,
#    hjust = 0
#  ) + 
#  scale_fill_paletteer_d("nationalparkcolors::Hawaii", name = "Event Type") +
#  theme(
#    panel.background = element_blank(), 
#    axis.ticks = element_blank(), 
#    axis.text = element_blank()
#  ) + 
#  labs(x = "", y = "")


