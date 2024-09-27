
# Interface map 
nom_page_1 <- "Visualisation des données"
map_page_1<- fluidRow(
    column(8,
           leafletOutput("map"),
           sliderInput("slider", "Choisissez une valeur:", min = 1, max = 35064, value = 1,
                       pre= "observation n°", width = '100%')
    ),
    
    column(4,
           wellPanel(
             h3(textOutput("clicked_point"))
           )
    )
  )

