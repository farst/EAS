library(simmer)
library(EnvStats)

sandGlass <- trajectory(name = "sandGlass") %>% 
  # initialize resource parameters
  set_global(keys = paste0(paramList$resource$asteroid$name, ".pop"), 
             value = paramList$resource$asteroid$initial.pop) %>% 
  set_global(keys = paste0(paramList$oreStorage$name, ".pop"), 
             value = paramList$oreStorage$initialCapacity) %>% 
  set_global(keys = paste0(paramList$refinedStorage$name, ".pop"), 
             value = paramList$refinedStorage$initialCapacity) %>% 
  set_global(keys = paste0(paramList$shellStorage$name, ".pop"), 
             value = paramList$shellStorage$initialCapacity) %>% 
  set_global(keys = paste0(paramList$equipmentStorage$name, ".pop"), 
             value = paramList$equipmentStorage$initialCapacity) %>%
  # initialize entities in the system
  set_global(paste0(paramList$entity$ore$name, ".pop"),
             value = paramList$entity$ore$initial.pop) %>% 
  set_global(paste0(paramList$entity$refinedMaterial$name, ".pop"),
             value = paramList$entity$refinedMaterial$initial.pop) %>%
  set_global(paste0(paramList$entity$shell$name, ".pop"),
             value = paramList$entity$shell$initial.pop) %>%
  set_global(paste0(paramList$entity$equipment$name, ".pop"),
             value = paramList$entity$equipment$initial.pop) %>%
  set_global(paste0(paramList$entity$habitation$name, ".pop"),
             value = paramList$entity$habitation$initial.pop) %>%
  set_global(paste0(paramList$entity$lifeSupport$name, ".pop"),
             value = paramList$entity$lifeSupport$initial.pop) %>%
  set_global(paste0(paramList$population$human$name, ".pop"),
             value = paramList$population$human$initial.pop) %>%
  # initialize srr
  set_global(paste0(paramList$miningModule$name, ".srr"),
             value = paramList$miningModule$srr) %>% 
  set_global(paste0(paramList$oreStorage$name, ".srr"),
             value = paramList$oreStorage$srr) %>% 
  set_global(paste0(paramList$processingModule$name, ".srr"),
             value = paramList$processingModule$srr) %>% 
  set_global(paste0(paramList$refinedStorage$name, ".srr"),
             value = paramList$refinedStorage$srr) %>% 
  set_global(paste0(paramList$printerRobot$name, ".srr"),
             value = paramList$printerRobot$srr) %>% 
  set_global(paste0(paramList$shellStorage$name, ".srr"),
             value = paramList$shellStorage$srr) %>% 
  set_global(paste0(paramList$manufacturingModule$name, ".srr"),
             value = paramList$manufacturingModule$srr) %>% 
  set_global(paste0(paramList$equipmentStorage$name, ".srr"),
             value = paramList$equipmentStorage$srr) %>% 
  set_global(paste0(paramList$assemblyRobot$name, ".srr"),
             value = paramList$assemblyRobot$srr) %>% 
  # initialize resource capacity
  set_global(keys = paste0(paramList$miningModule$name, ".cap"), 
             value = paramList$miningModule$capacity) %>% 
  set_global(keys = paste0(paramList$processingModule$name, ".cap"), 
             value = paramList$processingModule$capacity) %>% 
  set_global(keys = paste0(paramList$recyclingModule$name, ".cap"), 
             value = paramList$recyclingModule$capacity) %>% 
  set_global(keys = paste0(paramList$printerRobot$name, ".cap"), 
             value = paramList$printerRobot$capacity) %>% 
  set_global(keys = paste0(paramList$manufacturingModule$name, ".cap"), 
             value = paramList$manufacturingModule$capacity) %>% 
  set_global(keys = paste0(paramList$assemblyRobot$name, ".cap"), 
             value = paramList$assemblyRobot$capacity) %>% 
  log_("time flies ...") %>%
  activate("asteroid_dust") %>% 
  timeout(1) %>% 
  # actively update resource capacity
  # update occupancy KPI
  set_global(key = "occupancy.kpi",
             value = function() get_global(EAS, keys = paste0(paramList$population$human$name, ".pop"))/
               get_global(EAS, paste0(paramList$entity$habitation$name, ".pop"))
  ) %>% 
  rollback(4)

