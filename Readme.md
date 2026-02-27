# 260227

## Comados R aprendidos hoy - lista

* `str() %>% capture.output() %>% writeLines("str_sl.txt")`
* `apply_labels`
* `var_lab`
* `val_lab`
* `as.labelled`
* `add_labelled_class`
* `attributes`
* `sapply`
* `cross_cases`
* `is.null`

## Comados R aprendidos hoy - resumen

* En Spss todas las variables cuantitativas o factores son preguntas cerradas (num) y las variables correspondientes a preguntas abiertas son de texto (character).

```r
# Creamos dataframe
mid <- data.frame(
  y = rnorm(500, 12, 15),
  x = sample(1:3, 500, replace = TRUE),
  z = rep(LETTERS[1:5], 100),
  w = sample(c(50 / 500, 200 / 500, 150 / 500, 100 / 500), 500,
    prob = c(.1, .4, .3, .2), replace = TRUE
  )
)

# Aplicamos etiquetas
# Primero las varaibles númericas
mid %<>% apply_labels(
  y = "Score", x = "Nivel Socio Económico", w = "Weight",
  x = c("nseA" = 1, "nseB" = 2, "nseC" = 3)
)

# Variables de caracteres deben ser convertidas a factores
# al usar as.labelled se crean sus niveles automáticamente
# solo queda etiquetar la variable
mid$z %<>% as.factor %>% as.labelled()
mid %<>% apply_labels(z = "Producto")

# Test
mid %>% cross_cases(z, x)
mid %>% cross_mean(y, x, weight = w)
```

* Este es el flujo a seguir siempre que se quiera importar un .sav. 

```r
# 1. Siempre en ese orden
library(haven)
library(expss)

# 2. Cargando data
spss_data <-
  haven::read_spss(
    file.path(
      "D:\\BackUp Desktop -Abril25\\Documents\\2025\\03Mar\\",
      "d26\\R_Test\\R_Join_II\\Files\\Capítulo_I_NACIONAL.sav"
    )
  )

# 3. Activando labels (Paso Fundamental)
spss_data_labels <- add_labelled_class(spss_data)

sl <- spss_data_labels

attributes(sl)
attributes(sl$TIPO_VIA)

# 4. Opcional (Comparar estructuras)
spss_data_labels %>%
  str() %>%
  capture.output() %>%
  writeLines("str_sl.txt")

sl %>%
  colnames() %>%
  matrix()

sl %>% count(DEPARTAMENTO)
```

* Identificar cuales variables tienen val_labels. Recuerda `sapply` aplica una función a cada columan de un data.frame y simplifica la salida.
```r
# Crear funciones
ver_label <- \(x){
  attributes(x)$label
}
ver_label(sl$PROVINCIA)

ver_valuelabels <- \(x){
  x %>%
    val_lab() %>%
    is.null() -> z
  return(!z)
}
ver_valuelabels(sl$P40_3)
ver_valuelabels(sl$P40_3_TIEMPO)

# Crear tibble
a <- sl %>%
  sapply(ver_label) %>%
  names()

b <- sl %>%
  sapply(ver_label) %>%
  as.character()

c <- sl %>%
  sapply(ver_valuelabels) %>%
  as.logical()

pregs <- tibble(Id = seq_len(length(a)), Preg = a, VarLabels = c, Texto = b)
```