library(shiny)
library(shinythemes)
library(shinyBS)

shinyUI(fluidPage(
  theme = shinytheme("darkly"),
  load(file= "www/LastPredictor",envir = .GlobalEnv,verbose = FALSE),
  fillRow(navbarPage("Madres solteras en Colombia", 
                                 tabPanel("Visualización de hogar como red",
                                          fluidRow(column(6, h1("Seleccione el hogar que desea visualizar", align = "center"), offset = 3)),
                                          hr(),
                                          fluidRow(
                                            column(2, offset = 4, selectInput("db",choices = unique(HogaresMadresSolteras$DIRECTORIO),label = NULL)),
                                            column(2, offset = 1, actionButton("apply",label = "Generar grafo", class = "btn btn-primary"))),
                                          fluidRow(column(6, plotOutput("grafo"), offset = 3))
                                  ),
                            tabPanel("Estimador de satisfacción",
                                fluidRow(column(6, h1("Diligencie los campos a continuación para estimar su satisfacción", align = "center"), offset = 3)),
                                    hr(),
                                column(6, offset = 3, 
                                     verticalLayout(
                                       numericInput("var1",
                                                    label = "Ingrese el nivel de satisfacción que tiene con sus ingresos actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                                                    max = 10,min = 0,step = 1,value = " ", width = "100%"),
                                       numericInput("var2",
                                                    label = "Ingrese el nivel de satisfacción que tiene con su salud actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                                                    max = 10,min = 0,step = 1,value = " " , width = "100%"),
                                       numericInput("var3",
                                                    label = "Ingrese el nivel de satisfacción que tiene con su seguridad actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                                                    max = 10,min = 0,step = 1,value = " ", width = "100%"),
                                       numericInput("var4",
                                                    label = "Ingrese el nivel de satisfacción que tiene con su trabajo actualmente, siendo 10 totalmente satisfecho y 0 totalmente insatisfecho.",
                                                    max = 10,min = 0,step = 1,value = " ", width = "100%"),
                                       numericInput("var5",
                                                    label = "Ingrese el nivel de felicidad que sintió el día de ayer, siendo 10 muy feliz y 0 muy infeliz.",
                                                    max = 10,min = 0,step = 1,value = " ", width = "100%"),
                                       numericInput("var6",
                                                    label = "Ingrese que tanto considera que las cosas que hace en su vida actualmente valen la pena, siendo 10 que vale la pena toltalmente y 0 que no valen la pena.",
                                                    max = 10,min = 0,step = 1,value = " ", width = "100%"),
                                       selectInput("var7",
                                                   label = "Actualmente las condiciones de vida en su hogar son:",
                                                   choices = c(" ","Muy buenas","Buenas","Regulares","Malas"),
                                                   width = "100%"),
                                       selectInput("var8",
                                                   label = "La vivienda ocupada por este hogar es:",
                                                   choices = c(" ","Propia, totalmente pagada",
                                                               "Propia, la están pagando",
                                                               "En arriendo o subarriendo",
                                                               "Con permiso del propietario, sin pago alguno (usufructuario)",
                                                               "Posesión sin título (ocupante de hecho)",
                                                               "Propiedad colectiva"),
                                                   width = "100%"),
                                       textInput("var9",
                                                    label = "Ingrese la edad de sus hijos separada por coma:",
                                                    value = " ", width = "100%"),
                                       selectInput("var10",
                                                   label = "Ingrese el estrato para la tarifa de servicios públicos",
                                                   choices = c(" ","1. Bajo - Bajo",
                                                               "2. Bajo",
                                                               "3. Medio - Bajo",
                                                               "4. Medio",
                                                               "5. Medio - Alto",
                                                               "6. Alto"
                                                   ),
                                                   width = "100%"),
                                       
                                       
                                       actionButton("apply2",label = "Generar predicción", width = "100%", class = "btn btn-primary")
                                     )
                                   ),
                                    bsModal("modalResult", "", "apply2", size = "large",
                                            h3("Se estima que su satisfacción con la vida es de:"),
                                    verbatimTextOutput("satisfaccion"))
                                 )
                  
           )
  )
))
