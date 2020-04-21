# irunervey-CIU-Practica9
Practica 9 de creando interfaces de usuario.

## Autoría.
El trabajo fue realizado por Iru Nervey Navarro Alejo.

## Descripción.
Para esta práctica le he añadido a la practica 7 cinco filtros utilizando shaders.

## Controles.

- Pulsa espacio para salir del menú
- Para cambiar entre el modo de juego y de rebote pulsa la e.
- Para cambiar en el modo de juego si se creara una nueva pelota o no pulse la r.
- Para quitar o poner el rectángulo facial pulse la t.
- Para pausar la musica pulsar m.
- Con el click del raton apareceran más pelotas.
- Para cambiar de filtro pulse del 1 al 5.

## Implementación.
He utilizado la libreria [open CV](http://www.magicandlove.com/blog/2018/11/22/opencv-4-0-0-java-built-and-cvimage-library/)  abajo para identificar las caras que aparezcan en la imagen para despues comprobar si colisionan con la cara. He implementado un modo rebote en el cual las pelotas rebotan en la cara o caras de los jugadores.
Para la reproduccion de sonido utilizo el metodo makeMusic() y el código que reproduce el sonido al eliminar las pelotas se encuentra en el metodo faceDetect(Mat grey).
Para los filtros he utilizado cinco shaders diferentes los cuales modifican la imagen capturada por la cámara detectando bordes, bordes en el eje x, bordes en el eje y, un desenfoque bastante leve y un filtro que modifica los colores de la imagen en el tiempo y por la posición del ratón. Este ultimo filtro tambien aplica un patron a la imagen.

## Herramientas utilizadas.

Debe estar instalada la libreria de [open CV](http://www.magicandlove.com/blog/2018/11/22/opencv-4-0-0-java-built-and-cvimage-library/).

Debe estar instalada la libreria de [soundcipher](http://explodingart.com/soundcipher/download.html).

Para crear el gif que muestro a continuación utilize la herramienta de gif-animation que puedes encontrar en este [enlace](https://github.com/extrapixel/gif-animation).

## Resultado.
![](https://github.com/irunervey/CIU-Practica6/blob/master/gif.gif)
