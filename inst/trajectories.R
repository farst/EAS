sandGlass <- trajectory(name = "sandGlass") %>% 
  log_("time flies ...") %>% 
  #activate("asteroid_dust") %>% 
  timeout(1) %>% 
  send("mine") %>% 
  rollback(5)

miningTraj <- trajectory(name = "mining") %>%
  seize(resource = paramList$miningModule$name) %>% 
  timeout(paramList$miningModule$processTime) %>% 
  process(consumes = paramList$resource$asteroid$name, 
          creates = paramList$entity$ore$name, 
          i = 1, o = 1, att = "ore") %>%
  release(resource = paramList$miningModule$name) %>% 
  activate("ore")

processingTraj <- trajectory(name = "processing") %>% 
  seize(resource = paramList$processingModule$name) %>% 
  timeout(paramList$processingModule$processingTime) %>% 
  process(consumes = paramList$entity$ore$name, 
          creates = paramList$entity$refinedMaterial$name,
          i = 1 , o = 1, att = "ref") %>% 
  release(paramList$processingModule$name) %>% 
  activate("refined_material_pri") %>% 
  activate("refined_material_equi")

printingTraj <- trajectory(name = "printing") %>% 
  seize(resource = paramList$printerRobot$name) %>% 
  timeout(paramList$printerRobot$processingTime) %>% 
  process(consumes = paramList$entity$refinedMaterial$name,
          creates = paramList$entity$shell$name,
          i = 1, o = 1, att = "shell") %>%
  release(paramList$printerRobot$name)

manufacturingTraj <- trajectory(name = "manufacturing") %>% 
  seize(resource = paramList$manufacturingModule$name) %>% 
  timeout(paramList$manufacturingModule$processingTime) %>% 
  process(consumes = paramList$entity$refinedMaterial$name,
          creates = paramList$entity$equipment$name,
          i = 1, o = 1, att = "equi") %>% 
  release(paramList$manufacturingModule$name) %>% 
  activate("assembly_order")
  
# assemblingTraj <- trajectory(name = "assembling") %>% 
#   log_("assembly activated") %>% 
#   seize(resource = paramList$assemblyRobot$name) %>% 
#   timeout(paramList$assemblyRobot$processingTime) %>% 
#   assemble(rcp = list(c(paramList$entity$habitation$name, 1),
#                       c(paramList$entity$shell$name, -1),
#                       c(paramList$entity$equipment$name, -1)),
#            att = "hab") %>%
#   release(paramList$assemblyRobot$name)
  
assemblingTraj <- trajectory(name = "assembling") %>% 
  log_("assembly activated") %>% 
  seize(resource = paramList$assemblyRobot$name) %>% 
  timeout(paramList$assemblyRobot$processingTime) %>% 
  process(consumes = paramList$entity$shell$name, creates = paramList$entity$habitation$name, i = 1, o = 0, att = "shelR") %>%
  process(consumes = paramList$entity$equipment$name, creates = paramList$entity$habitation$name, i = 1, o = 1, att = "hab") %>% 
  release(paramList$assemblyRobot$name)