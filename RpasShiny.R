df <- read.table("df.csv",sep=",",header=T,stringsAsFactors = T)

#réorganisation
data<-df
data$year<-as.factor(data$year)
data$month<-as.factor(data$month)
data$day<-as.factor(data$day)
data$hour<-as.factor(data$hour)
summary(data)

require("corrplot")
cor_matrix <- cor(data[,c(6:15,17)],use = "complete.obs")
corrplot(cor_matrix, method = "circle")
corrplot(cor_matrix, method = "square")
corrplot(cor_matrix, method = "number")
corrplot(cor_matrix, method = "color")


#Indice de la Qualité de l'Air (IQA)
df_IQA <- read.table("AQI_INDEX.csv",sep=",",header=TRUE,stringsAsFactors = TRUE)
df_IQA <- df_IQA[1:35,1:5]
summary(df_IQA)

#IQA pour PM2.5
df_polluant <- df_IQA[df_IQA$polluant == "pm2_5",]
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqi<-sapply(data$PM2.5, get_first_index)#index du premier TRUE
data$index_high_pm25 <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low_pm25 <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high_pm25 <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low_pm25 <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQAPM2.5 <- (data$index_high_pm25 - data$index_low_pm25)/(data$C_high_pm25-data$C_low_pm25)*(data$PM2.5-data$C_low_pm25)+data$index_low_pm25

#IQA pour PM10
df_polluant <- df_IQA[df_IQA$polluant == "pm10",]
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqipm10<-sapply(data$PM10, get_first_index)#index du premier TRUE
data$index_high_pm10 <- sapply(data$row_aqipm10, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low_pm10 <- sapply(data$row_aqipm10, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high_pm10 <- sapply(data$row_aqipm10, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low_pm10 <- sapply(data$row_aqipm10, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQAPM10 <- (data$index_high_pm10 - data$index_low_pm10)/(data$C_high_pm10-data$C_low_pm10)*(data$PM10-data$C_low_pm10)+data$index_low_pm10


#IQA pour SO2
df_polluant <- df_IQA[df_IQA$polluant == "so2",]
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqi<-sapply(data$S02, get_first_index)#index du premier TRUE
data$index_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQAS02 <- (data$index_high - data$index_low)/(data$C_high-data$C_low)*(data$SO2-data$C_low)+data$index_low

#IQA pour CO
df_polluant <- df_IQA[df_IQA$polluant == "co",]
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqi<-sapply(data$CO/100, get_first_index)#index du premier TRUE
data$index_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQACO <- (data$index_high - data$index_low)/(data$C_high-data$C_low)*(data$CO/100-data$C_low)+data$index_low


#IQA pour NO2
df_polluant <- df_IQA[df_IQA$polluant == "no2",]
df_polluant[1,3]<-0
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqi<-sapply(data$NO2, get_first_index)#index du premier TRUE
data$index_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQANO2 <- (data$index_high - data$index_low)/(data$C_high-data$C_low)*(data$NO2-data$C_low)+data$index_low


#IQA pour 03
df_polluant <- df_IQA[df_IQA$polluant == "O3",]
get_first_index <- function(pm_value) {
  index <- which(pm_value < c(df_polluant$concentration_sup))[1]
  if (is.na(index)) {
    return(NA)
  } else {
    return(index)
  }
}
data$row_aqi<-sapply(data$O3, get_first_index)#index du premier TRUE
data$index_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_sup[index])
  } else {
    return(NA)
  }
})
data$index_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$aqi_range_inf[index])
  } else {
    return(NA)
  }
})
data$C_high <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_sup[index])
  } else {
    return(NA)
  }
})
data$C_low <- sapply(data$row_aqi, function(index) {
  if (!is.na(index)) {
    return(df_polluant$concentration_inf[index])
  } else {
    return(NA)
  }
})

data$IQAO3 <- (data$index_high - data$index_low)/(data$C_high-data$C_low)*(data$O3-data$C_low)+data$index_low



df$IQA_PM2.5 <- data$IQAPM2.5
df$IQA_PM10 <- data$IQAPM10
df$IQA_SO2 <- data$IQAS02
df$IQA_CO <- data$IQACO
df$IQA_NO2 <- data$IQANO2
df$IQA_O3 <- data$IQAO3

write.csv(df, file = "dfplusIQA.csv", row.names = FALSE)
write.table(df, file = "df.txt", sep = "\t", row.names = FALSE)

