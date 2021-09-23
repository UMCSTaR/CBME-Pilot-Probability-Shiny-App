main_dt <- data.table::fread("CBME_predicted_readiness/data/20210921_shiny_data.csv")
main_dt[,traineePGY := as.factor(traineePGY)]
# PGY
main_dt %>% count(traineePGY) 

# proc
proc_name_list = main_dt %>%
  count(procName) %>%
  pull(procName) %>% 
  as.list()

names(proc_name_list) <- proc_name_list

write_csv(proc_name_list, file = "CBME_predicted_readiness/data/proc_name_list.csv")
