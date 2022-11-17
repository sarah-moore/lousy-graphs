packages <- c("tidyverse", "reshape2", "fauxnaif", "gganimate", "ggthemes",
              "stringr", "gridExtra", "gifski", "png", "ggrepel", "scales",
              "lubridate", "paletteer", "GGally", "systemfonts", "extrafont",
              "colorspace", "sf", "rnaturalearth", "ggmap",
              "rnaturalearthdata", "paletteer", "stringr", "haven", 
              "plotly", "ggridges")

lapply(packages, require, character.only = TRUE)

loadfonts(device = "all")

# Derived from tutorials at : http://rstudio-pubs-static.s3.amazonaws.com/256588_57b585da6c054349825cba46685d8464.html
# and: https://rpubs.com/tsholliger/301914

# create a vector of just the text data 
bigfoot <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv")

sample_df <- sample(1:nrow(bigfoot), 1500)

bigfoot_sample <- bigfoot[sample_df,]

bigfoot_text <- bigfoot_sample %>%
  select(doc_id = number, text = observed)

# install new packages
# UNCOMMENT BELOW!!!!! 
# install.packages(c("qdap", "tm"), dep =T)
library(qdap)
library(tm)

# pre-processing 
bigfoot_source <- DataframeSource(bigfoot_text)
bigfoot_corpus <- VCorpus(bigfoot_source)

# let's see some terms 
frequent_bigfoot_report <- freq_terms(bigfoot_corpus)

clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, stopwords("en"))
  return(corpus)
}

# Apply your customized function
clean_corp <- clean_corpus(bigfoot_corpus)

clean_corp[[3]][1]

# create a document term matrix
bigfoot_dtm <- DocumentTermMatrix(clean_corp)
bigfoot_mat <- as.matrix(bigfoot_dtm)
dim(bigfoot_mat)

# let's get rid of some unneccessary sparseness 
bigfoot_dtm_rm_sparse <- removeSparseTerms(bigfoot_dtm, 0.85)

bigfoot_dtm_rm_sparse # take a look at the trimmed dtm matrix's features 

bigfoot_mat <- as.matrix(bigfoot_dtm_rm_sparse) # save as a matrix 

bigfoot_words_frequency <- colSums(as.matrix(bigfoot_mat)) 

findFreqTerms(bigfoot_dtm_rm_sparse, lowfreq = 100, highfreq = Inf)

dtm_bigfoot_tfidf <- DocumentTermMatrix(clean_corp, 
                                        control = list(weighting = weightTfIdf))

dtm_bigfoot_tfidf_sparse <- removeSparseTerms(dtm_bigfoot_tfidf, 0.85)

# now let's make a dataset of our terms 
library(tidytext)
df_bigfoot_terms <- tidytext::tidy(bigfoot_dtm_rm_sparse)

df_bigfoot_terms %>%
  group_by(term) %>%
  summarise(total_freq = sum(count, na.rm = T)) %>%
  filter(total_freq > 800) -> df_bigfoot_terms

ggplot(df_bigfoot_terms, aes(y = reorder(term, total_freq), x = total_freq)) +
  geom_bar(stat = "identity", alpha = .8) +
  labs()


# install the wordcloud package 
install.packages("ggwordcloud")
library(ggwordcloud)

ggplot(df_bigfoot_terms, aes(label = term, size = total_freq, color = term)) +
  geom_text_wordcloud() +
  scale_size_continuous(range=c(2,15)) 


# what's an alternative? figure out how to implement the interactive + qual!
library(leaflet)
bigfoot$new_date <- format(as.Date(bigfoot$date), "%D")

install.packages("leafletCN")

bigfoot %>%
  filter(year(date)>=2000) %>%
  leaflet() %>%
  setView(-103.4617, 44.58, zoom = 4) %>%
  addTiles() %>%
  addMarkers(~longitude, ~latitude, popup = ~paste("<b>Date:</b>", new_date, "<br>", "<b>Report</b>:", observed), 
             clusterOptions = markerClusterOptions()) 
  

library(htmlwidgets)
saveWidget(sightings_map, file = "exercises/sightings_map.html", 
           knitrOptions = c(fig.width = 6), 
           title = "Bigfoot Sightings Across the U.S., 2000-2021")
