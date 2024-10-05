df <- read.csv("dfplusIQA.csv",sep=",",dec=".",header=T,stringsAsFactors = T,fileEncoding = "utf-8")

library(ggplot2)

#réorganisation
data<-df
data$year<-as.factor(data$year)
data$month<-as.factor(data$month)
data$day<-as.factor(data$day)
data$hour<-as.factor(data$hour)
data$IQA_binaire<-as.factor(data$IQA_binaire)
summary(data)

#missing data
missing_data <- colSums(is.na(data)) / nrow(data) * 100
print(missing_data)  # View missing percentages per column

#correlations
require("corrplot")
data$IQA_binaire<-as.numeric(data$IQA_binaire)

cor_matrix <- cor(data[,c(6:15,17,20:25,27)],use = "complete.obs")
corrplot(cor_matrix, method = "number")
corrplot(cor_matrix, method = "circle")
corrplot(cor_matrix, method = "square")
corrplot(cor_matrix, method = "color")


levels(data$IQA)
data$IQA <- factor(data$IQA, levels = c("bon", "modere", "non-sain pour sensibles",
                                        "non-sain", "tres non-sain", "dangereux"))
data$IQA_numeric <- as.numeric(data$IQA)
cor_matrix <- cor(data[,c(6:15,17,20:25,27,28)],use = "complete.obs")
corrplot(cor_matrix, method = "number",type="upper")
corrplot(cor_matrix, method = "circle")
#correlations CO et PM2.5 plus élevées avec IQA_numeric que IQA_binaire donc 
#plus responsables de gros pics ?



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
ggplot(dt_melt, aes(x = concentration, fill = pollutant, color = pollutant)) +
  geom_density(alpha = 0.5) +  # Use transparency (alpha) for overlapping areas
  labs(title = "graphique des densités de la concentration des différents polluants",
       x = "concentration normalisée", y = "densité") +
  theme_minimal()



#rendre interactif?
require("patchwork")
plotPM2.5<-ggplot(data, aes(x = data$hour, y = data$PM2.5)) +
  geom_boxplot() +
  labs(title = "polluants en fonction de l'heure de la journée",
       x = "heure de la journée", y = "concentration du polluant")
plotPM10<-ggplot(data, aes(x = data$hour, y = data$PM10)) +
  geom_boxplot() +
  labs(title = "polluants en fonction de l'heure de la journée",
       x = "heure de la journée", y = "concentration du polluant")
plotPM2.5+plotPM10














