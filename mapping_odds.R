# mapping to betfair data.
library(XLConnect)
library(tidyr)
library(dplyr)

# Load submission workbook
file_name <- "kenji_ball_submission1.xlsx"
sheet_name <- "mapping"
workbook <- loadWorkbook(file_name, create = FALSE)
worksheet <- readWorksheet(workbook, sheet_name, header = TRUE)

# Run a refresh of Odds Data
source("get_odds_api.R")

# map odds to worksheet
joined_data <- inner_join(worksheet,odds_data)

# Spread and Bind data in order to have One match per line
event_df <- unique(data.frame(joined_data$event_id, joined_data$match_id, joined_data$date ))

price_amt_df <-  data.frame(joined_data$event_id,joined_data$team, joined_data$price_amt) %>%
  spread(joined_data.team,joined_data.price_amt)

price_mvmt_df <- data.frame(joined_data$event_id,joined_data$team, joined_data$price_mvmt) %>%
  spread(joined_data.team,joined_data.price_mvmt) 
  
names_df <-  data.frame(joined_data$event_id,joined_data$team, joined_data$selection_name) %>%
  spread(joined_data.team,joined_data.selection_name) 

selectionid_df <-  data.frame(joined_data$event_id,joined_data$team, joined_data$selectionId) %>%
  spread(joined_data.team,joined_data.selectionId) 

match_data <- inner_join(event_df,names_df) %>%
                inner_join(selectionid_df, by = c("joined_data.event_id")) %>%
                inner_join(price_amt_df, by = c("joined_data.event_id")) %>%
                inner_join(price_mvmt_df, by = c("joined_data.event_id"))

names(match_data) <- c("event_id","match_id","date"
                     ,"name_draw","name_team1","name_team2"
                     ,"id_draw","id_team1","id_team2"
                     ,"price_draw","price_team1","price_team2"
                     ,"price_mvt_draw","price_mvt_team1","price_mvt_team2"
                     )  

# Mutate data to add in market perctage and implied probabilities
match_data2 <- match_data %>% mutate(group = substr(match_id,1,1)) %>% 
                              mutate(market_prct = (1/price_draw + 1/price_team1 + 1/price_team2)) %>% 
                              mutate(market_prob_draw = (1/price_draw)/market_prct,
                                     market_prob_team1 = (1/price_team1)/market_prct,
                                     market_prob_team2 = (1/price_team2)/market_prct) 
head(match_data2, 5)


# Write to work sheet
#createSheet(workbook, name = "team_map")
#writeWorksheet(workbook,team_map,"team_map",startRow = 1, startCol =1, header = TRUE)
#saveWorkbook(workbook)

write.csv(match_data2,"match_data3.csv")
