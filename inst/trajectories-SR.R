library(simmer)
library(EnvStats)

sandGlass <- trajectory(name = "sandGlass") %>% 
  # initialize storage / asteroid resource parameters
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
  set_global(paste0(paramList$recyclingModule$name, ".srr"),
             value = paramList$recyclingModule$srr) %>%
  # initialize resource capacity
  set_global(keys = paste0(paramList$miningModule$name, ".pop"), 
             value = paramList$miningModule$capacity) %>% 
  set_global(keys = paste0(paramList$processingModule$name, ".pop"), 
             value = paramList$processingModule$capacity) %>% 
  set_global(keys = paste0(paramList$recyclingModule$name, ".pop"), 
             value = paramList$recyclingModule$capacity) %>% 
  set_global(keys = paste0(paramList$printerRobot$name, ".pop"), 
             value = paramList$printerRobot$capacity) %>% 
  set_global(keys = paste0(paramList$manufacturingModule$name, ".pop"), 
             value = paramList$manufacturingModule$capacity) %>% 
  set_global(keys = paste0(paramList$assemblyRobot$name, ".pop"), 
             value = paramList$assemblyRobot$capacity) %>% 
  log_("time flies ...") %>%
  activate("asteroid_dust") %>% 
  timeout(task = function() 0.5*rtri(1, min = paramList$miningModule$processTime$min,
                                 mode = paramList$miningModule$processTime$mode,
                                 max = paramList$miningModule$processTime$ max)/
            get_global(EAS, paste0(paramList$miningModule$name, ".pop"))
          ) %>% 
  # actively update resource capacity
  set_capacity(resource = paramList$miningModule$name,
               value = function() min(get_global(EAS, paste0(paramList$miningModule$name, ".pop")),
               get_global(EAS, paste0(paramList$resource$asteroid$name, ".pop")))) %>%
  set_capacity(resource = paramList$processingModule$name,
               value = function() min(get_global(EAS, paste0(paramList$processingModule$name, ".pop")),
                                      get_global(EAS, paste0(paramList$entity$ore$name, ".pop")))) %>%
  set_capacity(resource = paramList$printerRobot$name,
               value = function() min(get_global(EAS, paste0(paramList$printerRobot$name, ".pop")),
                                      get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")))) %>%
  set_capacity(resource = paramList$manufacturingModule$name,
               value = function() min(get_global(EAS, paste0(paramList$manufacturingModule$name, ".pop")),
                                      get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")))) %>%
  set_capacity(resource = paramList$assemblyRobot$name,
               value = function() min(get_global(EAS, paste0(paramList$assemblyRobot$name, ".pop")),
                                      get_global(EAS, paste0(paramList$entity$shell$name, ".pop")),
                                      get_global(EAS, paste0(paramList$entity$equipment$name, ".pop")))) %>%
  set_capacity(resource = paramList$recyclingModule$name,
               value = get_global(EAS, paste0(paramList$recyclingModule$name, ".pop"))) %>%
  # update occupancy KPI
  set_global(key = "occupancy.kpi",
             value = function() get_global(EAS, keys = paste0(paramList$population$human$name, ".pop"))/
               get_global(EAS, paste0(paramList$entity$habitation$name, ".pop"))
  ) %>% 
  rollback(10)

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
         trajectory() %>% 
           set_global(keys = paste0(paramList$miningModule$name, ".srr"),
                      value = function() round(1 - (get_global(EAS, paste0(paramList$entity$ore$name, ".pop"))/
                                                      get_global(EAS, keys = paste0(paramList$oreStorage$name, ".pop")))),
                      mod = "+"
           ) %>% 
           branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$ore$name, ".pop")) < 
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
                    # ore storage SR mechanics:
                    set_global(paste0(paramList$oreStorage$name, ".srr"),
                               value = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$ore$name, ".pop")) /
                                                           get_global(EAS, keys = paste0(paramList$oreStorage$name, ".pop")) >= 0.9 &&
                                                           get_global(EAS, keys = paste0(paramList$oreStorage$name, ".pop")) <
                                                           get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop"))
                                                           , 1, 0),
                               mod = "+"
                    ) %>%
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
         trajectory() %>% 
           # output buffer SR component
           set_global(keys = paste0(paramList$processingModule$name, ".srr"),
                      value = function() round(1 - (get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop"))/
                                                      get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")))),
                      mod = "+"
           ) %>% 
           branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # refined material storage is not full:
                                 trajectory() %>% 
                    # input buffer SR component:
                    set_global(keys = paste0(paramList$processingModule$name, ".srr"),
                               value = function() ifelse(get_queue_count(EAS, paramList$processingModule$name)/
                                                           get_global(EAS, paste0(paramList$processingModule$name, ".pop")) > 1, 1, 0),
                               mod = "+"
                                 ) %>% 
                                   timeout(function() rtri(1, 
                                                           min = paramList$processingModule$processingTime$min,
                                                           mode = paramList$processingModule$processingTime$mode,
                                                           max = paramList$processingModule$processingTime$max)
                                   )%>% 
                                   process(consumes = paramList$entity$ore$name, 
                                           creates = paramList$entity$refinedMaterial$name,
                                           i = 1 , o = 1, att = "ref") %>% 
                                   release(paramList$processingModule$name) %>% 
                    # refined material storage SR mechanics:
                    set_global(paste0(paramList$refinedStorage$name, ".srr"),
                               value = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$refinedMaterial$name, ".pop")) /
                                                           get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")) >= 0.9 &&
                                                           get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")) <
                                                           get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")) &&
                                                           get_global(EAS, keys = paste0(paramList$refinedStorage$name, ".pop")) <
                                                           get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop"))
                                                         , 1, 0),
                               mod = "+"
                    ) %>%
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                          ),
                                 # refined material storage is full:
                                 trajectory() %>% 
                                   log_("refined storage is full") %>% 
                    release(resource = paramList$processingModule$name) %>%
                    branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                        get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                           continue = c(FALSE, FALSE),
                           trajectory() %>% activate("refined_material_equi"),
                           trajectory() %>% activate("refined_material_pri")
                    ) %>%
                                   release(resource = paramList$processingModule$name)
         ),
         # ore storage is empty:
         trajectory() %>% 
           log_("ore storages are fully depleted") %>% 
           release(resource = paramList$processingModule$name) %>% 
           branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                               get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                  continue = c(FALSE, FALSE),
                  trajectory() %>% activate("refined_material_equi"),
                  trajectory() %>% activate("refined_material_pri")
           )
  )


