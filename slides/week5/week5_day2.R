# WEEK 5, DAY 2
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png")
lapply(packages, require, character.only = TRUE)

hdi_df <- read.csv("https://hdr.undp.org/sites/default/files/2021-22_HDR/HDR21-22_Composite_indices_complete_time_series.csv")
names(hdi_df)

hdi_df %>% 
  select(country, region, starts_with(c("hdi_1", "hdi_2", "gni_"))) -> hdi_sub

hdi_sub_melt <- melt(hdi_sub, id.vars = c("country", "region"))
# View(hdi_sub_melt)

hdi_sub_melt$year <- as.numeric(str_sub(hdi_sub_melt$variable, start= -4))
unique(hdi_sub_melt$year)

hdi_sub_melt$variable <- as.character(hdi_sub_melt$variable)
hdi_sub_melt$variable <- strtrim(hdi_sub_melt$variable , nchar(hdi_sub_melt$variable)-5)

hdi_sub_melt %>%
  pivot_wider(names_from = variable) -> hdi_gni_wide

hdi_gni_wide %>%
  filter(region == "AS") %>%
  ggplot(aes(x = hdi, y = country, label = country)) + 
  geom_label(aes(label = country))-> p

p + transition_time(year) +
  labs(title = "Year: {frame_time}") 



