# Notas sobre sonido en medios físicos y digitales

Estas notas son un resumen acotado acerca del sonido. Debido al número de fuentes que describen ya sea desde la perspectiva física, musical o electrónico esto. Este apartado servirá solamente como una discusión personal en función de aunar las tres en un mismo lugar.

_Con el tiempo, iré ordenando esto, extendendiendo las discusiones, mejorando las referencias y aparecerán ejemplos hechos en SC para ayudar al entendimiento de algunos tópicos._

## Medio Físico

El sonido hace referencia a una onda mecánica, la cual puede ser descrita más allá de la sensación de movimiento, propio de cualquier onda mecánica, esto es, puede ser "escuchada". 

Las siguientes propiedades del sonido suelen ser las más mencionadas ya sea desde la música (mús) o  desde la física (fís):
- Altura (mús) o frecuencia (fís): se refiere a la cantidad de ciclos por unidad de tiempo relacionados a una onda. Los sonidos graves están asociados a bajas frecuencias, y los sonidos agudos están asociados a altas frecuencías.
- Intensidad/Volumen (mús) o amplitud (fís): se refiere a la potencia en un área de una onda sonora.
- Duración (mús/fís): se refiere a la persistencia en el tiempo de un sonido.
- Timbre (mús/fís): es la totalidad de las ondas sonoras emitidas en un instante por una fuente. Esta característica se debe a la materialidad de esta última y es lo que hace distinguir un sonido de otro. También puede decirse que un timbre específico tiene asociada una forma de onda específica.

A estas propiedades de cualquier sonido emitido por una fuente, podemos agregar espacialidad, esto en cuenta que hay receptor encontrado a una cierta distancia del emisor. Dado que el sonido, en circunstancias normales, suele transmitirse omnidireccionalmete, la distancia podría considerarse un factor relevante, esto debido a la [velocidad de ondas sonoras](https://openstax.org/books/f%C3%ADsica-universitaria-volumen-1/pages/17-2-velocidad-del-sonido "ir a link"), que podría ser causa de latencias. 

Ahora, siguiendo la idea de cuerpos interactuando con las ondas, también podríamos tener en cuenta rebotes e interferencias. Los rebotes ocasionan que una onda con la suficiente tenacidad puede regresar a su fuente, y dependiendo de la latencia con que lo haga esta puede ser considerada un eco o una reberverancia. Las interferencias, también refieren a la acción de un tercer cuerpo, que interactúa entre emisor y un receptor objetivo.

## Medio Digital

En un medio digital, como son los computadores, los sonidos serán convertidos en datos, a través de un convertidor dedicado, los llamados DAC o digital audio converter. Para la realización de esta traducción hay algunas técnologías que están implementadas en los equipos que se venden comercialmente. Una es el Registro de Aproximaciones Sucesivas o SAR, es la que más he visto implementada en equipos de alta o baja calidad. Otra técnología es la conocida como Sigma-Delta.

Los distintos sistemas operativos tienen implementados drivers para hacer uso de las entradas y salidas de audio de los equipos. En Windows 10, al usar los comandos

```supercollider
ServerOptions.devices;
ServerOptions.inDevices;
ServerOptions.outDevices;
```

podemos ver las APIs usadas por SC para los servicios de audio. Estos son los resultados:

```supercollider
-> [ MME : Microsoft Sound Mapper - Input, MME : Microphone (2- High Definition , MME : Microsoft Sound Mapper - Output, MME : Altavoces (2- High Definition A, Windows DirectSound : Controlador primario de captura de sonido, Windows DirectSound : Microphone (2- High Definition Audio Device), Windows DirectSound : Controlador primario de sonido, Windows DirectSound : Altavoces (2- High Definition Audio Device), Windows WASAPI : Altavoces (2- High Definition Audio Device), Windows WASAPI : Microphone (2- High De...etc...
-> [ MME : Microsoft Sound Mapper - Input, MME : Microphone (2- High Definition , Windows DirectSound : Controlador primario de captura de sonido, Windows DirectSound : Microphone (2- High Definition Audio Device), Windows WASAPI : Microphone (2- High Definition Audio Device), Windows WDM-KS : Micrófono (HD Audio Microphone) ]
-> [ MME : Microsoft Sound Mapper - Output, MME : Altavoces (2- High Definition A, Windows DirectSound : Controlador primario de sonido, Windows DirectSound : Altavoces (2- High Definition Audio Device), Windows WASAPI : Altavoces (2- High Definition Audio Device), Windows WDM-KS : Speakers (HD Audio Headphone/Speakers) ]
```

MME (MultiMedia Extension) o Microsoft Sound Mapper es el driver por defecto de Windows. WDM es Windows Driver Model y KS es Kernel Streaming, estos operan en el modo kernel del sistema operativo. WASAPI hace referencia a Windows Audio Sesion API, es un driver de baja latencia que permite el flujo de audio desde el cliente hacia las salidas (endpoint devices). [Este artículo](https://www.thewelltemperedcomputer.com/KB/WASAPI.htm) contiene más información acerca de esto, como el siguiente cuadro, que muestra la arquitectura de audio en Windows.
![Arquitectura de Audio en Windows](https://www.thewelltemperedcomputer.com/Pictures/Software/Tweak/DiagramWinAudio.jpg "Arquitectura de Audio en Windows")