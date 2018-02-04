
setwd("/Users/fabiand/Documents/GitHub/football_fun/")

library(dplyr)

load("afl2014.RData")
load("afl2015.RData")
load("afl2016.RData")
load("afl2017.RData")

afl <- rbind(afl2014,afl2015,afl2016,afl2017)

player_cons <- 
