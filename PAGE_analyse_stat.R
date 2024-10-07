
source("./analyse_stat/analyse_stat_ui.R", local = T)


page_visu_analyse_stat <- tabPanel(
  "analyse statistiques", 
  # display flex components
  div(
    p("chargement des plots...")
  ),
  div(
    div(analyse_stat_ui) # Map on top
    #div(style = "flex: 0 0 30%; height: auto;", densites_polluants)    # Reduce size of ui_radio (e.g., 30% of the left side height)
  ),
)