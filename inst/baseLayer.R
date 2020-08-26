library(simmer)
library(plotly)
library(data.table)

EAS <- simmer()
reset(EAS)
EAS %>% 
  add_generator("time", sandGlass, at(0)) %>% 
  add_generator("population", population, at(0)) %>% 
  add_generator("asteroid_dust", miningTraj, when_activated(1)) %>%
  add_resource(paramList$miningModule$name, paramList$miningModule$capacity) %>% 
  add_generator("ore", processingTraj, when_activated(1)) %>% 
  add_resource(paramList$processingModule$name, paramList$processingModule$capacity, queue_size = Inf) %>% 
  add_generator("refined_material_pri", printingTraj, when_activated(1)) %>% 
  add_resource(paramList$printerRobot$name, paramList$printerRobot$capacity) %>% 
  add_generator("refined_material_equi", manufacturingTraj, when_activated(1)) %>% 
  add_resource(paramList$manufacturingModule$name, paramList$manufacturingModule$capacity) %>%
  add_generator("assembly_order", assemblingTraj, when_activated(1)) %>% 
  add_resource(paramList$assemblyRobot$name, paramList$assemblyRobot$capacity) %>%
  add_resource(paramList$recyclingModule$name, paramList$recyclingModule$capacity)

EAS %>% run(10000)
DT <- as.data.table(EAS %>% get_mon_attributes())
DT[key == "human.pop", value := round(value)]
DT2 <- as.data.table(EAS %>% get_mon_resources())
resources <- c(paramList$miningModule$name, paramList$processingModule$name,
               paramList$recyclingModule$name, paramList$printerRobot$name,
               paramList$manufacturingModule$name, paramList$assemblyRobot$name,
               paramList$entity$habitation$name, paramList$entity$lifeSupport$name)
storages <- c(paramList$oreStorage$name, paramList$refinedStorage,
              paramList$shellStorage$name, paramList$equipmentStorage$name)
entities <- c(paramList$entity$ore$name, paramList$entity$refinedMaterial$name,
              paramList$entity$shell$name, paramList$entity$equipment$name,
              paramList$resource$asteroid$name)
fig1 <- plot_ly(DT2, x=~time, y=~queue, split=~resource, type="scatter", mode="lines")# %>% layout("quoue counts")
# currently we have multiple entries for one time, something like max(abs) could be useful
# dcast(DT , time~key, value.var = "value") 
fig2 <- plot_ly(DT[key %in% paste0(resources, ".pop")], x=~time, y=~value, split=~key, type="scatter", mode="lines")# %>% layout(title = "entities")
fig3 <- plot_ly(DT[key %in% paste0(entities, ".pop")], x=~time, y=~value, split=~key, type="scatter", mode="lines")# %>% layout(title = "entities")
fig4 <- plot_ly(DT[key %in% paste0(resources, ".pop")], x=~time, y=~value, split=~key, type="scatter", mode="lines")# %>% layout(title = "entities")
fig5 <- plot_ly(DT[grepl("kpi", key)], x=~time, y=~value, split=~key, type="scatter", mode="lines")
fig6 <- plot_ly(DT[grepl("srr", key)], x=~time, y=~value, split=~key, type="scatter", mode="lines")# %>% layout(title = "srr")

subplot(fig1, fig2, fig3, fig4, fig5, fig6, nrows = 2, shareX = T)
