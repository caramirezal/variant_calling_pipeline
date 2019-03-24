## Data analysis of athletes genomes 
library(googlesheets)
library(dplyr)
library(curl)

sheet <- gs_title("Lista_Atletas_PEI")

## data cleaning
athletes_ls <- gs_read(sheet, ws = "metadata")
athletes_ls <- filter(athletes_ls, ! is.na(Codigo))
athletes_ls <- select(athletes_ls, Codigo, Atleta, Potencia, Resistencia)
athletes_ls <- mutate(athletes_ls, 
                      power_logical = ! is.na(Potencia) & tolower(Potencia) == "x") 
athletes_ls <- mutate(athletes_ls, 
                      endurance_logical = ! is.na(Resistencia) & tolower(Resistencia) == "x")
athletes_ls <- mutate(athletes_ls,
                      power_bin=sapply(athletes_ls$power_logical, 
                                       function(x) ifelse(x, 1, 0)))
athletes_ls <- mutate(athletes_ls,
                      endurance_bin=sapply(athletes_ls$endurance_logical, 
                                           function(x) ifelse(x, 1, 0)))
athletes_ls <- mutate(athletes_ls, IID=paste0( "GEN/", gsub(" ", "", athletes_ls$Codigo)))

## getting list of athletes codes from ped files
system("cat ../data/miADN/raw/miADN.ped | cut -f1-2 > ../data/athletes_list_map.txt")
ath_ls_ped <- read.table("../data/athletes_list_map.txt", 
                         stringsAsFactors = FALSE,
                         sep = "\t")
names(ath_ls_ped) <- c("FID", "IID")

## definition of pheno file
pheno <- merge(ath_ls_ped, athletes_ls, all.x = TRUE)
pheno <- select(pheno, FID, IID, Atleta, power_bin, endurance_bin) %>% 
                 arrange(IID)
write.table(pheno, "../data/subcat_pheno.tsv", 
            sep = "\t", 
            row.names = FALSE, 
            quote = FALSE)

