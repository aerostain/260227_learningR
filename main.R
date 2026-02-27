# Librerías
library(tidyverse)
library(magrittr)
library(ggplot2)
library(gridExtra)
library(haven)
library(expss)
library(ggdark)
library(lubridate)
library(DBI)
library(RMySQL)
library(sf)
library(terra)
library(rio)
library(broom)
library(pacman)
library(shiny)
library(devtools)

# .lintr
text <- c(
  "linters: linters_with_defaults(",
  "  assignment_linter(allow_pipe_assign = TRUE),",
  "  object_usage_linter = NULL",
  "  )"
)
pathfile <- file.path(getwd(), ".lintr")
writeLines(text, pathfile)


system("git init")
system("git status")
file.create(".gitignore")
system("git add .")
system("git commit -m 'Init'")
system("git log --oneline")
system("git remote add repos https://github.com/aerostain/260227_learningR.git")

system("git push repos master")


# ---------------------------------------------------------------------
# Repaso
# ---------------------------------------------------------------------

mid <- data.frame(
  y = rnorm(500, 12, 15),
  x = sample(1:3, 500, replace = TRUE),
  z = rep(LETTERS[1:5], 100),
  w = sample(c(50 / 500, 200 / 500, 150 / 500, 100 / 500), 500,
    prob = c(.1, .4, .3, .2), replace = TRUE
  )
)

mid %>% head()
mid %>% str()

mid %<>% apply_labels(
  y = "Score", x = "Nivel Socio Económico", w = "Weight",
  x = c("nseA" = 1, "nseB" = 2, "nseC" = 3)
)

mid %>% str()
mid$z %<>% as.factor %>% as.labelled()
mid %<>% apply_labels(z = "Producto")

mid %>% cross_cases(z, x)
mid %>% cross_mean(y, x, weight = w)

# ---------------------------------------------------------------------
# Importar
# ---------------------------------------------------------------------

library(haven)
library(expss)

spss_data <-
  haven::read_spss(
    file.path(
      "D:\\BackUp Desktop -Abril25\\Documents\\2025\\03Mar\\",
      "d26\\R_Test\\R_Join_II\\Files\\Capítulo_IV_NACIONAL.sav"
    )
  )

sl <- spss_data %>% add_labelled_class()
sl %>% str()

sl %>% cross_mean(P40_2_TIEMPO)
sl %>% cross_cases(P30_1)
sl %>% cross_cases(P29)

sl$P29 %>% val_lab()
sl$P40_3 %>% val_lab()

extraer_label <- \(x){
  attributes(x)$label
}

extraer_label(sl$PROVINCIA)

ver_valuelabels <- \(x){
  x %>%
    val_lab() %>%
    is.null() -> z
  return(!z)
}

ver_valuelabels(sl$P40_3)
ver_valuelabels(sl$P40_3_TIEMPO)

sl %>% str()

a <- sl %>%
  sapply(extraer_label) %>%
  names()

b <- sl %>%
  sapply(extraer_label) %>%
  as.character()

c <- sl %>%
  sapply(ver_valuelabels) %>%
  as.logical()

pregs <- tibble(Id = seq_len(length(a)), Preg = a, VarLabels = c, Texto = b)

pregs %>% view()

pregs %>%
  filter(VarLabels == TRUE) %>%
  view()

sl %>% cross_cases(P34)

