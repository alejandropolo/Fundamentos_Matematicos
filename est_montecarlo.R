library(shiny)
library(ggplot2)

ui<-fluidPage(
  
  titlePanel("Geometric Brownian Motion - Monte Carlo Simulation"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("duracion",
                   "Duración de la simulación:",
                   min = 1,
                   max = 200,
                   value = 10,
                   step = 1),
      numericInput("iter",
                   "Iterations of MonteCarlo Method",
                   min = 1,
                   value = 30),
      numericInput("initPrice",
                   "Precio inicial del stock",
                   min = 1,
                   value = 100),
      numericInput("mu",
                   "mu: ",
                   min = 1,
                   value = 1),
      numericInput("sigma",
                   "sigma: ",
                   min = 1,
                   value = 1),
      numericInput("lambda",
                   "lambda: ",
                   min = 1,
                   value = 1),
      numericInput("strikePrice",
                   "Precio de ejecución (StrikePrice): ",
                   min = 1,
                   value = 1),
      checkboxInput("seeds",
                    "Set seed?"),
      numericInput("setseed",
                   "Select number of seed",
                   min = 1,
                   value = 1),
      submitButton("Submit")
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      headerPanel(withMathJax("$$\\text{GBM Model: } S_0 \\exp\\left(\\left(\\mu - \\frac{\\sigma^2}{2}\\right)t + \\sigma W_t\\right) $$")),
      h4("To run the simulation you have to enter the following inputs on the side bar:"),
      h4("Initial Stock Price is the current price of the stock;"),
      h4("Drift rate is the expected rate of return;"),
      h4("Yearly Standard Deviation is the volatility of the stock price;"),
      h4("Number of Simulation represents how many simulation of stock price you want to display;"),
      h4("In the side bar is also possible, through a check box, to set the seed to a fix value. Please mark the check box and select the value from the numeric box. If it is unmarked the seed will be assigned randomly.
            As the calculation time increases with the number of simulation, there is a 'Submit' button to click as soon as the parameters are decided.")
    )
  )
)

server<-shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    if (input$seeds == TRUE) {
      set.seed(input$setseed)
    }
    jdm_bs(day=input$duracion,monte_carlo=input$iter,start_price=input$initPrice,mu=input$mu,sigma=input$sigma,lambda=input$lambda,K=input$strikePrice,plot=TRUE)
  })
})
shinyApp(ui = ui, server = server)