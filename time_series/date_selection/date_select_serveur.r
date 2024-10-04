observe({#slider heure
    time_s_stop_hour <- input$custom_slider_hour
    
    output$time_s_stop_hour <- renderText({
        if (is.null(time_s_stop_hour)) {#par défaut
        time_s_stop_hour <- 0
        }
        paste("heure:", time_s_stop_hour)
    })
})