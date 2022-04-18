![portada](/images/portada.jpg)

# Caso de uso: clasificación de imágenes médica mediante modelos de inteligencia artificial
Este repositorio contiene un proyecto de clasificación de imágenes de radio-diagnóstico mediante un modelo de IA utilizando Python, R y Keras.

# Contexto

Este repositorio complementa al informe sobre *Tecnologías emergentes y datos abiertos: introducción a la ciencia de datos aplicada al análisis de imagen* y forma parte del contenido práctico que acompaña al informe teórico. Recordamos que la metodología seguida en esta serie de informes, estructura el contenido en tres secciones diferentes: _awarenes_, _inspire_ y _action_, siendo esta última la parte más práctica y aplicada del informe. En este repositorio, el lector encontrará todos los elementos necesarios para reproducir (si así lo desea) un ejemplo concreto de análisis de imagen mediante técnicas de inteligencia artificial.

![metodologia](/images/metodologia.jpg)


# Introducción

En este ejemplo, mostramos la capacidad de los algoritmos de Deep Learning para clasificar imágenes de radiodiagnóstico médico. *El objetivo de este proyecto es entrenar a un algoritmo para que sea capaz de clasificar automáticamente una imágen de una radiografía de pecho en dos categorías (enferma vs no-enferma)*. 

# Proyectos previos

