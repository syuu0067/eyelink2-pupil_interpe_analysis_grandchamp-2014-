rm(list = ls())
setwd("../data")
library(ggplot2)
library(tidyverse)
library(patchwork)
library(dplyr)
library(zoo)
##解析
subject <- "s4"
mw_filename <- paste(subject, "_mw_all.csv", sep = "")
rf_filename <- paste(subject, "_rf_all.csv", sep = "")
ct_filename <- paste(subject, "_ct_all.csv", sep = "")
mw_dat <- read.csv(mw_filename)
rf_dat <- read.csv(rf_filename)
ct_dat <- read.csv(ct_filename)

mw_dat <- mw_dat % > %
  arrange(trial, time) % > %
  group_by(trial) % > %
  mutate(
    blink_count = cumsum(
      blink_duration != lag(blink_duration, default = first(blink_duration))
    )
  ) % > %
  ungroup()

rf_dat <- rf_dat % > %
  arrange(trial, time) % > %
  group_by(trial) % > %
  mutate(
    blink_count = cumsum(
      blink_duration != lag(blink_duration, default = first(blink_duration))
    )
  ) % > %
  ungroup()

ct_dat <- ct_dat % > %
  arrange(trial, time) % > %
  group_by(trial) % > %
  mutate(
    blink_count = cumsum(
      blink_duration != lag(blink_duration, default = first(blink_duration))
    )
  ) % > %
  ungroup()

rf_blink <- rf_dat % > %
  arrange(trial, time_rel) % > %
  group_by(trial) % > %
  summarise(blink_sample_counts = sum(blink_duration) * 4,
            number_of_blink = max(blink_count) / 2) % > %
  mutate(blink_duration_rate = (blink_sample_counts / 9000) * 100,
         blink_duration_mean = blink_sample_counts / number_of_blink)

mw_blink <- mw_dat % > %
  arrange(trial, time_rel) % > %
  group_by(trial) % > %
  summarise(blink_sample_counts = sum(blink_duration) * 4,
            number_of_blink = max(blink_count) / 2) % > %
  mutate(blink_duration_rate = (blink_sample_counts / 9000) * 100,
         blink_duration_mean = blink_sample_counts / number_of_blink)

ct_blink <- ct_dat % > %
  arrange(trial, time_rel) % > %
  group_by(trial) % > %
  summarise(blink_sample_counts = sum(blink_duration) * 4,
            number_of_blink = max(blink_count) / 2) % > %
  mutate(blink_duration_rate = (blink_sample_counts / 9000) * 100)


mw_temp <- mw_dat % > %
  group_by(trial) % > %
  summarise(
    pupil_slope = coef(lm(pupil ~ time))[2],
    pupil_mean = mean(pupil, na.rm = TRUE),
    pupil_sd = sd(pupil),
    blink_rate = (max(blink_count) / 2) * 6.67,
    blink_duration_epoch = if_else(
      max(blink_count) / 2 > 0,
      (sum(blink_duration) * 4) / (max(blink_count) / 2),
      0
    ),
    gaze_x_mean = mean(x),
    gaze_y_mean = mean(y),
    gaze_x_sd = sd(x),
    gaze_y_sd = sd(y),
    .groups = "drop"
  ) % > %
  mutate(
    state = "mw",
    .before = 1
  )

rf_temp <- rf_dat % > %
  group_by(trial) % > %
  summarise(
    pupil_slope = coef(lm(pupil ~ time))[2],
    pupil_mean = mean(pupil, na.rm = TRUE),
    pupil_sd = sd(pupil),
    blink_rate = (max(blink_count) / 2) * 6.67,
    blink_duration_epoch = if_else(
      max(blink_count) / 2 > 0,
      (sum(blink_duration) * 4) / (max(blink_count) / 2),
      0
    ),
    gaze_x_mean = mean(x),
    gaze_y_mean = mean(y),
    gaze_x_sd = sd(x),
    gaze_y_sd = sd(y),
    .groups = "drop"
  ) % > %
  mutate(
    state = "rf",
    .before = 1
  )

ct_temp <- ct_dat % > %
  group_by(trial) % > %
  summarise(
    pupil_slope = coef(lm(pupil ~ time))[2],
    pupil_mean = mean(pupil, na.rm = TRUE),
    pupil_sd = sd(pupil),
    blink_rate = (max(blink_count) / 2) * 6.67,
    blink_duration_epoch = if_else(
      max(blink_count) / 2 > 0,
      (sum(blink_duration) * 4) / (max(blink_count) / 2),
      0
    ),
    gaze_x_mean = mean(x),
    gaze_y_mean = mean(y),
    gaze_x_sd = sd(x),
    gaze_y_sd = sd(y),
    .groups = "drop"
  ) % > %
  mutate(
    state = "ct",
    .before = 1
  )

svm_dat <- bind_rows(mw_temp, rf_temp, ct_temp)


write.csv(svm_dat, paste(subject, "_SVM_dat.csv", sep = ""), row.names = FALSE)
