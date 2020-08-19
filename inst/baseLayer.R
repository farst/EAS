library(simmer)
library(plotly)
library(data.table)

EAS <- simmer()
reset(EAS)
EAS %>% 
  add_generator("time", sandGlass, at(0)) %>% 
  add_generator("asteroid_dust", miningTraj, when_activated(1)) %>%
  add_resource(paramList$miningModule$name, paramList$miningModule$capacity) %>% 
  add_generator("ore", processingTraj, when_activated(1)) %>% 
  add_resource(paramList$processingModule$name, paramList$processingModule$capacity) %>% 
  #get_attribute(keys = "ore.pop") %>% 
  add_generator("refined_material_pri", printingTraj, when_activated(1)) %>% 
  add_resource(paramList$printerRobot$name, paramList$printerRobot$capacity) %>% 
  add_generator("refined_material_equi", manufacturingTraj, when_activated(1)) %>% 
  add_resource(paramList$manufacturingModule$name, paramList$manufacturingModule$capacity) %>%
  add_generator("assembly_order", assemblingTraj, when_activated(1)) %>% 
  add_resource(paramList$assemblyRobot$name, paramList$assemblyRobot$capacity)

EAS %>% run(10000)
#willem %>% get_mon_attributes()
DT <- as.data.table(EAS %>% get_mon_attributes())
DT
# currently we have multiple entries for one time, something like max(abs) could be useful
# dcast(DT , time~key, value.var = "value") 
plot_ly(DT, x=~time, y=~value, split=~key, type="scatter", mode="lines")
