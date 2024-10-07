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
    input$periode_mod
},{
    req(rv$time_series_df)
    print(input$time_series_vars)

    if (!is.null(rv$time_series_df) && length(input$time_series_vars) >= 1 ){
        output$develop_output <- renderText("")
        # data  visualisation

        # Configuration de l'espace de graphique
        # num_plots <- length(input$time_series_vars)
        # par(mfrow = c(num_plots, 1))   # Disposition des graphiques

        # # Création d'un boxplot
        # output$visu_time_series_single_var <- renderPlot({lapply(
        #     input$selectedVariables, function(var) {
        #         # Créer un boxplot pour chaque variable sélectionnée
        #         boxplot(data[[var]] ~ data[[input$periode_mod]], 
        #                 main = paste("Box Plot de", var, "par Temps"), 
        #                 xlab = "Temps", 
        #                 ylab = var,
        #                 col = "lightblue")
        # })})
        # par(mfrow = c(1, 1))
        output$visu_time_series_single_var <- renderPlot({
            boxplot(rv$time_series_df[[input$time_series_vars]] ~ rv$time_series_df[[input$periode_mod]])
        })

    output$line_evo_multi_var <- renderPlotly({
        plot_ly(rv$time_series_df, x = rv$time_series_df[,input$date], y = rv$time_series_df[,input$time_series_vars], type = 'scatter', mode = 'lines')
    })



    } else {
        output$develop_output <- renderText("Selectionnez une range de données correcte pour aficher les analyse")
    }
    x <- reactive({
        rv$time_series_df[,input$date]
    })
    
    y <- reactive({
        rv$time_series_df[,input$time_series_vars]
    })

    output$line_evo_multi_var <- renderPlotly({
        req(rv$time_series_df)
        if (!is.null(rv$time_series_df)){
            plot_ly(rv$time_series_df, x = x(), y = y(), type = 'scatter', mode = 'lines')
        }
    })


})