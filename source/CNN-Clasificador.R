## ----setup, include=FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, 
                      cache = TRUE, 
                      message = FALSE, 
                      warning = FALSE, 
                      dpi = 600)


## ------------------------------------------------------------------------------------------------------
library(tidyverse)
library(rmarkdown)
theme_set(theme_light())
library(keras)


## ------------------------------------------------------------------------------------------------------
process_pix <- function(lsf) {
  img <- lapply(lsf, image_load, color_mode = "grayscale") # grayscale the image
  arr <- lapply(img, image_to_array) # turns it into an array
  arr_resized <- lapply(arr, image_array_resize, 
                        height = 100, 
                        width = 100) # resize
  arr_normalized <- normalize(arr_resized, axis = 1) #normalize to make small numbers 
  return(arr_normalized)
}


## ----eval = TRUE---------------------------------------------------------------------------------------
# Imágenes de personas CON patologías

lsf <- list.files("../data/Pneumothorax/", full.names = TRUE) 

# Restrinjo la lista a 1000 elementos. 
lsf2 <- lsf[1:100]

dissease <- process_pix(lsf2)

dissease <- dissease[,,,1]
dissease_reshaped <- array_reshape(dissease, c(nrow(dissease), 100*100))

# Imágenes de personas SIN patologías
lsf <- list.files("../data/No-Finding/", full.names = TRUE) 

# Restrinjo la lista a 1000 elementos. 
lsf3 <- lsf[1:100]

ndissease <- process_pix(lsf3)
ndissease  <- ndissease[,,,1]
ndissease_reshaped <- array_reshape(ndissease, c(nrow(ndissease), 100*100))


## ------------------------------------------------------------------------------------------------------
scandissease <- reshape2::melt(dissease[10,,])
plotdissease <- scandissease %>%
  ggplot() +
  aes(x = Var1, y = Var2, fill = value) + 
  geom_raster() +
  labs(x = NULL, y = NULL, title = "Raxos-x de personas con enfermedad") + 
  scale_fill_viridis_c() + 
  theme(legend.position = "none")

scanndissease <- reshape2::melt(ndissease[10,,])
plotndissease <- scanndissease %>%
  ggplot() +
  aes(x = Var1, y = Var2, fill = value) + 
  geom_raster() +
  labs(x = NULL, y = NULL, title = "Raxos-x de personas sin enfermedad") + 
  scale_fill_viridis_c() + 
  theme(legend.position = "none")

library(patchwork)
plotdissease + plotndissease


## ------------------------------------------------------------------------------------------------------
df <- rbind(cbind(dissease_reshaped, 1), # 1 = dissease
            cbind(ndissease_reshaped, 0)) # 0 = no dissease
set.seed(1234)
shuffle <- sample(nrow(df), replace = F)
df <- df[shuffle, ]


## ------------------------------------------------------------------------------------------------------
set.seed(2022)
split <- sample(2, nrow(df), replace = T, prob = c(0.8, 0.2))
train <- df[split == 1,]
test <- df[split == 2,]
train_target <- df[split == 1, 10001] # label in training dataset
test_target <- df[split == 2, 10001] # label in testing dataset


## ------------------------------------------------------------------------------------------------------
model <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = "relu") %>% 
  layer_dropout(0.4) %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dropout(0.3) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(0.2) %>%
  layer_dense(units = 2, activation = 'softmax')


## ------------------------------------------------------------------------------------------------------
model %>%
  compile(optimizer = 'adam',
          loss = 'binary_crossentropy', 
          metrics = c('accuracy'))


## ------------------------------------------------------------------------------------------------------
train_label <- to_categorical(train_target)
test_label <- to_categorical(test_target)


## ------------------------------------------------------------------------------------------------------
fit_dissease <- model %>%
  fit(x = train,
      y = train_label, 
      epochs = 25,
      batch_size = 512, # try also 256, 512
      verbose = 2,
      validation_split = 0.2)


## ------------------------------------------------------------------------------------------------------
plot(fit_dissease)


## ------------------------------------------------------------------------------------------------------
model %>%
  evaluate(test, test_label)


## ------------------------------------------------------------------------------------------------------
predictedclasses <- model %>%
  predict(test) %>% `>`(0.5) %>% k_cast("int32")
table(Prediction = as.numeric(predictedclasses[,2]), Truth = test_target)


## ----eval = FALSE--------------------------------------------------------------------------------------
## save_model_tf(model, "model/disseasemodel") # save the model

