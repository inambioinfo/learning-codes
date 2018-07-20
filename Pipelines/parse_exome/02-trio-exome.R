
# library -----------------------------------------------------------------

library(magrittr)

# path --------------------------------------------------------------------

path_wxs <- "/data/liucj/wxs/liujy/Project_C0571180007/wxs-result"
path_ana <- file.path(path_wxs, "analysis")
if (!dir.exists(path_ana)) dir.create(path_ana)

#P18006013LU01（son）P18006014LU01（mother）P18006503LU01（father）
rel <- c(P18006013LU01 = "son", P18006014LU01 = "mother", P18006503LU01 = "father")


# load data ---------------------------------------------------------------
fn_read_vcf <- function(.x, .t) {
  .path <- file.path(path_wxs, glue::glue("Sample_{.x}"), "Annotation", .t)
  .file <- list.files(path = .path, pattern = "hg19_multianno.txt$", full.names = TRUE)
  .d <- readr::read_tsv(file = .file) 
  
  .dir <- file.path(path_ana, "01-all-mutation")
  if (!dir.exists(.dir)) dir.create(.dir)
  
  # write to xlsx
  .xlsx <- glue::glue("{rel[.x]}-{.t}-all-mutation.xlsx")
  if (!file.exists(file.path(.dir, .xlsx))) writexl::write_xlsx(.d, path = file.path(.dir, .xlsx))
  
  .d %>% dplyr::mutate(key = paste(Chr, Start, End, Ref, Alt, sep = "#"))
}

names(rel) %>% 
  purrr::walk(
    .f = function(.x) {
      # for snp
      .name <- glue::glue("{rel[.x]}_snp")
      .d <- fn_read_vcf(.x, "SNP")
      assign(x = .name, value = .d, envir = .GlobalEnv)
      # for indel
      .name <- glue::glue("{rel[.x]}_indel")
      .d <- fn_read_vcf(.x, "INDEL")
      assign(x = .name, value = .d, envir = .GlobalEnv)
    }
  )


# question ----------------------------------------------------------------

# 1. new mutation for the son

c("snp", "indel") %>% 
  purrr::walk(
    .f = function(.x) {
      .son <- get(glue::glue("son_{.x}"))
      .mother <- get(glue::glue("mother_{.x}"))
      .father <- get(glue::glue("father_{.x}"))
      
      .new <- setdiff(setdiff(.son$key, .mother$key), .father$key)
      
      .son %>% dplyr::filter(key %in% .new) %>% dplyr::select(-key) -> .d
      
      .dir <- file.path(path_ana, "02-son-unique-mutation")
      if (!dir.exists(.dir)) dir.create(.dir)
      
      .xlsx <- glue::glue("son-{.x}-unique-mutation.xlsx")
      if (!file.exists(file.path(.dir, .xlsx))) writexl::write_xlsx(.d, path = file.path(.dir, .xlsx))
    }
  )


# 2. mother x 0/1, son 0/1 mutation

mother_snp %>% dplyr::filter(Chr == "chrX")
son_snp %>% dplyr::filter(Chr == "chrX")
