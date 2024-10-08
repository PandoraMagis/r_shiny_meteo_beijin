# relativ services and fonctions logics
source("./time_series/functions/date_hell_format.r", local = TRUE)

# date selection

source("./time_series/date_selection/date_select_serveur.r", local = T)

# Server routes

# develop output
output$develop_output <- renderText({
    test_value <- "FALSE"    
    if ( test_value ) { 
        paste("omg it's broken", test_value) 
    }else{
        "everything's fine :)"
    }

    test_value <- paste( dim(df) )

})