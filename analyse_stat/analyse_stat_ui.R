analyse_stat_ui <- 
  fluidPage(
    # Titre de l'application
    titlePanel("Comparaison de Modèles avec Shiny"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput("selected_profil", "Choisissez un profil : ",
                    choices = c("fumeur" = "fumeur",
                                "sans_maladie" = "sans_maladie",
                                "asmathique" = "asmathique",
                                "graves_problemes_respiratoires" = "graves_problemes_respiratoires",
                                "avec_enfant" = "avec_enfant"),
                    selected = "sans_maladie"),
        actionButton("submit_profil", "Soumettre Profil"),
        hr(),
        
        # Boutons d'action
        actionButton("model1_btn", "Calculer Modèle GLM"),
        actionButton("model2_btn", "Calculer Modèle des arbres de décision"),
        actionButton("compare_btn", "Comparer les Modèles")
      ),


    mainPanel(
      uiOutput("confirmation_msg"),
      # Affichage des résumés des modèles
      h3("Résumé du Modèle de régression logistique (GLM)"),
      verbatimTextOutput("model1_summary"),
      
      h3("Résumé du Modèle d'abres de décision (CART)"),
      verbatimTextOutput("model2_summary"),
      
      # Affichage des courbes ROC
      h3("Courbes ROC"),
      plotOutput("roc_plot")

)
)
)
  