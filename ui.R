# This web app uses the Global Biodiversity Information Facility (GBIF) API
# to map the geographic distribution of a particular species.
#
# Author: C.Ribeiro
# Last Modification: 14/09/2014
# 

library(shiny)

shinyUI(fluidPage(

  titlePanel("Global Biodiversity"),

  sidebarLayout(
    sidebarPanel(
        
        helpText("This web app uses the",
                 "Global Biodiversity Information Facility (GBIF) API",
                 "to map the geographic distribution of a particular species.",
                 "GBIF provides a single point of access to more than 400 million",
                 "records related to more than one million species."),
        HTML("<br />"),
        
        textInput("search",
                  label=h5("Search species:"),
                  value="Ursus americanus"),
 
        helpText("Search by scientific name e.g.,",
                 em("Ursus americanus."), "Search is",strong("case insensitive.")),
        
        HTML("<br />"),
        
        sliderInput("gbifLimit",
                    label=h5("Number of GBIF records to return: "),
                    min=50, max=1000, step=10, value=50),
        
        helpText("By default only the first 50 records are shown.",
                 "You can change this number by using the slider above and",
                 "then pressing the Submit button."),
        
        HTML("<br />"),
        HTML("<br />"),

        submitButton(text = "Submit"),

        HTML("<br />"),
        HTML("<br />"),
        HTML("<br />"),
        
        helpText("The tooltips on the markers display the basis of the record",
                 "(e.g., HUMAN_OBSERVATION) for that particular location")
        
    ),

    mainPanel(
        img(src="GBIF_logo_short_form.gif",width=128,height=128),
        
        h3("GBIF occurrence data"),
        
        h5("Searching for..."),
        
        textOutput("sp"),
        
        HTML("<br />"),
        HTML("<br />"),
        
        htmlOutput("gvis")
    )
  )
))
