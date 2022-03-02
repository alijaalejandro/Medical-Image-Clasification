![portada](images/portada.png)

# Caso de uso: clasificación de imágenes médica mediante modelos de inteligencia artificial
Este repositorio contiene un proyecto de clasificación de imágenes de radio-diagnóstico mediante un modelo de IA utilizando Python, R y Keras.

# Contexto

Este repositorio complementa al informe sobre *Tecnologías emergentes y datos abiertos: introducción a la ciencia de datos aplicada al análisis de imagen* y forma parte del contenido práctico que acompaña al informe teórico. Recordamos que la metodología seguida en esta serie de informes, estructura el contenido en tres secciones diferentes: _awarenes_, _inspire_ y _action_, siendo esta última la parte más práctica y aplicada del informe. En esta ocasión, hemos creído conveniente proporcionar al lector esta sección de _Action_ en forma de repositorio de código. En este repositorio, el lector encontrará todos los elementos necesarios para reproducir (si así lo desea) un ejemplo concreto de análisis de imagen mediante técnicas de inteligencia artificial.

![metodologia](images/metodologia.png)


# Introducción

En este ejemplo, mostramos la capacidad de los algoritmos de Deep Learning para clasificar imágenes de radiodiagnóstico médico. El objetivo de este proyecto es entrenar a un algoritmo para que sea capaz de clasificar automáticamente una imágen de una radiografía de pecho en dos categorías (enferma vs no-enferma). 

# Proyectos previos

Este proyecto es una adaptación del proyecto original de Michael Blum [tweeted](https://twitter.com/mblum_g/status/1475940763716444161?s=20) sobre el desafío [STOIC2021 - dissease-19 AI challenge](https://stoic2021.grand-challenge.org/stoic2021/). El proyecto original de Michael, partía de un conjunto de imágenes de pacientes con patología dissease-19 junto con otros pacientes sanos para hacer de contraste. En una segunda aproximación, [Olivier Gimenez](https://oliviergimenez.github.io/) utilizó un conjunto de datos similar al del proyetco original publicado en una competición de [Kaggle](https://en.wikipedia.org/wiki/Kaggle) repository <https://www.kaggle.com/plameneduardo/sarscov2-ctscan-dataset>. La razón de utilizar este nuevo dataset es que era considerablemente más manejable que el original (280GB). El nuevo dataset pesaba alrededor de 250MB y contenía algo más de 1000 imágenes de pacientes sanos y enfermos. El código del proyecto de Olivier puede encontrase en [Github](https://github.com/oliviergimenez/bin-image-classif). 

# Conjunto de Datos

En nuestro caso, inspirándonos en estos dos fantásticos proyectos previos, damos un paso más. En este proyecto, partimos de un conjunto de datos (imágenes médicas) de radio-diagnóstico que están disponibles en el repositorio abierto del [NIH](https://clinicalcenter.nih.gov/). El Centro Clínico NIH es un hospital dedicado únicamente a la investigación clínica en el campus de los Institutos Nacionales de Salud en Bethesda, Maryland (EEUU). En el post [10 repositorios de datos públicos relacionados con la salud y el bienestar](https://datos.gob.es/es/noticia/10-repositorios-de-datos-publicos-relacionados-con-la-salud-y-el-bienestar) se cita al NIH como uno de los orígenes de datos sanitarios de calidad.

En particular, nuestro conjunto de datos está disponible públicamente [aquí](https://nihcc.app.box.com/v/ChestXray-NIHCC/folder/36938765345). El repositorio incluye toda la información necesario para usarlo y en la descripción los autores comentan:

>El examen de rayos X de tórax es uno de los exámenes de imágenes médicas más frecuentes y rentables. Sin embargo, el diagnóstico clínico de la radiografía de tórax puede ser un desafío y, a veces, se cree que es más difícil que el diagnóstico mediante imágenes de [TC](https://es.wikipedia.org/wiki/Tomograf%C3%ADa_axial_computarizada) (Tomografía Computerizada) de tórax_

El conjunto de datos de rayos X de tórax comprende **112.120** imágenes de rayos X de vista frontal de **30.805** pacientes únicos con las **etiquetas de imágenes de catorce enfermedades** extraídas de texto (donde cada imagen puede tener múltiples etiquetas), extraídas de los informes radiológicos asociados utilizando procesamiento de lenguaje natural.

Ejemplo de imágen del repositorio:
![imagen de paciente sano](/images/00012908_000.jpg)

## Metadatos de las imágenes - Anotaciones

Como parte del conjunto de datos, se proporciona una [lista ordenada](/source/Data_Entry_2017_v2020.csv) que relaciona cada imágen con la patología diagnosticada por un especialista

```
      Image.Index         Finding.Labels Follow.up.. Patient.ID Patient.Age
1 00000001_000.png           Cardiomegaly           0          1          57
2 00000001_001.png Cardiomegaly|Emphysema           1          1          58
3 00000001_002.png  Cardiomegaly|Effusion           2          1          58
```


# Descarga masiva de imágenes

- Los gestores del repositorio de imágenes ponen a disposición un [script de Python](/source/batch_download_zips.py) para realizar una descarga desatendida de todos los paquetes de imágenes.

- Una vez descargados todos los paquetes comprimidos de imágenes debemos de extraerlos en un único directorio denominado denominado [images](/data/images)

- Como parte de este proyecto, hemos desarrollado un [script adicional de Python](/source/create_folders.py) que, partiendo del directorio donde hemos dejado las imágenes descomprimidas, seleccionamos una patología deseada y ejecutamos para que el script clasifique en un directorio específico las imágenes con dicha patología (a partir de la lista mencionada en la sección anterior)

```
table_orig=table
table=table[table['Finding Labels']=='No Finding']
```

