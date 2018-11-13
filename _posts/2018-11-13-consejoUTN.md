---
layout: post
title: Análisis de textos
author: Soledad Retamar
published: true
status: publish
draft: false
tags: consejo
---
 
```{r setup, include=FALSE} knitr::opts_chunk$set(echo = FALSE)
```
 
## Actas de reuniones del Consejo Superior de UTN
En este post trataremos de reproducir el trabajo realizado por .
 
En este caso hemos tomado lactas de reuniones del Consejo Superior de los últimos 10 años.
Los paquetes necesarios serán: NLP, openNLP y magrittr
 

{% highlight text %}
## Loading required package: xml2
{% endhighlight %}



{% highlight text %}
## 
## Attaching package: 'rvest'
{% endhighlight %}



{% highlight text %}
## The following object is masked from 'package:purrr':
## 
##     pluck
{% endhighlight %}



{% highlight text %}
## The following object is masked from 'package:qdap':
## 
##     %>%
{% endhighlight %}



{% highlight text %}
## 
## Attaching package: 'readr'
{% endhighlight %}



{% highlight text %}
## The following object is masked from 'package:rvest':
## 
##     guess_encoding
{% endhighlight %}



{% highlight text %}
## -- Attaching packages ---------------------------------- tidyverse 1.2.1 --
{% endhighlight %}



{% highlight text %}
## v forcats 0.3.0
{% endhighlight %}



{% highlight text %}
## -- Conflicts ------------------------------------- tidyverse_conflicts() --
## x ggplot2::%+%()          masks qdapRegex::%+%()
## x ggplot2::annotate()     masks NLP::annotate()
## x dplyr::explain()        masks qdapRegex::explain()
## x tidyr::extract()        masks magrittr::extract()
## x dplyr::filter()         masks stats::filter()
## x readr::guess_encoding() masks rvest::guess_encoding()
## x dplyr::id()             masks qdapTools::id()
## x dplyr::lag()            masks stats::lag()
## x rvest::pluck()          masks purrr::pluck()
## x purrr::set_names()      masks magrittr::set_names()
{% endhighlight %}



{% highlight text %}
## 
## Attaching package: 'tau'
{% endhighlight %}



{% highlight text %}
## The following object is masked from 'package:readr':
## 
##     tokenize
{% endhighlight %}



{% highlight text %}
## Loading required package: viridisLite
{% endhighlight %}



{% highlight text %}
## Warning in file(filename, "r", encoding = encoding): cannot open file
## 'functions.R': No such file or directory
{% endhighlight %}



{% highlight text %}
## Error in file(filename, "r", encoding = encoding): cannot open the connection
{% endhighlight %}
 
## Palabras y Oraciones
Necesitaremos definir dos funciones, basadas en librerías de Java, que nos marcarán donde comienza y termina cada palabra y cada oracion.

{% highlight r %}
palabras_ann <- Maxent_Word_Token_Annotator()
oracion_ann <- Maxent_Sent_Token_Annotator()
{% endhighlight %}
Llamaremos iterativamente a estas funciones para el texto contenido en noticia para determinar primero dónde están las oraciones y luego determinar dónde están las palabras. 
Podemos aplicar estas funciones a nuestros datos utilizando la función annotate().

{% highlight r %}
noticia1_annotations <- annotate(noticia, list(oracion_ann, palabras_ann))
{% endhighlight %}



{% highlight text %}
## Error in as.data.frame.default(x[[i]], optional = TRUE): cannot coerce class 'c("Simple_Sent_Token_Annotator", "Annotator")' to a data.frame
{% endhighlight %}
El objeto creado contiene ahora un objeto que contiene una lista de oraciones y de palabras identificadas por posición. 

{% highlight text %}
##  id type     start end features
##   1 sentence     1 250 constituents=<<integer,42>>
##   2 sentence   252 455 constituents=<<integer,37>>
##   3 sentence   457 606 constituents=<<integer,25>>
##   4 sentence   608 660 constituents=<<integer,11>>
##   5 sentence   662 693 constituents=<<integer,6>>
##   6 sentence   695 882 constituents=<<integer,35>>
##   7 word         1   6 
##   8 word         8  12
{% endhighlight %}
En nuestro ejemplo, la primera oración en el documento comienza en el caracter 1 y termina en el caracter 250. En el caso de la primer palabra detectada sus posicion inicial es 1 y finaliza en el caracter 6.
 
