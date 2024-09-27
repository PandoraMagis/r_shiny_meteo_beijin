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