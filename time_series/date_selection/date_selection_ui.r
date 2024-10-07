date_selection_ui <- sidebarLayout(
    sidebarPanel(
      # Sélecteur pour le mois
      h4("start date"),
      selectInput("month_in", 
                  label = "Choisissez un mois:", 
                  choices = setNames(1:12, month.name), 
                  selected = format(Sys.Date(), "%m")),
      
      # Sélecteur pour le jour
      selectInput("day_in", 
                  label = "Choisissez un jour:", 
                  choices = 1:31, 
                  selected = format(Sys.Date(), "%d")),
      
      # Sélecteur pour l'année
      selectInput("year_in", 
                  label = "Choisissez une année:", 
                  choices = 2013:2017, 
                  selected = format(Sys.Date(), "%Y")),
      
      # Slider-heure
      sliderInput("hour_in", 
                  label = "Choisissez l'heure:", 
                  min = 0, max = 23, 
                  value = as.numeric(format(Sys.time(), "%H")), 
                  step = 1),
    
      h4("end date"),
      # Sélecteur pour le mois
      selectInput("month_end", 
                  label = "Choisissez un mois:", 
                  choices = setNames(1:12, month.name), 
                  selected = format(Sys.Date(), "%m")),
      
      # Sélecteur pour le jour
      selectInput("day_end", 
                  label = "Choisissez un jour:", 
                  choices = 1:31, 
                  selected = format(Sys.Date(), "%d")),
      
      # Sélecteur pour l'année
      selectInput("year_end", 
                  label = "Choisissez une année:", 
                  choices = 2013:2017, 
                  selected = format(Sys.Date(), "%Y")),
      
      # Slider-heure
      sliderInput("hour_end", 
                  label = "Choisissez l'heure:", 
                  min = 0, max = 23, 
                  value = as.numeric(format(Sys.time(), "%H")), 
                  step = 1),

        # varraibles observed:... = 
        checkboxGroupInput(
            "time_series_vars", "choisisez les varriables a afficher",
            c(
                "PM2.5"             = "PM2.5",
                "PM10"              = "PM10",
                "SO2"               = "SO2",
                "NO2"               = "NO2",
                "CO"                = "CO",
                "O3"                = "O3",
                "Temperature"       ="TEMP",
                "Pression"          ="PRES",
                "Depression"        ="DEWP",           
                "Pluie"             ="RAIN",
                "Vent"              ="wd",
                "Vitesse du vent"   ="WSPM",
                # ""                  =#"station",
                "moyenne sept jour" ="avg_temp_last_7"
            )
        )
    
    ),

    mainPanel( 
        h2(textOutput("selected_date_time")),

        radioButtons("periode_mod", "Choissiez en fonction de quelle periode separer les donnés",
            choices = c(
                "Années"    = "year",
                "Mois"      = "month",
                "Jours"     = "day",
                "Heures"    = "hour"
            ), selected = "day"
        ),
        plotOutput("visu_time_series_single_var"),
        plotOutput("line_evo_multi_var")
    )
)