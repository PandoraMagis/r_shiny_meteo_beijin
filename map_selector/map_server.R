library(shiny)
library(leaflet)


# Logique serveur


data_points <- data.frame(
  id = c("Aotizhongxin","Changping","Dingling","Dongsi","Guanyuan","Gucheng","Huairou","Nongzhanguan","Shunyi","Tiantan","Wanliu","Wanshouxigong"),
  name = c("Aotizhongxin","Changping","Dingling","Dongsi","Guanyuan","Gucheng","Huairou","Nongzhanguan","Shunyi","Tiantan","Wanliu","Wanshouxigong"),
  lng = c(116.23,116.12,116.13,116.25,116.21,116.10,116.3905,116.47,116.39,116.24,116.17,116.18),
  lat = c(39.58,40.13,40.18,39.55,39.54,39.54,40.1834,39.94,40.07,39.52,39.59,39.56),
  stringsAsFactors = FALSE
)


# Création de la carte leaflet
# Dynamically update the leaflet map based on the theme switch
output$map <- renderLeaflet({
  leaflet() %>%
    addProviderTiles(
      if (is.null(input$theme_switch_checkbox) || !input$theme_switch_checkbox) {
        providers$CartoDB.Positron  # Default to light mode if null or false
      } else {
        providers$CartoDB.DarkMatter  # Dark mode
      }
    ) %>%
    setView(116.2, 39.88, zoom = 9) %>%  # View centered on Beijing
    addMarkers(
      lng = data_points$lng + 0.16,
      lat = data_points$lat + 0.09,
      popup = data_points$name,
      layerId = data_points$id
    )
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

