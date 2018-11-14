---
layout: post
title: Reconocimiento de Entidades
author: Soledad Retamar
published: true
status: publish
draft: false
tags: entidades
---
 
```{r setup, include=FALSE} knitr::opts_chunk$set(echo = FALSE)
```
 
## Detección de oraciones y palabras
Con estas lineas de código describiremos como detectar oraciones, palabras, personas, lugares y organizaciones en un texto. Para realizarlo mas práctico en este ejemplo analizaremos una noticia extraída y asignaremos el texto en el código, pero se podría aplicar al texto que obtengamos dinamicamente de nuestras fuentes de datos.
 
Los paquetes necesarios serán: NLP, openNLP y magrittr
 

{% highlight r %}
library(NLP)
library(openNLP)
library(magrittr)
 
noticia <- as.String('Donald Trump apuntó este martes contra el presidente francés, 
Emmanuel Macron, por su propuesta de crear un ejército europeo, en un nuevo reclamo 
hacia sus aliados europeos para que refuercen su aporte económico hacia el 
financiamiento de la OTAN.
Macron declaró la semana pasada la necesidad de proteger con unas fuerzas armadas 
a Europa,"en relación a China, Rusia e incluso Estados Unidos", una idea que Trump
calificó el viernes como "insultante". Ahora, renovó su rechazo con un mordaz 
comentario, reabriendo heridas entre París y Berlín, hoy estrechos aliados y 
defensores del multilateralismo.
"Fue Alemania en la Primera y Segunda Guerra Mundial. ¿Cómo funcionó eso para Francia?
Ellos estaban comenzando a aprender alemán en París antes de que EEUU intervenga", 
escribió en su Twitter, en referencia a la ocupación nazi sobre la capital francesa, 
entre 1940 y 1944.')
{% endhighlight %}
 
## Palabras y Oraciones
Necesitaremos definir dos funciones, basadas en librerías de Java, que nos marcarán donde comienza y termina cada palabra y cada oracion.

{% highlight r %}
palabras_ann <- Maxent_Word_Token_Annotator()
{% endhighlight %}



{% highlight text %}
## Error in .jnew("opennlp.tools.tokenize.TokenizerModel", .jcast(.jnew("java.io.FileInputStream", : java.lang.OutOfMemoryError: Java heap space
{% endhighlight %}



{% highlight r %}
oracion_ann <- Maxent_Sent_Token_Annotator()
{% endhighlight %}



{% highlight text %}
## Error in .jnew("opennlp.tools.sentdetect.SentenceModel", .jcast(.jnew("java.io.FileInputStream", : java.lang.OutOfMemoryError: GC overhead limit exceeded
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
{% endhighlight %}



{% highlight text %}
## Error in .jnew("opennlp.tools.namefind.TokenNameFinderModel", .jcast(.jnew("java.io.FileInputStream", : java.lang.OutOfMemoryError: GC overhead limit exceeded
{% endhighlight %}



{% highlight r %}
ubicacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "location")
{% endhighlight %}



{% highlight text %}
## Error in .jnew("opennlp.tools.namefind.TokenNameFinderModel", .jcast(.jnew("java.io.FileInputStream", : java.lang.OutOfMemoryError: GC overhead limit exceeded
{% endhighlight %}



{% highlight r %}
organizacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "organization")
{% endhighlight %}



{% highlight text %}
## Error in .jnew("opennlp.tools.namefind.TokenNameFinderModel", .jcast(.jnew("java.io.FileInputStream", : java.lang.OutOfMemoryError: GC overhead limit exceeded
{% endhighlight %}
 
Crearemos una nueva lista para mantener nuestros anotadores en el orden en que queremos aplicarlos
 

{% highlight r %}
annot.l1 = NLP::annotate(noticia, list(oracion_ann, 
                                      palabras_ann,
                                      ubicacion_ann,
                                      persona_ann, 
                                      organizacion_ann))
{% endhighlight %}



{% highlight text %}
## Error in as.Annotator_Pipeline(f): object 'ubicacion_ann' not found
{% endhighlight %}



{% highlight r %}
k <- sapply(annot.l1$features, `[[`, "kind")
{% endhighlight %}



{% highlight text %}
## Error in lapply(X = X, FUN = FUN, ...): object 'annot.l1' not found
{% endhighlight %}
 
### Personas que aparecen en la noticia

{% highlight r %}
personas = noticia[annot.l1[k == "person"]]
{% endhighlight %}



{% highlight text %}
## Error in is.Span(i): object 'annot.l1' not found
{% endhighlight %}
Los nombres propios que se encontraron en la noticia son:

{% highlight text %}
## Error in eval(expr, envir, enclos): object 'personas' not found
{% endhighlight %}
 
### Lugares

{% highlight r %}
lugares = noticia[annot.l1[k == "location"]]
{% endhighlight %}



{% highlight text %}
## Error in is.Span(i): object 'annot.l1' not found
{% endhighlight %}
Si vizualizamos los lugares que detectó en la noticia obtendremos:

{% highlight text %}
## Error in eval(expr, envir, enclos): object 'lugares' not found
{% endhighlight %}
 
### Organizaciones

{% highlight r %}
org = noticia[annot.l1[k == "organization"]]
{% endhighlight %}



{% highlight text %}
## Error in is.Span(i): object 'annot.l1' not found
{% endhighlight %}
 
Si vemos las organizaciones:

{% highlight text %}
## Error in eval(expr, envir, enclos): object 'org' not found
{% endhighlight %}
 

{% highlight r %}
plot(pressure)
{% endhighlight %}

![plot of chunk pressure](/figures/pressure-1.png)
 
Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
