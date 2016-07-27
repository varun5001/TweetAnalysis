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
donald_tweets = searchTwitteR("@realDonaldTrump", n=500, lang="en")
donald_tweets_char <- sapply(donald_tweets, function(x) x$getText())
donald_tweets_corpus <- Corpus(VectorSource(donald_tweets_char))
donald_tweets_corpus <- tm_map(donald_tweets_corpus, removePunctuation)
donald_tweets_corpus <- tm_map(donald_tweets_corpus, content_transformer(tolower))
donald_tweets_corpus <- tm_map(donald_tweets_corpus, removeWords, stopwords("english"))
donald_tweets_corpus <- tm_map(donald_tweets_corpus, removeNumbers)
donald_tweets_corpus <- tm_map(donald_tweets_corpus, removeWords, c("realdonaldtrump","trump","will"))
donald_tweets_corpus <- tm_map(donald_tweets_corpus, stripWhitespace)
wordcloud(donald_tweets_corpus, random.order = F, max.words = 100, col=rainbow(100))
