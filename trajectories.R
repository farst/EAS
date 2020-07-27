library(simmer)
library(ggplot2)
library(data.table)

env <- simmer()

miningTraj <- trajectory(name = "mining") %>%
  seize(resource = paramList$miningModule$name) %>% 
  timeout(paramList$miningModule$processTime) %>% 
  process(consumes = paramList$resource$asteroid$name, 
          creates = paramList$entity$ore$name, 
          i = 1, o = 1, att = "ore") %>% 
  release(resource = paramList$miningModule$name)

processingTraj <- trajectory(name = "processing") %>% 
  seize(resource = paramList$processingModule$name) %>% 
  timeout(paramList$processingModule$processingTime) %>% 
  process(consumes = paramList$entity$ore$name, 
          creates = paramList$entity$refinedMaterial$name,
          i = 1 , o = 1, att = "ref") %>% 
  release(paramList$processingModule$name)

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
  release(paramList$manufacturingModule$name)