population <- trajectory(name = "population") %>% 
  set_global(keys = paste0(paramList$population$human$name, ".pop"),
             value = function() get_global(EAS, keys = paste0(paramList$population$human$name, ".pop")) 
                                            + (paramList$population$human$modelParam$delta * 
                                                 (1 - ( get_global(EAS, keys = paste0(paramList$population$human$name, ".pop"))/
                                                                   (paramList$population$human$modelParam$max.occupancy * 
                                                                     min(get_global(EAS, paste0(paramList$entity$habitation$name, ".pop")),
                                                                         get_global(EAS, paste0(paramList$entity$lifeSupport$name, ".pop")))
                                                                    )
                                                       )
                                                  )
                                               ) * get_global(EAS, keys = paste0(paramList$population$human$name, ".pop"))
             ) %>% 
  timeout(2) %>% 
  rollback(2)

miningTraj <- trajectory(name = "mining") %>%
  seize(resource = paramList$miningModule$name) %>%
  # check if the asteroid has any resources to mine:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$resource$asteroid$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # asteroid still has resources to mine
         trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$ore$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$oreStorage$name, ".pop")), 1, 2),
                continue = c(FALSE, FALSE),
                # ore storage is not full:
                trajectory() %>%  
                  timeout(function() rtri(1, 
                                          min = paramList$miningModule$processTime$min,
                                          mode = paramList$miningModule$processTime$mode,
                                          max = paramList$miningModule$processTime$max)
                          ) %>% 
                  process(consumes = paramList$resource$asteroid$name, 
                          creates = paramList$entity$ore$name, 
                          i = 1, o = 1, att = "ore") %>%
                  release(resource = paramList$miningModule$name) %>% 
                  activate("ore"),
                # ore storage is full:
                trajectory() %>% 
                  log_("ore storage is full") %>% 
                  activate("ore") %>% 
                  release(resource = paramList$miningModule$name)
                ),
         # asteroid is out of resources:
         trajectory() %>% 
           log_("asteroid resources are fully depleted") %>% 
           release(resource = paramList$miningModule$name) %>% 
           activate("ore")
  )

processingTraj <- trajectory(name = "processing") %>% 
  seize(resource = paramList$processingModule$name) %>%
  #check if the ore storage has ore:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$ore$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # ore is available:
         trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # refined material storage is not full:
                                 trajectory() %>% 
                                   timeout(function() rtri(1, 
                                                           min = paramList$processingModule$processingTime$min,
                                                           mode = paramList$processingModule$processingTime$mode,
                                                           max = paramList$processingModule$processingTime$max)
                                           )%>% 
                                   process(consumes = paramList$entity$ore$name, 
                                           creates = paramList$entity$refinedMaterial$name,
                                           i = 1 , o = 1, att = "ref") %>% 
                                   release(paramList$processingModule$name) %>% 
                                   activate("refined_material_pri") %>% 
                                   activate("refined_material_equi"),
                                 # refined material storage is full:
                                 trajectory() %>% 
                                   log_("refined storage is full") %>% 
                                   activate("refined_material_pri") %>% 
                                   activate("refined_material_equi") %>%
                                   release(resource = paramList$processingModule$name)
         ),
         # ore storage is empty:
         trajectory() %>% 
           log_("ore storages are fully depleted") %>% 
           release(resource = paramList$processingModule$name) %>% 
           activate("refined_material_pri") %>% 
           activate("refined_material_equi")
  )
  

