library(shiny)
library(ggplot2)

ui<-fluidPage(
  
  titlePanel("Geometric Brownian Motion - Monte Carlo Simulation"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("drift",
                   "Drift :",
                   min = 1,
                   value = 15),
      numericInput("stdev",
                   "SD Anual",
                   min = 1,
                   value = 30),
      numericInput("initPrice",
                   "Precio Inicial",
                   min = 1,
                   value = 100),
      numericInput("simul",
                   "Simulaciones",
                   min = 1,
                   value = 1),
      checkboxInput("seeds",
                    "¿Quieres establecer una semilla?"),
      numericInput("setseed",
                   "Selecciona la semilla: ",
                   min = 1,
                   value = 1),
      submitButton("Submit")
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      headerPanel(withMathJax("$$\\text{Movimiento Browninano Exponencial: } S_0 \\exp\\left(\\left(\\mu - \\frac{\\sigma^2}{2}\\right)t + \\sigma W_t\\right) $$"))
    )
  )
)

server<-shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    if (input$seeds == TRUE) {
      set.seed(input$setseed)
    }
    mu <- input$drift/100
    sigma <- input$stdev/100
    S0 <- input$initPrice
    nsim <- input$simul
    t <- 365
    
    gbm <- matrix(ncol = nsim, nrow = t)
    for (simu in 1:nsim) {
      for (day in 2:t) {
        epsilon <- rnorm(t)
        dt = 1 / 365
        gbm[1, simu] <- S0
        gbm[day, simu] <- exp((mu - sigma * sigma / 2) * dt + sigma * epsilon[day] * sqrt(dt))
      }
    }
    gbm <- apply(gbm, 2, cumprod)
    
    ts.plot(gbm, gpars = list(col=rainbow(10)))
  })
})
shinyApp(ui = ui, server = server)
