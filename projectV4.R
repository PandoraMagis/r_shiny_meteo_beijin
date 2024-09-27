library(shiny)
library(zoo)

# UI changes
ui <- fluidPage(
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  tags$head(includeCSS("style.css")),
  
  # JavaScript to bind custom radio buttons with Shiny inputs
  tags$script(HTML("
    $(document).on('change', 'input[name=district-radio]', function() {
      var selectedValue = $('input[name=district-radio]:checked').val();
      Shiny.setInputValue('district_radio', selectedValue);
    });
    $(document).on('change', 'input[name=band]', function() {
      var selectedValue = $('input[name=band]:checked').val();
      Shiny.setInputValue('month_radio', selectedValue);
    });
    $(document).on('input', '#custom_slider', function() {
    var sliderValue = $('#custom_slider').val();
    Shiny.setInputValue('custom_slider', sliderValue);
  });
  $(document).on('input', '#custom_slider_hour', function() {
    var sliderValue = $('#custom_slider_hour').val();
    Shiny.setInputValue('custom_slider_hour', sliderValue);
  });
  $(document).on('change', '#theme-switch-checkbox', function() {
      var isChecked = $(this).is(':checked');
      Shiny.setInputValue('theme_switch_checkbox', isChecked);
    });
  ")),
  
  # Main layout
  fluidRow(
    
    #switch
    tags$head(includeCSS("toggle_switch.css")),
    tags$div(class = "theme-switch-container", 
             tags$div(class = "theme-switch",
                      tags$input(type = "checkbox", class = "theme-switch__checkbox", id = "theme-switch-checkbox"),
                      tags$label(`for` = "theme-switch-checkbox", class = "theme-switch__container",
                                 tags$div(class = "theme-switch__circle-container",
                                          tags$div(class = "theme-switch__sun-moon-container",
                                                   tags$div(class = "theme-switch__moon",
                                                            tags$div(class = "theme-switch__spot"),
                                                            tags$div(class = "theme-switch__spot")
                                                   )
                                          ),
                                          tags$div(class = "theme-switch__clouds"),
                                          tags$div(class = "theme-switch__stars-container",
                                                   tags$div(class = "theme-switch__star"),
                                                   tags$div(class = "theme-switch__star"),
                                                   tags$div(class = "theme-switch__star"),
                                                   tags$div(class = "theme-switch__star")
                                          )
                                 )
                      )
             ),
             tags$div(
               class = "mode-text",
               textOutput("sunandmoon")  # This will display the current mode
             )
    ),
    
    # Large window on the left
    column(6,offset=-3, 
           div(class = "window-with-bg",
             # Circular Radio Buttons
             tags$head(includeCSS("analog_knob_latestV2.css")),
             tags$div(
               class = "radio-input",
               style = "display: flex; flex-direction: column; align-items: center;",  # Centering styles
               tags$div(
                 class = "radio-input-path",
                 
                 # 5 Districts Radio Buttons
                 tags$div(class = "radioContainer radioContainer1",
                          tags$label(class = "label1", `for` = "value-1", "2013"),
                          tags$input(class = "radio1", value = "2013", name = "district-radio", id = "value-1", type = "radio", checked = "checked")
                 ),
                 tags$div(class = "radioContainer radioContainer2",
                          tags$label(class = "label2", `for` = "value-2", "2014"),
                          tags$input(class = "radio2", value = "2014", name = "district-radio", id = "value-2", type = "radio")
                 ),
                 tags$div(class = "radioContainer radioContainer3",
                          tags$label(class = "label3", `for` = "value-3", "2015"),
                          tags$input(class = "radio3", value = "2015", name = "district-radio", id = "value-3", type = "radio")
                 ),
                 tags$div(class = "radioContainer radioContainer4",
                          tags$label(class = "label4", `for` = "value-4", "2016"),
                          tags$input(class = "radio4", value = "2016", name = "district-radio", id = "value-4", type = "radio")
                 ),
                 tags$div(class = "radioContainer radioContainer5",
                          tags$label(class = "label5", `for` = "value-5", "2017"),
                          tags$input(class = "radio5", value = "2017", name = "district-radio", id = "value-5", type = "radio")
                 )
               ),
               tags$div(class = "knob",
                        tags$div(class = "center")
               )
             ), # fin radio buttons
             tags$head(includeCSS("radio_buttons.css")),
             div(class = "radio-month",
                 tags$form(
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "jan", checked = TRUE),
                     tags$span("JAN")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "fev"),
                     tags$span("FEV")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "mar"),
                     tags$span("MAR")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "avr"),
                     tags$span("AVR")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "mai"),
                     tags$span("MAI")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "jun"),
                     tags$span("JUN")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "jui"),
                     tags$span("JUI")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "aou"),
                     tags$span("AOU")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "sep"),
                     tags$span("SEP")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "oct"),
                     tags$span("OCT")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "nov"),
                     tags$span("NOV")
                   ),
                   tags$label(
                     tags$input(type = "radio", name = "band", value = "dec"),
                     tags$span("DEC")
                   )
                   
                 )),#fin de radio buttons
             tags$head(includeCSS("sliderinput.css")),
             
             div(class = "slider",
                 h6("jour"),
                 tags$input(type = "range", class = "range-style", min = 1, max = 31, id = "custom_slider",value = 3,style = "margin-bottom: 20px;"),
                 h6("heure"),
                 tags$input(type = "range", class = "range-style", min = 0, max = 23, id = "custom_slider_hour",value=0)
                 # Output to display the selected value
                 
             )
           )#fin div class = background
    ),
    
    # Right column for weather information
    column(6, 
           tags$head(includeCSS("style.css")),
           div(
             class = "weather-module",
             h3("lieu : Aotizhongxin"),
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
             )
           )
    )
  ),
  fluidRow(
    textOutput("selected_year"),
    textOutput("selected_month"),
    textOutput("slider_value"),
    textOutput("slider_value_hour"),
    textOutput("sunandmoon")
  ),
  fluidRow(
    # Another module at the bottom right
    column(4, offset = 8,
           div(
             class = "bottom-right-module",
             h3("Additional Info"),
             p("Content for the additional module goes here."),
             p("Example text or metrics.")
           )
    )
  ),
  tags$img(src = "arrow_down.png", width = "20px"),
  tags$img(src = "arrow_up.png", width = "20px")
)


