#除外用コード
rm(list=ls())
setwd("~/pupil/data")
library(dplyr)

#データ取込
subject <- "s1"
data_num <- 2
data_num <- sprintf("%02d",data_num)
file_name <- paste(subject,data_num,"_mw_dat.csv", sep="")
data <- read.csv(file_name)

#実行列
eject_trial <- data %>%
  arrange(trial,time) %>%
  group_by(trial)%>%
  summarise(
    interped_rate = mean(interped, na.rm = TRUE) * 100,
    .groups = "drop"
  )%>%
  filter(interped_rate > 40)

eject_num <- eject_trial$trial

ejected_dat <- data %>%
  dplyr::filter(trial !=eject_num)

##保存
write.csv(ejected_dat,file_name,row.names = FALSE)

