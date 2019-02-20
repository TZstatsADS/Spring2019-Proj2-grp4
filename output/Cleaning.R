library(dplyr)
#iter 1
data = read.csv("./CollegeScorecard_Raw_Data/MERGED2016_17_PP.csv", stringsAsFactors = F)

dat = data %>%
  mutate(LONGITUDE = as.numeric(LONGITUDE)) %>%
  mutate(LATITUDE = as.numeric(LATITUDE)) %>%
  filter(!is.na(LONGITUDE))

write.csv(dat, file = "./output/processed_data")

#iter 2
data = read.csv("./output/ranking_data.csv")

names(data)
dat = data %>%
  filter(CURROPER == 1) %>%
  select(UNITID, INSTNM, ZIP, CONTROL, PREDDEG, AVGFACSAL, LATITUDE, LONGITUDE) 

write.csv(dat, file = "./output/processed_data_map.csv")

#iter 3
data = read.csv("./output/processed_data_map.csv")

saveRDS(data, file = "./output/processed_data_map.rds")