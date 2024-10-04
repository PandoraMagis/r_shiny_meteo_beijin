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
    style = "display: flex; flex-direction: row; height: 100vh;", # Flex row to split the page into two parts (left and right)
    
    # Left side: map above the radio buttons
    div(
      style = "width: 50%; display: flex; flex-direction: column;", # Flex column for left part
      div(style = "flex: 1; height: 50%;", map_page_1), # Map on top
      div(style = "flex: 0 0 30%; height: auto;", ui_radio)    # Reduce size of ui_radio (e.g., 30% of the left side height)
    ),
    
    # Right side: info bubble
    div(style = "width: 50%;", df_info_buble) # Right part
  )
)