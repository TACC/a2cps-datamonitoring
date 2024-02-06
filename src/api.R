
library(httr)

convert_cookie_string <- function(cookie) {
  cookie <- gsub(" ", "", cookie)
  cookie <- unlist(strsplit(cookie, ";"))
  cookie <- strsplit(cookie, "=")
  cookie <- setNames(sapply(cookie, function(x) x[2]), sapply(cookie, function(x) x[1]))
  return(cookie)
}

get_api_data <- function(api_address, session) {
  print(api_address)
  print(session$request$HTTP_COOKIE)
  cookies <- convert_cookie_string(session$request$HTTP_COOKIE)
  print(cookies)
  datastore_response <- GET(api_address, set_cookies(cookies))
  warn_for_status(datastore_response)
  json_text <- content(datastore_response, as = "text")
  print("json_text: ")
  print(typeof(json_text))
  return(json_text)
}