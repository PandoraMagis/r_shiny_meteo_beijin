
df_info_buble <- wellPanel(
    
    # Right column for weather information
    tags$head(includeCSS("./radio_selector/style.css")),
    div(
        class = "weather-module",
        # station name
        h3(textOutput("clicked_point")),
        uiOutput("weather_icon"),
        h4("temperature: ", 
        div(style = "display: inline-block; vertical-align: middle; margin-right: 10px;",
            textOutput("temp")),
        div(style = "display: inline-block; vertical-align: middle;",
            uiOutput("trend_indicator"))
        ),
        h4("pressure: ", textOutput("pressure")),
        h4("rain: ", textOutput("rain")),
        h4("wind speed: ", textOutput("wind_speed")),
        h4("wind direction: ", textOutput("wd")),

        div(
            class = "small-box",
            h5("moyenne/7j:"),
            
            # Use inline-block style for avg_temp, trend_indicator, and led
            div(style = "display: inline-block; vertical-align: middle; margin-right: 10px;", 
                textOutput("avg_temp")),
            
            #div(style = "display: inline-block; vertical-align: middle; margin-right: 10px;", 
            #   uiOutput("trend_indicator")),
            
            div(style = "display: inline-block; vertical-align: middle;", 
                tags$div(id = "led"))
        ),    
        div(
            class = "bottom-right-module",
            h3("informations supplémentaires"),
            htmlOutput("index_IQA"),
            tableOutput("formattedTable"),
            p("le polluant responsable de l'IQA est affiché en gras"),
            fluidRow(
                # textOutput("clicked_point"),
                br(),
                br(),
                p("------------------------------------"),
                p("paramètre des sélecteurs ci-dessous:"),
                textOutput("selected_year"),
                textOutput("selected_month"),
                textOutput("slider_value"),
                textOutput("slider_value_hour"),
                textOutput("sunandmoon")
            ),
            br(),
            br(),
            tags$img(src = "arrow_down.png", width = "20px"),p("température plus basse que la moyenne des 7 derniers jours"),
            tags$img(src = "arrow_up.png", width = "20px"),p("température plus élevée que la moyenne des 7 derniers jours")
        )
    ),

)