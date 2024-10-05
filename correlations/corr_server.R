library(shiny)

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

output$missing_data <- renderText({
  data<-df
  data$year<-as.factor(data$year)
  data$month<-as.factor(data$month)
  data$day<-as.factor(data$day)
  data$hour<-as.factor(data$hour)
  data$IQA_binaire<-as.factor(data$IQA_binaire)
  summary(data)
  missing_data <- colSums(is.na(data)) / nrow(data) * 100
  formatted_data <- paste(names(missing_data), ":", round(missing_data, 2), "%", collapse = ", ")
  paste("donnees manquantes par colonne en pourcentage:", formatted_data)  
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



