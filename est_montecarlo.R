library(shiny)
library(ggplot2)
#shiny app

ui<-fluidPage(
  
  titlePanel("Simulacion de Montecarlo"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("duracion",
                   "Duración de la simulación:",
                   min = 1,
                   max = 200,
                   value = 100,
                   step = 1),
      numericInput("iter",
                   "Iterations of MonteCarlo Method",
                   min = 1,
                   value = 30),
      numericInput("initPrice",
                   "Precio inicial del stock",
                   min = 1,
                   value=55000),
      numericInput("mu",
                   "mu: ",
                   min = 0,
                   value = 0.05),
      numericInput("sigma",
                   "sigma: ",
                   min = 0,
                   value = 0.1),
      numericInput("strikePrice",
                   "Precio de ejecución (StrikePrice): ",
                   min = 0,
                   value = 12000),
      checkboxInput("seeds",
                    "¿Quieres establecer una semilla?"),
      numericInput("setseed",
                   "Elige el número de la semilla",
                   min = 1,
                   value = 1),
      submitButton("Submit")
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      headerPanel(withMathJax("Aproximación usando JDMBS ")),
      
    )
  )
)

server<-shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    if (input$seeds == TRUE) {
      set.seed(input$setseed)
    }
    print(input$vec1)
    jdm_bs(day=input$duracion,monte_carlo=input$iter,start_price=input$initPrice,mu=input$mu,sigma=input$sigma,lambda=2,K=input$strikePrice,plot=TRUE)
  })
})
shinyApp(ui = ui, server = server)
