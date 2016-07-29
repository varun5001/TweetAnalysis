library(twitteR)
library(tm)
library(ggplot2)

hillary_tweets <- userTimeline("HillaryClinton", n=1500)
donald_tweets <- userTimeline("realDonaldTrump", n=1500)

hillary_txt <- sapply(hillary_tweets, function(x) x$getText())
donald_txt <- sapply(donald_tweets, function(x) x$getText())

clean_data <- function(data){
  #data <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", data)
  data <- tm_map(data, removePunctuation)
  data <- tm_map(data, content_transformer(tolower))
  data <- tm_map(data, removeNumbers)
  data <- tm_map(data, removeWords, stopwords("english"))
  data <- tm_map(data, stripWhitespace)
  return(data)
}

tweets_corpus <-  Corpus(VectorSource(c(hillary_txt,donald_txt)))
tweets_corpus <- clean_data(tweets_corpus)

tdm <- TermDocumentMatrix(tweets_corpus)

tweets_df <- as.data.frame(inspect(tdm))
names(tweets_df) <- c("hillary.txt", "donald.txt")

tweets_df <- subset(tweets_df, hillary.txt>2 & donald.txt>2)

tweets_df$freq.dif = tweets_df$hillary.txt - tweets_df$donald.txt

hillary_df <- subset(tweets_df, freq.dif > 0)

donald_df <- subset(tweets_df, freq.dif < 0)

both_df <- subset(tweets_df, freq.dif == 0)

optimal.spacing <- function(spaces)
{
  if(spaces > 1) {
    spacing <- 1 / spaces
    if(spaces%%2 > 0) {
      lim = spacing * floor(spaces/2)
      return(seq(-lim, lim, spacing))
    }
    else {
      lim = spacing * (spaces-1)
      return(seq(-lim, lim, spacing*2))
    }
  }
  else {
    # add some jitter when 0
    return(jitter(0, amount=0.2))
  }
}

hillary_spacing <- sapply(table(hillary_df$freq.dif),
function(x) optimal.spacing(x))

donald_spacing <- sapply(table(donald_df$freq.dif), function(x) optimal.spacing)

both_spacing <- sapply(table(both_df$freq.dif), function(x) optimal.spacing)

hillary_optim = rep(0, nrow(donald_df))
for(n in names(hillary_spacing)){
  hillary_optim[hillary_df$freq.dif == as.numeric(n)] <- hillary_spacing[[n]]
}
hillary_df = transform(hillary_df, Spacing=hillary_optim)

donald_optim <- rep(0, nrow(donald_df))
for(n in names(donald_spacing)){
  donald_optim[donald_df$freq.dif == as.numeric(n)] <- donald_spacing[[n]]
}
donald_df = transform(donald_df, Spacing=donald_optim)
both_df$Spacing = as.vector(both_spacing)
                         
ggplot(hillary_df, aes(x=freq.dif, y=Spacing)) +
  geom_text(aes(size=hillary.txt, label=row.names(hillary_df), colour=freq.dif), alpha=0.7, family='Times')
