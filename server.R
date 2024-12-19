# Server
library(shiny)
library(sf)
library(DT)
library(plotly)
library(dplyr)
library(bslib)


geodata <- st_read("./www/map.js")
# pop <- as.numeric(gsub(",", "", geodata$shapeID))
 
  
function(input, output) {
  

  geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))
  pal <- colorNumeric(palette = "YlOrRd", domain =geodata$shapeID)
  sumTotal <- sum(geodata$shapeID)
  
  sorted_data <- geodata %>%
    arrange( desc(geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))))
  
  sorted_data_asc <- geodata %>%
    arrange( geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID)))
  
  output$sum <- renderPrint(
    paste(sumTotal)
  )
  
#------------PLOTLY---------------------
  
   output$barChart <- renderPlotly({
     sorted_data <- geodata %>%
       arrange( desc(geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))))
    new_data <- sorted_data
     
    new_data %>%
     plot_ly() %>%
         add_bars(
           data = new_data,
           x = ~shapeName,
           y = ~shapeID)%>%
       layout(
         xaxis = list(title = "Districts"),
         yaxis = list(title = "Population")
       )
  })
   
  output$barchartTab <- renderPlotly({
    sorted_data <- geodata %>%
      arrange( desc(geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))))
    new_data <- sorted_data
    
    new_data %>%
      plot_ly() %>%
      add_bars(
        data = new_data,
        x = ~shapeName,
        y = ~shapeID)%>%
      layout(
        xaxis = list(title = "Districts"),
        yaxis = list(title = "Population")
      )
  })
   # --------------Data Tables -ulta-------------------------
   
    output$dataT <- renderDataTable({
    sorted_data %>%
      as.data.frame() %>%     # Convert to data frame
      select(-geometry,-shapeISO,-shapeGroup,shapeType)%>%
        mutate(
          shapeID=scales::comma(round(shapeID))
        )%>%
        rename(
          `District`=shapeName,
          `Population`=shapeID
        )
  } )
  
  output$tableTab <- renderDataTable({
    sorted_data %>%
      as.data.frame() %>%     # Convert to data frame
      select(-geometry,-shapeISO,-shapeGroup,shapeType)%>%
      mutate(
        shapeID=scales::comma(round(shapeID))
      )%>%
      rename(
        `District`=shapeName,
        `Population`=shapeID
      )
  } )
  
   output$top5 <- renderTable({
     sorted_data_asc %>% 
       as.data.frame() %>%     # Convert to data frame
       select(-geometry,-shapeISO,-shapeGroup,-shapeType) %>%  # Exclude geometry column
       head(5)%>%
       mutate(
         shapeID=scales::comma(round(shapeID))
       )%>%
       rename(
         `District`=shapeName,
         `Population`=shapeID
       )
   })
   
   output$low5 <- renderTable({
     sorted_data %>% 
       as.data.frame() %>%  
       select(-geometry,-shapeISO,-shapeGroup,-shapeType) %>% 
       arrange(desc(shapeID)) %>% 
       head(5)%>%
       mutate(
         shapeID=scales::comma(round(shapeID))
       )%>%
       rename(
         `District`=shapeName,
         `Population`=shapeID
       )
   })
#-------------------------LEAFLET-------------------------------
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(lng = 90.399452, lat = 23.777176, zoom = 7) %>%  #chaining continues
      addPolygons(
        data = geodata,
        fillColor = ~pal(shapeID),
        fillOpacity = 0.8,
        color = "black",
        weight = 1,
        popup = ~paste("Population of",geodata$shapeName,":", shapeID),
        highlight = highlightOptions(
          weight = 3,
          color = "blue",
          fillColor = "lightblue",
          fillOpacity = 0.7,
          bringToFront = TRUE
        )
      ) %>% 
      addLegend(
        position = "bottomright",
        pal = pal,
        values = geodata$shapeID,
        title = "Population",
        opacity = 0.5
      ) %>%
      addMiniMap(
        width = 150,
        height = 150,
        collapsedWidth = 19,
        collapsedHeight = 19,
      )
      
  })
#--------EVENTS-------------------------------
  
 choics <- sorted_data$shapeName
 

 
observeEvent(input$location, {
  req(input$location) # Ensure a selection is made
  
  # Find coordinates of selected location
  selected_layer <- geodata %>% 
    filter(shapeName == input$location)
  
  # Get centroid coordinates for flyTo
  selected_location <- st_centroid(selected_layer) %>%
    st_coordinates()
  
  
  # Update the map
  leafletProxy("mymap") %>%
    clearPopups() %>%
    flyTo(lng = selected_location[1], lat = selected_location[2], zoom = 10)%>%
    addPopups(
      lng = selected_location[1], 
      lat = selected_location[2],
      popup = paste(
        "<b>Location:</b>", selected_layer$shapeName, "<br>",
        "<b>Population:</b>", selected_layer$shapeID, "<br>"
        
      )
    )
})      
  
#------------dynamic ui---------------
output$populationT <- renderUI({
  value_box(
    title = "Total Population",
    value = year_data[[input$rate]]$population,  # Fetch from dataset
    showcase = bsicons::bs_icon("globe-central-south-asia"),
    theme = "primary",
    class = "border",
    height = 100
  )
})

output$rateT <- renderUI({
  value_box(
    title = "Population Growth Rate",
    value = year_data[[input$rate]]$growth_rate,  # Fetch from dataset
    showcase = bsicons::bs_icon("person-bounding-box"),
    theme = value_box_theme(bg = "white", fg = "#0B538E"),
    height = 100
  )
})


}





