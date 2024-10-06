library(shiny)
library(ggplot2)
#df <- read.csv("dfplusIQA.csv",sep=",",dec=".",header=T,stringsAsFactors = T,fileEncoding = "utf-8")


#réorganisation
data<-df
data$year<-as.factor(data$year)
data$month<-as.factor(data$month)
data$day<-as.factor(data$day)
data$hour<-as.factor(data$hour)
data$IQA_binaire<-as.factor(data$IQA_binaire)
summary(data)

#correlations
require("corrplot")
data$IQA_binaire<-as.numeric(data$IQA_binaire)

#cor_matrix <- cor(data[,c(6:15,17,20:25,27)],use = "complete.obs")
#corrplot(cor_matrix, method = "number")
#corrplot(cor_matrix, method = "circle")
#corrplot(cor_matrix, method = "square")
#corrplot(cor_matrix, method = "color")


levels(data$IQA)
data$IQA <- factor(data$IQA, levels = c("bon", "modere", "non-sain pour sensibles",
                                        "non-sain", "tres non-sain", "dangereux"))
data$IQA_numeric <- as.numeric(data$IQA)
#cor_matrix <- cor(data[,c(6:15,17,20:25,27,28)],use = "complete.obs")
#corrplot(cor_matrix, method = "number",type="upper")
#corrplot(cor_matrix, method = "circle")
#correlations CO et PM2.5 plus élevées avec IQA_numeric que IQA_binaire donc 
#plus responsables de gros pics ?

output$missing_data <- renderUI({
  data <- df
  data$year <- as.factor(data$year)
  data$month <- as.factor(data$month)
  data$day <- as.factor(data$day)
  data$hour <- as.factor(data$hour)
  data$IQA_binaire <- as.factor(data$IQA_binaire)
  
  # Calculate the percentage of missing data
  missing_data <- colSums(is.na(data)) / nrow(data) * 100
  
  # Create an HTML string with color-coding based on missing data percentage
  formatted_data <- sapply(seq_along(missing_data), function(i) {
    column_name <- names(missing_data)[i]
    missing_percent <- round(missing_data[i], 2)
    
    if (missing_percent == 0) {
      color <- "#004d00"  
    } else if (missing_percent <= 2.5) {
      color <- "#00b300"  
    } else if (missing_percent <= 6) {
      color <- "#cccc00"  
    } else if (missing_percent <= 12) {
      color <- "#cc8500"  
    } else {
      color <- "#FF0000"  
    }
    
    # Return HTML span with color
    paste0("<span style='color:", color, "'>", column_name, ": ", missing_percent, "%</span>")
  })
  
  # Join all columns with a comma and return as HTML
  HTML(paste("Données manquantes par colonne en pourcentage:", paste(formatted_data, collapse = ", ")))
})


#df$pollutant_ma <- rollmean(df$pollutant_variable, k = 24, fill = NA)  # 24-hour moving average

#densité polluants
require("reshape2")
min_max_normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}
data <- data[complete.cases(data), ]  #enlève NAs
data$PM2.5norm <- min_max_normalize(data$PM2.5)
data$PM10norm <- min_max_normalize(data$PM10)
data$NO2norm <- min_max_normalize(data$NO2)
data$O3norm <- min_max_normalize(data$O3)
data$SO2norm <- min_max_normalize(data$SO2)
data$COnorm <- min_max_normalize(data$CO)
dt_melt <- melt(data, id.vars = "day", measure.vars = c("PM2.5norm", "PM10norm", "SO2norm","COnorm","NO2norm","O3norm"),
                variable.name = "pollutant", value.name = "concentration")
# Plot density for each pollutant
page_corr.plot_densite <- ggplot(dt_melt, aes(x = concentration, fill = pollutant, color = pollutant)) +
  geom_density(alpha = 0.5) +  # Use transparency (alpha) for overlapping areas
  labs(title = "graphique des densités de la concentration des différents polluants",
       x = "concentration normalisée", y = "densité") +
  theme_minimal()



output$corrPlot <- renderPlot({
  # Subset numeric columns and calculate correlation matrix
  cor_matrix <- cor(data[,c(6:15,17,20:25,27,28)],use = "complete.obs")
  
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
  plotPM2.5<-ggplot(data, aes_string(x = x_var, y = data$PM2.5)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de PM2.5 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant PM2.5")
  plotPM10<-ggplot(data, aes_string(x = x_var, y = data$PM10)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de PM10 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant PM10")
  (plotPM2.5+plotPM10)
})
output$boxplots_horaires2 <- renderPlot({
  x_var <- input$time_period
  plotSO2<-ggplot(data, aes_string(x = x_var, y = data$SO2)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de SO2 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant SO2")
  plotNO2<-ggplot(data, aes_string(x = x_var, y = data$NO2)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de NO2 et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant NO2")
  (plotSO2+plotNO2)
})
output$boxplots_horaires3 <- renderPlot({
  x_var <- input$time_period
  plotCO<-ggplot(data, aes_string(x = x_var, y = data$CO)) +
    geom_boxplot() +
    labs(title = "boxplot concentration de CO et temps",
         x = paste("variable plage de temps: ",x_var), y = "concentration du polluant CO")
  plotO3<-ggplot(data, aes_string(x = x_var, y = data$O3)) +
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
  mod <- lm(formula, data = data)
  signif <- emmeans(mod, specs = x_var, data = data)
  signif_summary <- as.data.frame(summary(signif))
  DT::datatable(signif_summary, options = list(pageLength = 25, autoWidth = TRUE))
})

