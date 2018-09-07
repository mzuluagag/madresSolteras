library(shiny)
library(gapminder)

shinyUI(fluidPage(
  
  titlePanel("Madres solteras en Colombia"),
  navlistPanel(
    tabPanel("Visualizacion de hogar como red",
             titlePanel("Seleccione el hogar que desea visualizar"),
             selectInput("db",choices = unique(gapminder$year),label = NULL),#aqui irian los directorios de los hogares
             plotOutput("grafo")#aqui va el output del grafo
             ),
    tabPanel("Modelo de prediccion de satisfaccion",
             titlePanel("Ingrese los datos a continuacion para realizar la prediccion de satisfaccion"),
             verticalLayout(
               textInput("var1",value = "Ingrese la variable 1",label = "Variable 1"),
               numericInput("numVar2",value=0,label = "Maybe num hijos",min=1,max=10,step=1)
             )
             )
  )
  
))
