---
layout: post
title: Blog RStudio
author: Soledad Retamar
published: true
status: publish
draft: false
tags: myblog
---
 
Bienvenidos,
 
Este blog intenta mostrar algunos de los trabajos realizados en R por el grupo de investigación GIBD.
Les mostraremos aplicaciones sencillas de Minería de Texto y dejaremos todo el código de las mismas alojadas en el repositorio ...
 
- Acuerdate que has de modificar el fichero **_config.yml** para poner tus datos (nombre , e-mail etc...). Lo que tienes que cambiar esta señalado con la marca [AQUI+]   
 
- Si quieres poner tu foto tienes que sustituir el archivo meSmall.jpg que encontraras en la carpeta  [  /images  ]   
 
 
Para subir posts a tu blog solo tienes que añadir ficheros escritos en markdown (.md) en la carpeta [  _posts  ]    
 
 
Este blog esta muy-muy basado, vamos que es una copia (forkeo) del de Andy South. Lo puedes ver [aquí](http://andysouth.github.io/)    
 
 
 
Ale, a escribir    
 
 
 

{% highlight r %}
PD: recuerda que si quieres escribir con ficheros (.Rmd):   
 
0) Escribe en .Rmd pero el yaml header ha de tener (mira el fichero en la carpeta _rmd):     
 
    - layout: post    
    
    - status: process  
    
1) Haz un source del fichero rmd2md.R Se cargara la función rmd2md() 
 
2) En la consola de RStudio ejecuta:  rmd2md()  
{% endhighlight %}
 
 
Un poco mejor explicado [aquí](http://perezp44.github.io/r/Tutorial-para-crear-Jekyll-blog-hosted-in-Gitbub/)
