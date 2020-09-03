# EAS Sim Cmd Ctrl

library(shiny)



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Evolving Asteroid Starship"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("asteroidSize",
                        "Size of Asteroid:",
                        min = 50,
                        max = 500,
                        value = 100),
            actionButton("updateParamList",
                         label = "Update Parameters"
                         ),
            numericInput("runTime",
                         "Number of steps to run the simulation:",
                         value = 3000,
                         min = 300,
                         max = 30000),
            actionButton("runSimulation",
                         label = "Run Simualtion"
            ),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("runResPlot")
        )
    )
)

runEAS <- function(input){
    library(simmer, quietly = TRUE)
    library(plotly, quietly = TRUE)
    library(EnvStats, quietly = TRUE)
    library(data.table, quietly = TRUE)
    source("../../R/fun_modules.R", echo = FALSE, local = TRUE)
    source("../../R/paramList.R", echo = FALSE, local = TRUE)
    source("../../inst/trajectories-SR.R", echo = FALSE, local = TRUE)
    EAS <- simmer()
    reset(EAS)
    EAS_inst <- EAS %>% 
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
    return(EAS_inst)
}

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    observeEvent(eventExpr = input$updateParamList, {
        paramList$resource$asteroid$initial.pop <- input$asteroidSize
    }
                )
    
    observeEvent(eventExpr = input$runSimulation, {
        
        simResEnv <- run(EAS_inst, input$runTime)
        
        output$runResPlot <- renderPlotly({
            splt %>% layout(annotations = list(
                list(x = 0.02 , y = 1.01, text = "Modules and Robots", showarrow = F, xref='paper', yref='paper'),
                list(x = 0.82 , y = 1.01, text = "Resources and Entities", showarrow = F, xref='paper', yref='paper'),
                list(x = 0.02 , y = 0.48, text = "Human population", showarrow = F, xref='paper', yref='paper'),
                list(x = 0.8 , y = 0.48, text = "Average occupancy", showarrow = F, xref='paper', yref='paper')
            )
            )
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
