library(tidyverse)
# install.packages("extrafont")
library(extrafont)
# install.packages('showtext', dependencies = TRUE)
library(showtext)
loadfonts(device = "all")
font_files()

##############################################
# Bad Visualization Number 1 
numbers <- c(108.6, 101.7)
labels <-c("108.6M", "101.7M")
category <- c("People on Welfare", "People with a\nFull Time Job")

fox_graph <- data.frame(category, labels, numbers)

fox_graph %>%
  ggplot(aes(x = category, y = numbers, labels = labels)) +
  geom_bar(stat = "identity", fill = "yellow") +
  coord_cartesian(ylim=c(100, 110)) + 
  geom_label(aes(label = labels), size = 4, 
            hjust = -1.15, vjust = 1.4)+ 
  labs(x = "", y = "", title = "WELFARE VS. FULL TIME JOBS") + 
  theme(rect = element_rect(fill = "darkgreen"),
        panel.background = element_rect(fill = "darkgreen"),
        text = element_text(size =15, color = "yellow", 
                            family = "Impact"),
        plot.title = element_text(hjust = 0.5), 
        axis.ticks = element_blank(), 
        axis.text.y = element_blank(),
        axis.text.x = element_text(color = "white"), 
        panel.grid=element_blank())


###################################################
# Bad Visualization Number 2 

murders <- c(873, 800, 798, 800, 725, 690, 675, 625, 598,
             450, 498, 500, 550, 585, 550, 525, 750, 805, 785, 
             685, 675, 685, 721)

murders_neg <- -murders

years <- c(1990:2012)

murders_df <- data.frame(years, murders, murders_neg)

murders_df %>% 
  ggplot(aes(x = years, y = murders_neg)) + 
  geom_area(fill = "darkred", color = "black")+
  geom_point() + 
  geom_line() + 
  coord_cartesian(ylim=c(-1000, 0), 
                  xlim = c(1990, 2012)) +
  annotate(geom = "text", x = 2004, y = - 400, 
           label ="2005\nFlorida enacted\nits 'Stand Your\nGround' law", 
           hjust = 0, color = "white", size = 3) + 
  geom_segment(aes(x = 2005, y = -485, xend = 2005, yend = -513), 
               color = "white") + 
  labs(x = "", y = "", 
       title = "Gun deaths in Florida", 
       subtitle = "Number of murders committed using firearms") +
  scale_y_continuous(breaks = c(-200, -400, -600, -800, -1000), 
                     labels = c(200, 400, 600, 800, 1000)) +
  scale_x_continuous(breaks = c(1990, 1994, 2000, 2004, 2010, 2012, 2012),
                     labels = c("","1990s","","2000s","","2010s", "")) +
  theme(panel.border = element_blank(), 
        panel.background = element_rect(fill = "white"), 
        panel.grid.major.y = element_line(color = "black"), 
        panel.grid.major.x = element_blank(), 
        text = element_text(family = "sans"), 
        axis.ticks.x = element_line(color = c("white", 
                                              "white", 
                                              "black", 
                                              "white", 
                                              "black", 
                                              "white", 
                                              "white")))


###################################################
# Data Wrangling + What to do with wide data  

hdi_df <- read.csv("https://hdr.undp.org/sites/default/files/2021-22_HDR/HDR21-22_Composite_indices_complete_time_series.csv")
names(hdi_df)

# install.packages("reshape2")
library(reshape2)

hdi_df %>% 
  select(country, region, starts_with("hdi_2")) %>%
  melt(id.vars = c("country", "region")) -> hdi_long

names(hdi_long)

hdi_long %>% 
  filter(!is.na(value), region!="") %>%
  ggplot(aes(x = value, y = reorder(region, value))) + 
  geom_point(stat = "summary", fun = "mean")


# install.packages("stringr")
library(stringr)
hdi_long$year <- as.numeric(str_sub(hdi_long$variable, start= -4))

hdi_long %>% 
  filter(!is.na(value), region!="") %>%
  ggplot(aes(y = value, x = year, color = country)) + 
  geom_jitter(alpha = 0.45) + 
  facet_wrap(~region) +
  theme(legend.position = "none")


# install.packages("gridExtra")

