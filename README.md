# Medical-Image-Clasification
Este repositorio contiene un proyecto de clasificación de imágenes de radiodiagnóstico mediante un modelo de IA utilizando python, R y Keras.

# Introducción

En este ejemplo, mostramos la capacidad de los algoritmos de Deep Learning para clasificar imágenes de radiodiagnóstico médico. El objetivo de este proyecto es entrenar a un algoritmo para que sea capaz de clasificar automáticamente una imágen de una radiografía de pecho en dos categorías (enferma vs no-enferma). 

# Proyectos previos

Este proyecto es una adaptación del proyecto original de Michael Blum [tweeted](https://twitter.com/mblum_g/status/1475940763716444161?s=20) sobre el desafío [STOIC2021 - dissease-19 AI challenge](https://stoic2021.grand-challenge.org/stoic2021/). El proyecto roiginal de Michael partía de un conjunto de imágenes de pacientes con patología dissease-19 junto con otros pacientes sanos para hacer de contraste. Del proyecto original de Michael, [Olivier Gimenez](https://oliviergimenez.github.io/) utilizó un conjunto de datos similar al del proyetco original publicado en una competición de [Kaggle](https://en.wikipedia.org/wiki/Kaggle) repository <https://www.kaggle.com/plameneduardo/sarscov2-ctscan-dataset>. La razón de utilizar este nuevo dataset es que era considerablemente más manejable que el original (280GB). El nuevo dataset pesaba alrededor de 250MB y contenía algo más de 1000 imágenes de pacientes sanos y enfermos. El código del proyecto de Olivier puede encontrase en [Github](https://github.com/oliviergimenez/bin-image-classif). 

# Conjunto de Datos

En nuestro caso, inspirándonos en estos dos fantásticos proyectos previos, damos un paso más. En este proyecto, partimos de un conjunto de datos (imágenes médicas) de radio-diagnóstico que están disponibles en el repositorio abierto del [NIH](https://clinicalcenter.nih.gov/). El Centro Clínico NIH es un hospital dedicado únicamente a la investigación clínica en el campus de los Institutos Nacionales de Salud en Bethesda, Maryland (EEUU). En el post [10 repositorios de datos públicos relacionados con la salud y el bienestar](https://datos.gob.es/es/noticia/10-repositorios-de-datos-publicos-relacionados-con-la-salud-y-el-bienestar) se cita al NIH como uno de los orígenes de datos sanitarios de calidad.

En particular, nuestro conjunto de datos está disponible públicamente [aquí](https://nihcc.app.box.com/v/ChestXray-NIHCC/folder/36938765345). El repositorio incluye toda la información necesario para usarlo y en la descripción los autores comentan:

>El examen de rayos X de tórax es uno de los exámenes de imágenes médicas más frecuentes y rentables. Sin embargo, el diagnóstico clínico de la radiografía de tórax puede ser un desafío y, a veces, se cree que es más difícil que el diagnóstico mediante imágenes de [TC](https://es.wikipedia.org/wiki/Tomograf%C3%ADa_axial_computarizada) (Tomografía Computerizada) de tórax_

El conjunto de datos de rayos X de tórax comprende **112.120** imágenes de rayos X de vista frontal de **30.805** pacientes únicos con las **etiquetas de imágenes de catorce enfermedades** extraídas de texto (donde cada imagen puede tener múltiples etiquetas), extraídas de los informes radiológicos asociados utilizando procesamiento de lenguaje natural.

Ejemplo de imágen del repositorio:
![imagen de paciente sano](../images/00012908_000.jpg)
