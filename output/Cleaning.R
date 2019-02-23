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

#iter 4

data = read.csv("./output/ranking_data.csv")
data %>%
  select(UNITID, INSTNM, ADM_RATE, TUITIONFEE_IN, Ranking) %>%
  write.csv(file = "./output/processed_data_value_box.csv")
  
#iter 4

data = read.csv("../output/ranking_data.csv")
library(readxl)
locations = read_excel("../output/locations.xlsx", col_names = F)
colnames(locations) <- c("ST_FIPS", "Location")

dat = data %>%
  filter(CURROPER == 1) %>%
  select(UNITID, INSTNM, INSTURL, Ranking, ST_FIPS, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, PCIP01, PCIP03, PCIP04, PCIP05, PCIP09, PCIP10, PCIP11, PCIP12, PCIP13, PCIP14,
         PCIP15, PCIP16, PCIP19, PCIP22, PCIP23, PCIP24, PCIP25, PCIP26, PCIP27, PCIP29, PCIP30,PCIP31, PCIP38, PCIP39, PCIP40, PCIP41, PCIP42, PCIP43, PCIP44,
         PCIP45, PCIP46, PCIP47, PCIP48, PCIP49, PCIP50, PCIP51, PCIP52, PCIP54, OPENADMP) %>%
  left_join(locations, by = "ST_FIPS") %>% 
  select(UNITID, INSTNM, INSTURL, Ranking,  Location, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, PCIP01, PCIP03, PCIP04, PCIP05, PCIP09, PCIP10, PCIP11, PCIP12, PCIP13, PCIP14,
         PCIP15, PCIP16, PCIP19, PCIP22, PCIP23, PCIP24, PCIP25, PCIP26, PCIP27, PCIP29, PCIP30,PCIP31, PCIP38, PCIP39, PCIP40, PCIP41, PCIP42, PCIP43, PCIP44,
         PCIP45, PCIP46, PCIP47, PCIP48, PCIP49, PCIP50, PCIP51, PCIP52, PCIP54, OPENADMP) %>%
  mutate(HIGHDEG = factor(HIGHDEG,
                          levels = c(0, 1, 2, 3, 4),
                          labels =  c('Non-Degree', 'Certificate', 'Associate', 'Bachelor', "Graduate"))) %>%
  mutate(CONTROL = factor(CONTROL,
                          levels = c(1, 2, 3),
                          labels =  c('Public', 'Private Non-Profit', 'Private for-Profit'))) %>%
  mutate(OPENADMP = factor(OPENADMP,
                           levels = c(1, 2, "NULL"),
                           labels =  c('Yes', 'No', 'Unknown')))

to_binary = function(data) {
  ifelse(as.numeric(as.character(data))>0, 1, 0)
}

dat_major = dat %>%
  mutate(PCIP_Other = ifelse(PCIP01 == "NULL", 1, 0)) %>%
  select(starts_with("PCIP")) %>%
  replace(.=="NULL", 0) %>%
  apply(MARGIN = c(1, 2), FUN = to_binary) 
  
colnames(dat_major) <- c("Agriculture","Natural Resources and Conservation","Architecture",
                         "Cultural and Gender Studies","Communication and Journalism","Communications Technologies and Support Services",
                         "Computer and Information Sciences","Personal and Culinary Services","Education","Engineering","Engineering Technologies",
                         "Foreign Languages and Linguistics","Family and Consumer Sciences","Legal Professions and Studies","English Language and Literature",
                         "Liberal Arts and Sciences - General Studies and Humanities","Library Science","Biological and Biomedical Sciences","Mathematics and Statistics",
                         "Military Technologies and Applied Sciences","Interdisciplinary Studies","Recreation Studies","Philosophy and Religious Studies",
                         "Theology and Religious Vocations","Physical Sciences","Science Technologies","Psychology","Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                         "Public Administration","Social Sciences","Construction Trades","Mechanic and Repair Technologies","Precision Production",
                         "Transportation and Materials Moving","Visual and Performing Arts","Health Professions",
                         "Business Management and Marketing","History", "Other")

dat_major = as.data.frame(dat_major)

dat = dat %>%
  select(UNITID, INSTNM, INSTURL, Ranking, Location, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, OPENADMP) %>%
  cbind(dat_major)