printingTraj <- trajectory(name = "printing") %>% 
  seize(resource = paramList$printerRobot$name) %>% 
  #check if the refined material storage has refined material:
  branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$refinedMaterial$name, ".pop")) > 0, 1,2),
         continue = c(FALSE,FALSE),
         # refined material is available:
         trajectory() %>% 
           # output buffer SR component
           set_global(keys = paste0(paramList$printerRobot$name, ".srr"),
                      value = function() round(1 - (get_global(EAS, paste0(paramList$entity$shell$name, ".pop"))/
                                                      get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")))),
                      mod = "+"
           ) %>%
           branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$shell$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # shell storage is not full:
                                 trajectory() %>%
                    # input buffer SR component:
                    set_global(keys = paste0(paramList$printerRobot$name, ".srr"),
                               value = function() ifelse(get_queue_count(EAS, paramList$printerRobot$name)/
                                                           get_global(EAS, paste0(paramList$printerRobot$name, ".pop")) > 1, 1, 0),
                               mod = "+"
                    ) %>%
                                   timeout(function() rtri(1, 
                                                           min = paramList$printerRobot$processingTime$min,
                                                           mode = paramList$printerRobot$processingTime$mode,
                                                           max = paramList$printerRobot$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$refinedMaterial$name,
                                           creates = paramList$entity$shell$name,
                                           i = 0.75, o = 1, att = "shell") %>%
                                   release(paramList$printerRobot$name) %>% 
                    # shell storage SR mechanics:
                    set_global(paste0(paramList$shellStorage$name, ".srr"),
                               value = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) /
                                                           get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")) >= 0.9 &&
                                                           get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")) <= 
                                                           get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop"))
                                                         , 1, 0),
                               mod = "+"
                    ) %>%
                                   activate("assembly_order"),
                                 # shell storage is full:
                                 trajectory() %>% 
                    # shell storage SR mechanics:
                    # set_global(paste0(paramList$shellStorage$name, ".srr"),
                    #            value = function() ifelse(get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")) <=
                    #                                        get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")), 1, 0),
                    #            mod = "+"
                    # ) %>%
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
         trajectory() %>%
           # output buffer SR component
           set_global(keys = paste0(paramList$manufacturingModule$name, ".srr"),
                      value = function() round(1 - (get_global(EAS, paste0(paramList$entity$equipment$name, ".pop"))/
                                                      get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")))),
                      mod = "+"
           ) %>% 
           branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$equipment$name, ".pop")) < 
                                                              get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")), 1, 2),
                                 continue = c(FALSE, FALSE),
                                 # equipment storage is not full:
                                 trajectory() %>%
                    # input buffer SR component:
                    set_global(keys = paste0(paramList$manufacturingModule$name, ".srr"),
                               value = function() ifelse(get_queue_count(EAS, paramList$manufacturingModule$name)/
                                                           get_global(EAS, paste0(paramList$manufacturingModule$name, ".pop")) > 1, 1, 0),
                               mod = "+"
                    ) %>%
                                   timeout(function() rtri(1, 
                                                           min = paramList$manufacturingModule$processingTime$min,
                                                           mode = paramList$manufacturingModule$processingTime$mode,
                                                           max = paramList$manufacturingModule$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$refinedMaterial$name,
                                           creates = paramList$entity$equipment$name,
                                           i = 0.1, o = 1, att = "equi") %>% 
                                   release(paramList$manufacturingModule$name) %>% 
                    # shell storage SR mechanics:
                    set_global(paste0(paramList$equipmentStorage$name, ".srr"),
                               value = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")) /
                                                           get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")) >= 0.9 &&
                                                           get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")) <= 
                                                           get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop"))
                                                         , 1, 0),
                               mod = "+"
                    ) %>%
                                   activate("assembly_order"),
                                 # equipment storage is full:
                                 trajectory() %>% 
                    # equipment storage SR mechanics:
                    # set_global(paste0(paramList$equipmentStorage$name, ".srr"),
                    #            value = function() ifelse(get_global(EAS, keys = paste0(paramList$equipmentStorage$name, ".pop")) <=
                    #                                        get_global(EAS, keys = paste0(paramList$shellStorage$name, ".pop")), 1, 0),
                    #            mod = "+"
                    # ) %>%
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
                                   # input buffer SR component:
                                   set_global(keys = paste0(paramList$assemblyRobot$name, ".srr"),
                                              value = function() ifelse(get_queue_count(EAS, paramList$assemblyRobot$name)/
                                                                          get_global(EAS, paste0(paramList$assemblyRobot$name, ".pop")) > 1, 1, 0),
                                              mod = "+"
                                   ) %>%
                                   set_global(keys = paste0(paramList$recyclingModule$name, ".srr"),
                                              value = function() ifelse(get_queue_count(EAS, paramList$recyclingModule$name)/
                                                                          get_global(EAS, paste0(paramList$recyclingModule$name, ".pop")) > 1, 1, 0),
                                              mod = "+"
                                   ) %>%
                                   timeout(function() rtri(1, 
                                                           min = paramList$assemblyRobot$processingTime$min,
                                                           mode = paramList$assemblyRobot$processingTime$mode,
                                                           max = paramList$assemblyRobot$processingTime$max)
                                   )%>%  
                                   process(consumes = paramList$entity$shell$name, creates = paramList$entity$habitation$name, i = 1, o = 0, att = "shelR") %>%
                                   process(consumes = paramList$entity$equipment$name, creates = paramList$entity$blankModule$name, i = 1, o = 1, att = "hab") %>% 
                                   release(paramList$assemblyRobot$name)%>%
                                   branch(option = function() ifelse(get_global(EAS, "occupancy.kpi") > 4, 1 ,2 ),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% branch(option = function() ifelse(get_global(EAS, paste0(paramList$entity$lifeSupport$name, ".pop")) >= 
                                                                                                get_global(EAS, paste0(paramList$entity$habitation$name, ".pop")), 1, 2),
                                                                   continue = c(FALSE, FALSE),
                                                                   trajectory() %>% process(consumes = paramList$entity$blankModule$name,
                                                                                            creates = paramList$entity$habitation$name,
                                                                                            i = 1, o = 1, att = "hab") %>% 
                                                                    timeout(function() rtri(1, min = paramList$habitationModule$lifeTime$min,
                                                                                            mode = paramList$habitationModule$lifeTime$mode,
                                                                                            max = paramList$habitationModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$entity$habitation$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name),
                                                                   trajectory() %>% process(consumes = paramList$entity$blankModule$name,
                                                                                            creates = paramList$entity$lifeSupport$name,
                                                                                            i = 1, o = 1, att = "lif") %>% 
                                                                    timeout(function() rtri(1, min = paramList$bioModule$lifeTime$min,
                                                                                            mode = paramList$bioModule$lifeTime$mode,
                                                                                            max = paramList$bioModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$entity$lifeSupport$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name)
                                                                  ),
                                          trajectory() %>% branch(option = function() findSrPriority(EAS,
                                                                                                     modules = c(paste0(paramList$miningModule$name, ".srr"),
                                                                                                                 paste0(paramList$processingModule$name, ".srr"),
                                                                                                                 paste0(paramList$printerRobot$name, ".srr"),
                                                                                                                 paste0(paramList$manufacturingModule$name, ".srr"),
                                                                                                                 paste0(paramList$assemblyRobot$name, ".srr"),
                                                                                                                 paste0(paramList$recyclingModule$name, ".srr"),
                                                                                                                 paste0(paramList$oreStorage$name, ".srr"),
                                                                                                                 paste0(paramList$refinedStorage$name, ".srr"),
                                                                                                                 paste0(paramList$shellStorage$name, ".srr"),
                                                                                                                 paste0(paramList$equipmentStorage$name, ".srr"))
                                                                                                     ), 
                                                                  continue = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$miningModule$name, ".srr"),
                                                                                              value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$miningModule$name,
                                                                                           i = 1, o = 1, att = "min") %>%
                                                                    timeout(function() rtri(1, min = paramList$miningModule$lifeTime$min,
                                                                                                                            mode = paramList$miningModule$lifeTime$mode,
                                                                                                                            max = paramList$miningModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$miningModule$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                                                    branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                                                        get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                                                           continue = c(FALSE, FALSE),
                                                                           trajectory() %>% activate("refined_material_equi"),
                                                                           trajectory() %>% activate("refined_material_pri")
                                                                    ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$processingModule$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$processingModule$name,
                                                                                           i = 1, o = 1, att = "pro") %>%
                                                                    timeout(function() rtri(1, min = paramList$processingModule$lifeTime$min,
                                                                                            mode = paramList$processingModule$lifeTime$mode,
                                                                                            max = paramList$processingModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$processingModule$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                            branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                                get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                                   continue = c(FALSE, FALSE),
                                                   trajectory() %>% activate("refined_material_equi"),
                                                   trajectory() %>% activate("refined_material_pri")
                                            ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$printerRobot$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$printerRobot$name,
                                                                                           i = 1, o = 1, att = "pri") %>%
                                                                    timeout(function() rtri(1, min = paramList$printerRobot$lifeTime$min,
                                                                                            mode = paramList$printerRobot$lifeTime$mode,
                                                                                            max = paramList$printerRobot$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$printerRobot$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                            branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                                get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                                   continue = c(FALSE, FALSE),
                                                   trajectory() %>% activate("refined_material_equi"),
                                                   trajectory() %>% activate("refined_material_pri")
                                            ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$manufacturingModule$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$manufacturingModule$name,
                                                                                           i = 1, o = 1, att = "man") %>%
                                                                    timeout(function() rtri(1, min = paramList$manufacturingModule$lifeTime$min,
                                                                                            mode = paramList$manufacturingModule$lifeTime$mode,
                                                                                            max = paramList$manufacturingModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$manufacturingModule$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$assemblyRobot$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$assemblyRobot$name,
                                                                                           i = 1, o = 1, att = "assR") %>%
                                                                    timeout(function() rtri(1, min = paramList$assemblyRobot$lifeTime$min,
                                                                                            mode = paramList$assemblyRobot$lifeTime$mode,
                                                                                            max = paramList$assemblyRobot$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$assemblyRobot$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$recyclingModule$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                            creates = paramList$recyclingModule$name,
                                                                            i = 1, o = 1, att = "rcy") %>%
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$lifeTime$min,
                                                                                            mode = paramList$recyclingModule$lifeTime$mode,
                                                                                            max = paramList$recyclingModule$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$recyclingModule$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>%   
                                                                    set_global(paste0(paramList$oreStorage$name, ".srr"),
                                                                                                value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$oreStorage$name,
                                                                                           i = 1, o = 1, att = "orS") %>%
                                                                    timeout(function() rtri(1, min = paramList$oreStorage$lifeTime$min,
                                                                                            mode = paramList$oreStorage$lifeTime$mode,
                                                                                            max = paramList$oreStorage$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$oreStorage$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$refinedStorage$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$refinedStorage$name,
                                                                                           i = 1, o = 1, att = "rmS") %>%
                                                                    timeout(function() rtri(1, min = paramList$refinedStorage$lifeTime$min,
                                                                                            mode = paramList$refinedStorage$lifeTime$mode,
                                                                                            max = paramList$refinedStorage$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$refinedStorage$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name) %>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$shellStorage$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$shellStorage$name,
                                                                                           i = 1, o = 1, att = "shS") %>%
                                                                    timeout(function() rtri(1, min = paramList$shellStorage$lifeTime$min,
                                                                                            mode = paramList$shellStorage$lifeTime$mode,
                                                                                            max = paramList$shellStorage$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$shellStorage$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name)%>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   ),
                                                                  
                                                                  trajectory() %>% 
                                                                    set_global(paste0(paramList$equipmentStorage$name, ".srr"),
                                                                               value = 0) %>% 
                                                                    process(consumes = paramList$entity$blankModule$name,
                                                                                           creates = paramList$equipmentStorage$name,
                                                                                           i = 1, o = 1, att = "eqS")%>%
                                                                    timeout(function() rtri(1, min = paramList$equipmentStorage$lifeTime$min,
                                                                                            mode = paramList$equipmentStorage$lifeTime$mode,
                                                                                            max = paramList$equipmentStorage$lifeTime$max)
                                                                    ) %>% 
                                                                    seize(paramList$recyclingModule$name) %>% 
                                                                    timeout(function() rtri(1, min = paramList$recyclingModule$processingTime$min,
                                                                                            mode = paramList$recyclingModule$processingTime$mode,
                                                                                            max = paramList$recyclingModule$processingTime$max)) %>% 
                                                                    process(consumes = paramList$equipmentStorage$name,
                                                                            creates = paramList$entity$refinedMaterial$name,
                                                                            i = 1, o = 0.5, att = "ref") %>% 
                                                                    release(paramList$recyclingModule$name)%>% 
                                   branch(option = function() ifelse(get_global(EAS, keys = paste0(paramList$entity$shell$name, ".pop")) >
                                                                       get_global(EAS, keys = paste0(paramList$entity$equipment$name, ".pop")), 1,2),
                                          continue = c(FALSE, FALSE),
                                          trajectory() %>% activate("refined_material_equi"),
                                          trajectory() %>% activate("refined_material_pri")
                                   )
                                          )
                                   ),
                                   
                                 
                                 # equipment storage is fully depleted:
                                 trajectory() %>% 
                                   log_("equipment storages are fully depleted") %>% 
                                   release(resource = paramList$assemblyRobot$name)
         ),
         # shell storage is empty:
         trajectory() %>% 
           log_("shell storages are fully depleted") %>% 
           release(resource = paramList$assemblyRobot$name)
  )
