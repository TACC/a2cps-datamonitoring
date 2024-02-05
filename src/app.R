# Demo app for Shiny with datastore 
library(httr)
library(jsonlite)
library(shiny)
source("api.R", local = TRUE)

datastore_url <- Sys.getenv(c("DATASTORE_URL"))


# Define UI
ui <- fluidPage(
  fluidRow(
    column(12, h3("Imaging Report via Shiny app"))
  ),
  verbatimTextOutput("info"),
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
    output$info <- renderText({""})
    output$json_table <- renderDataTable({
      parsed_json$data$imaging
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