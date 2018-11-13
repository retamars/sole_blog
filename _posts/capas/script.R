# Armo la tabla
for (a in  c("Alto", "Medio", "Bajo")){
  for (b in  c('Alto', 'Medio', 'Bajo')){
      for (c in  c('Alto', 'Medio', 'Bajo')){
        for (d in  c('Alto', 'Medio', 'Bajo')){
          for (e in  c('Alto', 'Bajo')){
            tabla <- as.data.frame(cbind(a, b, c, d, e))
            print(c(a, b, c, d, e))
          }
        }
      }
  }
}


## 
library(maptools)
library(ggmap)
library(ggplot2)
censo2001 <- shapefile("Censo2001GK_CdelU_Indic.shp")
censo2001 <- spTransform(censo2001, CRS("+proj=longlat +datum=WGS84"))
censo2010 <- shapefile("Censo2010GK_CdelU_Indic.shp")
censo2010 <- spTransform(censo2010, CRS("+proj=longlat +datum=WGS84"))
tabla
