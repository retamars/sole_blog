---
layout: post
title: Reconocimiento de Entidades
author: Soledad Retamar
published: true
status: publish
draft: false
tags: entidades
---
 
```{r setup, include=FALSE, echo=FALSE} knitr::opts_chunk$set(echo = FALSE)
```
 
## Detección de oraciones y palabras
Con estas lineas de código describiremos como detectar oraciones, palabras, personas, lugares y organizaciones en un texto. Para realizarlo mas práctico en este ejemplo analizaremos una noticia extraña y asignaremos el texto en el código, pero se podría aplicar al texto que obtengamos dinamicamente de nuestras fuentes de datos.
 
Los paquetes necesarios serían: NLP, openNLP y magrittr
 

{% highlight r %}
library(NLP)
library(openNLP)
library(magrittr)
 
noticia <- as.String('Donald Trump apuntÃ³ este martes contra el presidente francÃ©s, 
Emmanuel Macron, por su propuesta de crear un ejÃ©rcito europeo, en un nuevo reclamo 
hacia sus aliados europeos para que refuercen su aporte econÃ³mico hacia el 
financiamiento de la OTAN.
Macron declarÃ³ la semana pasada la necesidad de proteger con unas fuerzas armadas 
a Europa,"en relaciÃ³n a China, Rusia e incluso Estados Unidos", una idea que Trump
calificÃ³ el viernes como "insultante". Ahora, renovÃ³ su rechazo con un mordaz 
comentario, reabriendo heridas entre ParÃ­s y BerlÃ­n, hoy estrechos aliados y 
defensores del multilateralismo.
"Fue Alemania en la Primera y Segunda Guerra Mundial. Â¿CÃ³mo funcionÃ³ eso para Francia?
Ellos estaban comenzando a aprender alemÃ¡n en ParÃ­s antes de que EEUU intervenga", 
escribiÃ³ en su Twitter, en referencia a la ocupaciÃ³n nazi sobre la capital francesa, 
entre 1940 y 1944.')
{% endhighlight %}
 
## Palabras y Oraciones
Necesitaremos definir dos funciones, basadas en librerÃ­as de Java, que nos marcarÃ¡n donde comienza y termina cada palabra y cada oracion.

{% highlight r %}
palabras_ann <- Maxent_Word_Token_Annotator()
oracion_ann <- Maxent_Sent_Token_Annotator()
{% endhighlight %}
Llamaremos iterativamente a estas funciones para el texto contenido en noticia para determinar primero dÃ³nde estÃ¡n las oraciones y luego determinar dÃ³nde estÃ¡n las palabras. 
Podemos aplicar estas funciones a nuestros datos utilizando la funciÃ³n annotate().

{% highlight r %}
noticia1_annotations <- annotate(noticia, list(oracion_ann, palabras_ann))
{% endhighlight %}



{% highlight text %}
## Error in as.data.frame.default(x[[i]], optional = TRUE): cannot coerce class 'c("Simple_Sent_Token_Annotator", "Annotator")' to a data.frame
{% endhighlight %}
El objeto creado contiene ahora un objeto que contiene una lista de oraciones y de palabras identificadas por posiciÃ³n. 

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
En nuestro ejemplo, la primera oraciÃ³n en el documento comienza en el caracter 1 y termina en el caracter 250. En el caso de la primer palabra detectada sus posicion inicial es 1 y finaliza en el caracter 6.
 
Para combinar la noticia y el objeto creado con las posiciones usaremos la funciÃ³n AnnotatedPlainTextDocument del paquete NLP. Si quisiÃ©ramos, tambiÃ©n podrÃ­amos asociar metadatos con el objeto usando el argumento "meta".

{% highlight r %}
noti_doc <- AnnotatedPlainTextDocument(noticia, noticia1_annotations)
{% endhighlight %}
 
# Palabras y oraciones
Ahora podemos extraer informaciÃ³n de nuestro documento utilizando las funciones sents() para obtener las oraciones y words() para obtener las palabras. Mostraremos la primer oraciÃ³n y las primeras 10 palabras:
 

{% highlight r %}
sents(noti_doc) %>% head(1)
{% endhighlight %}



{% highlight text %}
## [[1]]
##  [1] "Donald"          "Trump"           "apuntÃ"         
##  [4] " est"            " marte"          " contr"         
##  [7] " e"              " president"      " francÃ"        
## [10] "©"               " \nEmmanu"       "l Macr"         
## [13] "o"               ", p"             "r "             
## [16] "u propues"       "a "              "e cre"          
## [19] "r "              "n ejÃ©rc"        "to euro"        
## [22] "p"               "o,"              "en"             
## [25] "un nu"           "vo recl"         "o \nha"         
## [28] "ia "             "us alia"         "os europ"       
## [31] "os p"            "ra "             "ue refuer"      
## [34] "en"              "su apo"          "te econÃ³"      
## [37] "ico h"           "ci"              "el \nfinanciami"
## [40] "nt"              " d"              " la O"
{% endhighlight %}



{% highlight r %}
words(noti_doc) %>% head(10)
{% endhighlight %}



{% highlight text %}
##  [1] "Donald"     "Trump"      "apuntÃ"     " est"       " marte"    
##  [6] " contr"     " e"         " president" " francÃ"    "©"
{% endhighlight %}
 
# Identificando personas y lugares.
Entre los distintos tipos de anotadores proporcionados por el paquete openNLP se encuentra uno de entidades.
Una entidad es basicamente un nombre propio, como una persona o un nombre de lugar.
 
Usando una tÃ©cnica llamada reconocimiento de entidad nombrada (NER), podemos extraer varios tipos de nombres de un documento. 
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
Si vizualizamos los lugares que detectÃ³ en la noticia obtendremos:

{% highlight text %}
## [1] "Europa"  "China"   "ParÃ­s"  "BerlÃ­n" "Francia" "ParÃ­s"
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
 
 
 
