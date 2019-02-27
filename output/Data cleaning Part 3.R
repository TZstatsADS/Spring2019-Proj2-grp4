library(dplyr)
data = read.csv('output/ranking_data.csv',  stringsAsFactors=FALSE)

# basic information
basic = data %>%
        select(INSTNM, CITY, INSTURL, Ranking, ADM_RATE, CONTROL, HIGHDEG, FAMINC)
basic$CONTROL = as.factor(basic$CONTROL)
levels(basic$CONTROL) = c('Public', 'Private nonprofit', 'Private for-profit')
basic$HIGHDEG = as.factor(basic$HIGHDEG)
levels(basic$HIGHDEG) = c("Non-degree-granting","Certificate degree","Associate degree",
                          "Bachelor's degree","Graduate degree")
basic$Ranking[is.na(basic$Ranking)] = "> 230"

write.csv(basic, file = "./output/basic.csv")

path = "C:/Users/sharonsnow/Documents/GitHub/Spring2019-Proj2-grp4/data/CollegeScorecard_Raw_Data"
filenames = dir(path)
filePath <- sapply(filenames, function(x){paste(path,x,sep='/')})
all_data = lapply(filePath, function(x){
  read.csv(x, header=T,  stringsAsFactors=FALSE)})

# Acdemics
academics = data %>%
  select(INSTNM, PCIP01, PCIP03, PCIP04, PCIP05, PCIP09, PCIP10, PCIP11, PCIP12, PCIP13, 
         PCIP14, PCIP15, PCIP16, PCIP19, PCIP22, PCIP23, PCIP24, PCIP25, PCIP26, 
         PCIP27, PCIP29, PCIP30, PCIP31, PCIP38, PCIP39, PCIP40, PCIP41, PCIP42, 
         PCIP43, PCIP44, PCIP45, PCIP46, PCIP47, PCIP48, PCIP49, PCIP50, PCIP51, 
         PCIP52, PCIP54)
colnames(academics) = c('INSTNM', 'Agriculture',
                        'Natural Resources and Conservation', 'Architecture',
                        'Area/Ethnic/Cultural/Gender/Group',
                        'Communication&Journalism',
                        'Communications Technologies',
                        'Computer&Information',
                        'Personal&Culinary', 'Education', 'Engineering',
                        'Engineering Technologies',
                        'Foreign Languages',
                        'Human Sciences',
                        'Legal Professions', 'English Language',
                        'Liberal Arts and Sciences&Humanities',
                        'Library', 'Biological and Biomedical Sciences',
                        'Mathematics and Statistics', 'Military Technologies',
                        'Multi/Interdisciplinary Studies', 'Parks Recreation Leisure and Fitness',
                        'Philosophy and Religious', 'Theology and Religious Vocations',
                        'Physical Sciences', 'Science Technologies', 'Psychology',
                        'Homeland Security/Law Enforcement/Firefighting',
                        'Public Administration&Social Service',
                        'Social', 'Construction Trades', 'Mechanic and Repair Technologies/Technicians',
                        'Precision Production', 'Transportation and Materials Moving',
                        'Visual and Performing Arts', 'Health Professions',
                        'Business/Management/Marketing',
                        'History')
write.csv(academics, file = "./output/academics.csv")

# Scores
act = sat = data %>%
  select(UNITID,INSTNM)
for(i in 1:10){
  temp1 = all_data[[i]] %>%
    select(UNITID, ACTCM25, ACTCMMID, ACTCM75, ACTEN25, ACTENMID, ACTEN75, ACTMT25,  ACTMTMID, 
           ACTMT75)
  colnames(temp1) = c("UNITID", paste(i,c('ACTCM25', 'ACTCMMID', 'ACTCM75', 'ACTEN25', 'ACTENMID', 'ACTEN75',
                                          'ACTMT25', 'ACTMTMID', 'ACTMT75')))
  temp2 = all_data[[i]] %>%
    select(UNITID, SATVR25, SATVRMID, SATVR75, SATMT25, SATMTMID, SATMT75, SAT_AVG)
  colnames(temp2) = c("UNITID", paste(i,c('SATVR25', 'SATVRMID', 'SATVR75', 'SATMT25', 'SATMTMID', 'SATMT75', 'SATAVG')))
  act  = merge(act,temp1,by= 'UNITID', all.x = TRUE)
  sat  = merge(sat,temp2,by= 'UNITID', all.x = TRUE)
}
write.csv(act, file = "./output/act.csv")
write.csv(sat, file = "./output/sat.csv")

# Tuition and Fee
cost = data %>%
  select(UNITID,INSTNM)
for(i in 1:10){
  temp = all_data[[i]] %>%
    select(UNITID, TUITIONFEE_IN, TUITIONFEE_OUT)
  colnames(temp) = c("UNITID", paste(i,c('TUITIONFEE_IN', 'TUITIONFEE_OUT')))
  cost  = merge(cost,temp,by= 'UNITID', all.x = TRUE)
}
write.csv(cost, file = "./output/cost.csv")

# Admission Rate
adm_rate = data %>%
  select(UNITID,INSTNM)
for(i in 1:10){
  temp = all_data[[i]] %>%
    select(UNITID, ADM_RATE)
  colnames(temp) = c("UNITID", paste(i,c('ADM_RATE')))
  adm_rate  = merge(adm_rate,temp,by= 'UNITID', all.x = TRUE)
}
write.csv(adm_rate, file = "./output/adm_rate.csv")