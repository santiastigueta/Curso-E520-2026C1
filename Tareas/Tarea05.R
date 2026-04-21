# Cargar librerías --------------------------------------------------------
install.packages("tidyverse")
library(tidyverse)
install.packages("readr")
library(readr)

# Cargar Datos ------------------------------------------------------------
# anac_2025 <- read.csv("datasets/informe_ministerio.csv")
anac_2025 <-
  read_csv2(
    file='datasets/informe_ministerio_vuelos2026.csv')      

# Clima 365


# Aeropuerto
aeropuertos <- # csv2 es para los datasts separados por ; no es el caso
  read_csv(file='datasets/iata-icao.csv')

# clima
clima <- # Nuestro obstaculo es que es un archivo txt y no csv.
  read_fwf(
    file='datasets/registro_temperatura365d_smn.txt',
    col_positions = fwf_widths(c(8,1,5,1,5, 200), c('Fecha','x', 'TMAX', 'y', 'TMIN', 'Nombre'))
    , skip=3) |>
  select(-x, -y) # Para eliminar las columnas que no necesitamos.
# Importante limpieza de datos como ejemplo para el hackaton
# Sin embargo, tenemos una tabla sin primary key. No hay como linkear esta tabla con nuestros aeropuertos... O si...
# Una posible solucion seria encontrar una forma que linkee el nombre de la estacion meteorologica con los nombres de los aeropuertos
# ya que supeustamente la estacion meteorologica esta en el aeropuerto. Sin embargo, esto no es tan sencillo porque los nombres de las estaciones meteorologicas no son iguales a los nombres de los aeropuertos.


# Analisis de los datos ---------------------------------------------------

glimpse(anac_2025) # Las variables con comillas son porque tienen espacios.
# Atencion: la columna fecha esta en formato str ya que el formato anglosajon no entiende.

anac_2025 <- anac_2025 |>
  mutate(
    tipo_vuelo = factor(`Clase de Vuelo (todos los vuelos)`),
    clasif_vuelos = factor(`Clasificación Vuelo`),
    tipo_movimiento = factor(`Tipo de Movimiento`),
    aeropuerto = factor(Aeropuerto),
    origen_destino = factor(`Origen / Destino`),
    aerolinea = factor(`Aerolinea Nombre`),
    calidad_dato = factor(`Calidad dato`),
    aeronave = factor(Aeronave)
  )
summary(anac_2025) # HAY DOS COLUMNAS QUE SIGUEN MAL, TRATAR DE CORREGIRLAS.
glimpse(anac_2025)

# TAREA PARA EL HOGAR: relacionar las tablas del clima, vuelos y los aeropuertos que descargamos.
# La tarea 05 onsiste en esto mismo + simplemente agregarle mas años.
# Para conectar las tablas hayq ue investigar como crear uestras primary keys y foreign keys.

# tarea 05 ----------------------------------------------------------------


# Tip de gemini: defino un esquema unico para todos los datasets
# Definimos el esquema de columnas para asegurar que todos los años sean iguales

esquema <- cols(
  .default = col_guess(),
  Aeronave = col_character(),
  `Clase de Vuelo (todos los vuelos)` = col_character(),
  `Clasificación Vuelo` = col_character(),
  `Tipo de Movimiento` = col_character(),
  Aeropuerto = col_character(),
  `Origen / Destino` = col_character()
)

# carga de archivos de mi carpeta datasets
df2019 <- read_csv2("datasets/tarea05/vuelos_2019.csv", col_types = esquema)
df2020 <- read_csv2("datasets/tarea05/vuelos_2020.csv", col_types = esquema)
df2021 <- read_csv2("datasets/tarea05/vuelos_2021.csv", col_types = esquema)
df2022 <- read_csv2("datasets/tarea05/vuelos_2022.csv", col_types = esquema)
df2023 <- read_csv2("datasets/tarea05/vuelos_2023.csv", col_types = esquema)
df2024 <- read_csv2("datasets/tarea05/vuelos_2024.csv", col_types = esquema)
df2025 <- read_csv2("datasets/tarea05/vuelos_2025.csv", col_types = esquema)

# Combino los data frames en uno solo
vuelos_total <- bind_rows(df2019, df2020, df2021, df2022, df2023, df2024, df2025) # Con bind rows junto todas las tablas para hacer un analisis completo!
glimpse(vuelos_total) 
summary(vuelos_total)

# Convierto las fechas en formato date
vuelos_total <- vuelos_total %>%
  mutate(Fecha_Final = as.Date(`Fecha UTC`, format="%d/%m/%Y"))

#Grafico de tendencia de vuelos por año para ver el impacto de la pandemia
vuelos_total %>%
  group_by(Anio = lubridate::year(as.Date(`Fecha UTC`, format="%d/%m/%Y"))) %>% # 
  summarise(cantidad = n()) %>%
  ggplot(aes(x = Anio, y = cantidad)) + geom_col() + labs(title="Impacto Pandemia")

# Se observa un colapso estructural en la serie de tiempo de vuelos durante el año 2020, 
# que coincide con las restricciones sanitarias a nivel global. La caída muestra una timida 
# recuperacion que no es inmediata, al analizar los años siguientes, la tendencia vuelve al 
# alza pero tarda aproximadamente entre 3 y 4 años en volver a los niveles del 2019, evidenciando 
# un impacto muy negativo que tuvo la pandemia en éste sector en concreto. 
