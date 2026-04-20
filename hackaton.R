## Hackaton code!

library(tidyverse)
library(ggplot2)

install.packages("leaflet")
library(leaflet)


puntos_censos_mensuales <- 
  read_csv('datasets/puntos-censos-mensuales.csv')
comercios_con_beneficios_ciclistas <- 
  read_csv2('datasets/comercios-con-beneficios-a-ciclistas.csv')
volumen_ciclistas_mensuales <- 
  read_csv('datasets/volumen-ciclistas-mensuales.csv')

# Asesoramiento de los profesores, añadir al mapa las nuevas estaciones de bicicletas publicas:
nuevas_estaciones_bicis_publicas <- 
  read_csv('datasets/nuevas-estaciones-bicicletas-publicas.csv')
nuevas_estaciones_bicis_publicas




estaciones_clean <- nuevas_estaciones_bicis_publicas %>%
  rename(lat = latitud, lng = longitud) %>%
  mutate(lat = as.numeric(lat), lng = as.numeric(lng))

colnames(estaciones_clean)

#2. Limpiar y preparar Comercios (Extraemos Lat/Lng del campo WKT)
comercios_clean <- comercios_con_beneficios_ciclistas %>%
  mutate(
    # POINT (-58.37 -34.65) -> extraemos los números
    coords = str_replace_all(WKT, "POINT \\(|\\)", ""),
    lng = as.numeric(word(coords, 1)),
    lat = as.numeric(word(coords, 2)),
    comuna = as.character(comuna)
  ) %>%
  filter(!is.na(lng))

print(comercios_clean, n = Inf)

# Conteo por comuna para el análisis económico
conteo_comercios_comuna <- comercios_clean %>%
  group_by(comuna) %>%
  summarise(total_comercios = n())

# 3. Preparar Volúmenes y unir con Geografía
# Primero promediamos el flujo mensual por punto
volumen_promedio <- volumen_ciclistas_mensuales %>%
  group_by(punto_referencia) %>%
  summarise(promedio_ciclistas = mean(cantidad_ciclistas, na.rm = TRUE))

# Unimos con las coordenadas de los puntos de censo (PB)
censos_geo_volumen <- puntos_censos_mensuales %>%
  inner_join(volumen_promedio, by = c("PB" = "punto_referencia"))

censos_geo_volumen
# 4 Join final --> analisis x columna
data_analisis <- censos_geo_volumen %>%
  mutate(comuna = case_when(
    PB == "PB01" ~ "1",
    PB == "PB45" ~ "15",
    PB == "PB46" ~ "14",
    PB == "PB10" ~ "2",
    # Agrega más mapeos según necesites
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(comuna)) %>%
  inner_join(conteo_comercios_comuna, by = "comuna")

# 5. MAPA INTERACTIVO 
mapa <- leaflet() %>%
  addTiles() %>%
  # Capa de Puntos de Censo (Círculos azules proporcionales al flujo)
  addCircleMarkers(
    data = censos_geo_volumen,
    lng = ~x_coo, lat = ~y_coo,
    radius = ~promedio_ciclistas / 400, # Ajustar escala visual
    color = "blue",
    fillOpacity = 0.6,
    popup = ~paste("Cruce:", CRUCE, "<br>Promedio mensual:", round(promedio_ciclistas))
  ) %>%
  # Capa de Comercios (Marcadores rojos)
  addCircleMarkers(
    data = comercios_clean,
    lng = ~lng, lat = ~lat,
    radius = 3,
    color = "red",
    popup = ~paste("Comercio:", nombre, "<br>Beneficio:", beneficio)
  ) %>%
  # Capa de Estaciones (Verde)
  addCircleMarkers(
    data = estaciones_clean, 
    lng = ~lng, 
    lat = ~lat,
    radius = 4,
    color = "green",
    group = "Estaciones Bici", 
    popup = ~nombre
    ) %>%
  addLegend(
    "bottomright", 
    colors = c("blue", "red", "green"), 
    labels = c("Flujo de Ciclistas (Censos)", "Comercios con Beneficios", "Nuevas Estaciones de Bicicletas Pública"),
    title = "Oferta vs Demanda Ciclista"
  )

# Mostrar mapa
mapa
