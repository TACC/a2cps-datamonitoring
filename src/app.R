# Demo app for Shiny with datastore 
library(httr)
library(jsonlite)
library(shiny)
source("api.R", local = TRUE)

datastore_url <- Sys.getenv(c("DATASTORE_URL"))


# Define UI
ui <- fluidPage(
  fluidRow(
    column(12, h3("Data Monitoring via Shiny app"))
  ),
  h3('Date Date: '),
  verbatimTextOutput("info"),
  h3('Available Data tables: '),
  verbatimTextOutput("data_tables"),
  dataTableOutput("json_table")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  print("Request for report received")
  tryCatch({
    api_address <- paste0(datastore_url, "api/monitoring")
    response <- get_api_data(api_address, session)
    response <- gsub("NaN", "null", response)
    parsed_json <- fromJSON(response)
    print(parsed_json$date)
    for (thing in names(parsed_json$data)){
        print(thing)
    }
    data_tables_list_string <- ""
    for (thing in names(parsed_json$data)){
        data_tables_list_string <- paste(data_tables_list_string, thing)
        data_tables_list_string <- paste(data_tables_list_string, "\n")
    }
    print(data_tables_list_string)

    output$info <- renderText(parsed_json$date)
    output$data_tables <- renderText(data_tables_list_string)
    output$json_table <- renderDataTable({
      parsed_json$data
    })
  }, error = function(e) {
    # Handle exceptions and update status
    output$info <- renderText({
      paste("An error occurred:", e$message)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)