Para combinar la noticia y el objeto creado con las posiciones usaremos la función AnnotatedPlainTextDocument del paquete NLP. Si quisiéramos, también podríamos asociar metadatos con el objeto usando el argumento "meta".

{% highlight r %}
noti_doc <- AnnotatedPlainTextDocument(noticia, noticia1_annotations)
{% endhighlight %}
 
# Palabras y oraciones
Ahora podemos extraer información de nuestro documento utilizando las funciones sents() para obtener las oraciones y words() para obtener las palabras. Mostraremos la primer oración y las primeras 10 palabras:
 

{% highlight r %}
sents(noti_doc) %>% head(1)
{% endhighlight %}



{% highlight text %}
## [[1]]
##  [1] "Donald"          "Trump"           "apunt�"         
##  [4] " est"            " marte"          " contr"         
##  [7] " e"              " president"      " franc�"        
## [10] "�"               " \nEmmanu"       "l Macr"         
## [13] "o"               ", p"             "r "             
## [16] "u propues"       "a "              "e cre"          
## [19] "r "              "n ejérc"        "to euro"        
## [22] "p"               "o,"              "en"             
## [25] "un nu"           "vo recl"         "o \nha"         
## [28] "ia "             "us alia"         "os europ"       
## [31] "os p"            "ra "             "ue refuer"      
## [34] "en"              "su apo"          "te econó"      
## [37] "ico h"           "ci"              "el \nfinanciami"
## [40] "nt"              " d"              " la O"
{% endhighlight %}



{% highlight r %}
words(noti_doc) %>% head(10)
{% endhighlight %}



{% highlight text %}
##  [1] "Donald"     "Trump"      "apunt�"     " est"       " marte"    
##  [6] " contr"     " e"         " president" " franc�"    "�"
{% endhighlight %}
 
# Identificando personas y lugares.
Entre los distintos tipos de anotadores proporcionados por el paquete openNLP se encuentra uno de entidades.
Una entidad es basicamente un nombre propio, como una persona o un nombre de lugar.
 
Usando una técnica llamada reconocimiento de entidad nombrada (NER), podemos extraer varios tipos de nombres de un documento. 
Crearemos las funciones para detectar tres tipos de entidades: personas, ubicaciones y organizaciones.
 

{% highlight r %}
persona_ann <- Maxent_Entity_Annotator(language ="es", kind = "person")
ubicacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "location")
organizacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "organization")
{% endhighlight %}
 
Crearemos una nueva lista para mantener nuestros anotadores en el orden en que queremos aplicarlos
 

{% highlight r %}
annot.l1 = NLP::annotate(noticia, list(oracion_ann, 
                                      palabras_ann,
                                      ubicacion_ann,
                                      persona_ann, 
                                      organizacion_ann))
k <- sapply(annot.l1$features, `[[`, "kind")
{% endhighlight %}
 
### Personas que aparecen en la noticia

{% highlight r %}
personas = noticia[annot.l1[k == "person"]]
{% endhighlight %}
Los nombres propios que se encontraron en la noticia son:

{% highlight text %}
## [1] "Donald Trump"           "Emmanuel Macron"       
## [3] "Trump"                  "Segunda Guerra Mundial"
{% endhighlight %}
 
### Lugares

{% highlight r %}
lugares = noticia[annot.l1[k == "location"]]
{% endhighlight %}
Si vizualizamos los lugares que detectó en la noticia obtendremos:

{% highlight text %}
## [1] "Europa"  "China"   "París"  "Berlín" "Francia" "París"
{% endhighlight %}
 
### Organizaciones

{% highlight r %}
org = noticia[annot.l1[k == "organization"]]
{% endhighlight %}
 
Si vemos las organizaciones:

{% highlight text %}
## [1] "China"            "Rusia"            "Estados Unidos\""
## [4] "Francia"          "EEUU"
{% endhighlight %}
 

{% highlight r %}
plot(pressure)
{% endhighlight %}

![plot of chunk pressure](/figures/pressure-1.png)
 
Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
