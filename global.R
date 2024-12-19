library(shiny)
library(shinydashboard)
library(sf)
library(DT)
library(leaflet)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)


geodata <- st_read("./www/map.js")
geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))
pal <- colorNumeric(palette = "YlOrRd", domain =geodata$shapeID)
sumTotal <- sum(geodata$shapeID)

sorted_data <- geodata %>%
  arrange( desc(geodata$shapeID <- as.numeric(gsub(",", "", geodata$shapeID))))

choics <- sorted_data$shapeName

year_data <- list(
  "2024" = list(population = "174,701,211", growth_rate = "1.01%"),
  "2023" = list(population = "172,954,319", growth_rate = "1.03%"),
  "2022" = list(population = "171,186,372", growth_rate = "1.08%"),
  "2021" = list(population = "169,356,251", growth_rate = "1.16%"),
  "2020" = list(population = "167,420,951", growth_rate = "1.15%"),
  "2019" = list(population = "165,516,222", growth_rate = "1.12%"),
  "2018" = list(population = "163,683,958", growth_rate = "1.17%"),
  "2017" = list(population = "161,793,964", growth_rate = "1.26%"),
  "2016" = list(population = "159,784,568", growth_rate = "1.24%"),
  "2015" = list(population = "157,830,000", growth_rate = "1.20%"),
  "2014" = list(population = "155,961,299", growth_rate = "1.25%"),
  "2013" = list(population = "154,030,139", growth_rate = "1.28%"),
  "2012" = list(population = "152,090,649", growth_rate = "1.25%"),
  "2011" = list(population = "150,211,005", growth_rate = "1.23%"),
  "2010" = list(population = "148,391,139", growth_rate = "1.15%"),
  "2009" = list(population = "146,706,810", growth_rate = "0.88%"),
  "2008" = list(population = "145,421,318", growth_rate = "0.89%"),
  "2007" = list(population = "144,135,934", growth_rate = "1.06%"),
  "2006" = list(population = "142,628,831", growth_rate = "1.22%"),
  "2005" = list(population = "140,912,590", growth_rate = "1.53%"),
  "2004" = list(population = "138,789,725", growth_rate = "1.68%"),
  "2003" = list(population = "136,503,206", growth_rate = "1.76%"),
  "2002" = list(population = "134,139,826", growth_rate = "1.88%"),
  "2001" = list(population = "131,670,484", growth_rate = "1.92%"),
  "2000" = list(population = "129,193,327", growth_rate = "1.92%")
)
