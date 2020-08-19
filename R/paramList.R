# this is a parameter list for keeping record of parameters and easy manipulation
paramList <- list(
  miningModule = list(
    name = "miningModule",
    processTime = 20,
    capacity = 1
  ),
  oreStorage = list(
    name = "oreStorage",
    initialCapacity = 10
  ),
  processingModule = list(
    name = "processingModule",
    processingTime = 35,
    capacity = 1
  ),
  refinedStorage = list(
    name = "refinedStorage",
    initialCapacity = 10
  ),
  recyclingModule = list(
    name = "recyclingModule",
    processingTime = 40,
    capacity = 1
  ),
  printerRobot = list(
    name = "printerRobot",
    processingTime = 10,
    capacity = 1
  ),
  shellStorage = list(
    name = "shellStorage",
    initialCapacity = 10
  ),
  manufacturingModule = list(
    name = "manufacturingModule",
    processingTime = 20,
    capacity = 1
  ),
  equipmentStorage = list(
    name = "equipmentStorage",
    initialCapacity = 10
  ),
  assemblyRobot = list(
    name = "assemblyRobot",
    processingTime = 20,
    capacity = 1
  ),
  habitationModule = list(
    name = "habitationModule",
    lifeTime = 10,
    population = 1
  ),
  bioModule = list(
    name = "bioModule",
    lifeTime = 10,
    population = 1
  ),
  entity = list(
    ore = list(
      name = "ore",
      initial.pop = 5,
      live.pop = 0
    ),
    refinedMaterial = list(
      name = "refinedMaterial",
      initial.pop = 5,
      live.pop = 0
    ),
    shell = list(
      name = "shell",
      initial.pop = 5,
      live.pop = 0
    ),
    equipment = list(
      name = "equipment",
      initial.pop = 5,
      live.pop = 0
    ),
    habitation = list(
      name = "habitation",
      initial.pop = 5,
      live.pop = 0
    )
  ),
  resource = list(
    asteroid = list(
      name = "asteroid",
      initial.pop = 100,
      live.pop = 0
    ) 
  )
)

# this will initialize all the live entity counters in the Global
for (i in 1:length(paramList$entity)) {
  assign(paramList$entity[[i]]$name, 0)
}

asteroid <- 1000
