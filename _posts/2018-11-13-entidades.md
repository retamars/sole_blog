---
layout: post
title: Reconocimiento de Entidades
author: Soledad Retamar
published: true
status: publish
draft: false
tags: entidades
---
 

```{r setup, include=FALSE} knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

Anotaciones de frases y palabras
Ahora que tenemos el archivo cargado, podemos comenzar a convertirlo en palabras y oraciones. 
 Este es un requisito previo para cualquier otro tipo de procesamiento de lenguaje natural, 
porque ese tipo de acciones de PNL tendrá que saber dónde están las palabras y las oraciones. 
Paquetes necesarios: NLP, openNLP y magrittr

```{r}
library(NLP)
library(openNLP)
library(rJava)
library(RWeka)
library(qdap)
library(magrittr)

noticia <- as.String(news[[2]]$body)

```

## Anotadores

Luego necesitamos crear anotadores para palabras y oraciones. 
Los anotadores se crean mediante funciones que cargan las bibliotecas de Java subyacentes. Estas funciones luego marcan los lugares en la cadena donde las palabras y oraciones comienzan y terminan. 
Las funciones de anotación son creadas por funciones.

```{r}
palabras_ann <- Maxent_Word_Token_Annotator()
oracion_ann <- Maxent_Sent_Token_Annotator()
```

## Pipeline
Estos anotadores forman un "pipeline" para anotar el texto en nuestra variable noticia1.
Primero tenemos que determinar d?nde est?n las oraciones, luego podemos determinar d?nde est?n las palabras. 
Podemos aplicar estas funciones de anotador a nuestros datos utilizando la función annotate ().

```{r}
noticia1_annotations <- annotate(noticia, list(oracion_ann, palabras_ann))
```

Vemos que el objeto de anotación contiene una lista de oraciones (y también palabras) identificadas por posición. Es decir, la primera oración en el documento comienza en el caracter 1 y termina en el caracter 111. 
Las oraciones también contienen información sobre las posiciones de las palabras que las componen.

Podemos combinar la biografía y las anotaciones para crear lo que el paquete de NLP llama un AnnotatedPlainTextDocument. 
Si quisiéramos, también podríamos asociar metadatos con el objeto usando el argumento meta =.

```{r}
noti_doc <- AnnotatedPlainTextDocument(noticia, noticia1_annotations)
```

# Palabras y oraciones
Ahora podemos extraer información de nuestro documento utilizando funciones de acceso como sents() para obtener las oraciones y words() para obtener las palabras. 
```{r}
sents(noti_doc) %>% head(2)
words(noti_doc) %>% head(10)
```

# Anotando personas y lugares.
Entre los varios tipos de anotadores proporcionados por el paquete openNLP se encuentra un anotador de entidad.
Una entidad es b?sicamente un nombre propio, como una persona o un nombre de lugar.
Usando una técnica llamada reconocimiento de entidad nombrada (NER), podemos extraer varios tipos de nombres de un documento. En inglés, OpenNLP puede encontrar fechas, ubicaciones, dinero, organizaciones, porcentajes, personas y horarios. (Los valores aceptados son "date", "location", "money", "organization", "percentage", "person", "misc".)
Estos tipos de funciones se crean utilizando los mismos tipos de funciones de constructor que usamos para words() y sents().

```{r}
persona_ann <- Maxent_Entity_Annotator(language ="es", kind = "person")
ubicacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "location")
organizacion_ann <- Maxent_Entity_Annotator(language ="es", kind = "organization")
```


Anteriormente pasamos una lista de funciones de anotador a la función annotate() para indicar qué tipo de anotaciones queríamos hacer. Crearemos una nueva lista para mantener nuestros anotadores en el orden en que queremos aplicarlos

```{r}
annot.l1 = NLP::annotate(noticia1, list(oracion_ann, palabras_ann,ubicacion_ann,persona_ann, organizacion_ann))
k <- sapply(annot.l1$features, `[[`, "kind")
```

### Personas que aparecen en la noticia
```{r}
personas = noticia1[annot.l1[k == "person"]]
lugares = noticia1[annot.l1[k == "location"]]
org = noticia1[annot.l1[k == "organization"]]
```


```{r pressure, echo=TRUE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