Este proyecto es una adaptación del proyecto original de Michael Blum [tweeted](https://twitter.com/mblum_g/status/1475940763716444161?s=20) sobre el desafío [STOIC2021 - dissease-19 AI challenge](https://stoic2021.grand-challenge.org/stoic2021/). El proyecto original de Michael, partía de un conjunto de imágenes de pacientes con patología Covid-19, junto con otros pacientes sanos para hacer de contraste. En una segunda aproximación, [Olivier Gimenez](https://oliviergimenez.github.io/) utilizó un conjunto de datos similar al del proyecto original publicado en una competición de [Kaggle](https://en.wikipedia.org/wiki/Kaggle) (repositorio: <https://www.kaggle.com/plameneduardo/sarscov2-ctscan-dataset>). Este nuevo _dataset_ (250 MB) era considerablemente más manejable que el original (280GB). El nuevo _dataset_ contenía algo más de 1000 imágenes de pacientes sanos y enfermos. El código del proyecto de Olivier puede encontrase en el siguiente repositorio de [Github](https://github.com/oliviergimenez/bin-image-classif). Ç



# Conjunto de Datos

En nuestro caso, inspirándonos en estos dos fantásticos proyectos previos, damos un paso más. En este proyecto, partimos de un conjunto de datos (imágenes médicas) de radio-diagnóstico que están disponibles en el repositorio abierto del [NIH](https://clinicalcenter.nih.gov/). El Centro Clínico NIH es un hospital dedicado únicamente a la investigación clínica en el campus del Instituto Nacional de Salud en Bethesda, Maryland (EEUU). En el post [10 repositorios de datos públicos relacionados con la salud y el bienestar](https://datos.gob.es/es/noticia/10-repositorios-de-datos-publicos-relacionados-con-la-salud-y-el-bienestar) se cita al NIH como uno de los orígenes de datos sanitarios de calidad.

En particular, nuestro conjunto de datos está disponible públicamente [aquí](https://nihcc.app.box.com/v/ChestXray-NIHCC/folder/36938765345). El repositorio incluye toda la información necesario para usarlo y en la descripción los autores comentan:

>El examen de rayos X de tórax es uno de los exámenes de imágenes médicas más frecuentes y rentables. Sin embargo, el diagnóstico clínico de la radiografía de tórax puede ser un desafío y, a veces, se cree que es más difícil que el diagnóstico mediante imágenes de [TC](https://es.wikipedia.org/wiki/Tomograf%C3%ADa_axial_computarizada) (Tomografía Computerizada) de tórax.

El conjunto de datos de rayos X de tórax comprende **112.120** imágenes de rayos-X (vista frontal) de **30.805** pacientes únicos. Las imágenes se acompañan con las **etiquetas asociadas de catorce enfermedades** (donde cada imagen puede tener múltiples etiquetas), extraídas de los informes radiológicos asociados utilizando procesamiento de lenguaje natural (NLP). Si quieres ampliar la información sobre el campo de procesamiento del lenguaje natural puedes consultar el [siguiente informe](https://datos.gob.es/es/documentacion/tecnologias-emergentes-y-datos-abiertos-procesamiento-del-lenguaje-natural).

A continuación, mostramos una imagen tipo de más de 100.000 que ofrece el repositorio mencionado.
![imagen de paciente sano](/images/00012908_000.jpg)

## Metadatos de las imágenes - Anotaciones

Como parte del conjunto de datos, se proporciona una [lista ordenada](/source/Data_Entry_2017_v2020.csv) que relaciona cada imágen con la patología diagnosticada por un especialista. Esta lista de etiquetas es la que se utiliza para clasificar las imágenes en directorios que posteriormente se utilizan en el clasificador binario. Es decir, el modelo de IA se entrenará con las imágenes almacenadas en un directorio que identificará la enfermedad que buscamos identificar. En Este proyecto, de toda la lista de enfermedades, hemos escogido el _Pneumothorax_. De esta forma, de todas las posibles enfermedades, hemos creado dos directorios: uno con las imágenes de pacientes sanos y otro con las imágenes de pacientes que presentan _Pneumothorax_.

```R
      Image.Index         Finding.Labels Follow.up.. Patient.ID Patient.Age
1 00000001_000.png           Cardiomegaly           0          1          57
2 00000001_001.png Cardiomegaly|Emphysema           1          1          58
3 00000001_002.png  Cardiomegaly|Effusion           2          1          58
```


# Descarga masiva de imágenes

Para obtener las imágenes del repositorio de datos hemos seguido el siguiente procedimiento:

- Los gestores del repositorio de imágenes ponen a disposición un [script de Python](/source/batch_download_zips.py) para realizar una descarga desatendida de todos los paquetes de imágenes.

- Una vez descargados todos los paquetes comprimidos de imágenes debemos de extraerlos en un único directorio denominado denominado [images](/data/images)

- Como parte de este proyecto, hemos desarrollado un [script adicional de Python](/source/create_folders.py) que, partiendo del directorio donde hemos dejado las imágenes descomprimidas, seleccionamos una patología deseada y ejecutamos para que el script clasifique en un directorio específico las imágenes con dicha patología (a partir de la lista mencionada en la sección anterior)

```python
table_orig=table
table=table[table['Finding Labels']=='No Finding']
```
Editando la anterior línea de código en este script de python le decimos al programa que almacene las imágenes de la enfermedad deseada en un nuevo directorio. Es decir, en nuestro caso, lo hemos ejecutado 2 veces:

- Primero, seleccionamos las imágenes de los pacientes sanos:
```python
table=table[table['Finding Labels']=='No Finding']
```
- Segundo, seleccionamos las imágenes de los pacientes que presentan _Pneumothorax_:

```python
table=table[table['Finding Labels']=='Pneumothorax']
```

# Desarrollo

En esencia, el proyecto consiste en descargar un conjunto de imágenes médicas anotadas y estructurarlas en directorios, separando las diferentes enfermedades por carpetas. Una vez hecho esto, entrenaremos (para una patología concreta) un modelo de tipo CNN (Convolutional Neural Network) que nos permitirá clasificar automáticamente una imagen dada, identificando si el paciente en cuestión presenta dicha patología o no.

## Cómo usar este repositorio

Una vez leída esta introducción, el lector que lo desee puede tratar de seguir el código paso a paso que se encuentra en este [notebook de R](/source/CNN-Clasificador.Rmd). Aquellos lectores que deseen ejecutar el proyecto completo, pueden clonar o descargar este repositorio y abrir el [proyecto de RStudio](/source/UseCase1-CT-Scans.Rproj). Para aquellos desarrolladores que se encuentren más cómodos con Jupyter Notebooks, también se ha generado el [correspondiente fichero ](/source/CNN-Clasificador.ipynb). Para trabajar en el entorno Google Colab se puede invocar a la siguiente llamada ```https://colab.research.google.com/github/datosgobes/nombre-del-repositorio/blob/main/archivo-con-codigo.ipynb```



