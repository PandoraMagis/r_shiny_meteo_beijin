switch_ui <- 
#switch
div(tags$head(includeCSS("./radio_selector/toggle_switch.css")),
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
    )
)