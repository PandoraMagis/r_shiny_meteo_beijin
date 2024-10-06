correlations_number <- 
  fluidPage(
    mainPanel(
    htmlOutput("missing_data")),
      selectInput("time_period", "plage de temps : ",
                choices = c("horaire" = "hour",
                            "journaliere" = "day",
                            "mensuelle" = "month",
                            "annuelle" = "year"),
                selected = "hour"),
    titlePanel("evolutions des polluants au cours du temps et matrice des correlations"),
      mainPanel(
        plotOutput("boxplots_horaires1"),
        plotOutput("boxplots_horaires2"),
        plotOutput("boxplots_horaires3"),
        selectInput("polluant_select_emmeans", "polluant à analyser en détail : ",
                    choices = c("PM2.5" = "PM2.5",
                                "PM10" = "PM10",
                                "SO2" = "SO2",
                                "NO2" = "NO2",
                                "CO" = "CO",
                                "O3" = "O3"),
                    selected = "O3"),
        DT::dataTableOutput("emmeansplots")
      ),
    mainPanel(
      plotOutput("corrPlot"),  # This is where the corrplot will be shown
      plotOutput("densitePlot")
    )
    )