# get_odds_api.R

# Call packages
library(curl)
library(jsonlite)

# Set working directory
setwd(wc_wd)

# Function to Read Player Data Json from API and save to file 
grabData <- function(gameid,api_url,api_key){
  # Create API call from gameid
  API_str <- paste(api_url
                   ,gameid
                   ,api_key
                   , sep = "", collapse = NULL)
   # Call API to get data for a game
  jsonData <- fromJSON(API_str)
  #jsonDataPretty <- toJSON(jsonData, pretty = TRUE)
  jsonData <- as.data.frame(jsonData)
  names(jsonData) <- gsub("odds.","",names(jsonData))
  
  event_id <- rep(gameid,nrow(jsonData))
  price_amt <- jsonData$price$value
  price_mvmt <- jsonData$price$movement
  jsonData2 <- data.frame(event_id,jsonData$selectionId, jsonData$type
                          , jsonData$betType, price_amt, price_mvmt, jsonData$bookmakerId )
  names(jsonData2) <- gsub("jsonData.","",names(jsonData2))
  return(jsonData2)
}



# function loop through all game ids
grabData_all <- function(game_vector){
    all_match_data <- data.frame()
      
    for(i in 1:length(game_vector)){
    
      event_data <- grabData(game_vector[i],api_url_wc,api_odds_key)
      
      all_match_data <- rbind(all_match_data,event_data)
      
      
    }
    return(all_match_data)
}



# set game id vector
game_id <- c(658072:658102,658104:658120)

# Run Function
odds_data <- grabData_all(game_id)

# write.csv(odds_data,"odds_data.csv")