printingTraj <- trajectory(name = "printing") %>% 
  seize(resource = paramList$printerRobot$name) %>% 
  #check if the refined material storage has refined material:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # refined material is available:
         trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$shell$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # shell storage is not full:
                                 trajectory() %>%
                                   timeout(function() rtri(1, 
                                                           min = paramList$printerRobot$processingTime$min,
                                                           mode = paramList$printerRobot$processingTime$mode,
                                                           max = paramList$printerRobot$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$refinedMaterial$name,
                                           creates = paramList$entity$shell$name,
                                           i = 0.75, o = 1, att = "shell") %>%
                                   release(paramList$printerRobot$name) %>% 
                                   activate("assembly_order"),
                                 # shell storage is full:
                                 trajectory() %>% 
                                   log_("shell storage is full") %>% 
                                   release(resource = paramList$printerRobot$name) %>% 
                                   activate("assembly_order")
         ),
         # refined material storage is empty:
         trajectory() %>% 
           log_("refined material storages are fully depleted") %>% 
           release(resource = paramList$printerRobot$name)%>% 
           activate("assembly_order")
  )
  

manufacturingTraj <- trajectory(name = "manufacturing") %>% 
  seize(resource = paramList$manufacturingModule$name) %>% 
  #check if the refined material storage has refined material:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # refined material is available:
         trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$equipment$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # equipment storage is not full:
                                 trajectory() %>%
                                   timeout(function() rtri(1, 
                                                           min = paramList$manufacturingModule$processingTime$min,
                                                           mode = paramList$manufacturingModule$processingTime$mode,
                                                           max = paramList$manufacturingModule$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$refinedMaterial$name,
                                           creates = paramList$entity$equipment$name,
                                           i = 0.1, o = 1, att = "equi") %>% 
                                   release(paramList$manufacturingModule$name) %>% 
                                   activate("assembly_order"),
                                 # equipment storage is full:
                                 trajectory() %>% 
                                   log_("equipment storage is full") %>% 
                                   release(resource = paramList$manufacturingModule$name) %>% 
                                   activate("assembly_order")
         ),
         # refined material storage is empty:
         trajectory() %>% 
           log_("refined material storages are fully depleted") %>% 
           release(resource = paramList$manufacturingModule$name)%>% 
           activate("assembly_order")
  )
  
assemblingTraj <- trajectory(name = "assembling") %>% 
  seize(resource = paramList$assemblyRobot$name) %>% 
  #check if the shell storage has shell:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$shell$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # shell is available:
         trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$equipment$name, ".pop")) > 0, 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # equipment is available:
                                 trajectory() %>% 
                                   timeout(function() rtri(1, 
                                                           min = paramList$assemblyRobot$processingTime$min,
                                                           mode = paramList$assemblyRobot$processingTime$mode,
                                                           max = paramList$assemblyRobot$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$shell$name, creates = paramList$entity$habitation$name, i = 1, o = 0, att = "shelR") %>%
                                   process(consumes = paramList$entity$equipment$name, creates = paramList$entity$blankModule$name, i = 1, o = 1, att = "hab") %>% 
                                   release(paramList$assemblyRobot$name)%>%
                                   branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$lifeSupport$name, ".pop")) >= 
                                                                                  get_global(EAS, paste0(paramList$entity$habitation$name, ".pop")), 1, 2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% process(consumes = paramList$entity$blankModule$name,
                                                                   creates = paramList$entity$habitation$name,
                                                                   i = 1, o = 1, att = "hab"),
                                          trajectory() %>% process(consumes = paramList$entity$blankModule$name,
                                                                   creates = paramList$entity$lifeSupport$name,
                                                                   i = 1, o = 1, att = "hab")
                                          ),
                                   
                                 # equipment storage is full:
                                 trajectory() %>% 
                                   log_("equipment storages are fully depleted") %>% 
                                   release(resource = paramList$assemblyRobot$name)
         ),
         # shell storage is empty:
         trajectory() %>% 
           log_("shell storages are fully depleted") %>% 
           release(resource = paramList$assemblyRobot$name)
         )
