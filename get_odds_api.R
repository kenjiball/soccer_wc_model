# get_odds_api.R

# Call packages
library(curl)
library(jsonlite)

# Set working directory
set(wc_wd)

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
  return(jsonData)
}


api_url_wc <- "https://puntapi.com/odds/event/"
api_odds_key <- "?derived=best&betTypes=fixed-win" 


game_id <- c(658072:658102,658104:658120)
game_id
length(odds_id)

# Single game 
grabData(658072,api_url_wc,api_odds_key)



