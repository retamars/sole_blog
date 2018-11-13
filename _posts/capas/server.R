## This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.#
# Find out more about building applications with Shiny here:
##    http://shiny.rstudio.com/#
#  setwd("C:\\Users\\UNER\\Dropbox\\PID Observatorio\\ObservatorioCensos\\")

# list.files()
library(shiny)
library(shinydashboard)
library(leaflet)
# library(shapefiles)
library(rgdal)
library(maptools)
library(ggmap)
library(ggplot2)
library(ggvis)
library(rgeos)
library(htmltools)

server<-function(input, output, session) {
  progress <- shiny::Progress$new()
  progress$set(message="Cargando los datos al mapa", value=0)

  censo2001 <- readOGR("Censo2001GK_CdelU_Indic.shp")
  censo2001 <- spTransform(censo2001, CRS("+proj=longlat +datum=WGS84"))
  censo2010 <- readOGR("Censo2010GK_CdelU_Indic.shp")
  censo2010 <- spTransform(censo2010, CRS("+proj=longlat +datum=WGS84"))
  censo2001$PorAnalfMe
  censo2001$NbiEscolar
  # censo2001$HOGARES/censo2001$TOTAL
  censo2001$HOGARES
  censo2001$TOTAL
  # Color NBI: NBI Bajo (de 0 a 9 por ciento); Medio (de 9,1 a 12 por ciento); Alto (12,1 por ciento y ms)
  binpalA <- colorFactor("Blues", c('Alto', 'Medio', 'Bajo'), ordered = TRUE , reverse = TRUE) #NBI
  binpalR <- colorFactor("OrRd", c('Alto', 'Medio', 'Bajo'), ordered = TRUE , reverse = TRUE) #CLOACA
  binpalB <- colorFactor("YlOrRd", c('Alto', 'Medio', 'Bajo'), ordered = TRUE , reverse = TRUE) #ANALFABETISMO
  binpalS <- colorFactor("BuGn", c('Alto', 'Medio', 'Bajo'), ordered = TRUE , reverse = TRUE) #SALUD
  binpalG <- colorFactor("Purples", c('Alto', 'Bajo'), ordered = TRUE , reverse = TRUE) # VIV PRECARIA
  #-----------
  # NBI
  #-----------
  
  # -- 2001
  mapNBI01 = leaflet()%>% addTiles() %>%
          setView(-58.2553996,  -32.4832925, zoom = 12)%>%
          addPolygons(data=censo2001, fillColor = ~binpalA(censo2001$I_NBI),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(paste(censo2001$I_NBI, " ",censo2001$PorConNBI, '%', sep="")), group="2001")  %>%
          addLegend(position ="topright", pal=binpalA,  
                values = censo2001$I_NBI, title = "NBI 2001")
    
  # -- 2010
  mapNBI10 = leaflet()%>% addTiles()%>%
            setView(-58.2553996, -32.4832925, zoom = 12)%>%
            addPolygons(data=censo2010, fillColor = ~binpalA(censo2010$I_NBI),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(paste(censo2010$I_NBI, " ", censo2010$PorConNBI,'%', sep="")), group="2010") %>%
            addLegend(position ="topright", pal=binpalA,  
                      values = censo2010$I_NBI, title = "NBI 2010")
    
  #-----------
  # CLOACA
  #-----------
    #- 2001
    mapCloaca01 = leaflet()%>% addTiles() %>%
      setView(-58.2553996,  -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2001, fillColor = ~binpalR(censo2001$I_Cloaca),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(paste(censo2001$I_Cloaca, " ", censo2001$PorSinCloa,'%', sep="")), group="2001")  %>%
      addLegend(position ="topright", pal=binpalR,  
                values = censo2001$I_Cloaca, title = "Cloaca 2001")
    # -- 2010
    mapCloaca10 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2010, fillColor = ~binpalR(censo2010$I_Cloaca),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(paste(censo2010$I_Cloaca, " ", censo2010$PorSinCloa,'%', sep="")), group="2010") %>%
      addLegend(position ="topright", pal=binpalR,  
                values = censo2010$I_Cloaca, title = "Cloaca 2010")
  
  #-----------
  # Analfabetismo
  #-----------
    #- 2001
    mapAnalf01 = leaflet()%>% addTiles() %>%
      setView(-58.2553996,  -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2001, fillColor = ~binpalB(censo2001$I_Analfab),
                weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                label = ~htmlEscape(paste(censo2001$I_Analfab, " ", censo2001$PorAnalfab, '%', sep = "")), group="2001")  %>%
      addLegend(position ="topright", pal=binpalB,  
              values = censo2001$I_Analfab, title = "Analfabetismo 2001")
  
    #- 2010
    mapAnalf10 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2010, fillColor = ~binpalB(censo2010$I_Analfab),
                weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                label = ~htmlEscape(paste(censo2010$I_Analfab," ", censo2010$PorAnalfab, '%', sep = "")), group="2010") %>%
      addLegend(position ="topright", pal=binpalB,  
              values = censo2010$I_Analfab, title = "Analfabetismo 2010")
  
  #-----------
  # Salud
  #-----------
    #- 2001
    mapSalud01 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2001, fillColor = ~binpalS(censo2001$I_Salud),
                weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                label = ~htmlEscape(paste(censo2001$I_Salud, " ", censo2001$PorSinCobe, '%', sep = "")), group="2001") %>%
      addLegend(position ="topright", pal=binpalS,  
              values = censo2001$I_Salud, title = "Cobertura Salud 2001")
    
    #- 2010
    mapSalud10 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2010, fillColor = ~binpalS(censo2010$I_Salud),
                weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                label = ~htmlEscape(paste(censo2010$I_Salud, " ", censo2010$PorSinCobe, '%', sep = "")), group="2010") %>%
      addLegend(position ="topright", pal=binpalS,  
              values = censo2010$I_Salud, title = "Cobertura Salud 2010")
    
  #-----------
  # Viv Precaria
  #-----------
    #- 2001
    mapViv01 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2001, fillColor = ~binpalG(censo2001$I_VivPrec),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(censo2001$I_VivPrec), group="2001") %>%
      addLegend(position ="topright", pal=binpalG,  
                values = censo2001$I_VivPrec, title = "Vivienda Precaria 2001")
    
    #- 2010
    mapViv10 = leaflet()%>% addTiles()%>%
      setView(-58.2553996, -32.4832925, zoom = 12)%>%
      addPolygons(data=censo2010, fillColor = ~binpalG(censo2010$I_VivPrec),
                  weight = 1, opacity = 1, color = "black", dashArray = "3", fillOpacity = 0.5,
                  label = ~htmlEscape(censo2010$I_VivPrec), group="2010") %>%
      addLegend(position ="topright", pal=binpalG,  
                values = censo2010$I_VivPrec, title = "Vivienda Precaria 2010")
    
    
  ##-----------
  ## Salidas 
  ##-----------
  # NBI
  #-----------
  output$mapaNBI01 <-renderLeaflet({mapNBI01})  
  output$mapaNBI10 <-renderLeaflet({mapNBI10}) 
  # 
  output$mapa2NBI01<-renderLeaflet({mapNBI01}) 
  output$mapa2NBI10 <-renderLeaflet({mapNBI10}) 
  ##-----------
  # CLOACA
  #-----------
  output$mapaCloaca01 <-renderLeaflet({mapCloaca01})  
  output$mapaCloaca10 <-renderLeaflet({mapCloaca10}) 
  # 
  output$mapa2Cloaca01 <-renderLeaflet({mapCloaca01})
  output$mapa2Cloaca10 <-renderLeaflet({mapCloaca10})
  ##-----------
  # ANALFABETISMO
  #----------------
  output$mapaAnalf01 <-renderLeaflet({mapAnalf01})  
  output$mapaAnalf10 <-renderLeaflet({mapAnalf10}) 
  # 
  output$mapa2Analf01 <-renderLeaflet({mapAnalf01})
  output$mapa2Analf10 <-renderLeaflet({mapAnalf10})
  ##-----------
  # SALUD
  #----------------
  output$mapaSalud01<-renderLeaflet({mapSalud01})
  output$mapaSalud10<-renderLeaflet({mapSalud10})
  
  output$mapa2Salud01<-renderLeaflet({mapSalud01})
  output$mapa2Salud10<-renderLeaflet({mapSalud10})  
  ##-----------
  # VIV PREC
  #----------------
  output$mapaViv01<-renderLeaflet({mapViv01})
  output$mapaViv10<-renderLeaflet({mapViv10})
  
  output$mapa2Viv01<-renderLeaflet({mapViv01})
  output$mapa2Viv10<-renderLeaflet({mapViv10})  
}