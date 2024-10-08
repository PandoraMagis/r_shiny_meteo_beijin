library(shiny)
library(ggplot2)
#df <- read.csv("dfplusIQA.csv",sep=",",dec=".",header=T,stringsAsFactors = T,fileEncoding = "utf-8")


#réorganisation
data_corr<-df
data_corr$year<-as.factor(data_corr$year)
data_corr$month<-as.factor(data_corr$month)
data_corr$day<-as.factor(data_corr$day)
data_corr$hour<-as.factor(data_corr$hour)
data_corr$IQA_binaire<-as.factor(data_corr$IQA_binaire)
summary(data_corr)

#correlations
require("corrplot")
data_corr$IQA_binaire<-as.numeric(data_corr$IQA_binaire)

#cor_matrix <- cor(data_corr[,c(6:15,17,20:25,27)],use = "complete.obs")
#corrplot(cor_matrix, method = "number")
#corrplot(cor_matrix, method = "circle")
#corrplot(cor_matrix, method = "square")
#corrplot(cor_matrix, method = "color")


levels(data_corr$IQA)
data_corr$IQA <- factor(data_corr$IQA, levels = c("bon", "modere", "non-sain pour sensibles",
                                        "non-sain", "tres non-sain", "dangereux"))
data_corr$IQA_numeric <- as.numeric(data_corr$IQA)
#cor_matrix <- cor(data_corr[,c(6:15,17,20:25,27,28)],use = "complete.obs")
#corrplot(cor_matrix, method = "number",type="upper")
#corrplot(cor_matrix, method = "circle")
#correlations CO et PM2.5 plus élevées avec IQA_numeric que IQA_binaire donc 
#plus responsables de gros pics ?

output$missing_data <- renderUI({
  data_corr <- df
  data_corr$year <- as.factor(data_corr$year)
  data_corr$month <- as.factor(data_corr$month)
  data_corr$day <- as.factor(data_corr$day)
  data_corr$hour <- as.factor(data_corr$hour)
  data_corr$IQA_binaire <- as.factor(data_corr$IQA_binaire)
  
  # Calculate the percentage of missing data_corr
  missing_data <- colSums(is.na(data_corr)) / nrow(data_corr) * 100
  
  # Prepare data for kable
  missing_summary <- data.frame(
    Column = names(missing_data),
    Missing_Percentage = round(missing_data, 2)
  )
  
  # Create a kable table with color-coding based on missing data percentage
  kable_output <- missing_summary %>%
    select(Missing_Percentage) %>%  # Keep only the second column
    kable("html", escape = FALSE, col.names = c("données manquantes (en %)")) %>%
    kable_styling("striped", full_width = F) %>%
    row_spec(0, bold = TRUE) %>%  # Bold header row
    row_spec(1:nrow(missing_summary), 
             background = case_when(
               missing_summary$Missing_Percentage == 0 ~ "#FFFFFF",  # Light green for 0%
               missing_summary$Missing_Percentage <= 2.5 ~ "#d0f0c0",  # Light green
               missing_summary$Missing_Percentage <= 6 ~ "#fffacd",    # Light yellow
               missing_summary$Missing_Percentage <= 12 ~ "#ffebcc",   # Light orange
               TRUE ~ "#ffcccb"  # Light red
             )
    ) %>%
    column_spec(c(1,2), color = sapply(missing_summary$Missing_Percentage, function(x) {
      if (x == 0) {
        "#004d00"  # Dark green
      } else if (x <= 2.5) {
        "#00b300"  # Green
      } else if (x <= 6) {
        "#cccc00"  # Yellow
      } else if (x <= 12) {
        "#cc8500"  # Orange
      } else {
        "#FF0000"  # Red
      }
    }))
  
  # Return the HTML table
  HTML(kable_output)
})


#df$pollutant_ma <- rollmean(df$pollutant_variable, k = 24, fill = NA)  # 24-hour moving average

#densité polluants
require("reshape2")
min_max_normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}
data_corr <- data_corr[complete.cases(data_corr), ]  #enlève NAs
data_corr$PM2.5norm <- min_max_normalize(data_corr$PM2.5)
data_corr$PM10norm <- min_max_normalize(data_corr$PM10)
data_corr$NO2norm <- min_max_normalize(data_corr$NO2)
data_corr$O3norm <- min_max_normalize(data_corr$O3)
data_corr$SO2norm <- min_max_normalize(data_corr$SO2)
data_corr$COnorm <- min_max_normalize(data_corr$CO)
dt_melt <- melt(data_corr, id.vars = "day", measure.vars = c("PM2.5norm", "PM10norm", "SO2norm","COnorm","NO2norm","O3norm"),
                variable.name = "pollutant", value.name = "concentration")
# Plot density for each pollutant
page_corr.plot_densite <- ggplot(dt_melt, aes(x = concentration, fill = pollutant, color = pollutant)) +
  geom_density(alpha = 0.5) +  # Use transparency (alpha) for overlapping areas
  labs(title = "graphique des densités de la concentration des différents polluants",
       x = "concentration normalisée", y = "densité") +
  theme_minimal()



output$corrPlot <- renderPlot({
  # Subset numeric columns and calculate correlation matrix
  cor_matrix <- cor(data_corr[,c(6:15,17,20:25,27,28)],use = "complete.obs")
  
  # Plot corrplot
  corrplot(cor_matrix, method = "circle", type = "upper", tl.col = "black")
})

output$densitePlot <- renderPlot({
  page_corr.plot_densite <- ggplot(dt_melt, aes(x = concentration, fill = pollutant, color = pollutant)) +
    geom_density(alpha = 0.5) +  # Use transparency (alpha) for overlapping areas
    labs(title = "graphique des densités de la concentration des différents polluants",
         x = "concentration normalisée", y = "densité") +
    theme_minimal()
  page_corr.plot_densite
})

output$boxplots_horaires1 <- renderPlot({
  x_var <- input$time_period
  require("patchwork")
  plotPM2.5<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$PM2.5)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de PM2.5 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant PM2.5")
  plotPM10<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$PM10)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de PM10 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant PM10")
  (plotPM2.5+plotPM10)
})
output$boxplots_horaires2 <- renderPlot({
  x_var <- input$time_period
  plotSO2<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$SO2)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de SO2 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant SO2")
  plotNO2<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$NO2)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de NO2 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant NO2")
  (plotSO2+plotNO2)
})
output$boxplots_horaires3 <- renderPlot({
  x_var <- input$time_period
  plotCO<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$CO)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de CO et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant CO")
  plotO3<-ggplot(data_corr, aes_string(x = x_var, y = data_corr$O3)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de O3 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant O3")
  (plotCO+plotO3)
})
require("DT")
output$emmeansplots <- DT::renderDataTable({
  require("emmeans")
  x_var <- input$time_period
  y_var <- input$polluant_select_emmeans
  formula <- as.formula(paste(y_var,"~", x_var))
  mod <- lm(formula, data = data_corr)
  signif <- emmeans(mod, specs = x_var, data = data_corr)
  signif_summary <- as.data.frame(summary(signif))
  datatable_output <- DT::datatable(signif_summary, options = list(pageLength = 25, autoWidth = TRUE)) %>%
    DT::formatStyle(
      columns = c(2),          # Specify columns 3 and 4
      fontWeight = 'bold'          # Set font weight to bold
    )
  
  return(datatable_output)
})

