library(shiny)
library(leaflet)
library(dplyr)
# Logique serveur
server <- function(input, output, session) {
  
  # Création de la carte leaflet
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = "http://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scl=1&style=7&x={x}&y={y}&z={z}",
               attribution = 'Map data © <a href="https://www.amap.com/">Amap</a>') %>%
      #addProviderTiles(providers$CartoDB.Positron) %>%
      setView(116.2, 39.88, zoom = 9) %>%   # Vue centrée sur Pekin
      addMarkers(lng = 116.23, lat = 39.58, popup = "Aotizhongxin",layerId = "Aotizhongxin") %>%  
      addMarkers(lng = 116.12, lat = 40.13, popup = "Changping",layerId = "Changping") %>% 
      addMarkers(lng =116.13, lat = 40.18, popup = "Dingling", layerId = "Dingling") %>%
      addMarkers(lng = 116.25, lat= 39.55, popup = "Dongsi", layerId = "Dongsi") %>%
      addMarkers(lng = 116.21, lat= 39.54, popup = "Guanyuan", layerId = "Guanyuan") %>%
      addMarkers(lng = 116.10, lat= 39.54, popup = "Gucheng", layerId = "Gucheng") %>%
      addMarkers(lng = 116.3905, lat= 40.1834, popup = "Huairou", layerId = "Huairou") %>%
      addMarkers(lng = 116.47, lat= 39.94, popup = "Nongzhanguan", layerId = "Nongzhanguan") %>%
      addMarkers(lng = 116.39, lat= 40.07 , popup = "Shunyi", layerId = "Shunyi") %>%
      addMarkers(lng = 116.24, lat= 39.52, popup = "Tiantan", layerId = "Tiantan" ) %>%
      addMarkers(lng = 116.17, lat= 39.59, popup = "Wanliu", layerId = "Wanliu") %>%
      addMarkers(lng = 116.18, lat= 39.56, popup = "Wanshouxigong", layerId = "Wanshouxigong")
    
    
  })
  


  # Observer les clics sur les marqueurs
  observeEvent(input$map_marker_click, {
    click_info <- input$map_marker_click
    # Vérifier si un marqueur a été cliqué
    if (!is.null(click_info$id)) {
      if (click_info$id == "Aotizhongxin") {
        output$clicked_point <- renderText("Station d'Aotizhongxin")
      } else {
        output$clicked_point <- renderText(paste("Station de " , click_info$id))
      }
    }
  })
}


time_stamp = function (year_start, month_start, day_start, hour_start, year_stop, month_stop, day_stop, hour_stop) {
  if (
    ( year_start < year_stop ) | 
    ( year_start == year_stop &&  month_start < month_stop) | 
    ( year_start == year_stop &&  month_start == month_stop && day_start < day_stop) |
    ( year_start == year_stop &&  month_start == month_stop && day_start == day_stop && hour_start < hour_stop )
  ){
    # space is neggatif
  } else {
  
  mutate(datetime = ISOdatetime(year, month, day, hour, 0, 0)) %>%  
    
  #airbnb_listings %>%
  #  filter(year %in% year_start : yeat_stop) %>%
  #  filter(month %in% month_start : month_stop) %>%
  #  filter(day)
  #}
  
  df <- data.frame(
    year = c(2023, 2023, 2023, 2024, 2024, 2024),
    month = c(8, 9, 10, 1, 2, 3),
    day = c(15, 25, 5, 10, 20, 30),
    hour = c(12, 14, 16, 18, 20, 22)
  )
  # Filter by year range first
  year_start = 2023
  year_stop = 2024
  month_start = 8
  month_stop = 2
  df %>% 
    filter( year >= year_start & year <= year_stop ) %>%
    filter( 
      (year_start == year_stop & month_start <= month & month <= month_stop) |
      (year == year_start & year != year_stop & month >= month_start) |  # If it's the start year, filter from m_start
      (year != year_start & year == year_stop & month <= month_stop) |  # If it's the start year, filter from m_start
      (year > year_start & year < year_stop)         # For years in between, include all months
    ) %>x% 
    filter(
      (month_start == month_stop & day_start <= day & day <= day_stop) |
      (month == month_start & month != month_stop & day >= day_start) |  # If it's the start month, filter from m_start
      (month != month_start & month == month_stop & day <= day_stop) |  # If it's the start month, filter from m_start
      (month > month_start & month < month_stop)         # For years in between, include all months
    )%>x% 
    filter(
      (day_start == day_stop & hours_start <= hours & hours <= hours_stop) |
        (day == day_start & day != day_stop & hours >= hours_start) |  # If it's the start day, filter from m_start
        (day != day_start & day == day_stop & hours <= hours_stop) |  # If it's the start day, filter from m_start
        (day > day_start & day < day_stop)         # For years in between, include all hourss
    )
    
    
   
  
}