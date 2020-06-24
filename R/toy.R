library(simmer)
library(data.table)
# define manufacturing trajectory
manufacturingTraj <- trajectory() %>% 
  branch(option = function() doComponentPriorityCheck, continue = rep(TRUE, 9),
         trajectory(name = "miningComp") %>% process(
           consumes = "refinedMat", creates = "minModComp", i = 2, o = 1, att = "mmc"
           ),
         trajectory(name = "oreStorageComp") %>% process(
           consumes = "refinedMat", creates = "oreStoComp", i = 1, o = 1, att = "osc"
           ),
         trajectory(name = "processingComp") %>% process(
           consumes = "refinedMat", creates = "proModComp", i = 2, o = 1, att = "pmc"
           ),
         trajectory(name = "refStorageComp") %>% process(
           consumes = "refinedMat", creates = "refStoComp", i = 1, o = 1, att = "rsc"
           ),
         trajectory(name = "printerComp") %>% process(
           consumes = "refinedMat", creates = "printerComp", i = 2, o = 1, att = "prc"
           ),
         trajectory(name = "manuModComp") %>% process(
           consumes = "refinedMat", creates = "manModComp", i = 3, o = 1, att = "mnc"
           ),
         trajectory(name = "assemblyRobComp") %>% process(
           consumes = "refinedMat", creates = "assemRobComp", i = 4, o = 1, att = "arc"
           ),
         trajectory(name = "habComp") %>% process(
           consumes = "refinedMat", creates = "habModComp", i = 3, o = 1, att = "hmc"
           ),
         trajectory(name = "lifeSupComp") %>% process(
           consumes = "refinedMat", creates = "lifeSupComp", i = 2, o = 1, att = "lsc"
           )
         )
# define the main trajectory
firstCycleTraj <- trajectory() %>% 
  log_("Ore extracted") %>% 
  seize("miningModule", 1) %>% 
  timeout(10) %>% 
  process(consumes = "astroidDust", creates = "ore", i = 1, o = 1, att = "ore") %>% 
  release("miningModule", 1) %>% 
  log_("Ore sent to processing module") %>%
  seize("processingModule", 1) %>% 
  timeout(25) %>% 
  process(consumes = "ore", creates = "refinedMat", i = 1, o = 1, att = "ref") %>% 
  log_("Refined material produced and sent to the storage") %>% 
  release("processingModule", 1)

secondCycleTraj %>% trajectory() %>%  
  branch(
    option =  refinedDistributor, continue = c(FALSE, TRUE),
    trajectory(name = "printing") %>% process(
      consumes = "refinedMat", creates = "shell", i = 2, o = 1, att = "shl"),
    manufacturingTraj
    ) %>% 
  log_("end")
# define the model environemnt and the generator
testEnv <- simmer("E|A|S")
testEnv %>%
  add_resource("miningModule", capacity = 1, queue_size = 5) %>% 
  add_resource("processingModule", capacity = 1, queue_size = 2) %>% 
  add_generator("Ore", firstCycleTraj, at(seq(1,1000))) %>% 
  run()
# monitoring
DT <- as.data.table(testEnv %>% get_mon_attributes())
plot(y = DT[grepl("ore", key)]$value, x = DT[grepl("ore", key)]$time, type = "l")
lines(y = DT[grepl("ref", key)]$value, x = DT[grepl("ref", key)]$time, col = "red")
