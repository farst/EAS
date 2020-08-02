# process
#' @description a function to add to population
#' the concept is simple: a process is described which consumes i units of an entity
#' in order to create o units of another entity. At the final step, the process will
#' bump up the selected attribute to the entity.
#'  
#' @param .trj the trajectory object
#' @param consumes the entity which has to be consumed
#' @param creates the entity which is going to be created
#' @param i the number of entities consumed in the process
#' @param o the number of entities created in the process
#' @param att the attribute to bump at the end of the process
#' 
#' @return .trj the trajectory object
#'  
#' @import simmer
#'  
#' @export

process <- function(.trj, consumes, creates, i, o, att){
  key.prod <- paste0(creates, ".pop")
  set_global(.trj = .trj
             ,keys = key.prod
             ,values = o
             ,mod = "+"
             ,init = 0)
  prod.storage <- paste0(creates, ".storage")
  # addOnTraj(.trj = .trj
  #             , storage = prod.storage
  #             , value = o)
  key.cons <- paste0(consumes, ".pop")
  set_global(.trj = .trj
             ,keys = key.cons
             ,values = - i
             ,mod = "+"
             ,init = 0)
  cons.storage <- paste0(consumes, ".storage")
  # assignOnTraj(.trj = .trj
  #             , storage = cons.storage
  #             , value = -i)
  log_(.trj = .trj
       ,paste0(i, " unit of ", consumes, " turned into ", o, " unit of ", creates)
       ,level = 2 )
  set_attribute(.trj = .trj
                ,keys = att
                ,values = 1
                ,mod = "+"
                ,init = 0)
  log_(.trj = .trj
       ,paste0("Arrival got the attribute ", att," bumped up")
       ,level = 2)
  return(.trj)
}

# assemble
#' @description a function to perform a parametric assembly
#' 
#' @param .trj the trajectory object
#' @param rcp is a list of pairs. Each pair consits of a character and a numeric.
#' the character is the name of the entity and the numeric is the number of units.
#' the sign of numeric indicates consumption of creation.
#' 
#' @param att the attribute to bump at the end of the assembly
#'  
#' @return .trj the trajectory object
#'  
#' @import simmer
#'  
#' @export

assemble <- function(.trj , rcp, att){
  for (i in length(rcp)) {
    key.pop <- paste0(rcp[[i]][1],".pop")
    set_global(.trj = .trj
               ,keys = key.pop
               ,values = as.numeric(rcp[[i]][2])
               ,mod = "+"
               ,init = 0)
  }
  log_(.trj = .trj
       ,paste0("Recipe successfully assembled. A new ", rcp[[1]][1], " added to the system.")
               ,level = 2)
       set_attribute(.trj = .trj
                     ,keys = att
                     ,values = 1
                     ,mod = "+"
                     ,init = 0)
       log_(.trj = .trj
            ,paste0("Arrival got the attribute ", att , "bumped up")
            ,level = 2)
       return(.trj)
}

# check feasibility
checkAvailability <- function(items, book){
  flag <- TRUE
  for (item in items) {
    tmpFlag <- book[[item]] > 0
    flag <- tmpFlag&&flag
  }
  return(flag)
}

# add to storage stock
addOnTraj <- function(.trj, masterBook = paramList, entity, value, env = .GlobalEnv){
  if (exists(masterBook[[entity]], env)) {
    masterBook[[entity]] <- masterBook[[entity]] + value
  } else {message(
    paste0("entity ", entity, " doesn't exist in the ", char(masterBook))
  )
    }
  return(.trj)
}
