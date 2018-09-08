library(shiny)

shinyUI(fluidPage(
  titlePanel("Madres solteras en Colombia"),
  navlistPanel(
    tabPanel("Visualizacion de hogar como red",
             load(file="www/HogaresMadresSolteras",envir = .GlobalEnv),
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
               numericInput("var2",
                            label = "Ingrese el nivel de satisfaccion que tienes con su salud actualmente, siento 10 totalmente satisfecho y 0 totalmente insatisfecho",
                            max = 10,min = 0,step = 1,value = 10),
               numericInput("var3",
                            label = "Ingrese el nivel de satisfaccion que tienes con su seguridad actualmente, siento 10 totalmente satisfecho y 0 totalmente insatisfecho",
                            max = 10,min = 0,step = 1,value = 10),
               numericInput("var4",
                            label = "Ingrese el nivel de satisfaccion que tienes con su trabajo actualmente, siento 10 totalmente satisfecho y 0 totalmente insatisfecho",
                            max = 10,min = 0,step = 1,value = 10),
               numericInput("var5",
                            label = "Ingrese el nivel de felicidad que sintio el día de ayer, siento 10 muy feliz y 0 muy infeliz",
                            max = 10,min = 0,step = 1,value = 10),
               numericInput("var6",
                            label = "Ingrese que tanto considera que las cosas que hace en su vida actualmente valen la pena, siento 10 valen la pena toltalmente y 0 no valen la pena",
                             max = 10,min = 0,step = 1,value = 10),
               selectInput("var7",
                           label = "Actualmente las condiciones de vida en su hogar son:",
                           choices = c("Muy buenas","Buenas","Regulares","Malas")),
               selectInput("var8",
                           label = "La vivienda ocupada por este hogar es:",
                           choices = c("Propia, totalmente pagada",
                                       "Propia, la estan pagando",
                                       "En arriendo o subarriendo",
                                       "Con permiso del propietario, sin pago alguno (usufructuario)",
                                       "Posesion sin titulo (ocupante de hecho)",
                                       "Propiedad colectiva")),
               numericInput("var9",
                            label = "Ingrese la edad promedio de sus hijos (temporal)",
                            max = 100,min = 0,step = 0.1,value = 10),
               selectInput("var10",
                           label = "Ingrese el estrato para la tarifa de servicios publicos",
                           choices = c("1. Bajo - Bajo",
                                       "2. Bajo",
                                       "3. Medio - Bajo",
                                       "4. Medio",
                                       "5. Medio - Alto",
                                       "6. Alto",
                                       "9 No conoce el estrato o no cuenta con recibo de pago.",
                                       "0 Recibos sin estrato o el servicio es pirata")),


               actionButton("apply2",label = "Generar prediccion")
              ),
             verbatimTextOutput("satisfaccion")
             )
  )
  
))
