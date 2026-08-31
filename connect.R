##ファイル結合用　同一被験者のみに適用すること
rm(list = ls())
setwd("../data")
library(ggplot2)
library(tidyverse)
library(patchwork)
library(dplyr)
library(zoo)

subject <- "s1"

i <- 1 ##Don't touch!
f <- i
mwdat <- list()
repeat{
  f <- sprintf("%02d",i)
  mw_file_name <- paste(subject, f, "_mw_dat.csv", sep = "")
  if(!file.exists(mw_file_name)) {
    break
  }
  mwdat[[i]] <- read.csv(mw_file_name)
  i <- i + 1
}

mw_all_data <- bind_rows(mwdat, .id = "file_id")

mw_all_data <- mw_all_data%>%
  mutate(trial = consecutive_id(file_id, trial))

write.csv(mw_all_data,paste(subject, "_mw_all.csv", sep = ""),row.names = FALSE)

i <- 1 ##Don't touch!
f <- i
rfdat <- list()
repeat{
  f <- sprintf("%02d",i)
  rf_file_name <- paste(subject, f, "_rf_dat.csv", sep = "")
  if(!file.exists(rf_file_name)) {
    break
  }
  rfdat[[i]] <- read.csv(rf_file_name)
  i <- i + 1
}

rf_all_data <- bind_rows(rfdat, .id = "file_id")

rf_all_data <- rf_all_data%>%
  mutate(trial = consecutive_id(file_id, trial))

write.csv(rf_all_data,paste(subject, "_rf_all.csv", sep = ""),row.names = FALSE)

i <- 1 ##Don't touch!
f <- i
ctdat <- list()
repeat{
  f <- sprintf("%02d",i)
  ct_file_name <- paste(subject, f, "_ct_dat.csv", sep = "")
  if(!file.exists(ct_file_name)) {
    break
  }
  ctdat[[i]] <- read.csv(ct_file_name)
  i <- i + 1
}

ct_all_data <- bind_rows(ctdat, .id = "file_id")

ct_all_data <- ct_all_data%>%
  mutate(trial = consecutive_id(file_id, trial))

write.csv(ct_all_data,paste(subject, "_ct_all.csv", sep = ""),row.names = FALSE)