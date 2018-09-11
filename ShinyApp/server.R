library(shiny)
library(igraph)

shinyServer(function(input, output) {
  output$grafo <- renderPlot(
    if(input$apply){
      isolate({
        FamNet(input$db)
      })
      }
  )
  
output$satisfaccion <- renderText(
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
      if (input$var8 == "Propia, la están pagando") {
        auxVar8 <- 2
      }else if (input$var8 == "En arriendo o subarriendo") {
        auxVar8 <- 3
      }else if (input$var8 == "Con permiso del propietario, sin pago alguno (usufructuario)") {
        auxVar8 <- 4
      }else if (input$var8 == "Posesión sin título (ocupante de hecho)") {
        auxVar8 <- 5
      }else if (input$var8 == "Propiedad colectiva") {
        auxVar8 <- 6
      }
      #var9
      auxVar9<-0
      auxVar9<-strsplit(input$var9,",")
      auxVar9<-unlist(auxVar9)
      auxVar9<-as.numeric(auxVar9)
      auxVar9<-mean(auxVar9)
      
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
      }

     a1<-c(input$var1,
             input$var2,
             input$var3,
             input$var4,
             input$var5,
             input$var6,
             auxVar7,
             auxVar8,
             auxVar9,
             auxVar10)
     a1<-t(a1)
     a1<-as.data.frame(a1)
     colnames(a1)[]<-c("P1896","P1897","P1898","P1899","P1901","P1905","P9030","P5095","prom_edad_hijos","P8520S1A1")
     res<-as.numeric(predict(modeloTransFinal,newdata=a1))
     
     if(res>10){
       res<-10
     }
     res<-round(res)
     res
  })
}
 )

  
})
