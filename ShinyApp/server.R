library(shiny)
library(gapminder)

shinyServer(function(input, output) {
  output$grafo <- renderPlot(
    barplot(gapminder$year)#aqui en vez de barplot iria el grafo
  )

  
})