write.csv(dat, file = "../output/processed_data_map_1.csv")
saveRDS(dat, file = "../output/processed_data_map_1.rds")

##Inter 5

data = read.csv("../output/ranking_data.csv")
library(readxl)
locations = read_excel("../output/locations.xlsx", col_names = F)
colnames(locations) <- c("ST_FIPS", "Location")

dat = data %>%
  filter(CURROPER == 1) %>%
  select(UNITID, INSTNM, INSTURL, Ranking, ST_FIPS, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, PCIP01, PCIP03, PCIP04, PCIP05, PCIP09, PCIP10, PCIP11, PCIP12, PCIP13, PCIP14,
         PCIP15, PCIP16, PCIP19, PCIP22, PCIP23, PCIP24, PCIP25, PCIP26, PCIP27, PCIP29, PCIP30,PCIP31, PCIP38, PCIP39, PCIP40, PCIP41, PCIP42, PCIP43, PCIP44,
         PCIP45, PCIP46, PCIP47, PCIP48, PCIP49, PCIP50, PCIP51, PCIP52, PCIP54, OPENADMP) %>%
  left_join(locations, by = "ST_FIPS") %>% 
  select(UNITID, INSTNM, INSTURL, Ranking, Location, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, PCIP01, PCIP03, PCIP04, PCIP05, PCIP09, PCIP10, PCIP11, PCIP12, PCIP13, PCIP14,
         PCIP15, PCIP16, PCIP19, PCIP22, PCIP23, PCIP24, PCIP25, PCIP26, PCIP27, PCIP29, PCIP30,PCIP31, PCIP38, PCIP39, PCIP40, PCIP41, PCIP42, PCIP43, PCIP44,
         PCIP45, PCIP46, PCIP47, PCIP48, PCIP49, PCIP50, PCIP51, PCIP52, PCIP54, OPENADMP) %>%
  mutate(HIGHDEG = factor(HIGHDEG,
                          levels = c(0, 1, 2, 3, 4),
                          labels =  c('Non-Degree', 'Certificate', 'Associate', 'Bachelor', "Graduate"))) %>%
  mutate(CONTROL = factor(CONTROL,
                          levels = c(1, 2, 3),
                          labels =  c('Public', 'Private Non-Profit', 'Private for-Profit'))) %>%
  mutate(OPENADMP = factor(OPENADMP,
                           levels = c(1, 2, "NULL"),
                           labels =  c('Yes', 'No', 'Unknown')))

to_float = function(data) {
  as.numeric(as.character(data))
}

dat_major = dat %>%
  mutate(PCIP_Other = ifelse(PCIP01 == "NULL", 1, 0)) %>%
  select(starts_with("PCIP")) %>%
  replace(.=="NULL", 0) %>%
  apply(MARGIN = c(1, 2), FUN = to_float) 

colnames(dat_major) <- c("Agriculture","Natural Resources and Conservation","Architecture",
                         "Cultural and Gender Studies","Communication and Journalism","Communications Technologies and Support Services",
                         "Computer and Information Sciences","Personal and Culinary Services","Education","Engineering","Engineering Technologies",
                         "Foreign Languages and Linguistics","Family and Consumer Sciences","Legal Professions and Studies","English Language and Literature",
                         "Liberal Arts and Sciences - General Studies and Humanities","Library Science","Biological and Biomedical Sciences","Mathematics and Statistics",
                         "Military Technologies and Applied Sciences","Interdisciplinary Studies","Recreation Studies","Philosophy and Religious Studies",
                         "Theology and Religious Vocations","Physical Sciences","Science Technologies","Psychology","Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                         "Public Administration","Social Sciences","Construction Trades","Mechanic and Repair Technologies","Precision Production",
                         "Transportation and Materials Moving","Visual and Performing Arts","Health Professions",
                         "Business Management and Marketing","History", "Other")

dat_major = as.data.frame(dat_major)

dat = dat %>%
  select(UNITID, INSTNM, INSTURL, Ranking, Location, HIGHDEG, CONTROL, ZIP, LATITUDE, LONGITUDE, OPENADMP) %>%
  cbind(dat_major)

write.csv(dat, file = "../output/processed_data_map_2.csv")
saveRDS(dat, file = "../output/processed_data_map_2.rds")

