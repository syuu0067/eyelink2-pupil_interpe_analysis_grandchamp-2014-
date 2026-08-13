#除外用コード
rm(list=ls())
setwd("~/pupil/data")
library(dplyr)

#データ取込
subject <- "s1"
data_num <- 2
data_num <- sprintf("%02d",data_num)
mw_name <- paste(subject,data_num,"_mw_dat.csv", sep="")
mw_data <- read.csv(mw_name)
rf_name <- paste(subject,data_num,"_rf_dat.csv", sep="")
rf_data <- read.csv(rf_name)
#実行列
mw_trial_summary <- mw_data %>%
  arrange(trial,time) %>%
  group_by(trial)%>%
  summarise(
    interped_rate = mean(interped, na.rm = TRUE) * 100,
    .groups = "drop"
  )

mw_eject_trial <- mw_trial_summary %>%
  filter(interped_rate >= 40)

mw_eject_num <- mw_eject_trial$trial

mw_ejected_dat <- mw_data %>%
  dplyr::filter(!trial %in% mw_eject_num)

##保存
write.csv(mw_ejected_dat,mw_name,row.names = FALSE)

#実行列
rf_trial_summary <- rf_data %>%
  arrange(trial,time) %>%
  group_by(trial)%>%
  summarise(
    interped_rate = mean(interped, na.rm = TRUE) * 100,
    .groups = "drop"
  )

rf_eject_trial <- rf_trial_summary %>%
  filter(interped_rate >= 40)

rf_eject_num <- rf_eject_trial$trial

rf_ejected_dat <- rf_data %>%
  dplyr::filter(!trial %in% rf_eject_num)

##保存
write.csv(rf_ejected_dat,rf_name,row.names = FALSE)


print(mw_trial_summary)

print(rf_trial_summary)

