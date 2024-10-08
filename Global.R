# app.R
library(formattable)
library(dplyr)
library(shiny)
library(leaflet)
library(zoo)
library(shiny)
library(ggplot2)
library(car)
library(plotROC)
library(rpart)
library(rpart.plot)
library(kableExtra)
library(patchwork)
 library(plotly)
# Laoding data frame
df<-read.table("df.csv",sep = ",",header = TRUE,stringsAsFactors = TRUE)

# Laoding data frame
df<-read.table("dfplusIQA.csv",sep = ",",header = TRUE,stringsAsFactors = TRUE)
options(encoding = "UTF-8")
# Importation des fichiers UI
source("./PAGE_data_visualisation.r")
source("./PAGE_correlations.R")#onglet correlations
source("./PAGE_analyse_stat.R")
source("./PAGE_time_series.r")
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
  page_time_series,
  
  # Quatrième page (Onglet 3)
  page_visu_analyse_stat,

  
  # Quatrième page (Onglet 4)
  # tabPanel("Modèle de prévision des pics de pollution",
  #          h1("Bienvenue sur le modèle de prévision des pics de pollution"),
  #          p("Voici la description de la quatrième page.")
  # ),
  switch_ui
)

# Serveur principal avec les modules
server <- function(input, output, session) {
  source("./map_selector/map_server.R", local = T)
  source("./radio_selector/radio_server.R", local = T)
  source("./theme_switch/switch_server.r", local = T)
  source("./correlations/corr_server.R", local = T)
  #source("./analyse_stat/analyse_stat_server.R", local = T)

  # time series got deported server files
  source("./time_series/SERVER_time_series.r", local = T)
}

# Lancer l'application
shinyApp(ui, server)
