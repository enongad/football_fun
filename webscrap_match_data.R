
setwd("/Users/fabiand/Documents/GitHub/football_fun/")

library(rvest)
library(XML)
library(RCurl)


teams <- c("adelaide","brisbane","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
            "gws","hawthorn","melbourne","north melbourne","port adelaide","richmond","stkilda","sydney","westcoast","bulldogs")

# the strings used in the website address, note some times have differences i.e. brisbane and bulldogs
site_teams <- c("adelaide","brisbanel","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
            "gws","hawthorn","melbourne","kangaroos","padelaide","richmond","stkilda","swans","westcoast","bullldogs")

#### Function required to append many datasets from a list
AppendMe <- function(dfNames) {
    do.call(rbind, lapply(dfNames, function(x) {
        cbind(get(x))
    }))
}



years <- c(2017,2016)
for(j in 1:18){
            for(i in 1:length(years)){
                        table <- 2018 - years[i]
                        ### certify url
                        URL <- getURL(paste0("https://afltables.com/afl/teams/",site_teams[j],"/allgames.html"))
                        x1<-readHTMLTable(URL,which=table)
                        x1$team <- teams[j]
                        assign(paste0(teams[j],"_",years[i]),x1)
            }
cat(paste0(teams[j],"-DONE \n"))
}
teams_2016 <- paste0(teams,"_2016")
afl_2016_matches <- AppendMe(teams_2016)
teams_2017 <- paste0(teams,"_2017")
afl_2017_matches <- AppendMe(teams_2017)
