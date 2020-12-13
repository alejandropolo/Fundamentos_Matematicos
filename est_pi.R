#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Estimating Pi using Monte Carlo Simulation"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("n",
                        "Número de muestras que vamos a generar: ",
                        min = 0,
                        max = 50000,
                        value = 100,
                        step = 20)
        ),
        mainPanel(
            plotOutput("distPlot")
        )
    )
)

server <- function(input, output) {
    output$distPlot <- renderPlot({
        
        #Generamos el número de muestras con la función runif entre el 1 y el -1
        #Basicamente lo que hacemos es generar parejas de x e y siendo ambos aleatorios y entre dichos valores
        samps <- data.frame(replicate(2, runif(input$n, -1, 1)))
        #Comprobamos cuales estan en el círculo
        samps$in_circ <- samps$X1^2 + samps$X2^2 < 1
        
        #Estimamos pi usando la formula anterior
        pi.est <- 4 * mean(samps$in_circ)
        
        #Dibujamos el circulo
        c.seq <- seq(from = 0, to = 2 * pi, length.out = 200)
        circ <- data.frame(x = cos(c.seq), y = sin(c.seq))
        
        #Ploteamos
        ggplot(samps, aes(x = X1, y = X2)) +
            geom_point(aes(colour = in_circ), show.legend = FALSE, shape = ".") +
            geom_path(data = circ, aes(x, y)) +
            xlab("x") +
            ylab("y") +
            ggtitle(paste0("Muestras: ",
                           as.character(input$n),
                           ", Estimación de pi: ",
                           as.character(round(pi.est, 5)),", Error cometido: ",as.character(round(abs(pi-pi.est),5)))) +
            coord_fixed() +
            theme_minimal()
    })
}

shinyApp(ui = ui, server = server)

