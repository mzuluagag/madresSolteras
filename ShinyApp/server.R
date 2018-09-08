library(shiny)

shinyServer(function(input, output) {
  output$grafo <- renderPlot(
    if(input$apply){
      isolate({
        FamNet(input$db)
      })
      }
  )
  
  output$satisfaccion <- renderPrint(
    if (input$apply2) {
      isolate({
        modeloLimpio(input$var1)
      })
    }
  )

  
})