server <- function(input, output, session) {
  mois <- c("jan","fev","mar","avr","mai","jun","jui","aou","sep","oct","nov","dec")
  row <- df[df$station == "Aotizhongxin" &
              df$year == 2013 &
              df$month == 3 &
              df$day == 1 &
              df$hour == 0, ]
  
  chosen_row <- reactive({
    req(input$district_radio, input$month_radio, input$custom_slider, input$custom_slider_hour)  # Ensure inputs exist
    row <- df[df$station == "Aotizhongxin" &
                df$year == as.integer(input$district_radio) &
                df$month == match(input$month_radio,mois) &
                df$day == input$custom_slider &
                df$hour == input$custom_slider_hour, ] # Include hour filter as well

    if (nrow(row) == 0) {
      return(NULL)  # Return NULL if no data exists
    } else {
      return(row)
    }
  })
  
  # Display weather data
  output$temp <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(row$TEMP, "°C")
    }
  })
  
  output$pressure <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(round(row$PRES / 1000, 2), "hPa")
    }
  })
  
  output$rain <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(row$RAIN, "mm")
    }
  })
  
  output$wind_speed <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(row$WSPM, "km/h")
    }
  })
  
  output$wd <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(row$wd)
    }
  })
  output$avg_temp <- renderText({
    row <- chosen_row()
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      paste(round(row$avg_temp,1),"°C")
    }
  })
  
  # Example weather icon (placeholder)
  output$weather_icon <- renderUI({
    tags$img(src = "weather_icon.png", width = "50px") # Replace with correct icon path
  })
  
  # Temperature trend indicator (placeholder)
  output$trend_indicator <- renderUI({
    row <- chosen_row()
    
    if (!is.null(row$avg_temp) && !is.null(row$TEMP)) {  # Check both fields exist
      if (round(row$avg_temp, 1) > row$TEMP || 
          isTRUE(all.equal(round(row$avg_temp, 1), row$TEMP))) {
        tags$img(src = "arrow_down.png", width = "20px")  # Show upward arrow
      } else {
        tags$img(src = "arrow_up.png", width = "20px")  # Show downward arrow
      }
    } else {
      return(NULL)  # Return NULL if avg_temp or TEMP are missing
    }
  })
  # Set the default value of input$district_radio to 2013 when the app initializes
  observe({
    if (is.null(input$district_radio)) {
      updateRadioButtons(session, "district_radio", selected = "2013")
      session$sendCustomMessage(type = "updateDistrictRadio", message = list(value = "2013"))
    }
  })
  # Display the selected year in text output
  output$selected_year <- renderText({
    selected_year <- input$district_radio
    if (is.null(selected_year)) {#par défaut
      selected_year <- "2013"
    }
    paste("année:", selected_year)
  })
  observe({
    if (is.null(input$month_radio)) {
      updateRadioButtons(session, "month_radio", selected = "jan")
      session$sendCustomMessage(type = "updateDistrictRadio", message = list(value = "jan"))
    }
  })
  output$selected_month <- renderText({
    selected_month <- input$month_radio
    if (is.null(selected_month)) {#par défaut
      selected_month <- "jan"
    }
    paste("mois:", selected_month)
  })
  observe({#slider jour
    slider_value <- input$custom_slider
    output$slider_value <- renderText({
      if (is.null(slider_value)) {#par défaut
        slider_value <- 3#premier mois dans le jeu de données c'est mars 2013 jour 1 heure 0
      }
      paste("jour:", slider_value)
    })
  })
  observe({#slider heure
    slider_value_hour <- input$custom_slider_hour
    output$slider_value_hour <- renderText({
      if (is.null(slider_value_hour)) {#par défaut
        slider_value_hour <- 0
      }
      paste("heure:", slider_value_hour)
    })
  })
  #partie toggle switch soleil et lune
  output$sunandmoon <- renderText({
    if (is.null(input$theme_switch_checkbox)) {
      "mode jour"  
    }
  })
  observeEvent(input$theme_switch_checkbox, {
    output$sunandmoon <- renderText({
      if (input$theme_switch_checkbox) {
        "mode nuit"
      } else {
        "mode jour"
      }
    })
  })
  #fin de partie toggle switch soleil et lune
  
}


shinyApp(ui = ui, server = server)
#runApp("projectV4.R")