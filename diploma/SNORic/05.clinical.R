library(magrittr)

data_path <- "/data/liucj/data/diploma/SNORic/snoric"

clinical <- readr::read_tsv(file.path(data_path, "clinical_dataset.tsv"), col_names = F)

subtype <- readr::read_tsv(file.path(data_path, "clinical_subtype.tsv"))


subtype %>% 
  dplyr::group_by(dataset_id, subtype) %>% 
  dplyr::mutate(s = sum(n)) %>% 
  dplyr::select(-stage, -n) %>% 
  dplyr::group_by(dataset_id, subtype, s) %>% 
  dplyr::count() %>% 
  dplyr::select(1,2,4,3) -> foo

names(foo) <- c("Cancer types", "Subtype", "Number of subtype", "Number of samples")
foo
foo %>% readr::write_csv("subtype_stat.csv")
