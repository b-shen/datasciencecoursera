#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("model_ngrams.R")

shinyUI(fluidPage(
    # Application title
    titlePanel("Predict Next Word"),
    # Sidebar for instructions using this shiny app
    sidebarLayout(
        sidebarPanel(
            h4(strong("Instructions:")), 
            h6("1. Please enter your word or phrases in the text box for prediction."),
            h6(tags$div("2. The predicted word will be in ",
                        strong(tags$span(style = "color: #0072b2;", "BLUE")),
                        "below the text box")),
            h6("4. A question mark (?) represents no prediction available."),
            a("Source Code GitHub Repository", href = "https://github.com/")
        ),
        # Show a plot of the generated distribution
        mainPanel(
            textInput("user_input", h4("Input text:"), 
                      value = "example: happy mothers"),
            h4("Prediction:"),
            h5(strong(em(span(textOutput("ngram_output"), style="color:#0072b2"))))
        )
    )
))