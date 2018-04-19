library(dplyr)
        
load("../data/afl_date.Rdata")

all_years = rbind(afl2014,afl2015,afl2016,afl2017)

all_years_matches = all_years %>% group_by(team,round,year) %>% summarise(
  disposals = sum(disposals),
  kicks = sum(kicks),
  marks = sum(marks),
  handballs = sum(handballs),
  goals = sum(goals),
  behinds = sum(behinds),
  hitouts = sum(hitouts),
  tackles = sum(tackles),
  rebounds = sum(rebounds),
  in50 = sum(inside50),
  clearances = sum(clearances),
  clangers = sum(clangers),
  ff = sum(ff),
  fa = sum(fa),
  con_pos = sum(con_pos),
  uncon_pos = sum(uncon_pos),
  con_mark = sum(con_mark),
  mark_in50 = sum(mark_in50),
  oneper = sum(oneper),
  bounces = sum(bounces),
  ga = sum(ga)
) %>%
  filter(
    round %in% paste0("R",seq(1:23))
  )  %>%
  mutate(
    score = 6*goals + behinds,
    points_per_in50 = score/in50,
    score_per_in50 = (goals+behinds)/in50,
    kicks_per_point = kicks/score,
    Round = as.numeric(substr(round,2,3)),
    score_eff = goals/(goals+behinds)
  ) 


all_years_matches = all_years_matches[with(all_years_matches,order(team,year,Round)),]

teams <- c("adelaide","brisbane","carlton","collingwood","essendon","fremantle","geelong","goldcoast",
           "gws","hawthorn","melbourne","north melbourne","port adelaide","richmond","stkilda","sydney","westcoast","bulldogs")



last_x_games = 5
for(i in 1:18){
  temp = NA
  temp = all_years_matches[all_years_matches$team == "westcoast",]
  temp = temp[with(temp,order(team,year,Round)),]
  
    for(j in 1:length(temp$team)){
      start= pmax(1,j-last_x_games)
      
      temp$av_kicks[j] = mean(temp$kicks[start:j])
      temp$av_hb[j] = mean(temp$handballs[start:j])
      temp$av_in50[j] = mean(temp$in50[start:j])
      temp$av_score[j] = mean(temp$goals[start:j])
      temp$av_score_eff[j] = mean(temp$score_eff[start:j])
      
    }
  
}




getwd()
save(all_years_matches, file = "../data/team_match_data.Rdata")

