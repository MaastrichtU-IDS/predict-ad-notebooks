library(readxl)
library(reshape2)
library(dplyr)

##################### Import file for table selection  --------

DATADIC <- read_excel("~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/temp/DATADIC.xlsx")
DATADIC <- DATADIC[which(DATADIC$inclusion == "x"),]
DATADIC <- DATADIC[which(DATADIC$Phase != "ADNI3"),]

##################### Import ADNIMERGE FILE for baseline diagnosis and convertion at 3 years --------

ADNIMERGE <- read.csv(file = "~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/Study_info/ADNIMERGE.csv")

# INCLUDE ONLY MCI
which_mci <- unique(ADNIMERGE$RID[which(ADNIMERGE$DX_bl %in% c("EMCI","LMCI"))])
ADNIMERGE <- ADNIMERGE[which(ADNIMERGE$RID %in% which_mci),]

# INCLUDE ONLY SUBJECTS WITH INFO OF CONVERTION AT LEAST YEAR 3
which_three_years <- unique(ADNIMERGE$RID[which(ADNIMERGE$VISCODE %in% names(sort(table(ADNIMERGE$VISCODE))[c(1:17,20)]))])
# which_three_years <- unique(ADNIMERGE$RID[which(ADNIMERGE$VISCODE %in% names(sort(table(ADNIMERGE$VISCODE))[c(18:25)]))])
ADNIMERGE <- ADNIMERGE[which(ADNIMERGE$RID %in% which_three_years),]

# OF THESE SUBJECTS, KEEP ONLY INFO OF CONVERTION BY YEAR 3
rownames(ADNIMERGE) <- 1:nrow(ADNIMERGE)
remove_more_than_three_years <- which(ADNIMERGE$VISCODE %in% c("bl","m03","m30","m36","m24","m18","m12","m06"))
ADNIMERGE <- ADNIMERGE[remove_more_than_three_years,]

# RID OF ONLY MCI SUBJETCS, used later for inclusion
which_to_include <- unique(ADNIMERGE$RID)

##################### Import OTHER FILE with relevant data, select only relenat data --------

names_table_included <- c(unique(DATADIC$TBLNAME),"CBB")

tables <- list.files(path = "~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017", pattern = ".csv$", recursive = TRUE)
zeppo <- tables[which(!(tables %in% tables[grep(pattern = paste(names_table_included,collapse="|"), tables)]))]
tables <- tables[grep(pattern = paste(names_table_included,collapse="|"), tables)]

for (i in 1:length(tables)) {
    
   names_this_file <- paste("~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/",tables[i],sep="")
   
   names_this_table <- gsub(".*/","",gsub(".csv","",tables[i]))
   
   table_this <- read.csv(file = names_this_file, header = TRUE)
   
   # include only variable at baseline or screening
   if ("VISCODE" %in% names(table_this)) {
      
      table_this <- table_this[which(table_this$VISCODE %in% c("sc","bl","v03")),]
      table_this$VISCODE <- factor(table_this$VISCODE)
      
   }
   
   # INCLUDE only baseline MCI subjects
   if ("RID" %in% names(table_this)) {
      
      table_this <- table_this[which(table_this$RID %in% which_to_include),]
      if (sum(duplicated(table_this$RID))) {print(paste(names_this_table, " may be in long format", sep=""))}
      
   }
   
   if (nrow(table_this)>10) {assign(names_this_table, table_this)}
   
}

# THESE WAS USED TO IMPORT EXLUDED TABLES AND SCREEN THEM

