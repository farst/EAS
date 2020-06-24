library(simmer)

param <- list(
  "mining_time" = 1,
  "ore_storing_time" = 1,
  "processing_time" = 1,
  "refined_storing_time" = 1,
  "printing_time" = 1,
  "manufacturing_time" = 1,
  "assembly_time_habitation" = 1,
  "assembly_time_lifeSupport" = 1
)

env <- simmer(name = "EAS")
printing <- trajectory("Printing trajectory") %>% 
  log_("Refined material allocated to a printer robot") %>% 
  timeout(param$printing_time) %>% 
  log_("Shell added to shell repository")
manufacturing <- trajectory("Manufacturing trajectory") %>% 
  log_("Refined material allocated to a manufacturing module") %>% 
  timeout(param$manufacturing_time) %>% 
  log_("Module added to components repository")
fork1 <- list(printing, manufacturing)
habitation_assembly <- trajectory("Assembly of a habitation module") %>% 
  timeout(param$assembly_time_habitation) %>% 
  log_("A new habitation module is available")
lifeSupport_assembly <- trajectory("Assembly of a life support mdoule") %>% 
  timeout(param$assembly_time_lifeSupport) %>% 
  log_("A new life support module is available")
fork2 <- list(habitation_assembly, lifeSupport_assembly)
ore <- trajectory("Ore's path") %>% 
  timeout(param$mining_time) %>% 
  log_("Ore extrancted") %>% 
  timeout(param$ore_storing_time) %>% 
  log_("Ore stored") %>% 
  log_("Ore sent to the processing module") %>% 
  timeout(param$processing_time) %>% 
  log_("Ore processed. Sending to refined storage") %>% 
  timeout(param$refined_storing_time) %>% 
  log_("Refined material stored in refined storage") %>% 
  branch(
    continue = c(TRUE, TRUE),
    fork1
  ) %>% 
  log_("A shell and a set of comonents entered an assembly robot") %>% 
  branch(
    continue = c(FALSE, FALSE),
    fork2
  )

env %>% add_generator(
  "ore", ore, at(0:2)) %>% 
  run()

