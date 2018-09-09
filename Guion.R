rm(list=ls())
library(DataCombine)
library(MASS)
library(nnet)
library(igraph)
library(ggplot2)
library(network)
library(GGally)
library(sna)
setwd("D:/Documents/GitHub/madresSolteras")
ComposicionHogar<-read.csv2("Caracteristicas y composicion del hogar/Características y composición del hogar.csv", header=T, sep=",")
#Seleccionar mujeres
Mujeres<-data.frame(ComposicionHogar)
Mujeres<-subset(Mujeres,ComposicionHogar$P6020==2)
#Seleccionar mujeres solteras
MujeresSolteras<-data.frame(Mujeres)
MujeresSolteras<-subset(MujeresSolteras,Mujeres$P5502==5|Mujeres$P5502==3|Mujeres$P5502==4)
#Filtrador para madres solteras
ForiLasting<-nrow(MujeresSolteras)
CheckDir<-0
#Crear dataframe vacío para el resultado
MadresSolteras<-MujeresSolteras[1,]
MadresSolteras<-MadresSolteras[-1,]
#Verificar que se estén comparando personas de la misma casa
for(i in 1:ForiLasting){
  if(CheckDir!=MujeresSolteras$DIRECTORIO[i]){
    CheckDir<-MujeresSolteras$DIRECTORIO[i]
    #Base de datos transitoria que va separando las madres solteras y posteriormente las agrega al MadresSolteras que es el dataframe final
    transitoria<-data.frame(MujeresSolteras)
    transitoria<-subset(transitoria,MujeresSolteras$DIRECTORIO==CheckDir)
    ForjLasting<-nrow(transitoria)
    #Ciclo for para comparar el orden de la persona que es la madre efectivamente si viva en el hogar, de ser así guardar
    for (j in 1:ForjLasting){
      for (k in 1:ForjLasting){
        if(transitoria$P6083S1[j]==transitoria$ORDEN[k]){
          MadresSolteras<-rbind2(MadresSolteras,transitoria[k,])
        }
      }
    }
  }
}
#Tomar los directorios de las madres solteras
id<-as.vector(MadresSolteras$DIRECTORIO)
#Volverlos únicos ya que pueden haber varias madres solteras en un mismo hogar
id<-unique(id)
ForhLasting<-length(id)
#Dataframe vacío
HogaresMadresSolteras<-ComposicionHogar[1,]
HogaresMadresSolteras<-HogaresMadresSolteras[-1,]
transito2<-ComposicionHogar[1,]
transito2<-transito2[-1,]
#Comparador de direcciones con la base de datos total para retomar los núcleos familiares de cada madre soltera
for(h in 1:ForhLasting){
  transito2<-subset(ComposicionHogar,ComposicionHogar$DIRECTORIO==id[h])
  HogaresMadresSolteras<-rbind2(HogaresMadresSolteras,transito2)
}
HogaresMadresSolteras<-HogaresMadresSolteras[!duplicated(HogaresMadresSolteras[c('DIRECTORIO','ORDEN')]),]
#Se procede ahora a separar las variables a utilizar y verificar que la madre posea registro en todas esas variables a observar
#Se cargan los datos faltantes
CondVida<-read.csv2("Condiciones de vida del hogar y tenencia de bienes/Condiciones de vida del hogar y tenencia de bienes.csv",header=T,sep=",")
DatosVivienda<-read.csv2("Datos de la vivienda/Datos de la vivienda.csv", header=T, sep=",")
Educacion<-read.csv2("Educacion/Educacion.csv", header=T, sep=",")
FuerzaTrabajo<-read.csv2("Fuerza de trabajo/Fuerza de trabajo.csv", header=T, sep=",")
Salud<-read.csv2("Salud/Salud.csv", header=T, sep=",")
ServiciosHogar<-read.csv2("Servicios del hogar/Servicios del hogar.csv", header=T, sep=",")
TIC<-read.csv2("Tecnologias de informacion y comunicacion/Tecnologias de informacion y comunicacion.csv", header=T, sep=",")
FinanHogar<-read.csv2("Tenencia y financiacion de la vivienda que ocupa el hogar/Tenencia y financiacion de la vivienda que ocupa el hogar.csv", header=T, sep=",")

#Se resumen las tablas para que sólo tengan las variables de interés

