# this is a parameter list for keeping record of parameters and easy manipulation
# srr = self replication request
paramList <- list(
  miningModule = list(
    name = "miningModule",
    processTime = 20,
    capacity = 1,
    srr = 0
  ),
  oreStorage = list(
    name = "oreStorage",
    initialCapacity = 10,
    srr = 0
  ),
  processingModule = list(
    name = "processingModule",
    processingTime = 35,
    capacity = 1,
    srr = 0
  ),
  refinedStorage = list(
    name = "refinedStorage",
    initialCapacity = 10,
    srr = 0
  ),
  recyclingModule = list(
    name = "recyclingModule",
    processingTime = 40,
    capacity = 1,
    srr = 0
  ),
  printerRobot = list(
    name = "printerRobot",
    processingTime = 10,
    capacity = 1,
    srr = 0
  ),
  shellStorage = list(
    name = "shellStorage",
    initialCapacity = 10,
    srr = 0
  ),
  manufacturingModule = list(
    name = "manufacturingModule",
    processingTime = 20,
    capacity = 1,
    srr = 0
  ),
  equipmentStorage = list(
    name = "equipmentStorage",
    initialCapacity = 10,
    srr = 0
  ),
  assemblyRobot = list(
    name = "assemblyRobot",
    processingTime = 20,
    capacity = 1,
    srr = 0
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
    ),
    blankModule = list(
      name = "blankModule",
      initial.pop = 0,
      live.pop = 0
    )
  ),
  resource = list(
    asteroid = list(
      name = "asteroid",
      initial.pop = 100,
      live.pop = 0
    ) 
  ),
  population = list(
    human = list(
      name = "human",
      initial.pop = 10,
      modelParam = list(
        max.occupancy = 6,
        delta = 1.1
      )
    )
  )
)

# this will initialize all the live entity counters in the Global
for (i in 1:length(paramList$entity)) {
  assign(paramList$entity[[i]]$name, 0)
}

asteroid <- 1000
