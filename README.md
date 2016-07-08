# TweetAnalysis
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
mach_tweets = searchTwitteR("@realDonaldTrump", n=500, lang="en")
mach_text = sapply(mach_tweets, function(x) x$getText())
mach_text <- iconv(mach_text,to="utf-8-mac")
# create a corpus
mach_corpus = Corpus(VectorSource(mach_text))

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(mach_corpus,
                         control = list(removePunctuation = TRUE,
                                        stopwords = c("hilaryclinton", "hilary", stopwords("english")),
                                        removeNumbers = TRUE, tolower = TRUE))
# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

# save the image in png format
png("MachineLearningCloud.png", width=12, height=8, units="in", res=300)
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()