DatosVivienda<-subset(DatosVivienda,select=c(DIRECTORIO, ORDEN, CANT_HOG_COMPLETOS, P8520S1A1))
ServiciosHogar<-subset(ServiciosHogar,select=c(DIRECTORIO, ORDEN, I_HOGAR))
Salud<-subset(Salud,select=c(DIRECTORIO, ORDEN, P6127, P6142))
Educacion<-subset(Educacion, select=c(DIRECTORIO, ORDEN, P8587))
FuerzaTrabajo<-subset(FuerzaTrabajo, select=c(DIRECTORIO, ORDEN, P6240))
TIC<-subset(TIC, select=c(DIRECTORIO, ORDEN, P1084))
FinanHogar<-subset(FinanHogar, select=c(DIRECTORIO, ORDEN, P5095))
CondVida<-subset(CondVida, select=c(DIRECTORIO, ORDEN, P9030, P5230,P9090))
MadresSolteras<-subset(MadresSolteras, select=c(DIRECTORIO, ORDEN,P6040,P1895,P1896,P1897,P1898,P1899, P1901, P1902,P1903,P1904,P1905,P6083S1))
#Procedo a usar la librería datacombine(la cargo al comienzo) que incluye la función "dMerge" la cuál permite eliminar duplicados al hacer un merge


