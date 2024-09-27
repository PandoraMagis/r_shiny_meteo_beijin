library(shiny)
library(zoo)

df<-read.table("donnees_meteo.csv",sep = ",",header = TRUE,stringsAsFactors = TRUE)

source("boutons_ui.R", local = T)
source("boutons_serveur.R", local = TRUE)

