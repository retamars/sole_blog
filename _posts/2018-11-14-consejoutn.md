---
layout: post
title: Actas CS UTN
author: Soledad Retamar
published: true
output: html_document
status: publish
draft: false
tags: consejoutn
---
 

 
 
## Actas de reuniones del Consejo Superior de UTN
En este post trataremos de reproducir el trabajo realizado por .
 
En este caso hemos tomado las actas de reuniones del Consejo Superior de los últimos 10 años.
Los paquetes necesarios serán: NLP, openNLP y magrittr
En primer lugar ejecutamos la función para extraer el texto de las actas, actualmente almacenadas en archivos .pdf. Ese post se puede ver en: ENLACE

 
En esta oportunidad sólo importamos el archivo .csv generado:

{% highlight r %}
  actas_CS <-   read.csv("data\\actas.csv", 
                          sep="\t", stringsAsFactors=FALSE, 
                          encoding="latin1" )
  names(actas_CS) <- c("archivo","anio", "nro", "reunion", "lugar", "txt")
{% endhighlight %}
 
### Cantidad de Reuniones por Año
En primer lugar analizaremos cuantas actas por año se recuperaron, que ser�?a equivalente a la cantidad de reuniones llevadas a cabo

{% highlight r %}
  reuniones <- actas_CS[actas_CS$anio != "2005" & 
                        actas_CS$anio != "3.pd" & 
                        actas_CS$anio != "AU20" & 
                        !is.na(actas_CS$anio),] %>% 
              count(anio, reunion, sort = TRUE) %>% 
              group_by(anio)
 
  anios <- as.data.frame(reuniones$anio, reuniones$reunion)
  names(anios)<-"anio"
 
  Freuniones<- ggplot(anios, aes(x=as.factor(anios$anio), 
      fill = as.numeric(anios$anio))) + 
    geom_bar(position='dodge', show.legend = FALSE) + 
    xlab("Año") + 
    ylab("Cantidad") + 
    scale_x_discrete("Años" ) + 
    theme_minimal() +
    ggtitle("Reuniones de CS UTN")
{% endhighlight %}
### El gráfico de frecuencias de reuniones por año:

{% highlight r %}
  plot(Freuniones)
{% endhighlight %}

![plot of chunk simpleplot](/../sole_blog/figures/simpleplot-1.png)