# Beijin meteo data - Aanalysis using R shiny package

For our master 2 and last year of ingenior cycle we want to get used to the [Rshiny](https://shiny.posit.co/py/docs/comp-r-shiny.html) Package and drive an statistical analysis based on metorological datafrom the beijin city aka Pekin in french, capital of China.

---

Is it possible to predict polluant spike with our data ?
Does some metrics or factor influence the pollution levels.

## About

-   File structure ideas for now \*

## Getting started

## Material

### Data set

https://archive.ics.uci.edu/dataset/501/beijing+multi+site+air+quality+data comes from [this paper : Cautionary tales on air-quality improvement in Beijing
Shuyi Zhang, Bin Guo, Anlan Dong, Jing He, Ziping Xu, S. Chen](https://www.semanticscholar.org/paper/Cautionary-tales-on-air-quality-improvement-in-Zhang-Guo/59c99a7bf19617b43be0aa9f492def8c80ffae19)

### Package

-   rhsiny : version xx
-   data.table : version xx

## Methods

### statistic approach

Comment vars liées une aux autre

-   Biejin data
    1. Data visualisation
        1. Geogrpahical between station
        1. Varriation / repetition in years
        1. Evol temperature over time space
        1. Shiny package pie chart on map
        1. CCL data vis -> 1st global understanding of the data
    2. Dimention reduction
        1. ACP qualité air
        1. ACP chq poluant
        1. ACP random row line and columns if data set or varriation not enough
        1. t-SNE
        1. u-MAP
        1. CCL 1 : paterns / interaction / correlation possible of vars
    3. others
        1. mat correlation res ~ fa -> covarriate of two factor entre eux
    4. Modele lineaire
        1. lm simple
        1. lm intereaction
        1. lm complet
        1. CCL 2 : confirmation dim reduc approach
    5. Hhhhhhhh
