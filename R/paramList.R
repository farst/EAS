# this is a parameter list for keeping record of parameters and easy manipulation
# srr = self replication request
paramList <- list(
  miningModule = list(
    name = "miningModule",
    processTime = list(
      min = 21,
      mode = 28,
      max  = 35
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 100,
      mode = 150,
      max = 200
    )
  ),
  oreStorage = list(
    name = "oreStorage",
    initialCapacity = 10,
    srr = 0,
    lifeTime = list(
      min = 200,
      mode = 250,
      max = 400
    )
  ),
  processingModule = list(
    name = "processingModule",
    processingTime = list(
      min = 42,
      mode = 56,
      max  = 70
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 200,
      mode = 350,
      max = 500
    )
  ),
  refinedStorage = list(
    name = "refinedStorage",
    initialCapacity = 10,
    srr = 0,
    lifeTime = list(
      min = 500,
      mode = 550,
      max = 600
    )
  ),
  recyclingModule = list(
    name = "recyclingModule",
    processingTime = list(
      min = 35,
      mode = 42,
      max  = 49
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 400,
      mode = 450,
      max = 500
    )
  ),
  printerRobot = list(
    name = "printerRobot",
    processingTime = list(
      min = 21,
      mode = 28,
      max  = 35
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 300,
      mode = 350,
      max = 400
    )
  ),
  shellStorage = list(
    name = "shellStorage",
    initialCapacity = 10,
    srr = 0,
    lifeTime = list(
      min = 400,
      mode = 550,
      max = 600
    )
  ),
  manufacturingModule = list(
    name = "manufacturingModule",
    processingTime = list(
      min = 35,
      mode = 42,
      max  = 49
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 300,
      mode = 350,
      max = 400
    )
  ),
  equipmentStorage = list(
    name = "equipmentStorage",
    initialCapacity = 10,
    srr = 0,
    lifeTime = list(
      min = 500,
      mode = 550,
      max = 600
    )
  ),
  assemblyRobot = list(
    name = "assemblyRobot",
    processingTime = list(
      min = 10,
      mode = 14,
      max  = 20
    ),
    capacity = 1,
    srr = 0,
    lifeTime = list(
      min = 400,
      mode = 450,
      max = 500
    )
  ),
  habitationModule = list(
    name = "habitationModule",
    lifeTime = list(
      min = 600,
      mode = 750,
      max = 900
    ),
    population = 1
  ),
  bioModule = list(
    name = "bioModule",
    lifeTime = list(
      min = 200,
      mode = 250,
      max = 300
    ),
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
      name = "habitationModule",
      initial.pop = 5,
      live.pop = 0
    ),
    lifeSupport = list(
      name = "bioModule",
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
      initial.pop = 300,
      live.pop = 0
    ) 
  ),
  population = list(
    human = list(
      name = "human",
      initial.pop = 10,
      modelParam = list(
        max.occupancy = 6,
        delta = 0.011
      )
    )
  )
)
