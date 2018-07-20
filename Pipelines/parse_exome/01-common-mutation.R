
# Load library ------------------------------------------------------------

library(magrittr)


# Data path ---------------------------------------------------------------

root <- "/home/liucj/data/wxs/liujy/WGC014621D-WGC014618D"


# Analysis ----------------------------------------------------------------

# WGC014621D,WGC014618D
pname <- c('w18' = 'WGC014618D', 'w21' = 'WGC014621D')

wgc18_snp_file <- file.path(root, "Sample_WGC014618D/annotation/snp", "WGC014618D_combined_filtered_R1.fastq.WGC014618D_combined_filtered_R2.fastq.snp.hg19_multianno.txt.maf")
wgc18_indel_file <- gsub(pattern = 'snp', replacement = 'indel', wgc18_snp_file)

wgc21_snp_file <- file.path(root, "Sample_WGC014621D/annotation/snp", "WGC014621D_combined_filtered_R1.fastq.WGC014621D_combined_filtered_R2.fastq.snp.hg19_multianno.txt.maf")
wgc21_indel_file <- gsub(pattern = 'snp', replacement = 'indel', wgc21_snp_file)


# Load data ---------------------------------------------------------------

snp_w18 <- readr::read_tsv(file = wgc18_snp_file) %>% 
  dplyr::select(Chr:snp137) %>% 
  dplyr::mutate(key = paste(Chr, Start, End, Ref, Alt, sep = "#"))
indel_w18 <- readr::read_tsv(file = wgc18_indel_file) %>% 
  dplyr::select(Chr:snp137) %>% 
  dplyr::mutate(key = paste(Chr, Start, End, Ref, Alt, sep = "#"))

snp_w21 <- readr::read_tsv(file = wgc21_snp_file) %>% 
  dplyr::select(Chr:snp137) %>%
  dplyr::mutate(key = paste(Chr, Start, End, Ref, Alt, sep = "#"))
indel_w21 <- readr::read_tsv(file = wgc21_indel_file) %>% 
  dplyr::select(Chr:snp137) %>%
  dplyr::mutate(key = paste(Chr, Start, End, Ref, Alt, sep = "#"))

inter_snp <- intersect(snp_w18$key, snp_w21$key)
inter_indel <- intersect(indel_w18$key, indel_w21$key)


# Results -----------------------------------------------------------------

# common results
rs_inter_snp <- 
  snp_w18 %>% 
  dplyr::filter(key %in% inter_snp) %>% 
  dplyr::select(-key)
  
rs_inter_indel <- indel_w18 %>% 
  dplyr::filter(key %in% inter_indel) %>% 
  dplyr::select(-key)

# unique results
# w18
rs_uniq_w18_snp <- snp_w18 %>% 
  dplyr::filter(!key %in% inter_snp) %>% 
  dplyr::select(-key)
rs_uniq_w18_indel <- indel_w18 %>% 
  dplyr::filter(!key %in% inter_indel) %>% 
  dplyr::select(-key)

# w21
rs_uniq_w21_snp <- snp_w21 %>% 
  dplyr::filter(!key %in% inter_snp) %>% 
  dplyr::select(-key)
rs_uniq_w21_indel <- indel_w21 %>% 
  dplyr::filter(!key %in% inter_indel) %>% 
  dplyr::select(-key)


# Save to xlsx ------------------------------------------------------------

# write common results
filename_snp_inter <- file.path(root, glue::glue("{paste0(pname, collapse = '-')}-snp-common.xlsx"))
filename_indel_inter <- file.path(root, glue::glue("{paste0(pname, collapse = '-')}-indel-common.xlsx"))
writexl::write_xlsx(x = rs_inter_snp, path = filename_snp_inter)
writexl::write_xlsx(x = rs_inter_indel, path = filename_indel_inter)

# write unique results
filename_uniq_w18_snp <- file.path(root, glue::glue("{pname[1]}-snp-uniq.xlsx"))
filename_uniq_w18_indel <- file.path(root, glue::glue("{pname[1]}-indel-uniq.xlsx"))
filename_uniq_w21_snp <- file.path(root, glue::glue("{pname[2]}-snp-uniq.xlsx"))
filename_uniq_w21_indel <- file.path(root, glue::glue("{pname[2]}-indel-uniq.xlsx"))

rs_uniq_w18_snp %>% writexl::write_xlsx(path = filename_uniq_w18_snp)
rs_uniq_w18_indel %>% writexl::write_xlsx(path = filename_uniq_w18_indel)  
rs_uniq_w21_snp %>% writexl::write_xlsx(path = filename_uniq_w21_snp)  
rs_uniq_w21_indel %>% writexl::write_xlsx(path = filename_uniq_w21_indel)  
