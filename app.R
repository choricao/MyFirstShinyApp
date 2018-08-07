library(shiny)

ui <- fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  titlePanel("New Hike"),
  
  mainPanel(
    actionButton("start_button", "Start"),
    actionButton("end_button", "End"),
    helpText("Distance (miles)"),
    textOutput("distance"),
    textInput("name", "Hike Name", ""),
    textInput("nicknames", "Plant Nicknames", ""),
    actionButton("sow_seeds_button", "Sow Seeds"),
    textOutput("name")
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
}

shinyApp(ui, server)