library(rvest)
library(ggplot2)
library(dplyr)
library(scales)
library(maps)
library(magrittr)
library(plotly)

url <- "https://en.wikipedia.org/wiki/Global_Peace_Index"
country <- read_html(url)
country %<>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/    table[2]') %>%
  .[[1]] %>%
  html_table(fill = T)
str(country) # 查看数据集的基本数据结构


for(i in 2:21){
  country[,i] = gsub("%", "", country[,i])
  country[,i] = as.numeric(country[,i])
}
str(country)

names(country)
names(country) <- make.names(names(country))

colnames(country) <- c("Country", "2017_rank", "2017_score", "2016_rank", "2016_score", "2015_rank", "2015_score", "2014_rank", '2014_score', "2013_rank", "2013_score", "2012_rank", "2012_score", "2011_rank", "2011_score", "2010_rank", "2010_score", "2009_rank", "2009_score", "2008_rank", "2008_score")

country <- country[-1,]

country <- na.omit(country)
View(country)

country <- country[,c(1,3)]

world_map <- map_data("world")

map.world.joined <- left_join(world_map, country, by = c('region' = 'Country'))

a = ggplot() + 
  geom_polygon(data = map.world.joined, aes(x = long, y = lat, group = group, fill = map.world.joined$`2017_score`)) +
  labs(title = 'Global Peace Index across different country', fill = 'Global Peace Index') +
  theme(axis.text= element_blank(),
        axis.title= element_blank(),
        axis.ticks= element_blank()) +
  theme_bw()

a
ggplotly(a)
  