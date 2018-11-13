#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(leaflet)
library(shiny)
library(shinydashboard)


  # ---------------------
  # Titulo
  # ---------------------
  header <-  dashboardHeader(title="Censos CdelU")
  
  # ---------------------
  # Barra Lateral - Sidebar
  # ---------------------
  
  sidebar <-  dashboardSidebar(
    sidebarMenu(
      title="Censos C. del U.",
      menuItem("Censo 2001", tabName = "2001"),

      menuItem("Censo 2010", tabName = "2010"),
      
      menuItem("Comparación de Indicadores", # tabName = "20102", icon = icon("globe"),startExpanded = FALSE,
        menuSubItem("Indicador NBI", tabName = "nbi"),
        menuSubItem("Indicador Hogares sin Cloaca", tabName = "cloaca"),
        menuSubItem("Indicador Analfabetismo", tabName = "analfa"),
        menuSubItem("Indicador Cobertura Salud", tabName = "salud"),
        menuSubItem("Indicador de Viviendas Precarias", tabName = "viv")
      )
    )
  )
  
  # ---------------------
  # cuerpo - Body
  # ---------------------
body<-dashboardBody(
  includeCSS("styles.css"),
  
  tabItems(
    
    ## ---------
    ## Menu 2001
    ## ---------
    tabItem(tabName="2001",
            
      fluidRow(
        valueBox("66607","Personas", icon("users"), width = 4, color = "light-blue"),
        valueBox("18625","Hogares", icon("home"), width = 4, color = "maroon") ),
     
      fluidRow(
        column(width = 6,
          box(title = "Indicador NBI", width = NULL, solidHeader = TRUE, status = "primary",
            "Este Indicador se construyó considerando el Porcentaje de hogares con NBI",
            "Bajo (de 0 a 9 por ciento); Medio (de 9,1 a 12 por ciento); Alto (12,1 por ciento y más)",
            leafletOutput("mapaNBI01"))),
        column(width = 6,
          box(title = "Indicador de Hogares sin Cloaca", width = NULL, solidHeader = TRUE, status = "warning", 
            "Porcentaje de viviendas sin desagüe a red cloacal:",
            "Bajo (de 0 a 74 por ciento); Medio (de 74,1 a 90 por ciento); Alto (90,1 por ciento y más)",
            leafletOutput("mapaCloaca01")))),
      
      fluidRow(
        column(width = 6,
          box(title = "Indicador de Analfabetismo", width = NULL, solidHeader = TRUE, status = "primary",
            "Porcentaje de población analfabeta (de 10 años y más):",
            "Bajo (de 0 a 2,5 por ciento); Medio (de 2,6 a 3,2 por ciento); Alto (3,3 por ciento y más)",
            leafletOutput("mapaAnalf01"))),
        column(width = 6,
          box(title = "Indicador de Cobertura de Salud", width = NULL, solidHeader = TRUE, status = "primary",
            "Porcentaje de población sin cobertura en salud: ",
            "Bajo (de 0 a 33,5 por ciento); Medio (de 33,6 a 39,3 por ciento); Alto (39,4 por ciento y más).",
            leafletOutput("mapaSalud01")),
          
          box(width = NULL, background = "black",
            "Indice de Precariedad de las Condiciones de Vida en los Partidos (IPREPAR)")))
      ),
    ## ---------
    ## Menu 2010
    ## ---------
    tabItem(tabName="2010",
            # h4('Datos extraídos del Censo Nacional de Población, Hogares y Viviendas 2010'),
      fluidRow(
        valueBox("73729","Personas", icon("users"), width = 4, color = "light-blue"),
        valueBox("23640","Hogares", icon("home"), width = 4, color = "maroon")),
      
      fluidRow(
        column(width = 6,
               box(title = "Indicador NBI", width = NULL, solidHeader = TRUE, status = "primary",
                   "Este Indicador se construyó considerando el Porcentaje de hogares con NBI",
                   "Bajo (de 0 a 9 por ciento); Medio (de 9,1 a 12 por ciento); Alto (12,1 por ciento y más)",
                   leafletOutput("mapaNBI10"))),
        column(width = 6,
               box(title = "Indicador de Hogares sin Cloaca", width = NULL, solidHeader = TRUE, status = "warning", 
                   "Porcentaje de viviendas sin desagüe a red cloacal:",
                   "Bajo (de 0 a 74 por ciento); Medio (de 74,1 a 90 por ciento); Alto (90,1 por ciento y más)",
                   leafletOutput("mapaCloaca10")))),
      
      fluidRow(
        column(width = 6,
               box(title = "Indicador de Analfabetismo", width = NULL, solidHeader = TRUE, status = "primary",
                   "Porcentaje de población analfabeta (de 10 años y más):",
                   "Bajo (de 0 a 2,5 por ciento); Medio (de 2,6 a 3,2 por ciento); Alto (3,3 por ciento y más)",
                   leafletOutput("mapaAnalf10"))),
        column(width = 6,
               box(title = "Indicador de Cobertura de Salud", width = NULL, solidHeader = TRUE, status = "primary",
                   "Porcentaje de población sin cobertura en salud: ",
                   "Bajo (de 0 a 33,5 por ciento); Medio (de 33,6 a 39,3 por ciento); Alto (39,4 por ciento y más).",
                   leafletOutput("mapaSalud10")),
               box(width = NULL, background = "black",
                   "Indice de Precariedad de las Condiciones de Vida en los Partidos (IPREPAR)")))
        ),
    
    ## ---------
    ## Menu Comparación de Indicadores
    ## ---------
    
    
    ## ---------
    ## 
    ## ---------
    tabItem(tabName = "nbi",
        
        tabsetPanel(type="tabs",
          tabPanel("2001",
            fluidRow(column(width=12,leafletOutput("mapa2NBI01")))),
          tabPanel("2010",
            fluidRow(column(width=12,leafletOutput("mapa2NBI10")))
            ))),
    
    tabItem(tabName="cloaca",
        tabsetPanel(type="pills",
          tabPanel("2001",
            fluidRow(column(width=12,leafletOutput("mapa2Cloaca01")))),
          tabPanel("2010",
            fluidRow(column(width=12,leafletOutput("mapa2Cloaca10")))
            ))),
    
    tabItem(tabName="analfa",
        p('Poblacion de 10 años y mas analfabeta, en porcentaje. Año 2010'),
        tabsetPanel(type="tabs",
          tabPanel("2001",
            fluidRow(column(width=12,leafletOutput("mapa2Analf01")))),
          tabPanel("2010",
            fluidRow(column(width=12,leafletOutput("mapa2Analf10")))
            ))),
    
    tabItem(tabName="salud",
            p('Población sin Cobertura de Salud'),
            tabsetPanel(type="tabs",
                        tabPanel("2001",
                                 fluidRow(column(width=12,leafletOutput("mapa2Salud01")))),
                        tabPanel("2010",
                                 fluidRow(column(width=12,leafletOutput("mapa2Salud10")))
               ))),
    tabItem(tabName="viv",
            p('Población con Viviendas Precarias'),
            tabsetPanel(type="tabs",
                        tabPanel("2001",
                                 fluidRow(column(width=12,leafletOutput("mapa2Viv01")))),
                        tabPanel("2010",
                                 fluidRow(column(width=12,leafletOutput("mapa2Viv10")))
                        )))
  )
)

dashboardPage(header, sidebar, body, skin = "black")
