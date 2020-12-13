library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Aproximación de la integral f(x)=x"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n",
                  "Número de muestras que vamos a generar :",
                  min = 0,
                  max = 1000,
                  value = 10,
                  step = 1)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    n=input$n
    val=runif(n, min = 0, max = 1)
    vaL=as.data.frame(val)
    
    est=sum(val)/n
    error=abs(0.5-est)
    
    val_sort=vaL$val[order(vaL$val)]
    
    plot(val_sort,main=paste("El valor aproximado de la integral es: ", round(est,4)," y el error es: ",round(error,6)))
    
  })
}


shinyApp(ui = ui, server = server)
