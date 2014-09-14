# This web app uses the Global Biodiversity Information Facility (GBIF) API
# to map the geographic distribution of a particular species.
#
# Author: C.Ribeiro
# Last Modification: 14/09/2014
# 

library(shiny)
suppressPackageStartupMessages(library(rgbif))
suppressPackageStartupMessages(library(Hmisc))
suppressPackageStartupMessages(library(googleVis))

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
    
    output$gvis <- renderGvis({
        
        key <- getGBIFkeys()
        
        if(is.null(key)){
            
            stop("Species not found!")
            
        } else {
            
            # Search species records with georeferenced information only. The
            # number of records is specified by the user. Due to
            # performance considerations, the default number of records
            # is set to 50.
            dat <- occ_search(taxonKey=key, return='data',
                              fields=c("name","key","decimalLatitude",
                                       "decimalLongitude","basisOfRecord"),
                              limit=input$gbifLimit, hasCoordinate = TRUE)
            
            # Plot species geographic distribution using googleVis.
            dat$Loc <- paste(dat$decimalLatitude, dat$decimalLongitude, sep=":")
            
            gvisMap(dat,
                    locationvar="Loc",
                    tipvar="basisOfRecord")
        }

    })
  
})
