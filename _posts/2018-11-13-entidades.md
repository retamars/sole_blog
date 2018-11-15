---
layout: post
title: Reconocimiento de Entidades
author: Soledad Retamar
published: true
status: publish
draft: false
tags: entidades
---
 

 
## Detección de oraciones y palabras
Con estas lineas de código describiremos como detectar oraciones, palabras, personas, lugares y organizaciones en un texto. Para realizarlo mas práctico en este ejemplo analizaremos una noticia extra�?da y asignaremos el texto en el código, pero se podr�?a aplicar al texto que obtengamos dinamicamente de nuestras fuentes de datos.
 
Los paquetes necesarios serán: NLP, openNLP y magrittr
 

{% highlight r %}
library(NLP)
library(openNLP)
library(magrittr)
 
noticia <- as.String('Donald Trump apunt� este martes contra el presidente franc�s, 
Emmanuel Macron, por su propuesta de crear un ej�rcito europeo, en un nuevo reclamo 
hacia sus aliados europeos para que refuercen su aporte econ�mico hacia el 
financiamiento de la OTAN.
Macron declar� la semana pasada la necesidad de proteger con unas fuerzas armadas 
a Europa,"en relaci�n a China, Rusia e incluso Estados Unidos", una idea que Trump
calific� el viernes como "insultante". Ahora, renov� su rechazo con un mordaz 
comentario, reabriendo heridas entre Par�s y Berl�n, hoy estrechos aliados y 
defensores del multilateralismo.
"Fue Alemania en la Primera y Segunda Guerra Mundial. �C�mo funcion� eso para Francia?
Ellos estaban comenzando a aprender alem�n en Par�s antes de que EEUU intervenga", 
escribi� en su Twitter, en referencia a la ocupaci�n nazi sobre la capital francesa, entre 1940 y 1944.')
{% endhighlight %}
 
## Palabras y Oraciones
Necesitaremos definir dos funciones, basadas en librer�as de Java, que nos marcar�n donde comienza y termina cada palabra y cada oraci�n.

{% highlight r %}
palabras_ann <- Maxent_Word_Token_Annotator()
oracion_ann <- Maxent_Sent_Token_Annotator()
{% endhighlight %}
Aplicaremos iterativamente estas funciones en el texto de la noticia para determinar en primer lugar d�nde est�n las oraciones y luego determinar d�nde est�n las palabras. 
Podemos aplicar estas funciones a nuestros datos utilizando la funci�n annotate().

{% highlight r %}
noticia1_annotations <- annotate(noticia, list(oracion_ann, palabras_ann))
{% endhighlight %}
El objeto creado contiene ahora una lista de oraciones y de palabras identificadas por posici�n. 

{% highlight r %}
noticia1_annotations[1:8]
{% endhighlight %}
En nuestro ejemplo, la primera oraci�n en el documento comienza en el caracter 1 y termina en el caracter 250. En el caso de la primer palabra detectada sus posicion inicial es 1 y finaliza en el caracter 6.
 
Para combinar la noticia y el objeto creado con las posiciones usaremos la funci�n AnnotatedPlainTextDocument del paquete NLP. Si quisi�ramos, tambi�n podr�amos asociar metadatos con el objeto usando el argumento "meta".
 

{% highlight r %}
noti_doc <- AnnotatedPlainTextDocument(noticia, noticia1_annotations)
{% endhighlight %}
 
# Palabras y oraciones
Ahora podemos extraer informaci�n de nuestro documento utilizando las funciones sents() para obtener las oraciones y words() para obtener las palabras. Mostraremos la primer oraci�n y las primeras 10 palabras:
 

{% highlight r %}
sents(noti_doc) %>% head(1)
words(noti_doc) %>% head(10)
{% endhighlight %}
 
# Identificando personas y lugares.
Entre los distintos tipos de anotadores proporcionados por el paquete openNLP se encuentra uno de entidades.
Una entidad es basicamente un nombre propio, como una persona o un nombre de lugar.
 
Usando una t�cnica llamada reconocimiento de entidad nombrada (NER), podemos extraer varios tipos de nombres de un documento. 
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
[1] "Emmanuel Macron"        "Segunda Guerra Mundial"
 
### Lugares

{% highlight r %}
lugares = noticia[annot.l1[k == "location"]]
{% endhighlight %}
Si vizualizamos los lugares que detectó en la noticia obtendremos:
[1] "Europa"  "Francia" "Par�s"  
 
### Organizaciones

{% highlight r %}
org = noticia[annot.l1[k == "organization"]]
{% endhighlight %}
 
Si vemos las organizaciones:
[1] "China"            "Rusia"            "Estados Unidos\""
[4] "Francia"          "EEUU"            
 
 
 
