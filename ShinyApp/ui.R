library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Madres solteras en Colombia"),
  navlistPanel(
    tabPanel("Visualizacion de hogar como red",
             load("www/FamNet",verbose = TRUE),
             load("www/HogaresMadresSolteras",verbose = TRUE),
             load("www/total",verbose = TRUE),
             titlePanel("Seleccione el hogar que desea visualizar"),
             selectInput("db",choices = total$DIRECTORIO,label = NULL),
             actionButton("apply",label = "Generar grafo"),
             plotOutput("grafo")
             ),
    tabPanel("Modelo de prediccion de satisfaccion",
             load("www/modeloLimpio"),
             titlePanel("Ingrese los datos a continuacion para realizar la prediccion de satisfaccion"),hr(),
             verticalLayout(
               numericInput("var1",
                            label = "Ingrese el nivel de satisfaccion que tienes con sus ingresos actualmente, siento 10 totalmente satisfecho y 0 totalmente insatisfecho",
                            max = 10,min = 0,step = 1,value = 10),
               #numericInput(),
               
               
               
               actionButton("apply2",label = "Generar prediccion")
              ),
             verbatimTextOutput("satisfaccion")
             )
  )
  
))

#Respuesta: p1895 Satisfacción vida
#Regresoras:
#P1896 - Satisfacción ingresos escala 10 max
#P1897 - Satisfacción salud 10 max
#P1898 - Satisfacción seguridad 10 max
#P1899 - Satisfacción trabajo 10 max
#P1901 - Feliz ayer 10 max
#P1905 - Vale la pena lo que hace 10 max
#P9030 -  Condiciones de vida 1-4 y 1 max
#P5095 - La vivienda ocupada es...
# ¿La vivienda ocupada por este hogar es?
#•	Propia, totalmente pagada
#•	Propia, la están pagando
#•	En arriendo o subarriendo
#•	Con permiso del propietario, sin pago alguno (usufructuario)
#•	Posesión sin título (ocupante de hecho) 
#•	Propiedad colectiva
#Prom_edad_hijos 
#P8520S1A1 estrato 6 max
