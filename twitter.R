install.packages('twitteR')
install.packages('tm')
install.packages('wordcloud')
install.packages('RColorBrewer')

library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

searchWord <- '#wwdc'
removedWords <- c('wwdc', 'apple')

twData <- searchTwitter(searchWord, n=200)
tw.df <- twListToDF(twData)
tw.corpus <- Corpus(DataframeSource(data.frame(tw.df$text)))
tw.corpus <- tm_map(tw.corpus, removePunctuation)
tw.corpus <- tm_map(tw.corpus, tolower)
tw.corpus <- tm_map(tw.corpus, function(x) removeWords(x, stopwords("english")))
tw.corpus <- tm_map(tw.corpus, function(x) removeWords(x, removedWords))
tdm <- TermDocumentMatrix(tw.corpus)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
pal <- brewer.pal(9, "BuGn")
pal <- pal[-(1:2)]
png("wordcloud.png", width=1280,height=800)
wordcloud(d$word,d$freq, scale=c(8,.3),min.freq=2,max.words=100, random.order=T, rot.per=.15, colors=pal, vfont=c("sans serif","plain"))
dev.off()
