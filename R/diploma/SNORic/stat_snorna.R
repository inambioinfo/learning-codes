library(magrittr)


data_dir <- "/home/liucj/data/data/diploma/SNORic"

whole <- readr::read_tsv(
  file = file.path(data_dir, "whole_snoRNA_UCSC_GENECODE.alias2"),
  col_names = FALSE
) 

names(whole) <- c("snorna", "chr", "strand", "start", "end", "symbol", "class")

whole$symbol %>% table() %>% sort() -> foo

length(foo)
foo[foo > 1] %>% length()

whole %>% 
  dplyr::filter(symbol %in% names(foo[foo == 1])) %>% 
  dplyr::count(chr) %>% 
  dplyr::arrange(n) %>% 
  print(n = Inf) -> c

chr_sort <- paste("chr", c(1:22, "X", "Y"), sep = "")
a %>% dplyr::left_join(b, by = "chr") %>% dplyr::left_join(c, by = "chr") %>% 
  dplyr::slice(match(chr_sort, chr)) -> bar

names(bar) <- c("Chromesome", "All", "With copy", "Non copy")

bar %>% readr::write_csv(path = file.path(here::here('SNORic'), "chromesome_copy.csv"))


whole %>% 
  dplyr::select(class) %>% 
  dplyr::count(class) %>% 
  dplyr::rename(Count = n, Class = class) %>% 
  dplyr::filter(!is.na(Class)) %>% 
  readr::write_csv(path = file.path(here::here('SNORic'), "snoRNA_classification.csv"))


whole %>%
  dplyr::filter(class == "Tandem-CD") %>% 
  print(n = Inf, width = Inf)
  dplyr::select(class, symbol) %>% 
  dplyr::group_by(symbol) %>% 
  dplyr::count() %>% 
  dplyr::arrange(-n)
