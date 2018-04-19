
setwd("/Users/fabiand/Documents/GitHub/football_fun/")

library(dplyr)
library(plotly)
load("afl2014.RData")
load("afl2015.RData")
load("afl2016.RData")
load("afl2017.RData")

afl <- rbind(afl2014,afl2015,afl2016,afl2017)
afl <- afl[afl$round != "Tot",]
afl$fantasy <- with(afl,kicks*3 + marks*3 + handballs*2 + tackles*4 +
  ff - fa*3 + hitouts + goals*6 + behinds)
player_cons <- afl %>% group_by(Player, year) %>%
            summarise(mean = mean(fantasy),sd=sd(fantasy),n = n())%>%
              filter(n>8)%>%
                mutate(SE = sd / sqrt(n))

centres <- player_cons %>% group_by(Player)%>%
                summarise(centre_mean = mean(mean),centre_sd=mean(sd)) 



p <- plot_ly(player_cons,x=~SE,y=~mean,mode = 'markers',type="scatter",text = ~paste(Player,year),color=~factor(year))
htmlwidgets::saveWidget(as_widget(p),"plot.html")
