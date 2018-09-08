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
      #var7
      auxVar7 <- 1
      if (input$var7 == "Buenas") {
        auxVar7<- 2
      }else if(input$var7 == "Regulares"){
        auxVar7<- 3
      }else if(input$var7 == "Malas"){
        auxVar7<- 4
      }
      #var8
      auxVar8 <- 1
      if (input$var8 == "Propia, la estan pagando") {
        auxVar8 <- 2
      }else if (input$var8 == "En arriendo o subarriendo") {
        auxVar8 <- 3
      }else if (input$var8 == "Con permiso del propietario, sin pago alguno (usufructuario)") {
        auxVar8 <- 4
      }else if (input$var8 == "Posesion sin titulo (ocupante de hecho)") {
        auxVar8 <- 5
      }else if (input$var8 == "Propiedad colectiva") {
        auxVar8 <- 6
      }
      #var10
      auxVar10 <- 1
      if (input$var10 == "2. Bajo") {
        auxVar10 <- 2
      }else if(input$var10 == "3. Medio - Bajo"){
        auxVar10 <- 3
      }else if(input$var10 == "4. Medio"){
        auxVar10 <- 4
      }else if(input$var10 == "5. Medio - Alto"){
        auxVar10 <- 5
      }else if(input$var10 == "6. Alto"){
        auxVar10 <- 6
      }else if(input$var10 == "9 No conoce el estrato o no cuenta con recibo de pago."){
        auxVar10 <- 9
      }else if(input$var10 == "0 Recibos sin estrato o el servicio es pirata"){
        auxVar10 <- 0
      }

      predict(modeloLimpio,
            c(input$var1,
             input$var2,
             input$var3,
             input$var4,
             input$var5,
             input$var6,
             auxVar7,
             auxVar8,
             input$var9,
             auxVar10))
  })
}
 )

  
})
