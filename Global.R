# app.R

library(shiny)
library(leaflet)

# Importation de la  fonction de transformation
#source("utils/coord_transform.R")

# Importation des fichiers UI
source("map_ui.R")
#source("boutons_ui.R")


# Importation des fichiers serveur
#source("boutons_serveur.R")

# Interface principale avec les modules
ui <- navbarPage(
  title = "Météo et pollution à Pékin entre 2013 et 2017",  # Titre de l'application dans la barre de navigation
  
  # Première page (Onglet 1)
  tabPanel(nom_page_1, map_page_1),
  
  # Deuxième page (Onglet 2)
  tabPanel("Correlation entre les facteurs",
           h1("Bienvenue sur la page d'étude de la correlation entre les variables"),
           p("Voici la description de la deuxième page.")
  ),
  
  # Troisième page (Onglet 3)
  tabPanel("Etude des séries temporelles",
           h1("Bienvenue sur la page d'étude des séries temporelles"),
           p("Voici la description de la troisième page.")
  ),
  
  # Quatrième page (Onglet 4)
  tabPanel("Modèle de prévision des pics de pollution",
           h1("Bienvenue sur le modèle de prévision des pics de pollution"),
           p("Voici la description de la quatrième page.")
  )
)

# Serveur principal avec les modules
server <- function(input, output, session) {
  source("map_server.R", local = T)
}

# Lancer l'application
shinyApp(ui, server)
