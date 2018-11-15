---
layout: post
title: Reconocimiento de Entidades
author: Soledad Retamar
published: true
status: publish
draft: false
tags: entidades
---
 
```{r setup} knitr::opts_chunk$set(echo = FALSE)
```
 
## Detección de oraciones y palabras
Con estas lineas de código describiremos como detectar oraciones, palabras, personas, lugares y organizaciones en un texto. Para realizarlo mas práctico en este ejemplo analizaremos una noticia extraída y asignaremos el texto en el código, pero se podría aplicar al texto que obtengamos dinamicamente de nuestras fuentes de datos.
 
Los paquetes necesarios serán: NLP, openNLP y magrittr
 

 
## Palabras y Oraciones
Necesitaremos definir dos funciones, basadas en librerías de Java, que nos marcarán donde comienza y termina cada palabra y cada oracion.

Llamaremos iterativamente a estas funciones para el texto contenido en noticia para determinar primero dónde están las oraciones y luego determinar dónde están las palabras. 
Podemos aplicar estas funciones a nuestros datos utilizando la función annotate().

El objeto creado contiene ahora un objeto que contiene una lista de oraciones y de palabras identificadas por posición. 

{% highlight r %}
noticia1_annotations[1:8]
{% endhighlight %}
En nuestro ejemplo, la primera oración en el documento comienza en el caracter 1 y termina en el caracter 250. En el caso de la primer palabra detectada sus posicion inicial es 1 y finaliza en el caracter 6.
 
Para combinar la noticia y el objeto creado con las posiciones usaremos la función AnnotatedPlainTextDocument del paquete NLP. Si quisiéramos, también podríamos asociar metadatos con el objeto usando el argumento "meta".

 
# Palabras y oraciones
Ahora podemos extraer información de nuestro documento utilizando las funciones sents() para obtener las oraciones y words() para obtener las palabras. Mostraremos la primer oración y las primeras 10 palabras:
 

 
# Identificando personas y lugares.
Entre los distintos tipos de anotadores proporcionados por el paquete openNLP se encuentra uno de entidades.
Una entidad es basicamente un nombre propio, como una persona o un nombre de lugar.
 
Usando una técnica llamada reconocimiento de entidad nombrada (NER), podemos extraer varios tipos de nombres de un documento. 
Crearemos las funciones para detectar tres tipos de entidades: personas, ubicaciones y organizaciones.
 

 
Crearemos una nueva lista para mantener nuestros anotadores en el orden en que queremos aplicarlos
 

 
### Personas que aparecen en la noticia

Los nombres propios que se encontraron en la noticia son:

{% highlight r %}
personas
{% endhighlight %}
 
### Lugares

Si vizualizamos los lugares que detectó en la noticia obtendremos:

{% highlight r %}
lugares
{% endhighlight %}
 
### Organizaciones

 
Si vemos las organizaciones:

{% highlight r %}
org
{% endhighlight %}
 
 
 
