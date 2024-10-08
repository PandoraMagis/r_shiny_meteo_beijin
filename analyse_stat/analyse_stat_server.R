
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
library(kableExtra)
library(rpart)
library(rpart.plot)

## IMPORT DES DONNÉES 
data <- read.table(file = "/Users/achillegausseres/OneDrive/PRO/ACO/3A/Projet_Big_Data/dfplusIQA.csv", 
                   header = T, sep= ",", stringsAsFactors = T)

# Stocker les modèles et leurs performances
models <- reactiveValues(
  model1 = NULL,
  model2 = NULL,
  roc1 = NULL,
  roc2 = NULL,
  trainData = NULL,
  testData = NULL,
  predclass.glm = NULL,
  probclass.glm =NULL,
  predclass.rpart = NULL,
  probclass.rpart =NULL,
  TPR_arbre = NULL,
  FPR_arbre = NULL,
  TPR_glm = NULL,
  FPR_glm = NULL
  
)

  observeEvent(input$submit_profil, {
    req(input$selected_profil)  
    # Fonction qui renvoie 1 ou 0 en fonction des règles pour chaque profil
    get_response <- function(IQA, profil) {
      if(profil == "fumeur") {
        return(ifelse(IQA %in% c("dangereux"), 1, 0))
      } else if(profil == "sans_maladie") {
        return(ifelse(IQA %in% c("dangereux", "tres non-sain"), 1, 0))
      } else if(profil == "asthmatique") {
        return(ifelse(IQA == c("dangereux", "tres non-sain","non-sain"), 1, 0))
      } else if(profil == "graves_problemes_respiratoires") {
        return(ifelse(IQA %in% c("dangereux", "tres non-sain","non-sain","non-sain pour sensibles"), 1, 0))
      } else if(profil == "avec_enfant") {
        return(ifelse(IQA == c("dangereux", "tres non-sain","non-sain","non-sain pour sensibles", "modere"), 1, 0))
      } else {
        return(NA)  # Si le profil n'est pas dans la liste
      }
    }

    
    #data$IQA_binaire <- mapply(get_response, data.frame(data$IQA), as.character(input$selected_profil))
    
    ## REORGANISATION DU JEU DE DONNÉES   
    data <- data[,-(6:11)]
    data <- data[,-(13:20)]
    data$IQA_binaire <- as.factor(data$IQA_binaire)

    # Vérifier les valeurs manquantes
    sapply(data, function(x) sum(is.na(x)))
    data <- na.omit(data)
    sapply(data, function(x) sum(is.na(x)))

    # Utiliser data.table pour créer des lags par station
    data <- as.data.table(data)
    setkey(data, station, year, month, day, hour)
    
    # Création des lags 
    lag_days <- c(1,24, 168)
    
    # Créer des lags pour chaque délai dans lag_days
    for(i in lag_days){
      data[, paste0("TEMP_lag_", i, "h_") := shift(TEMP, n = i, type = "lag"), by = station]
      data[, paste0("PRES_lag_", i, "h_") := shift(PRES, n = i, type = "lag"), by = station]
      data[, paste0("DEWP_lag_", i, "h_") := shift(DEWP, n = i, type = "lag"), by = station]
      data[, paste0("RAIN_lag_", i, "h_") := shift(RAIN, n = i, type = "lag"), by = station]
      data[, paste0("wd_lag_", i, "h_") := shift(wd, n = i, type = "lag"), by = station]
      data[, paste0("WSPM_lag_", i, "h_") := shift(WSPM, n = i, type = "lag"), by = station]
    }
    
    # Convertir de nouveau en data.frame
    data <- as.data.frame(data)
    
    # Supprimer les premières lignes avec NA dues aux lags
    data <- na.omit(data)
    data <- data[,-(1:2)]
    data <- data[,-2]
    data <-data[,-9]
    
    set.seed(123) # Pour la reproductibilité
    trainIndex <- createDataPartition(data$IQA_binaire, p = 0.8, list = FALSE)
    models$trainData <- data[trainIndex, ]
    models$testData  <- data[-trainIndex, ]
    
    enable("model1_btn")
    enable("model2_btn")
    
    # Afficher un message de confirmation
    output$confirmation_msg <- renderUI({
      tagList(
        strong("Profil ", input$selected_profil, " soumis."),
        br(),
        "Les données ont été réorganisées avec succès."
      )
    })
    
    
  })
  
  observeEvent(input$model1_btn, {
    req(models$trainData)  # Assurez-vous que les données ont été traitées
    models$trainData<- models$trainData[!is.na(models$trainData$IQA_binaire) & !is.nan(models$trainData$IQA_binaire) & !is.infinite(models$trainData$IQA_binaire), ]
    
    # Ajuster le modèle 1 avec les prédicteurs sélectionnés
    models$model1 <- glm(formula = IQA_binaire ~., data = models$trainData, family = "binomial")
    
    # Calculer les prédictions et ROC pour le modèle 1
    models$probclass.glm <- pred.glm <- predict(models$model1, newdata = models$testData[,-9], type = "response")
    models$predclass.glm <- apply( data.frame(pred.glm) >=0.5 , 2, factor, labels=c("0", "1"))
    
    # Afficher le résumé du modèle 1
    output$model1_summary <- renderPrint({
      summary(models$model1)
      confusionMatrix(factor(c(models$predclass.glm)), 
                      models$testData$IQA_binaire,
                      positive = "1")
    })
    
    # Activer le bouton de comparaison si le modèle 2 est déjà ajusté
    if(!is.null(models$model2)) {
      enable("compare_btn")
    }
  })
  
  # Observer le bouton pour le Modèle 2
  observeEvent(input$model2_btn, {
    req(models$trainData)  # Assurez-vous que les données ont été traitées
    
    # Ajuster le modèle 2 avec les prédicteurs sélectionnés
    models$model2 <- rpart(IQA_binaire~., data= models$trainData, cp=0.000001)
    cp.opt <- models$model2$cptable %>% as.data.frame() %>% 
      filter(xerror == min(xerror)) %>% select(CP) %>% max() %>% as.numeric()
    
    models$model2 <- prune(models$model2, cp = cp.opt)
    
    # Calculer les prédictions et ROC pour le modèle 2
    models$predclass.rpart <- predict(models$model2, newdata = models$testData, type ="class")
    
    # Afficher le résumé du modèle 2
    output$model2_summary <- renderPrint({
      confusionMatrix(factor(c(models$predclass.rpart)), 
                      models$testData$IQA_binaire,
                      positive = "1")

    })
    
    # Activer le bouton de comparaison si le modèle 1 est déjà ajusté
    if(!is.null(models$model1)) {
      enable("compare_btn")
    }
  })
  
  observeEvent(input$compare_btn, {
    
    req(models$model1, models$model2) 
    predclass.arbreROC <- predict(models$model2, newdata = models$testData, type ="prob")
    pred.glm <- predict(models$model1, newdata = models$testData[,-9], type = "response")
    seuils <- seq(from= 0.01,to = 0.99, length =1000)
    TPR_arbre <- rep(0,times = length(seuils))
    FPR_arbre <- TPR_test
    TPR_glm <- TPR_test
    FPR_glm <- TPR_test
    
    for (k in 1:length(seuils)){
      
      class_pred_arbre <- ifelse(predclass.arbreROC[,2] > seuils[k], "1", "0")
      table <- table(models$testData[,9], class_pred_arbre)
      tab <- round(prop.table(table, margin=1), 5)*100
      TPR_arbre[k] <- tab[2,2]
      FPR_arbre[k] <- tab[1,2]
      class_pred_glm <- ifelse(pred.glm > seuils[k], "1", "0")
      table <- table(models$testData[,9], class_pred_glm)
      tab <- round(prop.table(table, margin=1), 5)*100
      TPR_glm[k] <- tab[2,2]
      FPR_glm[k] <- tab[1,2]
      
    }
    models$TPR_arbre <- TPR_arbre
    models$FPR_arbre <- FPR_arbre
    models$TPR_glm <- TPR_glm
    models$FPR_glm <- FPR_glm
    
    # Générer le graphique ROC comparatif
    output$roc_plot <- renderPlot({
      ggplot() +
        geom_line(data = data.frame(models$TPR_arbre,models$FPR_arbre,models$TPR_glm,models$FPR_glm), 
                  aes(x = models$FPR_glm, y = models$TPR_glm, color = "GLM"), linewidth = 1) + 
        geom_line(data = data.frame(models$TPR_arbre,models$FPR_arbre,models$TPR_glm,models$FPR_glm),
                  aes(x = models$FPR_arbre, y = models$TPR_arbre, color = "CART"), linewidth = 1) + 
        scale_color_manual(values = c("GLM" = "blue", "CART" = "red")) +  
        labs(color = "Légende des courbes") +  
        theme_minimal() 
      
      

    })
  })
