library(devtools)
library(base64enc)
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
access_secret <- "Q9Ffm3kqA0jAPRmRr7Zx7JVn6CVGs3JWAcy7goKd6DpDd"
access_token <- "118661137-MEEOMLCxrW78thUZI4aUbOB9ClIoCkJd5tNi1inx"
consumer_key <- "OTtYUrhzqnlun94VLjIYnjNA0"
consumer_secret <- "cCcxkccanlTxOmQ2lsgOoBfxGYT0gS1eHVlVxJnEW6cWOljqTV"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
trump_tweets = userTimeline("realDonaldTrump", n=150)
trump_tweets.df <- twListToDF(trump_tweets) 
dim(trump_tweets.df)
for (i in c(1:3, 150)) {
  cat(paste0("[",i,"]"))
  writeLines(strwrap(trump_tweets.df$text[i],60))
}
myCorpus <- Corpus(VectorSource(trump_tweets.df$text))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
removeUrls <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeUrls))
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*","", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
