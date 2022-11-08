library(remotes)

install.packages("rgdal", configure.args = c("--with-proj-lib=/usr/local/lib/", "--with-proj-include=/usr/local/include/"))

install_github("r-spatial/sf", configure.args = "--with-proj-lib=/usr/local/lib/")

install.packages(c("rnaturalearth", "ggmap", "rnaturalearthdata"))

packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont",
              "colorspace", "sf", "rnaturalearth", "ggmap",
              "rnaturalearthdata", "paletteer", "stringr", "haven")

lapply(packages, require, character.only = TRUE)

loadfonts(device = "all")

# look at at all the countries 

world<- ne_countries(scale = "medium", returnclass = "sf")
ggplot(data = world)+
  geom_sf()-> world_map

world_map

# can add variables to map 

world$economy_c <- as.numeric(str_sub(world$economy, end= 2))

world$economy_c <- abs(world$economy_c-8)

ggplot(data = world, aes(fill = economy_c))+
   geom_sf(color = "black", lwd= 0.2) +
   scale_fill_gradient(low = "orange", high = "darkgreen",
                          name ="Economic Development",
                       breaks = c(1, 4, 7),
                       labels = c("Low", "Moderate",
                                  "High")) +
   theme(
     panel.background = element_rect(fill = "white"),
     legend.position = "bottom",
     legend.title = element_text(size = 8)
   ) +
   labs(title = "Economic Development Across the World")-> econ_world

econ_world

# can choose solo countries or other geounits
brazil <- ne_countries(geounit = "brazil", returnclass = "sf")

ggplot(data = brazil)+
  geom_sf(fill = "#19AE47") +
  annotate('text', x = -50, y = -12,
           label = "BRAZIL", size = 8, family = "mono") +
  theme(
    axis.text = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank()
  ) +
  labs(x = "", y = "")->brazil_solo


brazil_solo

# can highlight places in their context 
s_america <- ne_countries(continent = "south america", returnclass = "sf")
 
s_america$brazil <- if_else(s_america$geounit == "Brazil", 1, 0)
 
ggplot(data = s_america, aes(fill = as_factor(brazil)))+
   geom_sf() +
   scale_fill_manual(values = c("lightgrey", "#19AE47")) +
   annotate('text', x = -50, y = -12,
            label = "Brazil", size = 4, family = "serif") +
   theme(
     axis.text = element_blank(),
     panel.background = element_blank(),
     axis.ticks = element_blank(),
     legend.position = "none"
   ) +
   labs(x = "", y = "") -> s_america_gg
 
s_america_gg

# import brazil shape files 
setwd("")
brazil_states <-st_read("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/brazilshape/bra_admbnda_adm1_ibge_2020.shp")

brazil_mun <-st_read("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/brazilshape/bra_admbnda_adm2_ibge_2020.shp")

mg_mun_data <- read_csv2("~/Library/CloudStorage/OneDrive-NorthwesternUniversity/Teaching_RA/2022_Fall_DataViz/lousy-graphs/data/votacao_2018_MG.csv",
                                locale = readr::locale(encoding = "latin1"))


ggplot(data = brazil_states)+
  geom_sf() -> brazil_states

brazil_states

###
# change some metadata to make it easier 
names(mg_mun_data) <- tolower(names(mg_mun_data))

# take the voting data, filter it, do some transformations
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


brazil_mun %>%
   filter(ADM1_PT == "Minas Gerais") -> mg_shape
 names(mg_shape)<- tolower(names(mg_shape))

mg_shape$adm2_pt<- toupper(mg_shape$adm2_pt)
 
# check to see which municipalities might not match
mg_shape_mun<- unique(mg_shape$adm2_pt)
mg_elections_mun<- unique(mg_data_first$nm_municipio)
 
which(mg_shape_mun %in% mg_elections_mun) # all of them match!


voting_shape_mg_first <- inner_join(mg_shape, mg_data_first,
                                    by = c("adm2_pt"="nm_municipio"))

voting_shape_mg_first %>%
  filter(vote_win == 1) %>%
  ggplot(aes(fill = nm_partido))+
   geom_sf(lwd = 0.05, color = "black") +
   scale_fill_manual(name ="Candidate Party",
                       values = c("#009c3b","darkblue", "red", "orange", "#4fb9af")) +
   theme(
     axis.text = element_blank(),
     panel.background = element_blank(),
     axis.ticks = element_blank(),
     text = element_text(family = "Palatino"), 
     legend.text = element_text(size = 6), 
     legend.title = element_text(size = 6)
   ) +
   labs(title = "Brazilian Gubernatorial Elections, 2018",
          subtitle = "Winning Party at the Municipal Level") ->mg_first_round
 
mg_first_round


# so who won the whole state in the first round ?

mg_mun_data %>%
 filter(ds_cargo == "Governador", nr_turno == 1) %>%
 group_by(nm_partido) %>%
 summarize(total_party = sum(qt_votos_nominais)/9687247) %>%
 mutate(winner_first = if_else(total_party== max(total_party,
                                                 na.rm = T),
                               1,0))-> first_round_winner

ggplot(data = mg_shape)+
  geom_sf(lwd = 0.05,
          fill = "orange", color = "orange") +
  theme(
    axis.text = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    text = element_text(family = "Palatino")
  ) +
  annotate("text", x = -44, y = -18,
           label ="Minas Gerais\nPartido Novo",
           family = "Palatino") +
  labs(subtitle = "First Round Voting, Lead Candidate",
       x = '', y = '') ->mg_lead_first_round

mg_lead_first_round

# do some data manipulation and transformation
mg_mun_data %>%
  filter(ds_cargo == "Governador", nr_turno == 2) %>%
  group_by(nm_municipio, nm_partido) %>%
  summarize(sum_votes = qt_votos_nominais) %>%
  group_by(nm_municipio) %>%
  mutate(proportion_votes =
           sum_votes / sum(sum_votes, na.rm = T)) %>%
    group_by(nm_municipio) %>%
  mutate(vote_win =
           if_else(proportion_votes == max(proportion_votes, na.rm = T),
                   1, 0))-> mg_second_round


voting_shape_mg2 <- inner_join(mg_shape, mg_second_round, by = c("adm2_pt"="nm_municipio"))

voting_shape_mg2 %>%
  filter(vote_win == 1) %>%
  ggplot(aes(fill = nm_partido))+
  geom_sf(lwd = 0.05, color = "black") +
  scale_fill_manual(name = "Candidate Party",
                    values = c("orange", "darkblue"))+
  theme(
    axis.text = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    text = element_text(family = "Palatino")
  ) +
  ggtitle("Minas Gerais Electoral Results 2018: Governor",
          subtitle = "Winning Party at the Municipal Level, Runoff") -> mg_runoff

mg_runoff

# ggmap of santa fe, nm 

sfmap <- "santa fe"
qmap(sfmap, source = "stamen", zoom = 15)-> santa_fe

santa_fe

# let's try a different type of map 

mgmap <- "minas gerais"
qmap(mgmap, source = "google")

# and another of the same-ish place 
mgmap_map <- get_googlemap('belo horizonte', zoom = 6,
                           maptype = "roadmap")

ggmap(mgmap_map, extent = 'device')-> minas_gerais

minas_gerais
