# This web app uses the Global Biodiversity Information Facility (GBIF) API
# to map the geographic distribution of a particular species.

library(shiny)
library(ggplot2)
suppressPackageStartupMessages(library(rgbif))
suppressPackageStartupMessages(library(Hmisc))

shinyServer(function(input, output) {
    
    # Convert case insensitive user input to a proper
    # capitalized scientific name
    getSpeciesName <- reactive({
        
        capitalize(tolower(input$search))
        
    })
    
    # Search against the GBIF backbone taxonomy and return
    # the taxonomic keys corresponding to the species searched.
    getGBIFkeys <- reactive({
        
        name_backbone(name=getSpeciesName())$speciesKey
        
    })
    
    # Echo the species searched.
    output$sp <- renderText({
        paste(getSpeciesName())
    })
    
    # Search GBIF records and plot geographic distribution.
    output$map <- renderPlot({
        
        key <- getGBIFkeys()
        
        if(is.null(key)){
            
            stop("Species not found!")
            
        } else {
            
            # Search species records with georeferenced information only. The
            # number of records is specified by the user. Due to
            # performance considerations, the default number of records
            # is set to 50.
            dat <- occ_search(taxonKey=key, return='data',
                              limit=input$gbifLimit, hasCoordinate = TRUE)
            
            # Plot species geographic distribution on a world map.
            gbifmap(dat)+theme_grey(base_size = 16) +
                theme(legend.position = "bottom", legend.key = element_blank()) +
                guides(col = guide_legend(nrow = 2))
        }

    })


})
