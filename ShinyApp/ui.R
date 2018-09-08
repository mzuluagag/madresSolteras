library(shiny)

shinyUI(fluidPage(
  load(file= "www/LastPredictor",envir = .GlobalEnv,verbose = FALSE),
  titlePanel("Madres solteras en Colombia"),
  navlistPanel(
    tabPanel("Visualizacion de hogar como red",
             titlePanel("Seleccione el hogar que desea visualizar"),
             selectInput("db",choices = total$DIRECTORIO,label = NULL),
             actionButton("apply",label = "Generar grafo"),
             plotOutput("grafo")
             ),
    tabPanel("Modelo de prediccion de satisfaccion",
             titlePanel("Ingrese los datos a continuacion para realizar la prediccion de satisfaccion."),hr(),
             verticalLayout(
               numericInput("var1",
                            label = "Ingrese el nivel de satisfaccion que tiene con sus ingresos actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                            max = 10,min = 0,step = 1,value = 10),hr(),
               numericInput("var2",
                            label = "Ingrese el nivel de satisfaccion que tiene con su salud actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                            max = 10,min = 0,step = 1,value = 10),hr(),
               numericInput("var3",
                            label = "Ingrese el nivel de satisfaccion que tiene con su seguridad actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                            max = 10,min = 0,step = 1,value = 10),hr(),
               numericInput("var4",
                            label = "Ingrese el nivel de satisfaccion que tiene con su trabajo actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                            max = 10,min = 0,step = 1,value = 10),hr(),
               numericInput("var5",
                            label = "Ingrese el nivel de felicidad que sintio el día de ayer, siendo 10 muy feliz y 0 muy infeliz.",
                            max = 10,min = 0,step = 1,value = 10),hr(),
               numericInput("var6",
                            label = "Ingrese que tanto considera que las cosas que hace en su vida actualmente valen la pena, siendo 10 que vale la pena toltalmente y 0 que no valen la pena.",
                             max = 10,min = 0,step = 1,value = 10),hr(),
               selectInput("var7",
                           label = "Actualmente las condiciones de vida en su hogar son:",
                           choices = c("Muy buenas","Buenas","Regulares","Malas")),hr(),
               selectInput("var8",
                           label = "La vivienda ocupada por este hogar es:",
                           choices = c("Propia, totalmente pagada",
                                       "Propia, la estan pagando",
                                       "En arriendo o subarriendo",
                                       "Con permiso del propietario, sin pago alguno (usufructuario)",
                                       "Posesion sin titulo (ocupante de hecho)",
                                       "Propiedad colectiva")),hr(),
               numericInput("var9",
                            label = "Ingrese la edad promedio de sus hijos (temporal)",
                            max = 100,min = 0,step = 0.1,value = 10),hr(),
               selectInput("var10",
                           label = "Ingrese el estrato para la tarifa de servicios publicos",
                           choices = c("1. Bajo - Bajo",
                                       "2. Bajo",
                                       "3. Medio - Bajo",
                                       "4. Medio",
                                       "5. Medio - Alto",
                                       "6. Alto"
                                       )),hr(),


               actionButton("apply2",label = "Generar prediccion"),hr(),hr()
              ),
             verbatimTextOutput("satisfaccion")
             )
  )
  
))
