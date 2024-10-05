correlations_number <- 
  fluidPage(
      selectInput("time_period", "plage de temps : ",
                choices = c("horaire" = "hour",
                            "journaliere" = "day",
                            "mensuelle" = "month",
                            "annuelle" = "year"),
                selected = "hour"),
    titlePanel("evolutions des polluants au cours du temps"),
      mainPanel(
        plotOutput("boxplots_horaires1"),
        plotOutput("boxplots_horaires2"),
        plotOutput("boxplots_horaires3")
      ),
    titlePanel("matrice de correlation"),
    mainPanel(
      plotOutput("corrPlot"),  # This is where the corrplot will be shown
      plotOutput("densitePlot")
    )
    )