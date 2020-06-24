library(simmer)
library(ggplot2)
library(data.table)

trajectory1 <- trajectory(name = "mining&refining") %>%
  seize(resource = paramList$miningModule$name) %>% 
  timeout(paramList$miningModule$processTime) %>% 
  process(consumes = paramList$resource$asteroid$name, 
          creates = paramList$entity$ore$name, 
          i = 1, o = 1, att = "ore") %>% 
  release(resource = paramList$miningModule$name) %>% 
  seize(resource = paramList$processingModule$name) %>% 
  timeout(paramList$processingModule$processingTime) %>% 
  process(consumes = paramList$entity$ore$name, 
          creates = paramList$entity$refinedMaterial$name,
          i = 1 , o = 1, att = "ref") %>% 
  release(paramList$processingModule$name)

env <- simmer()
env %>% 
  add_resource(name = paramList$miningModule$name,
               capacity = paramList$miningModule$initialCapacity,
               queue_size = 0) %>% 
  add_resource(name = paramList$processingModule$name,
               capacity = paramList$processingModule$initialCapacity,
               queue_size = paramList$oreStorage$initialCapacity) %>% 
  add_generator(name_prefix = "beat", trajectory = trajectory1,
                distribution = at(seq(0, 100, 10))) %>% 
  run()
env %>% run()
