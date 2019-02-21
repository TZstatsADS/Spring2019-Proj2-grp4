library(dplyr)
library(gdata)
crime <- read.xls("../data/oncampuscrime151617.xls", sheet = 1,na.strings=c("NA")) 

crime$numbers <- apply(crime %>% select(MURD17:ARSON17),1,sum)

crime_17 <- crime %>% select(INSTNM,Total,numbers) %>% group_by(INSTNM) %>% mutate(crime = sum(numbers)) %>% select(-numbers) %>% distinct()

write.csv(crime_17, "../output/crimedata.csv")
