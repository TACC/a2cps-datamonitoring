
library(httr)

convert_cookie_string <- function(cookie) {
  cookie <- gsub(" ", "", cookie)
  cookie <- gsub(";", ",", cookie)
  return(cookie)
}

get_api_data <- function(api_address, session) {
  print(api_address)
  cookies <- convert_cookie_string(session$request$HTTP_COOKIE)
  datastore_response <- GET(api_address, set_cookies(cookies))
  warn_for_status(datastore_response)
  json_text <- content(datastore_response, as = "text")
  return(json_text)
}