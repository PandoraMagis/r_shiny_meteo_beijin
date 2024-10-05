
source("./correlations/corr_ui.R", local = T)


page_visu_correlations <- tabPanel(
  "page visualisation des corrélations", 
  # display flex components
  div(
    p("chargement des plots...")
  ),
  div(
    div(correlations_number) # Map on top
    #div(style = "flex: 0 0 30%; height: auto;", densites_polluants)    # Reduce size of ui_radio (e.g., 30% of the left side height)
  ),
)