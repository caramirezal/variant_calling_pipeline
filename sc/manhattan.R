## Manhattan plot on GWASS analysis
library(dplyr)
library(ggplot2)
library(CMplot)

alleles <- read.table("../data/gwass_athletes.tsv",
                      header = TRUE,
                      stringsAsFactors = FALSE)
head(alleles)


#select <- select(alleles,CHR,BP,CHISQ)
alleles <- filter(alleles,!is.na(CHISQ))
#alleles <- filter(alleles, CHR %in% 22)
alleles.s <- alleles[sample(1:nrow(alleles), 10000),]
head(alleles.s)
alleles.p <- mutate(alleles.s, 
                    Chromosome=CHR, 
                    Position=BP,
                    p_val=-log(P))
alleles.p <- select(alleles.p, SNP, Chromosome:p_val)
alleles.p <- filter(alleles.p, Chromosome %in% 1:22)


CMplot(alleles.p, plot.type="c", r=1.6, cir.legend=TRUE,
       outward=TRUE, cir.legend.col="black", cir.chr.h=.1 ,chr.den.col="orange", file="jpg",
       memo="", dpi=300, chr.labels=seq(1,22))


alleles <- arrange(alleles, alleles$P) 

write.table(alleles[1:3000,], "../data/gwass_athletes_sorted.tsv", 
            row.names = FALSE, 
            sep = "\t", 
            quote = FALSE)
