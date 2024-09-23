library(shiny)
library(leaflet)

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
      } else if (click_info$id == "Changping") {
        output$clicked_point <- renderText("Station de Changping")
      } else if (click_info$id == "Dingling") {
        output$clicked_point <- renderText("Station de Dingling")
      } else if (click_info$id == "Dongsi") {
        output$clicked_point <- renderText("Station de Dongsi")
      } else if (click_info$id == "Guanyuan") {
        output$clicked_point <- renderText("Station de Guanyuan")
      } else if (click_info$id == "Gucheng") {
        output$clicked_point <- renderText("Station de Gucheng")
      } else if (click_info$id == "Huairou") {
        output$clicked_point <- renderText("Station de Huairou")
      } else if (click_info$id == "Nongzhanguan") {
        output$clicked_point <- renderText("Station de Nongzhanguan")
      } else if (click_info$id == "Shunyi") {
        output$clicked_point <- renderText("Station de Shunyi")
      } else if (click_info$id == "Tiantan") {
        output$clicked_point <- renderText("Station de Tiantan")
      } else if (click_info$id == "Wanliu") {
        output$clicked_point <- renderText("Station de Wanliu")
      } else if (click_info$id == "Wanshouxigong") {
        output$clicked_point <- renderText("Station de Wanshouxigong")
      }
    }
  })
}