df<-read.table("dfplusIQA.csv",sep=",",header=T,stringsAsFactors = T)
data<-df
data$year<-as.factor(data$year)
data$month<-as.factor(data$month)
data$day<-as.factor(data$day)
data$hour<-as.factor(data$hour)
summary(data)
data$IQA <- sapply(1:nrow(data), function(i) {
  # Check if the index is valid
  if (!is.na(data$IQA_PM2.5[i]) && !is.na(data$IQA_PM10[i]) && !is.na(data$IQA_SO2[i]) && 
      !is.na(data$IQA_CO[i]) && !is.na(data$IQA_NO2[i]) && !is.na(data$IQA_O3[i])) {
    
    # Check conditions
    if (!(data$IQA_PM2.5[i] > 50 | data$IQA_PM10[i] > 50 | data$IQA_SO2[i] > 50 | 
          data$IQA_CO[i] > 50 | data$IQA_NO2[i] > 50 | data$IQA_O3[i] > 50)) {
      return("bon")
    } else if (!(data$IQA_PM2.5[i] > 100 | data$IQA_PM10[i] > 100 | data$IQA_SO2[i] > 100 | 
                 data$IQA_CO[i] > 100 | data$IQA_NO2[i] > 100 | data$IQA_O3[i] > 100)) {
      return("modéré")
    } else if (!(data$IQA_PM2.5[i] > 150 | data$IQA_PM10[i] > 150 | data$IQA_SO2[i] > 150 | 
                 data$IQA_CO[i] > 150 | data$IQA_NO2[i] > 150 | data$IQA_O3[i] > 150)) {
      return("non-sain pour sensibles")
    } else if (!(data$IQA_PM2.5[i] > 200 | data$IQA_PM10[i] > 200 | data$IQA_SO2[i] > 200 | 
                 data$IQA_CO[i] > 200 | data$IQA_NO2[i] > 200 | data$IQA_O3[i] > 200)) {
      return("non-sain")
    } else if (!(data$IQA_PM2.5[i] > 300 | data$IQA_PM10[i] > 300 | data$IQA_SO2[i] > 300 | 
                 data$IQA_CO[i] > 300 | data$IQA_NO2[i] > 300 | data$IQA_O3[i] > 300)) {
      return("très non-sain")
    } else {
      return("dangereux")
    }
  } else {
    return(NA)  # Return NA if any of the values are NA
  }
})
data$IQA_binaire <- sapply(1:nrow(data), function(i) {
  # Check if the index is valid
  if (!is.na(data$IQA_PM2.5[i]) && !is.na(data$IQA_PM10[i]) && !is.na(data$IQA_SO2[i]) && 
      !is.na(data$IQA_CO[i]) && !is.na(data$IQA_NO2[i]) && !is.na(data$IQA_O3[i])) {
    
    # Check conditions
    if (!(data$IQA_PM2.5[i] > 50 | data$IQA_PM10[i] > 50 | data$IQA_SO2[i] > 50 | 
          data$IQA_CO[i] > 50 | data$IQA_NO2[i] > 50 | data$IQA_O3[i] > 50)) {
      return(0)
    } else if (!(data$IQA_PM2.5[i] > 100 | data$IQA_PM10[i] > 100 | data$IQA_SO2[i] > 100 | 
                 data$IQA_CO[i] > 100 | data$IQA_NO2[i] > 100 | data$IQA_O3[i] > 100)) {
      return(0)
    } else if (!(data$IQA_PM2.5[i] > 150 | data$IQA_PM10[i] > 150 | data$IQA_SO2[i] > 150 | 
                 data$IQA_CO[i] > 150 | data$IQA_NO2[i] > 150 | data$IQA_O3[i] > 150)) {
      return(0)
    } else if (!(data$IQA_PM2.5[i] > 200 | data$IQA_PM10[i] > 200 | data$IQA_SO2[i] > 200 | 
                 data$IQA_CO[i] > 200 | data$IQA_NO2[i] > 200 | data$IQA_O3[i] > 200)) {
      return(1)
    } else if (!(data$IQA_PM2.5[i] > 300 | data$IQA_PM10[i] > 300 | data$IQA_SO2[i] > 300 | 
                 data$IQA_CO[i] > 300 | data$IQA_NO2[i] > 300 | data$IQA_O3[i] > 300)) {
      return(1)
    } else {
      return(1)
    }
  } else {
    return(NA)  # Return NA if any of the values are NA
  }
})
View(data)
write.csv(data, file = "dfplusIQA.csv", row.names = FALSE)






