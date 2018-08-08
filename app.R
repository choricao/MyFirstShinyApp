library(shiny)
library(jsonlite)

ui <- navbarPage(
  tags$head(tags$script(src = "message-handler.js")),
  tabPanel("New Hike",
           fluidPage(
             actionButton("start_button", "Start"),
             actionButton("end_button", "End"),
             helpText("Distance (miles)"),
             textOutput("distance"),
             textInput("name", "Hike Name", ""),
             textInput("nicknames", "Plant Nicknames", ""),
             actionButton("sow_seeds_button", "Sow Seeds"),
             textOutput("name")
           )
  ),
  tabPanel("Analytics",
           fluidPage(
             actionButton("show_data_button", "Show Data"),
             textOutput("hikes")
           )
    
  )
)

server <- function(input, output, session) {
  observeEvent(input$start_button, {
    session$sendCustomMessage(
      type = 'testmessage',
      message = 'You picked your start point!')
  })
  
  distance <- sample(1:10, 1)
  observeEvent(input$end_button, {
    output$distance <- renderText({
      paste0("You just hiked ", distance, " miles!")
    })
  })
  
  names <- eventReactive(input$sow_seeds_button, {
    if (input$name !="" && input$nicknames != ""){
      paste0("You just created a new hike ", input$name, ". Seeds have been planted are ", input$nicknames, ".")
    } else {
      "Please enter both hike name & plant nicknames."
    }
  })
  output$name <- renderText({
    names()
  })
  
  url <- "https://zc-hike-seed.herokuapp.com/hikes"
  res <- fromJSON(url)
  hikes <- eventReactive(input$show_data_button, {
    paste("There are", nrow(res), "hikes have been created between", min(res$date), "and", max(res$date), ". Among them,", sum(res$is_harvest == TRUE), " have produced seeds and been harvested.")
  })
  output$hikes <- renderText({
    hikes()
  })
}

shinyApp(ui, server)