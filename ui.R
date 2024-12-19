library(shiny)
library(shinydashboard)
library(leaflet)
library(sf)
library(DT)
library(plotly)
library(bslib)



# UI
header <- dashboardHeader(title = "Map Overview")

sidebar <- dashboardSidebar(
   sidebarMenu(
     menuItem("Map View", tabName = "map", icon = icon("globe")),
     menuItem("Table", tabName = "table", icon = icon("table")),
     menuItem("Graph", tabName = "graph", icon = icon("map")),
     menuItem("source code",icon = icon("github"),href ="https://github.com/sabberrahman?tab=repositories")
     
   ),collapsed = FALSE
)

body <- dashboardBody(
  
  
  tags$head(
    tags$style(HTML("
      .dataTable {
        padding: 20px;
         margin-top: 20px; /* Add padding to the entire table */
      }
    "))
  ),
  tabItems(
    tabItem(
      tabName ="map",
      fluidRow(
        column(width =4 ,
          selectInput("rate",label ="Rate each year",choices =names(year_data),selected = "2024",width = 100),     
          uiOutput("populationT"),
          uiOutput("rateT")
        ),
        column(width =4 ,box(title = "Top 5 Populated Districts", status = "primary",  collapsible = TRUE, solidHeader = TRUE, tableOutput("low5"),width =300)),
        column(width =4 ,box(title = "Less Populated Districts", status = "primary",  collapsible = TRUE, solidHeader = TRUE, tableOutput("top5"),width =300))
      ) ,
      
     
     fluidRow(
       column(width =8,leafletOutput("mymap",height =600 )),
       column(width =4, selectInput( 
         "location", 
         "Select options below:", 
         
         choices = choics,
         selected = "Dhaka"
       ))
     ),
     fluidRow(
       class="custom-row",
       column(width =6 ,dataTableOutput("dataT")),
       column(width =6 ,plotlyOutput("barChart",height =600 ))
     )
     
    ),
     #tab 2
    tabItem(
      tabName ="table",
      fluidRow(
        column(
          width=12,
          dataTableOutput("tableTab")
               )
      )
    ), 
    #tab 3
    tabItem(
      tabName ="graph",
      fluidRow(
        column(
          width=12,
          plotlyOutput("barchartTab",height = 700)
        )
      )
    )
 
  )
)

ui <- dashboardPage(header,sidebar,body)