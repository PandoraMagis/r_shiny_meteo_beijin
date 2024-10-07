
library(tidyverse)
library(caret)
library(randomForest)
library(xgboost)
library(e1071)
library(ranger)
library(lubridate)
library(data.table)
library(ggplot2)
library(plotly)

## IMPORT DES DONNÉES 
data_analyse <- read.table(file = "dfplusIQA.csv", 
                   header = T, sep= ",", stringsAsFactors = T)

output$analyse_stat_summary <- renderPrint({
  profil <- input$profil_input
  print("A")
  print(profil)
  # Fonction qui renvoie 1 ou 0 en fonction des règles pour chaque profil
  get_response <- function(IQA, profil) {
    if(profil == "fumeur") {
      return(ifelse(IQA %in% c("dangereux"), 1, 0))
    } else if(profil == "sans_maladie") {
      return(ifelse(IQA %in% c("dangereux", "tres non-sain"), 1, 0))
    } else if(profil == "asmathique") {
      return(ifelse(IQA == c("dangereux", "tres non-sain","non-sain"), 1, 0))
    } else if(profil == "graves_problemes_respiratoires") {
      return(ifelse(IQA %in% c("dangereux", "tres non-sain","non-sain","non-sain pour sensibles"), 1, 0))
    } else if(profil == "avec_enfant") {
      return(ifelse(IQA == c("dangereux", "tres non-sain","non-sain","non-sain pour sensibles", "modere"), 1, 0))
    } else {
      return(NA)  # Si le profil n'est pas dans la liste
    }
  }
  
  data_analyse$IQA_binaire <- mapply(get_response, data_analyse$IQA, profil)
  
  ## REORGANISATION DU JEU DE DONNÉES   
  data_analyse <- data_analyse[,-(6:11)]
  data_analyse <- data_analyse[,-(13:20)]
  data_analyse$IQA_binaire <- as.factor(data_analyse$IQA_binaire)
  print("B")
  
  
  # Vérifier les valeurs manquantes
  sapply(data_analyse, function(x) sum(is.na(x)))
  data_analyse <- na.omit(data_analyse)
  sapply(data_analyse, function(x) sum(is.na(x)))
  
  
  
  
  # Utiliser data_analyse.table pour créer des lags par station
  data_analyse <- as.data.table(data_analyse)
  setkey(data_analyse, station, year, month, day, hour)
  
  # Création des lags 
  lag_days <- c(1,24, 168)
  print("C")
  # Créer des lags pour chaque délai dans lag_days
  for(i in lag_days){
    data_analyse[, paste0("TEMP_lag_", i, "h_") := shift(TEMP, n = i, type = "lag"), by = station]
    data_analyse[, paste0("PRES_lag_", i, "h_") := shift(PRES, n = i, type = "lag"), by = station]
    data_analyse[, paste0("DEWP_lag_", i, "h_") := shift(DEWP, n = i, type = "lag"), by = station]
    data_analyse[, paste0("RAIN_lag_", i, "h_") := shift(RAIN, n = i, type = "lag"), by = station]
    data_analyse[, paste0("wd_lag_", i, "h_") := shift(wd, n = i, type = "lag"), by = station]
    data_analyse[, paste0("WSPM_lag_", i, "h_") := shift(WSPM, n = i, type = "lag"), by = station]
  }
  
  # Convertir de nouveau en data.frame
  data_analyse <- as.data.frame(data_analyse)
  
  # Supprimer les premières lignes avec NA dues aux lags
  data_analyse <- na.omit(data_analyse)
  
  
  data_analyse <- data_analyse[,-(1:2)]
  data_analyse <- data_analyse[,-2]
  data_analyse <-data_analyse[,-9]
  print("D")
  set.seed(123) # Pour la reproductibilité
  trainIndex <- createDataPartition(data_analyse$IQA_binaire, p = 0.8, list = FALSE)
  trainData <- data_analyse[trainIndex, ]
  testData  <- data_analyse[-trainIndex, ]
  
  #Méthode 1: Regression Multiple 
  
  sapply(trainData, function(x) sum(is.na(x)))
  any(is.na(data_analyse$y))       # Vérifie s'il y a des NA dans y
  any(is.nan(data_analyse$y))      # Vérifie s'il y a des NaN dans y
  any(is.infinite(data_analyse$y)) # Vérifie s'il y a des Inf dans y
  trainData<- trainData[!is.na(trainData$IQA_binaire) & !is.nan(trainData$IQA_binaire) & !is.infinite(trainData$IQA_binaire), ]
  
  print("E")
  mod.glm <- glm(formula = IQA_binaire ~., data = trainData, family = "binomial")
  
  ####################
  ##PARTIE AFFICHAGE##
  ####################
  print(paste("summary(mod.glm):",summary(mod.glm)))
  print("end.")
  #suite qui clc ptn
  library(car)
  library(plotROC)
  #Anova(mod.glm, type = 3, test.statistic = "LR", singular.ok = T)
  pred.glm <- predict(mod.glm, newdata = testData[,-9], type = "response")
  print(paste("print stp",head(pred.glm)))
})