# for (i in 1:length(zeppo)) {
#    
#    names_this_file <- paste("~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/",zeppo[i],sep="")
#    
#    names_this_table <- gsub(".*/","",gsub(".csv","",zeppo[i]))
#    
#    table_this <- read.csv(file = names_this_file, header = TRUE)
#    
#    # include only variable at baseline or screening
#    if ("VISCODE" %in% names(table_this)) {
#       
#       table_this <- table_this[which(table_this$VISCODE %in% c("sc","bl","v03")),]
#       table_this$VISCODE <- factor(table_this$VISCODE)
#       
#    }
#    
#    # INCLUDE only baseline MCI subjects
#    if ("RID" %in% names(table_this)) {
#       
#       table_this <- table_this[which(table_this$RID %in% which_to_include),]
#       if (sum(duplicated(table_this$RID))) {print(paste(names_this_table, " may be in long format", sep=""))}
#       
#    }
#    
#    if (nrow(table_this)>10) {assign(paste("TO_SCREEN_",names_this_table,sep=""), table_this)}
#    
# }

rm(table_this)
rm(names_this_table)
rm(names_this_file)
rm(list = ls(pattern = "DIC"))

##################### DECIDE NOW WHAT TO DO FOR EACH TABLE: REMOVE SOME TABLES AND MERGE OTHERS--------

# RESHAPE ADNIMERGE AND ADD CONVERTION VARIABLE AT THE END
tempo <- ADNIMERGE
ADNIMERGE <- ADNIMERGE[which(ADNIMERGE$VISCODE == "bl"),]

ADNIMERGE[,"CONVERSION_AT_3Y"] <- "NO"

for (i in 1:nrow(ADNIMERGE)) {
   
   if ("Dementia" %in% as.character(tempo$DX[which(tempo$RID == ADNIMERGE$RID[i])])) {ADNIMERGE[i,"CONVERSION_AT_3Y"] <- "YES"}
   
}

# ADAS
# the total scores of the two ADAS battery can be found in the two ADASSCORES AND ADAS_ADNIGO23 tables (one for adni1 and the other for adnigo23) can already be found in ther ADNIMERGE table
# what is missing is the single item score, so I create just a new table for them. we will include eventually later

# ADASSCORES[, c("RID",
#                "Q1",
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
#                "Q1"
# )]

rm(ADASSCORES)
rm(ADAS_ADNIGO23)

# ADAS_ADNI1 is actually the item-level score for ADAS in ADNI1
rm(ADAS_ADNI1)

# remove ADNI_CBBRESULTS is a cognitive battery used only in ADNI2 (only around 50 subjects)
rm(ADNI_CBBRESULTS)

# ADSXLIST and BLSCHECK are the same, with different names for different ADNI phase
names_temp <- names(ADSXLIST)

ADSXLIST <- as.data.frame(rbind(as.matrix(ADSXLIST), as.matrix(BLSCHECK)))
names(ADSXLIST) <- names_temp
rm(BLSCHECK)
rm(names_temp)
rm(tempo)

# remove AV45VITALS as it seems to be data related to a challange 
rm(AV45VITALS)

# reshape BACKMEDS. it is the coding of assumption of key medications for ADNIGO23 only
BACKMEDS[,"MED_0"] <- 0
BACKMEDS[,"MED_1"] <- 0
BACKMEDS[,"MED_2"] <- 0
BACKMEDS[,"MED_3"] <- 0
BACKMEDS[,"MED_4"] <- 0
BACKMEDS[,"MED_5"] <- 0
BACKMEDS[,"MED_6"] <- 0
BACKMEDS[,"MED_7"] <- 0

