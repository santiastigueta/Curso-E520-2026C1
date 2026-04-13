
# Clase  ------------------------------------------------------------------

install.packages("nycflights13")
library(nycflights13)

install.packages("dplyr", dependencies = TRUE)
library(dplyr)
# Hay dos grandes tipos de dtables: Las TRANSACCIONALES (muy extensas, repetitivasy densas, como el 
#registro de transacciones en mercado pago) y las de REFERENCIA que suelen ser mas estaticas,
#como por ejemplo los aeropuertos (no se extiende mucho porque construir o agregar aeropuesrtos
#es mas raro o costoso que registrar un vuelo)

# En este caso, tenemos una tabla de vuelos (transaccional) y otras tablas de referencia (aeropuertos, aviones, etc)
# VOY A limpiar mi enviroment:
glimpse(flights)

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> # Que datos quiero que se muestren
  summarize( # summarize crea una columna nueva. La llamamos arr_delay que es el promedio de los retrasos en la llegada, y le decimos que ignore los NA
    arr_delay = mean(arr_delay, na.rm = TRUE) 
  )

# Flights that departed on January 1
flights |> 
  filter(month == 1 & day == 1) # Es lo mismo que decir filter(month %in% c(1,2))

# La funcion arrange() permite ordenar los datos segun una o mas variables.

library(tidyverse)
library(nycflights13)

flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)
flights2

# Select crea una tabla mas pequeña, con las columnas que le indicamos.

flights2 |>
  left_join(airlines)

flights2 |> 
  left_join(weather |> select(origin, time_hour, temp, wind_speed)) # Se seleccionan solo algunas columnas de otra tabla para agregarle a nuestro flight2


flights2 |> 
  left_join(planes |> select(tailnum, type, engines, seats))

flights2 |> 
  left_join(planes) # Es problematico. Se agregan demasiados valores NA a la nueva tabla.
# Problema: se esta usando talimnum y year como clave compuesta primaria pero el problema es que por ejemplo, 
# year significa dos cosas distintas para cada tabla. La unica es usar tailnum. 

flights2 |> 
  left_join(planes, join_by(tailnum == tailnum ))

# Para juntar flights2 con airport deberemos usar dest == faa, PORQUE significan lo mismo pero con nombres distintos.
flights2 |> 
  left_join(airports, join_by(dest == faa)) # en este caso, la tabla que se une, se une la info del aeropuerto de destino de cada vuelo.
# tranquilamente podría hacerlo al reves.


# DIFERENCIAS DE JOINS:
## left_join: mantiene todas las filas de la izquierda (x), y solo agrega nueva info de (y) que coloca al costado a la derecha.
## right_join: mantiene todas las filas de la derecha (y), y solo agrega nueva info de (x) que coloca al costado a la izquierda.
## inner_join: solo mantiene las filas que tienen coincidencias en ambas tablas.
## full_join: mantiene todas las filas de ambas tablas

airports

airports |> 
  semi_join(flights2, join_by(faa == dest))

# Tarea 04 Ejercicios 3.2.5 ----------------------------------------------------------------
# Ejercicios del capitulo 3: Transformación de datos

# Ejercicio 1:
flights |>
  filter(dest %in% c("IAH", "HOU") & month %in% c(7,8,9) & dep_delay == 0 & arr_delay >= 60)

# Ejercicio 2:
# Ordena flights para encontrar los vuelos con los mayores retrasos en la salida. 
flights |>
  arrange(desc(dep_delay)) 
#Encuentra los vuelos que salieron más temprano por la mañana.
flights |>
  arrange(dep_time) # De menor a mayor, es decir, de los mas temprano a los mas tarde.

# Ejercicio 3:
#Ordena flights los vuelos para encontrar los más rápidos. 
#(Sugerencia: Intenta incluir un cálculo matemático dentro de tu función).

flights |> # Los vuelos mas rapidos, intuyo yo, relativamente, entonces no me sirve air_time. Para ser mas creativo
  # Puedo calcular la velocidad promedio distance / air_time
  arrange(distance / air_time)

# Ejercicio 4:
# Hubo vuelos todos los dias de 2013? busco los días que no tuvieron vuelos.
flights |>
  distinct(day, month, year) #Como distinct me devuelve los valores unicos de dia, mes y año, puedo contar cuantos dias unicos hay.
# Es razonable que si la cantidad de filas es de 365, entonces hubo vuelos todos los dias. El output me muestra 10 rows + 355 more rows. 355 + 10 = 365.
  
# Ejercicio 5: 
# ¿Qué vuelos recorrieron la mayor distancia? ¿Cuáles recorrieron la menor distancia?
flights |> 
  arrange(distance) |> # De menor a mayor, es decir, de los mas cortos a los mas largos.
  distinct(distance, origin, dest, day, month) # Para quedarnos solo con los valores unicos de distancia.
# El viaje mas corto fue de 17 millas, de EWR a LGA. 
flights |> 
  arrange(desc(distance)) |>
  distinct(distance, origin, dest, day, month)
# El viaje mas largo gue de 4983 millas, de JFK a HNL, en repetidas ocaciones. 
  
# Ejercicio 6:
# ¿Importa el orden en que se usan filter()y arrange()si se usan ambos? ¿Por qué sí o por qué no? Piensa en los resultados y en la cantidad de trabajo que tendrían que realizar las funciones.
flights |> 
  filter(dep_delay > 10) |>
  arrange(desc(dep_delay)) # Es logico que si se usan ambos, primero filtramos los datos del vuelo y luego los ordenamos. 
# Si primero los ordenas y luego los filtras estas haciendo trabajar de más al algoritmo. 
  