#Se combinan todos los datos con todas las variables y se garantiza que cada madre soltera a evaluar posea todas las variables para el análisis, de no ser así se descarta.
total<-dMerge(MadresSolteras,CondVida,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,FinanHogar,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,TIC,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,FuerzaTrabajo,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,Educacion,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,Salud,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,ServiciosHogar,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total<-dMerge(total,DatosVivienda,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
#Eliminar unos datos alterados por el merge
total<-total[!duplicated(total[c('DIRECTORIO','ORDEN')]),]
#1126 datos para el análisis y 23 variables, revisar que estén todas
#Tomar todos los datos cómo numéricos
total<- data.frame(lapply(total, function(x) as.numeric(as.character(x))))
#Eliminar NA o infinitos de el total de los datos
total<-subset(total, total$P8587!=Inf)
total<-subset(total, total$P8520S1A1!=Inf)
total<-subset(total,total$P1896!=99)
total<-subset(total, total$I_HOGAR!=0)
total<-subset(total, total$P8520S1A1!=8|total$P8520S1A1!=9)
# total$DIRECTORIO<-NULL
# total$ORDEN<-NULL


# modeloTotal<-lm(P1895~P6040+P1896+P1897+P1898+P1899+P1901+P1902+P1903+P1904+P1905+P9030+P5230+P9090+P5095+P1084+P6240+P8587+P6127+P6142+I_HOGAR+CANT_HOG_COMPLETOS+P8520S1A1,data=total,na.action=na.exclude)
# modeloTotalBack<-stepAIC(object=modeloTotal, trace=FALSE, direction="backward", k=2)
# empty.data<-lm(P1895~1,data=total)
# objetivo<-formula(P1895~P6040+P1896+P1897+P1898+P1899+P1901+P1902+P1903+P1904+P1905+P9030+P5230+P9090+P5095+P1084+P6240+P8587+P6127+P6142+I_HOGAR+CANT_HOG_COMPLETOS+P8520S1A1)
# modeloTotalForward<-stepAIC(empty.data,scope=objetivo,direction="forward",trace=FALSE)
# modeloTotalBoth<-stepAIC(empty.data,scope=objetivo,direction="both",trace=FALSE)
# modeloLimpio<-lm(P1895~P1896+P1901+P1905+P1898+P9030+P1899+P5095+P1897+P6040,data=total,na.action=na.exclude)

# modeloMultinomLog<-multinom(P1895~P1896+P1901+P1905+P1898+P9030+P1899+P5095+P1897+P6040,data=total)
# testtable<-table(predict(modeloMultinomLog),total$P1895)
# Missclassification<-1-sum(diag(testtable))/sum(testtable)
# #57% de error de clasificación -->43% de éxito del modelo(regular)
CheckDir<-0
vecprom<-c()
vechijos<-c()
for(i in 1:nrow(total)){
  if(CheckDir!=total$DIRECTORIO[i]){
    CheckDir<-total$DIRECTORIO[i]
    transitoria<-data.frame(HogaresMadresSolteras)
    transitoria<-subset(transitoria,HogaresMadresSolteras$DIRECTORIO==CheckDir)
    edad<-0
    hijos<-0
    for (k in 1:nrow(transitoria)){
      if(total$ORDEN[i]==transitoria$P6083S1[k]){
        hijos<-hijos+1
        edad<-edad+transitoria$P6040[k]
        
      }
    }
    vechijos[i]<-hijos
    vecprom[i]<-edad/hijos
  }
}
total<-cbind2(total,vecprom)
total<-cbind2(total,vechijos)
total$P6083S1<-NULL
colnames(total)[27]<-"cantidad_hijos"
colnames(total)[26]<-"prom_edad_hijos"
attach(total)
modeloTotal<-lm(P1895~P6040+P1896+P1897+P1898+P1899+P1901+P1902+P1903+P1904+P1905+P9030+P5230+P9090+P5095+P1084+P6240+P8587+P6127+P6142+I_HOGAR+CANT_HOG_COMPLETOS+P8520S1A1+prom_edad_hijos+cantidad_hijos,data=total,na.action=na.exclude)
modeloTotalBack<-stepAIC(object=modeloTotal, trace=FALSE, direction="backward", k=2)
modeloLimpio<-lm(P1895~P1896+P1897+P1898+P1899+P1901+P1905+P9030+P5095+prom_edad_hijos+P8520S1A1,data=total,na.action=na.exclude)
#Modelo transformado para garantizar que los mayores valores sean los mejores en cuánto a calidad de vida
modeloTransFinal<-lm(P1895~P1896+P1897+P1898+P1899+P1901+P1905+I(-P9030+5)+I(-P5095+7)+prom_edad_hijos+P8520S1A1,data=total,na.action=na.exclude)



FamNet<-function(direccion){
transitoria<-data.frame(HogaresMadresSolteras)
transitoria<-subset(transitoria,HogaresMadresSolteras$DIRECTORIO==direccion)
coorgraph<-c()
leyendas<-c()
for (j in 1:nrow(transitoria)){
  for (k in 1:nrow(transitoria)){
    if (transitoria$P6083[k]==1){
      if(transitoria$ORDEN[j]==transitoria$P6083S1[k]){
        coorgraph<-append(coorgraph,c(transitoria$ORDEN[j],transitoria$ORDEN[k]))
        leyendas<-append(leyendas,c(paste(transitoria$ORDEN[j],"es madre de",transitoria$ORDEN[k])))
      }
    }
    if (transitoria$P6071[k]==1){
      if(transitoria$ORDEN[j]==transitoria$P6071S1[k]){
        coorgraph<-append(coorgraph,c(transitoria$ORDEN[j],transitoria$ORDEN[k]))
        leyendas<-append(leyendas,c(paste(transitoria$ORDEN[j],"es cónyuge de",transitoria$ORDEN[k])))
        }
      }
    
    
    if (transitoria$P6081[k]==1){
      if(transitoria$ORDEN[j]==transitoria$P6081S1[k]){
        coorgraph<-append(coorgraph,c(transitoria$ORDEN[j],transitoria$ORDEN[k]))
        leyendas<-append(leyendas,c(paste(transitoria$ORDEN[j],"es padre de",transitoria$ORDEN[k])))
      }
    } 
  }
}
g1<-graph(coorgraph)
plot(g1,edge.width=2,edge.arrow.size=0,edge.color="gold",edge.label.color="steelblue4",edge.label.font=3,edge.lty="solid",
     vertex.color=c("gold",rep("pink",length(coorgraph)-1)),vertex.shape="sphere",
     vertex.size=20,vertex.label.font=4,
     vertex.frame.color="black",vertex.label.color="black",frame=TRUE,vertex.label.dist=0,
     vertex.label.cex=1, edge.curved=0.4,edge.label=leyendas,edge.label.family="sans")
title(paste("Núcleo familiar de",direccion), sub = "Copyright © 2018 UNALMED",
      cex.main = 1.5, family="serif",font.main= 2, col.main= "black",
      cex.sub = 0.75, font.sub = 3, col.sub = "red")
legend(-0.5, -1.2, legend=c("Jefe de hogar", "Familiar del jefe"),
       pch = c(19,19),col=c("gold","pink"), cex=0.8,pt.cex=1.5)


}

predictor<-function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10){
  y<-(as.numeric(coefficients(modeloTransFinal)[2])*a1+as.numeric(coefficients(modeloTransFinal)[3])*a2+
    as.numeric(coefficients(modeloTransFinal)[4])*a3+as.numeric(coefficients(modeloTransFinal)[5])*a4
  +as.numeric(coefficients(modeloTransFinal)[6])*a5+as.numeric(coefficients(modeloTransFinal)[7])*a6
  +as.numeric(coefficients(modeloTransFinal)[8])*a7+as.numeric(coefficients(modeloTransFinal)[9])*a8
  +as.numeric(coefficients(modeloTransFinal)[10])*a9+as.numeric(coefficients(modeloTransFinal)[11])*a10)
  return(round(y))
}