row.names(BACKMEDS) <- 1:nrow(BACKMEDS)
for (i in 1:nrow(BACKMEDS)) {
   if (length(grep("0",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_0"] <- 1
   if (length(grep("1",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_1"] <- 1
   if (length(grep("2",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_2"] <- 1
   if (length(grep("3",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_3"] <- 1
   if (length(grep("4",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_4"] <- 1
   if (length(grep("5",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_5"] <- 1
   if (length(grep("6",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_6"] <- 1
   if (length(grep("7",BACKMEDS$KEYMED[i])) > 0) BACKMEDS[i,"MED_7"] <- 1
}

# remove BLCHANGE. It codes the change in other info than diagnosis
rm(BLCHANGE)

# keep CDR. subscores have already proved to be predicted

# remove CLIELG. Inclusion criteria satisfaction

# remove ECOGPT. it is the item scores of everyday cog participant. Total is already in adnimerge
rm(ECOGPT)

# remove ECOGSP. it is the item scores of everyday cog partner. Total is already in adnimerge
rm(ECOGSP)

# remove FAQ. It contains item levels FAQ but total already in ADNIMERGE
rm(FAQ)

# keep DXSUM_PDXSUM_ADNIALL. diagnostic summary and specifics

# keep FHQ. Family history questionnaire

# keep GDSCALE. Geriatric depression cale but seems not for all included participants

# keep MEDHIST. Medical history for ADNI1GO

# remove MMSE. it's the item level of MMSE and the total is included in the ADNIMERGE
rm(MMSE)

# remove MOCA. it is the item scores of MOCA. Total is already in adnimerge
rm(MOCA)

# keep MODHACH. Modified Hachinski test

# keep NEUROBAT. Several tests not included in ADNIMERGE

# keep NEUROEXM. Neurological examination at screening

# merge NPI and NPIQ in NPI. NEUROPSYCHIATRIC info for ADNI2 not included in ADNIMERGE
# keep only total scores
# "SEV" in var name means severity

names(NPI)[grep("TOT$", names(NPI))] <- gsub("TOT$","SEV",names(NPI)[grep("TOT$", names(NPI))])
names(NPI)[which(names(NPI) %in% "NPITOTAL")] <- "NPISCORE"
names(NPI)[which(names(NPI) %in% "NPISOURC")] <- "NPISOURCE"

NPI <- NPI[,names(NPI)[which(names(NPI) %in% names(NPIQ))]]

NPI <- rbind(NPI, NPIQ)

rm(NPIQ)

# keep PHYSICAL. Physical screening

# keep PTDEMOG. Sociodemographics info

# keep RECCMED. Information about medications for all included subjects, but very hard to recode and originally in long format

# keep RECFHQ. Information about familiarity for dementia for all included subjects, but to be recoded and in long format

# keep RECMHIST. Information about medical history for all included subjects, but very hard to recode and originally in long format

# keep UWNPSYCHSUM_10_27_17. These are new total neurospychology scores for memory and exec func

# keep VITALS

##################### TAKE A LOOK SOME OTHER POTENTIALLY INTERESTING TABLES --------

# ITEM items of all tests?
# RECADV / RECBLLOG info about hispotalization at baseline. hard to code


##################### REMOVE NON-INTERESTIGN VARIABLES IN EACH TABLE --------




##################### REMOVE GARBAGE OBJECTS --------

rm(i)
rm(names_table_included)
rm(tables)
rm(which_mci)
rm(which_three_years)
rm(which_to_include)



# RESHAPE THOSE IN LONG FORMAT 

# # clean multiple sessions
# 
# ADNI_CBBRESULTS <- arrange(ADNI_CBBRESULTS, RID, TaskCode, TaskAttempt)
# 
# which_three_sessions <- which(ADNI_CBBRESULTS$TaskAttempt == 3)
# which_three_sessions_to_clean <- c(which_three_sessions -1 , which_three_sessions - 2)
# ADNI_CBBRESULTS <- ADNI_CBBRESULTS[-which_three_sessions_to_clean,]
# 
# which_two_sessions <- which(ADNI_CBBRESULTS$TaskAttempt == 2)
# which_two_sessions_to_clean <- c(which_two_sessions -1)
# ADNI_CBBRESULTS <- ADNI_CBBRESULTS[-which_two_sessions_to_clean,]
# 
# row.names(ADNI_CBBRESULTS) <- 1:nrow(ADNI_CBBRESULTS)
# 
# ADNI_CBBRESULTS <- reshape(ADNI_CBBRESULTS, direction = "wide", timevar = "TaskCode", v.names = names(ADNI_CBBRESULTS)[6:20], idvar = "RID")
