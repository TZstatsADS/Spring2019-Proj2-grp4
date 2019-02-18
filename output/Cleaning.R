library(dplyr)

data = read.csv("./CollegeScorecard_Raw_Data/MERGED2016_17_PP.csv", stringsAsFactors = F)

dat = data %>%
  mutate(LONGITUDE = as.numeric(LONGITUDE)) %>%
  mutate(LATITUDE = as.numeric(LATITUDE)) %>%
  filter(!is.na(LONGITUDE))

write.csv(dat, file = "./output/processed_data")