# fixed values visual presentation
mois <- c("jan","fev","mar","avr","mai","jun","jui","aou","sep","oct","nov","dec")

row <- df[df$station == "Aotizhongxin" &
              df$year == 2013 &
              df$month == 3 &
              df$day == 1 &
              df$hour == 0, ]
  
chosen_row <- reactive({
    # Ensure inputs exist
    req(
        input$map_marker_click,
        input$district_radio, 
        input$month_radio, 
        input$custom_slider, 
        input$custom_slider_hour
    )
    # Include hour filter as well
    row <- df[df$station == input$map_marker_click$id &
                df$year == as.integer(input$district_radio) &
                df$month == match(input$month_radio,mois) &
                df$day == input$custom_slider &
                df$hour == input$custom_slider_hour, 
    ] 

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
  output$index_IQA <- renderText({
    row <- chosen_row()
    
    if (is.null(row)) {
      "!!"  # Show "!!" if no data exists
    } else {
      iqa_value <- row$IQA
      color <- ""
      
      # Define color based on IQA value
      if (iqa_value == "bon") {
        color <- "green"
      } else if (iqa_value == "modéré") {
        color <- "blue"
      } else if (iqa_value == "non-sain pour sensibles") {
        color <- "yellow"
      } else if (iqa_value == "non-sain") {
        color <- "orange"
      } else if (iqa_value == "très non-sain") {
        color <- "red"
      } else if (iqa_value == "dangereux") {
        color <- "purple"
      }
      
      # Return HTML styled text with color
      paste0('<span style="color:', color, ';">l\'Index de Qualité de l\'Air --IQA--: ', iqa_value, '</span>')
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

