list.files(path = "data/original_data") # obtain a list of data files

# Load data files
daily_activity <- read_csv("data/original_data/dailyActivity_merged.csv")
daily_steps <- read_csv("data/original_data/dailySteps_merged.csv")
daily_intensities <- read_csv("data/original_data/dailyIntensities_merged.csv")
daily_calories <- read_csv("data/original_data/dailyCalories_merged.csv")
daily_sleep <- read_csv("data/original_data/sleepDay_merged.csv")
daily_weight <- read_csv("data/original_data/weightLogInfo_merged.csv")

# Comparing daily_activity vs daily_steps. 'Id' columns are the same, and for
# the columns 'ActivityDate' and 'TotalSteps' the only thing that changes is the
# name of the column, so I 'discard daily_steps_merged.csv'
compare(daily_activity, daily_steps, max_diffs = Inf)
compare(daily_activity$ActivityDate, daily_steps$ActivityDay)
compare(daily_activity$TotalSteps, daily_steps$StepTotal)

# Comparing daily_activity vs daily_intensities. All columns are the same,
# except for 'ActivityDate' where the only thing that changes is the name of the
# column, so I discard 'dailyIntensities_merged.csv'
compare(daily_activity, daily_intensities, max_diffs = Inf)
compare(daily_activity$ActivityDate, daily_intensities$ActivityDay)

# Comparing daily_activity vs daily_calories. All columns are the same, except
# for 'ActivityDate' where the only thing that changes is the name of the
# column, so I discard 'dailyCalories_merged.csv'
compare(daily_activity, daily_calories, max_diffs = Inf)
compare(daily_activity$ActivityDate, daily_calories$ActivityDay)

# Unify date formats in order to merge files
daily_activity %<>%
  mutate(ActivityDate = mdy(ActivityDate))
daily_sleep %<>%
  mutate(SleepDay = as_date(mdy_hms(SleepDay)))
daily_weight %<>%
  mutate(Date = as_date(mdy_hms(Date)))

# Merge files
daily_data <- left_join(daily_activity, daily_sleep,
                        by = c("Id" = "Id", "ActivityDate" = "SleepDay")) %>%
  left_join(., daily_weight, by = c("Id" = "Id", "ActivityDate" = "Date"))

# See if there are duplicates after joining and remove duplicates
compare(daily_activity$ActivityDate, daily_data$ActivityDate)
daily_data %>%
  duplicated()

daily_data <- distinct(daily_data)

# Save daily_data
write_csv(daily_data, 'data/daily_data.csv')

# Remove unnecessary objects
rm(daily_activity, daily_calories, daily_intensities, daily_sleep,
   daily_steps, daily_weight)
