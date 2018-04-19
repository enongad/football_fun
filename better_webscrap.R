library(rvest)
library(XML)
library(RCurl)
library(reshape2)
  
setwd("/home/fabian/Documents/AFL_PREDICTIONS/football_fun/")
  
  #names of teams - used to label datasets and create variable "team"
teams <- c("adelaide","brisbane","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
             "gws","hawthorn","melbourne","north melbourne","port adelaide","richmond","stkilda","sydney","westcoast","bulldogs")
  
  # the strings used in the website address, note some times have differences i.e. brisbane and bulldogs
site_teams <- c("adelaide","brisbanel","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
                  "gws","hawthorn","melbourne","kangaroos","padelaide","richmond","stkilda","swans","westcoast","bullldogs")
  
statistics <- c("disposals","kicks","marks","handballs","goals","behinds","hitouts","tackles","rebounds","inside50",
                  "clearances","clangers","ff","fa","brownlow","con_pos","uncon_pos","con_mark","mark_in50","oneper",
                  "bounces","ga","play")
  
  #### Function required to append many datasets from a list
AppendMe <- function(dfNames) {
  do.call(rbind, lapply(dfNames, function(x) {
    cbind(get(x))
  }))
}
  
  
  for(year in 2014:2017){
    #### team level of the for loop

    for(j in 1:18){
    
      
      url1 <- paste0("https://afltables.com/afl/stats/teams/",site_teams[j],"/",year,"_gbg.html")
      URL <- getURL(url1)
  
    ### loop through all statistics
      for(i in 1:23){
        
        x = NA    
        x<-readHTMLTable(URL,which=i)
        xx = NA
        xx <- melt(x,id="Player")
        xx$value = as.numeric(xx$value)
        xx <- xx[!is.na(xx$value),]
    
        colnames(xx)[2:3] <- c("round",statistics[i])
    
        if(i == 1){
          assign(teams[j], xx)
        } else{
          assign(teams[j],merge(x=get(teams[j]),y=xx,by=c("Player","round"),all.x = T))
        }
        
        assign(teams[j], `[[<-`(get(teams[j]), 'team', value = teams[j]))
        
    
      }
      

    cat(paste0(teams[j],"-",year,"-DONE \n"))
  
    }
  
  afl <- AppendMe(teams)
#  afl[,c(3,5:26)] <- sapply(afl[,c(3,5:26)] ,as.numeric)
  afl$year <- year
  afl = afl[as.character(afl$round) != "Tot",]
  afl[is.na(afl)] <- 0
  assign(paste0("afl",year),afl)
  #Output
  
  do.call(save, list(paste0("afl",year), file=paste0("../data/afl",year,".RData")))
  
  cat(paste("#######",year,"done\n"))
  
}


save(afl2017,afl2016,afl2015,afl2014,file="../data/afl_date.Rdata")
