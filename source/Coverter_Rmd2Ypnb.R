install.packages("devtools")
devtools::install_github("mkearney/rmd2jupyter")
library(rmd2jupyter)


rmd2jupyter("CNN-Clasificador.Rmd")

rmd2jupyter("Clasificador de imagenes medicas con modelo pre-entrenado.Rmd")
