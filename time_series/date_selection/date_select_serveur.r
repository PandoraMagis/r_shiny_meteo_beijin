rv <- reactiveValues(time_series_df = NULL)

# Combiner les valeurs sélectionnées pour afficher une date et heure complète
output$selected_date_time <- renderText({
    # Créer une chaîne de caractères qui combine le mois, le jour, l'année et l'heure
    paste("Vous avez sélectionné :", 
            input$day_in, 
            input$month_in, 
            input$year_in, 
            "à", 
            sprintf("%02d:00", input$hour_in),  # Formatage de l'heure pour affichage HH:00

            "jusqu'a :",
            input$day_end, 
            input$month_end, 
            input$year_end, 
            "à", 
            sprintf("%02d:00", input$hour_end)
    )
})

observeEvent({
    input$day_in
    input$month_in
    input$year_in
    input$hour_in
    input$day_end
    input$month_end
    input$year_end
    input$hour_end
    },{
    
    rv$time_series_df <- time_stamp(
        year_start  = input$year_in,
        month_start = input$month_in,
        day_start   = input$day_in,
        hour_start  = input$hour_in,

        year_stop   = input$year_end,
        month_stop  = input$month_end,
        day_stop    = input$day_end,
        hour_stop   = input$hour_end
        )

    output$develop_output <- renderText({paste("oui:",dim(rv$time_series_df))})


})

observeEvent({
    input$day_in
    input$month_in
    input$year_in
    input$hour_in
    input$day_end
    input$month_end
    input$year_end
    input$hour_end
    # added triggers
    input$time_series_vars
    # input$periode_mod
},{
    req(rv$time_series_df)

    if (!is.null(rv$time_series_df) && length(input$time_series_vars) >= 1 ){
        output$develop_output <- renderText("")


    req(input$time_series_vars)
    
    # setup graph df
    long_data <- rv$time_series_df %>%
        tidyr::pivot_longer(cols = all_of(input$time_series_vars), 
            names_to = "variable", 
            values_to = "value"
        )

    output$line_evo_multi_var <- renderPlotly({
        plot_ly(
            long_data, 
            x       = ~date, 
            y       =~value, 
            color   = ~variable,
            type    = "scatter",
            mode    = "lines",
            colors = "Set1"
        )

    
    })
    } else {
        output$develop_output <- renderText("Selectionnez une range de données correcte pour aficher les analyse")
    }


    # x <- reactive({
    #     rv$time_series_df[,input$date]
    # })
    
    # y <- reactive({
    #     rv$time_series_df[,input$time_series_vars]
    # })

    # output$line_evo_multi_var <- renderPlotly({
    #     req(rv$time_series_df)
    #     plot_ly(rv$time_series_df, x = x(), y = y(), type = 'scatter', mode = 'lines')
    # })


})