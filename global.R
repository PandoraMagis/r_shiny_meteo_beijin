# app.R
library(formattable)
library(dplyr)
library(shiny)
library(leaflet)
# jsp a quo sert cette lib la
library(zoo)
 
# Laoding data frame
df<-read.table("dfplusIQA.csv",sep = ",",header = TRUE,stringsAsFactors = TRUE)
options(encoding = "UTF-8")
# Importation des fichiers UI
source("./PAGE_data_visualisation.r")
source("./PAGE_correlations.R")#onglet correlations
source("./theme_switch/switch_ui.r")

# Importation des fichiers serveur
#source("boutons_serveur.R")

# Interface principale avec les modules
ui <- navbarPage(
  title = "Météo et pollution à Pékin entre 2013 et 2017",  # Titre de l'application dans la barre de navigation
  
  # Première page (Onglet 1)
  page_visu_data,
  
  # Deuxième page (Onglet 2)
  page_visu_correlations,
  
  # Troisième page (Onglet 3)
  tabPanel("Etude des séries temporelles",
           h1("Bienvenue sur la page d'étude des séries temporelles"),
           p("Voici la description de la troisième page.")
  ),
  
  # Quatrième page (Onglet 4)
  tabPanel("Modèle de prévision des pics de pollution",
           h1("Bienvenue sur le modèle de prévision des pics de pollution"),
           p("Voici la description de la quatrième page.")
  ),
  switch_ui
)

# Serveur principal avec les modules
server <- function(input, output, session) {
  source("./map_selector/map_server.R", local = T)
  source("./radio_selector/radio_server.R", local = T)
  source("./theme_switch/switch_server.r", local = T)
  source("./correlations/corr_server.R", local = T)
}

# Lancer l'application
shinyApp(ui, server)
