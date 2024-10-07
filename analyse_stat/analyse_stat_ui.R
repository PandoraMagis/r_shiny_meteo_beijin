analyse_stat_ui <- 
  fluidPage(
    mainPanel(
      selectInput("profil_input", "profil : ",
                  choices = c("fumeur" = "fumeur",
                              "sans_maladie" = "sans_maladie",
                              "asmathique" = "asmathique",
                              "graves_problemes_respiratoires" = "graves_problemes_respiratoires",
                              "avec_enfant" = "avec_enfant"),
                  selected = "sans_maladie"),
      verbatimTextOutput("analyse_stat_summary")
    )
  )