# Tarea 04 Ejercicios 19.2.4 ----------------------------------------------

library(tidyverse)
library(nycflights13)

# Ejercicio 1:
# We forgot to draw the relationship between weather and airports in Figure 19.1. 
# What is the relationship and how should it appear in the diagram?
weather
airport
# La relacion entre weather y airport es mas bien una relacion indirecta a traves de la tabla flights. 

# Ejercicio 2:
# weather only contains information for the three origin airports in NYC. 
# If it contained weather records for all airports in the USA, what additional connection would it make to flights?
# No cambiaria nada, porque origin ya captura el nombre de los aeropuertos, la conexion ya está hecha, solo se registrarían más numeros de aeropuertos.

# Ejercicio 3:
weather |> 
  count(year, month, day, hour, origin) |> 
  filter(n > 1)
# Segun lo que busqué, en EEUU hubo un cambio de horario que "ensució" los datos de éste día, ésa hora y ese origin. 
# Hay 3 datos que estan repetidos y todos sucedieron el 3 de noviembre de 2013 a la 1 AM. 


# Ejercicio 4:
# We know that some days of the year are special and fewer people than usual fly on them (e.g., Christmas eve and Christmas day). How might you represent that data as a data frame? What would be the primary key? How would it connect to the existing data frames?
Christmas_Flights_DataFrame <- flights |>
  filter(day == 25 & month == 12) |> #Filtro los dias de navidad
  distinct(year, month, day, hour, origin, flight) # Para quedarnos solo con los valores unicos de año, mes y dia.)
Christmas_Flights_DataFrame
# La clave primaria sería compuesta, éstas serian año, mes y dia y flight.

# Ejercicio 5 imposible de ilustrar acá



# Tarea 04 Ejercicios 19.3.4 ----------------------------------------------

#Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?
flights |> 
  # Agregamos origin acá para que no se pierda
  group_by(year, month, day, hour, origin) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE),
    .groups = "drop" # Segun Gemini esto es buena practica para que no aparezca el mensajito azul.
  ) |> 
  arrange(desc(arr_delay)) |> 
  head(48) |> 
  left_join(weather, by = c("year", "month", "day", "hour", "origin"))
# muchos datos concentrados en meses como julio, agosto. La humedad es alta, y hay mucho frio y mucha nieve. El patron puede ser mucha niebla y tormentas de nieve que dificulta los vuelos.


#Ejercicio 2:
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

top_dest |>
  semi_join(flights2, join_by(dest == dest))

# Ejercicio 3
# Does every departing flight have corresponding weather data for that hour?
weather

flights2 |>
  left_join(weather)

# Ejercicio 4: What do the tail numbers that don’t have a matching record in planes have in common? 
# (Hint: one variable explains ~90% of the problems.)
flights2 
planes

# Ejercicio 5 (Tuve que pedirle 100% ayuda  la IA para este, ya que es bastante dificil)
# Paso A: Crear un resumen de los aviones y sus aerolíneas
carrier_por_avion <- flights2 |> 
  filter(!is.na(tailnum)) |> 
  group_by(tailnum) |> 
  # paste con unique() junta las siglas (ej: "UA, DL") en un solo texto sin repetir
  summarise(historial_carriers = paste(unique(carrier), collapse = ", ")) 

# Paso B: Pegar esa nueva columna a la tabla planes original
planes_actualizado <- planes |> 
  left_join(carrier_por_avion, join_by(tailnum))

planes_actualizado

# Ejercicio 6: Add the latitude and the longitude of the origin and destination airport to flights. 
# Is it easier to rename the columns before or after the join?

flights2
airports

flights2 |>
  left_join(airports, join_by(origin == faa)) |> # me traigo la info de tabla airports del origin 
  rename(origin_lat = lat, origin_lon = lon) |> # las renombro para que no se confundan con las del destino
  left_join(airports, join_by(dest == faa)) |> # ahora si, traigo la info de aeropuertos de destino
  rename(dest_lat = lat, dest_lon = lon) |> # Renombro las nuevas que acaban de llegar
  select(origin, origin_lat, origin_lon, dest, dest_lat, dest_lon) # Creo una tabla nueva con la nueva info.
 # Conclusion: Es más fácil renombrar las columnas después del join. 

# Ejercicio 7: Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:
airports |>
  semi_join(flights, join_by(faa == dest)) |> # esta linea filtra los aeropuertos que realmente fueron destinos de algun viaje. Osea, los aeropuertos importantes.
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()


demoras_por_destino <- flights |> 
  group_by(dest) |> 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) # DEmora promedio de la llegada al destino.


mapa_datos <- demoras_por_destino |> 
  inner_join(airports, join_by(dest == faa))


mapa_datos |> 
  ggplot(aes(x = lon, y = lat, color = avg_delay)) + 
  borders("state") +
  geom_point(size = 2, alpha = 0.8) + 
  coord_quickmap() # Resultado final.

# Ejercicio 8: What happened on June 13 2013? Draw a map of the delays, and then use Google to cross-reference with the weather.
flights |> 
  filter(month == 6 & day == 13) |> 
  group_by(dest) |> 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) |> 
  inner_join(airports, join_by(dest == faa)) |> 
  ggplot(aes(x = lon, y = lat, color = avg_delay)) + 
  borders("state") +
  geom_point(size = 2, alpha = 0.8) + 
  coord_quickmap() # Resultado final.
# El 13 de junio de 2013 hubo una tormenta severa en el medio oeste de EEUU, lo que explica las demoras en esa zona.

# Nota al pie: Los ejercicios 7, 8 son bastante complejos, por lo que tuve que recurrir a una considerable ayuda de Gemini PRO para estudiantes.