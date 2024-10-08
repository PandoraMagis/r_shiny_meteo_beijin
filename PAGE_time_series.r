source("./time_series/date_selection/date_selection_ui.r")

page_time_series <- tabPanel(
    "Etude des séries temporelles",

    h1("time to analyse time it self"),
    date_selection_ui,

# Need the map

# need two time selector - maybe choising an other desing so it's easilly

# one with dr who box in original and one bigger on the insdide (i'm freestyling rn let's be honest)

# quali factor as levels on graphs evolving by tp + arrange quali factor by proximity

# quanti as std evolutionary graph
    div(textOutput("time_s_stop_hour"))
)