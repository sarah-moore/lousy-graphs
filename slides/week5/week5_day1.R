# WEEK 5, DAY 1
# install.packages("gifski", "png", "gganimate")
packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel")
lapply(packages, require, character.only = TRUE)

hdi_df <- read.csv("https://hdr.undp.org/sites/default/files/2021-22_HDR/HDR21-22_Composite_indices_complete_time_series.csv")
names(hdi_df)

hdi_df %>% 
  select(country, region, starts_with(c("hdi_1", "hdi_2", "gni_", "gnipc", "gii"))) -> hdi_sub

hdi_sub_melt <- melt(hdi_sub, id.vars = c("country", "region"))
# View(hdi_sub_melt)

hdi_sub_melt$year <- as.numeric(str_sub(hdi_sub_melt$variable, start= -4))
unique(hdi_sub_melt$year)

hdi_sub_melt$variable <- as.character(hdi_sub_melt$variable)
hdi_sub_melt$variable <- strtrim(hdi_sub_melt$variable , nchar(hdi_sub_melt$variable)-5)

hdi_sub_melt %>%
  pivot_wider(names_from = variable) -> hdi_gni_wide

hdi_gni_wide %>%
  mutate(median_gni = if_else(hdi_gni_wide$gnipc > median(hdi_gni_wide$gnipc, 
                                                          na.rm = T), 1, 0), 
         median_gii = if_else(hdi_gni_wide$gii > median(hdi_gni_wide$gii, 
                                                          na.rm = T), 1, 0))->hdi_gni_wide  

hdi_gni_wide %>%
  filter(!is.na(median_gni), region !="", !is.na(median_gii)) %>%
  ggplot(aes(y = hdi, x = region)) +
  geom_boxplot() + 
  facet_grid(median_gii~median_gni) + 
  ylim(0,1) 


hdi_gni_wide <- hdi_gni_wide %>%
  mutate(median_gii = recode(median_gii, 
                             "0" = "Below Median GII", 
                             "1"= "Above Median GII"), 
         
         median_gni = recode(median_gni, 
                             "0" = "Below Median GNI", 
                             "1"= "Above Median GNI"))


hdi_gni_wide %>%
  filter(!is.na(median_gni), region !="", !is.na(median_gii)) %>%
  ggplot(aes(y = hdi, x = region)) +
  geom_boxplot() + 
  facet_grid(median_gii~median_gni) + 
  ylim(0,1) + 
  labs(y = "Human Development Index (HDI)", x = "World Region", 
       title = "Human Development Index, 1990-2021 by World Region", 
       subtitle = "Differentiated by Country Observations above and below median GII and GNI")


hdi_gni_wide %>%
  filter(!is.na(median_gni), region !="", !is.na(median_gni)) %>%
  ggplot(aes(y = hdi, x = year, color = median_gni)) +
  geom_line(stat = "summary", fun = "median") +
  ylim(0,1)  + 
  annotate("label", y = 0.8 ,x = 2010, label = "Above Median GNI")+
  annotate("label", y = 0.5 ,x = 2010, label = "Below Median GNI")+ 
  facet_wrap(region~.) +
  theme(legend.position="none")+
  labs(y = "Human Development Index (HDI)", x = "World Region", 
       title = "Human Development Index, 1990-2021 by World Region", 
       subtitle = "Given GNI")


hdi_gni_wide %>%
  filter(!is.na(median_gni), region !="", !is.na(median_gni)) %>%
  ggplot(aes(y = hdi, x = year, color = median_gni)) +
  geom_line(stat = "summary", fun = "median") +
  ylim(0,1)  + 
  facet_wrap(region~.) +
  labs(y = "Human Development Index (HDI)", x = "World Region", 
       title = "Human Development Index, 1990-2021 by World Region")+ 
  scale_color_discrete(name = "Median GNI")

hdi_gni_wide %>%
  filter(region == "AS") %>%
  ggplot(aes(y = hdi, x = country, label = country)) + 
  geom_label(aes(label = country))-> p

p + transition_time(year) +
  labs(title = "Year: {frame_time}") 
