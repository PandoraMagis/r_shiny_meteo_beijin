# relativ services and fonctions logics
source("./time_series/functions/date_hell_format.r", local = TRUE)

# Server routes

# develop output
output$develop_output <- renderText({
    test_value <- FALSE    
    if ( test_value ) { 
        paste("omg it's broken", test_value) 
    }else{
        "everything's fine :)"
    }
})



# date selection

# copy paste of how it's manage in 1st part - great to have vars name right at proximity
    # req(
    #     input$map_marker_click,
    #     input$district_radio, 
    #     input$month_radio, 
    #     input$custom_slider, 
    #     input$custom_slider_hour
    # )
    # # Include hour filter as well
    # row <- df[df$station == input$map_marker_click$id &
    #             df$year == as.integer(input$district_radio) &
    #             df$month == match(input$month_radio,mois) &
    #             df$day == input$custom_slider &
    #             df$hour == input$custom_slider_hour, ]