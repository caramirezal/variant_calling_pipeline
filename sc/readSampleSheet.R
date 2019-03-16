## definition of the pheno files

library(dplyr)


## load samplesheets info
readSampleSheet <- function(file_name){
        pheno1 <- read.csv(file_name, 
                           skip = 15, 
                           header = TRUE,
                           stringsAsFactors = FALSE)
        pheno1 <- select(pheno1, Sample_ID)
        
        family_ID <- paste("F", seq(1, nrow(pheno1), by=1), sep="")
        pheno1 <- mutate(pheno1, FID=family_ID, IID=Sample_ID)
        pheno1 <- select(pheno1, FID:IID) 
        pheno1$"pheno" <- ifelse(grepl("AT", pheno1$IID), 1, 0)
        return(pheno1)
}

## reading samplesheets and merging into a single file
ssheet_dir <- "../data/miADN/samplesheet/"
fnames <- list.files(ssheet_dir)
fnames_full <- paste0(ssheet_dir, fnames)
ss <- lapply(fnames_full, function(x) readSampleSheet(x))
pheno <- rbind(ss[[1]], ss[[2]], ss[[3]])
str(pheno)

## saving pheno file
write.table(pheno, "../data/pheno.txt", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = FALSE)
