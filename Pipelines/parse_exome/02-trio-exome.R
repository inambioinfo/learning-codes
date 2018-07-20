
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

# load data in parallel
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


# 2. Mother 0/1 and the same with son 1/1
c("snp", "indel") %>% 
  purrr::walk(
    .f = function(.x) {
      .son <- get(glue::glue("son_{.x}"))
      .mother <- get(glue::glue("mother_{.x}"))
      
      .son %>% dplyr::filter(Chr == "chrX") -> .x_son
      .mother %>% dplyr::filter(Chr == "chrX") -> .x_mother
      
      # load avinput data
      list.files(
        path = file.path(path_wxs, "Sample_P18006013LU01", "Annotation", toupper(.x)), 
        pattern = "avinput.11",
        full.names = TRUE,
        recursive = TRUE
      ) %>% 
        readr::read_tsv(col_names = FALSE) %>% 
        dplyr::mutate(key = paste(X1, X2, X3, X4, X5, sep = "#")) %>% 
        dplyr::pull(key) -> 
        .key_son
      
      list.files(
        path = file.path(path_wxs, "Sample_P18006014LU01", "Annotation", toupper(.x)), 
        pattern = "avinput.01",
        full.names = TRUE,
        recursive = TRUE
      ) %>% 
        readr::read_tsv(col_names = FALSE) %>% 
        dplyr::mutate(key = paste(X1, X2, X3, X4, X5, sep = "#")) %>% 
        dplyr::pull(key) -> 
        .key_mother
      
      .x_son %>% dplyr::filter(key %in% .key_son) -> .x_son_11
      .x_mother %>% dplyr::filter(key %in% .key_mother) %>% dplyr::pull(key) -> .x_mother_01_key
      
      .x_son_11 %>% dplyr::filter(key %in% .x_mother_01_key) %>% dplyr::select(-key) -> .d
      
      .dir <- file.path(path_ana, "03-son-x-recurssive")
      if (!dir.exists(.dir)) dir.create(.dir)
      
      .xlsx <- glue::glue("son-{.x}-x-recurssive-mutation.xlsx")
      if (!file.exists(file.path(.dir, .xlsx))) writexl::write_xlsx(.d, path = file.path(.dir, .xlsx))
    }
  )


# 3. 
# - One from mother one from father
# - One from parents one from new mutation
# - Combine snp and indel

# 3.1
# combine data
rel %>% 
  purrr::walk(
    .f = function(.x) {
      .snp <- get(glue::glue("{.x}_snp"))
      .indel <- get(glue::glue("{.x}_indel"))
      
      .snp %>% dplyr::bind_rows(.indel) %>% 
        dplyr::filter(Gene.ensGene != ".") -> .d
      assign(x = .x, value = .d, envir = .GlobalEnv)
    }
  )


# mutation source from unique, mother and father in one gene.
combination <- c("unique", "mother", "father")

combination %>% 
  combn(2, simplify = FALSE) %>% 
  purrr::walk(
    .f = function(.x) {
      .y <-  setdiff(combination, .x)
      
      if ("unique" == .y) {
        .common <- intersect(intersect(son$key, mother$key), father$key)
        setdiff(intersect(son$key, get(.x[1])$key), .common) -> .x_1
        setdiff(intersect(son$key, get(.x[2])$key), .common) -> .x_2
      } else {
        setdiff(son$key, get(.y)$key) -> .son
        intersect(.son, get(.x[2])$key) -> .x_2
        setdiff(.son, get(.x[2])$key) -> .x_1
      }
      
      son %>%
        dplyr::filter(key %in% c(.x_1, .x_2)) %>%
        dplyr::mutate(from = dplyr::case_when(key %in% .x_1 ~ .x[1], key %in% .x_2 ~ .x[2])) %>%
        dplyr::group_by(Gene.ensGene) %>%
        dplyr::do(dplyr::filter(., length(unique(from)) == 2)) %>%
        dplyr::ungroup() %>%
        dplyr::select(-key) ->
        .d
      
      .dir <- file.path(path_ana, "04-multiple-mutation-in-one-gene-from-different-source")
      if (!dir.exists(.dir)) dir.create(.dir)
      
      .xlsx <- glue::glue("son-from-{.x[1]}-{.x[2]}-respectively.xlsx")
      if (!file.exists(file.path(.dir, .xlsx))) writexl::write_xlsx(.d, path = file.path(.dir, .xlsx))
    }
  )
