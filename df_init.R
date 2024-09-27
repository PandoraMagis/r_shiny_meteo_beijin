library(dplyr)
library(zoo)
#df1<-read.table("PRSA_Data_Aotizhongxin_20130301-20170228.csv",sep = ",",header = TRUE,
#                stringsAsFactors = TRUE)
#df2<-read.table("PRSA_Data_Changping_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df3<-read.table("PRSA_Data_Dingling_20130301-20170228.csv",sep = ",",header = TRUE,
#                stringsAsFactors = TRUE)
#df4<-read.table("PRSA_Data_Dongsi_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df5<-read.table("PRSA_Data_Guanyuan_20130301-20170228.csv",sep = ",",header = TRUE,
#                stringsAsFactors = TRUE)
#df6<-read.table("PRSA_Data_Gucheng_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df7<-read.table("PRSA_Data_Huairou_20130301-20170228.csv",sep = ",",header = TRUE,
#                stringsAsFactors = TRUE)
#df8<-read.table("PRSA_Data_Nongzhanguan_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df9<-read.table("PRSA_Data_Shunyi_20130301-20170228.csv",sep = ",",header = TRUE,
#                stringsAsFactors = TRUE)
#df10<-read.table("PRSA_Data_Tiantan_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df11<-read.table("PRSA_Data_Wanliu_20130301-20170228.csv",sep = ",",header = TRUE,
#                 stringsAsFactors = TRUE)
#df12<-read.table("PRSA_Data_Wanshouxigong_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
#df<-bind_rows(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
#df$avg_temp_last_7 <- rollapply(df$TEMP, width = 7, FUN = mean, align = "right", fill = NA, partial = TRUE)
#View(df)
df<-read.table("df.csv",sep = ",",header = TRUE,stringsAsFactors = TRUE)
