# daily_data

daily_data_skim <- skim(daily_data)

sleep <- daily_data %>%
  group_by(Id) %>%
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed)
