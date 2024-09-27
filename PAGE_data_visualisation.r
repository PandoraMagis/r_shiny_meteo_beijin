# Importation des fichiers UI
source("./map_selector/map_ui.R")
source("./radio_selector/radio_ui.r", local = T)
source("./data_text_buble/data_text_ui.r")
# TODO - dead code - Importation de la  fonction de transformation 
#source("utils/coord_transform.R")

page_visu_data <- tabPanel(
    nom_page_1, 
    # display flex components
    div(
        style = "display: flex; flex-direction: row;",
        div(style = "width:33% ; height : 700px", map_page_1), # Height don't work on map and it's quite ufgly to not have map and selector at same size
        div(style = "width:45%", ui_radio  ), 
        div(style = "width:33%", df_info_buble)
    ),
    # , flex = 1, width = "100%", height = "100%"
    
)