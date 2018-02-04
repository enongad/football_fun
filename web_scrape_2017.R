library(rvest)
library(XML)
library(RCurl)
library(reshape2)

setwd("/Users/fabiand/Documents/GitHub/football_fun/")

teams <- c("adelaide","brisbane","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
            "gws","hawthorn","melbourne","north","port","richdmond","stkilda","sydney","westcoast","bulldogs")

statistics <- c("disposals","kicks","marks","handballs","goals","behinds","hitouts","tackles","rebounds","inside50",
                "clearances","clangers","ff","fa","brownlow","con_pos","uncon_pos","con_mark","mark_in50","oneper",
                "bounces","ga","play")



#### Function required to append many datasets from a list
AppendMe <- function(dfNames) {
    do.call(rbind, lapply(dfNames, function(x) {
        cbind(get(x))
    }))
}


# year that data will be scrapped
year=2017

#### team level of the forloop
for(j in 1:18){

  url1 <- paste0("https://afltables.com/afl/stats/teams/",teams[j],"/",year,"_gbg.html"
  URL <- getURL(url1)

  for(i in 1:23){

    x<-readHTMLTable(URL,which=i)
    xx <- melt(x,id="Player")
    xx <- xx[xx$value != "",]
    colnames(xx)[2:3] <- c("round",statistics[i])

    if(i == 1){
      assign(teams[j], xx)
      } else{
        assign(teams[j],merge(x=get(teams[j]),y=xx,by=c("Player","round")))
        }

    assign(teams[j], `[[<-`(get(teams[j]), 'team', value = teams[j]))
  }

  afl <- AppendMe(teams)

}

#Output
save(afl,file=paste0("afl",year,".RData")
