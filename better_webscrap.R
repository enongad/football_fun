library(rvest)
library(XML)
library(RCurl)
library(reshape2)

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


for(year in 2015:2018){
  #### team level of the for loop
  
  for(j in 1:18){
   
    url <- paste0("https://afltables.com/afl/stats/teams/",site_teams[j],"/",year,"_gbg.html")
    
    webpage = read_html(url)
    
    ### loop through all statistics
    for(i in 1:23){
      
      
      raw_stat_table =  webpage %>%
        html_nodes("table") %>%
        .[i] %>%
        html_table(fill = TRUE) %>% as.data.frame()
      n = nrow(raw_stat_table)
      
      stat_table = raw_stat_table[2:n,]
      names(stat_table) = raw_stat_table[1,]
      # stat_table = stat_table[!is.na(stat_table)]
      
      long_stats <- melt(stat_table,id="Player")
      long_stats$value = as.numeric(long_stats$value)
      long_stats <- long_stats[!is.na(long_stats$value),]
      
      colnames(long_stats)[2:3] <- c("round",statistics[i])
      
      if(i == 1){
        assign(teams[j], long_stats)
      } else{
        assign(teams[j],merge(x=get(teams[j]),y=long_stats,by=c("Player","round"),all.x = T))
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
  # do.call(save, list(paste0("afl",year), file=paste0("../data/afl",year,".RData"))) 
  write.csv(afl, file=paste0('players_statistics_',year,".csv"),row.names = F)
  
  cat(paste("#######",year,"done\n"))
  
}


# save(afl2017,afl2016,afl2015,afl2014,file="../data/afl_date.Rdata")
