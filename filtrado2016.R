library(DataCombine)
library(MASS)
#Limpieza bases 2016
setwd("D:/Documents/GitHub/madresSolteras")
condi2016<-read.delim("2016/Condiciones de vida del hogar y tenencia de bienes/Condiciones de vida del hogar y tenencia de bienes.txt",header=T)
compo2016<-read.delim("2016/Caracteristicas y composicion del hogar/Caracteristicas y composicion del hogar.txt",header=T)
finanHogar2016<-read.delim("2016/Tenencia y financiacion de la vivienda que ocupa el hogar/Tenencia y financiacion de la vivienda que ocupa el hogar.txt",header=T)
dataVivi2016<-read.delim("2016/Datos de la vivienda/Datos de la vivienda.txt",header=T)
Mujeres2016<-data.frame(compo2016)
Mujeres2016<-subset(Mujeres2016,compo2016$P6020==2)
MujeresSolteras2016<-data.frame(Mujeres2016)
MujeresSolteras2016<-subset(MujeresSolteras2016,Mujeres2016$P5502==5|Mujeres2016$P5502==3|Mujeres2016$P5502==4)
MujeresSolteras2016[is.na(MujeresSolteras2016)]<-1.66666666666

#Filtrador para madres solteras
ForiLasting<-nrow(MujeresSolteras2016)
CheckDir<-0
#Crear dataframe vacío para el resultado
MadresSolteras2016<-MujeresSolteras2016[1,]
MadresSolteras2016<-MadresSolteras2016[-1,]
#Verificar que se estén comparando personas de la misma casa
for(i in 1:ForiLasting){
  if(CheckDir!=MujeresSolteras2016$DIRECTORIO[i]){
    CheckDir<-MujeresSolteras2016$DIRECTORIO[i]
    #Base de datos transitoria que va separando las madres solteras y posteriormente las agrega al MadresSolteras que es el dataframe final
    transitoria<-data.frame(MujeresSolteras2016)
    transitoria<-subset(transitoria,MujeresSolteras2016$DIRECTORIO==CheckDir)
    ForjLasting<-nrow(transitoria)
    #Ciclo for para comparar el orden de la persona que es la madre efectivamente si viva en el hogar, de ser así guardar
    for (j in 1:ForjLasting){
      for (k in 1:ForjLasting){
        if(transitoria$P6083S1[j]==transitoria$ORDEN[k]){
          MadresSolteras2016<-rbind2(MadresSolteras2016,transitoria[k,])
        }
      }
    }
  }
}
#Tomar los directorios de las madres solteras
id<-as.vector(MadresSolteras2016$DIRECTORIO)
#Volverlos únicos ya que pueden haber varias madres solteras en un mismo hogar
id<-unique(id)
ForhLasting<-length(id)
#Dataframe vacío
HogaresMadresSolteras2016<-compo2016[1,]
HogaresMadresSolteras2016<-HogaresMadresSolteras2016[-1,]
transito2<-compo2016[1,]
transito2<-transito2[-1,]
#Comparador de direcciones con la base de datos total para retomar los núcleos familiares de cada madre soltera
for(h in 1:ForhLasting){
  transito2<-subset(compo2016,compo2016$DIRECTORIO==id[h])
  HogaresMadresSolteras2016<-rbind2(HogaresMadresSolteras2016,transito2)
}
HogaresMadresSolteras2016<-HogaresMadresSolteras2016[!duplicated(HogaresMadresSolteras2016[c('DIRECTORIO','ORDEN')]),]

dataVivi2016<-subset(dataVivi2016,select=c(DIRECTORIO,ORDEN,P8520S1A1))
condi2016<-subset(condi2016,select=c(DIRECTORIO, ORDEN, P5676S4,P5676S5,P5676S7,P5676S6,P5677, P9030))
finanHogar2016<-subset(finanHogar2016,select=c(DIRECTORIO, ORDEN, P5095))
MadresSolteras2016<-subset(MadresSolteras2016, select=c(DIRECTORIO, ORDEN))
total2016<-dMerge(MadresSolteras2016,condi2016,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total2016<-dMerge(total2016,finanHogar2016,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total2016<-dMerge(total2016,dataVivi2016,by=c("DIRECTORIO","ORDEN"),dropDups = TRUE)
total2016<-total2016[!duplicated(total2016[c('DIRECTORIO','ORDEN')]),]
total2016<-na.omit(total2016)
total2016<-total2016[!duplicated(total2016[c('DIRECTORIO','ORDEN')]),]
total2016<- data.frame(lapply(total2016, function(x) as.numeric(as.character(x))))
total2016<-subset(total2016, total2016$P8520S1A1!=8|total2016$P8520S1A1!=9)
total2016$P5676S4<-(total2016$P5676S4-1)*(10/3)
total2016$P5676S5<-(total2016$P5676S5-1)*(10/3)
total2016$P5676S6<-(total2016$P5676S6-1)*(10/3)
total2016$P5676S7<-(total2016$P5676S7-1)*(10/3)
total2016$P5677<-(((-total2016$P5677+5)-1)*(10/3))
total2016$P9030<-total2016$P9030
total2016$P5095<-total2016$P5095
load("ShinyApp/www/LastPredictor")

HogaresMadresSolteras2016[is.na(HogaresMadresSolteras2016)]<-1.66666666666
CheckDir<-0
vecprom2016<-c()

for(i in 1:nrow(total2016)){
  if(CheckDir!=total2016$DIRECTORIO[i]){
    CheckDir<-total2016$DIRECTORIO[i]
    transitoria<-data.frame(HogaresMadresSolteras2016)
    transitoria<-subset(transitoria,HogaresMadresSolteras2016$DIRECTORIO==CheckDir)
    edad<-0
    hijos<-0
    for (k in 1:nrow(transitoria)){
      if(total2016$ORDEN[i]==transitoria$P6083S1[k]){
        hijos<-hijos+1
        edad<-edad+transitoria$P6040[k]
        
      }
    }
    vecprom2016[i]<-edad/hijos
  }
}
total2016<-cbind2(total2016,vecprom2016)
colnames(total2016)[11]<-"prom_edad_hijos"
attach(total2016)
vecsas<-c()
for(i in 1:nrow(total2016)){
  # modeloAdapt
  aux2<-c(P5676S4[i],P5676S5[i],P5676S7[i],P5676S6[i],P5677[i],P9030[i],P5095[i],prom_edad_hijos[i],P8520S1A1[i])
  aux2<-t(aux2)
  aux2<-as.data.frame(aux2)
  colnames(aux2)[]<-c("P1896","P1897","P1898","P1899","P1901","P9030","P5095","prom_edad_hijos","P8520S1A1")
  est<-as.numeric(predict(modeloAdapt,newdata=aux2))
  vecsas[i]<-est
}
total2016<-cbind2(total2016,vecsas)
colnames(total2016)[12]<-"SatisfaccionEst"
total2016<-na.omit(total2016)
total2016$SatisfaccionEst<-round(total2016$SatisfaccionEst)
total2016$SatisfaccionEst[total2016$SatisfaccionEst>10]<-10
