
source("./correlations/corr_ui.R", local = T)


page_visu_correlations <- tabPanel(
  "Analyse exploratoire des données", 
  # display flex components
  div(
    p("chargement des plots...")
  ),
  div(
    div(correlations_number) # Map on top
    #div(style = "flex: 0 0 30%; height: auto;", densites_polluants)    # Reduce size of ui_radio (e.g., 30% of the left side height)
  ),
)