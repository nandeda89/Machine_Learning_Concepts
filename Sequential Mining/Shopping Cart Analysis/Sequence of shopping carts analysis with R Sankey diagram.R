#Sequence of shopping carts in-depth analysis with R - Sankey diagram

# loading libraries
library(googleVis)
library(dplyr)
library(reshape2)

# creating an example of orders
set.seed(15)
df <- data.frame(orderId=c(1:1000),
                 clientId=sample(c(1:300), 1000, replace=TRUE),
                 prod1=sample(c('NULL','a'), 1000, replace=TRUE, prob=c(0.15, 0.5)),
                 prod2=sample(c('NULL','b'), 1000, replace=TRUE, prob=c(0.15, 0.3)),
                 prod3=sample(c('NULL','c'), 1000, replace=TRUE, prob=c(0.15, 0.2)))

# combining products
df$cart <- paste(df$prod1, df$prod2, df$prod3, sep=';')
df$cart <- gsub('NULL;|;NULL', '', df$cart)
df <- df[df$cart!='NULL', ]

df <- df %>%
  select(orderId, clientId, cart) %>%
  arrange(clientId, orderId, cart)

orders <- df %>%
  group_by(clientId) %>%
  mutate(n.ord = paste('ord', c(1:n()), sep='')) %>%
  ungroup()

orders <- dcast(orders, clientId ~ n.ord, value.var='cart', fun.aggregate = NULL)

orders <- orders %>%
  select(ord1, ord2, ord3, ord4, ord5)

orders.plot <- data.frame()

for (i in 2:ncol(orders)) {
  
  ord.cache <- orders %>%
    group_by(orders[ , i-1], orders[ , i]) %>%
    summarise(n=n()) %>%
    ungroup()
  
  colnames(ord.cache)[1:2] <- c('from', 'to')
  
  # adding tags to carts
  ord.cache$from <- paste(ord.cache$from, '(', i-1, ')', sep='')
  ord.cache$to <- paste(ord.cache$to, '(', i, ')', sep='')
  
  orders.plot <- rbind(orders.plot, ord.cache)
  
}

plot(gvisSankey(orders.plot, from='from', to='to', weight='n',
                options=list(height=900, width=1800, sankey="{link:{color:{fill:'lightblue'}}}")))

