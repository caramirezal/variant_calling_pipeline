## Transform genotypes from ped/map files to 23nMe like format

## transform ped/map files to binary bed/fam
./inst/plink --ped data/somosKit/SomosKit-INF015-1.ped --map data/somosKit/SomosKit-INF015-1.map  

## convert bed/fam to 23nMe format file 
./inst/plink --bfile plink --out genotype --recode 23
