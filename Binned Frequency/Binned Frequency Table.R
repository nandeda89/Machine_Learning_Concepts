# # x<-c(0.01,0.34,0.45,0.67,0.89,0.12,0.34,0.45,0.23,0.45,0.34,0.32,0.45,0.21,0.55,0.66,0.99,0.23,.012,0.34,1.2)
#
# br = seq(0,1,by=0.1)
#
# ranges = paste(head(br,-1), br[-1], sep=" - ")
# freq   = hist(x, breaks = br, include.lowest=TRUE, plot=FALSE)
#
# df1 <- data.frame(range = ranges, frequency = freq$counts)
#
# names(df1)[1] = 'gear'


path <- "F:\\Data Analytics\\R Programming\\Binned Frequency"
setwd(path)

df2 <- read.csv("sample.csv")
br <- read.csv("bin range_7.csv")

bin.range <-
    paste(head(br$bin.range, -1), br$bin.range[-1], sep = " to ")

df3 <- data.frame()
for (i in names(df2[-1]))
{
    freq   = hist(
        df2[[i]],
        breaks = br$bin.range,
        include.lowest = TRUE,
        plot = FALSE
    )
    df1 <- data.frame(range = bin.range, frequency = freq$counts)
    names(df1)[1] = i
    print(df1)
    
    if (length(df3) == 0)
    {
        df3 <- df1
    } else
    {
        df3 <- cbind(df3, "", df1)
    }
}

#Check Valid Rows
df2 <- read.csv("sample.csv", stringsAsFactors = FALSE)
head(df2)

df4 <- data.frame(Event = character(0), total= numeric(0), valid= integer(0), valid_percent = character(0))
for(i in unique(df2$Event))
{
    temp <- df2[df2$Event == i,i]
    total <- length(temp)
    valid <- sum(temp == 0)
    valid_percent = paste(round(valid/total *100,1), "%")
    
    df4 <- rbind(df4, data.frame(Event=i, total, valid, valid_percent))
}
