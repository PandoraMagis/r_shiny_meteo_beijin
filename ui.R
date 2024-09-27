library(shiny)
library(leaflet)

# Interface utilisateur
ui <- navbarPage(
  title = "Météo et pollution à Pékin entre 2013 et 2017",  # Titre de l'application dans la barre de navigation
  
  # Première page (Onglet 1)
  tabPanel("Visualisation des données",
           fluidRow(
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

  ),
  
  # Deuxième page (Onglet 2)
  tabPanel("Correlation entre les facteurs",
           h1("Bienvenue sur la page d'étude de la correlation entre les variables"),
           p("Voici la description de la deuxième page.")
  ),
  
  # Troisième page (Onglet 3)
  tabPanel("Etude des séries temporelles",
           
           fluidRow(
             column(8,
                    leafletOutput("map"),
             ),
             column(4, wellPanel(h3(textOutput("clicked_point"))))
           )
  ),
  
  # Quatrième page (Onglet 4)
  tabPanel("Modèle de prévision des pics de pollution",
           h1("Bienvenue sur le modèle de prévision des pics de pollution"),
           p("Voici la description de la quatrième page.")
  )
)

