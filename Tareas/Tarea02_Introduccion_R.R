# asignacion de un valor a una variable
ecuestado_id <- 1045
#imprimir el valor de la variable ctrl + shift + c hace comentar una linea.
print(ecuestado_id)

# Tipos de datos
ingreso <- 350000.50 #numerico
miembros_hogar <- 4L #entero la L fuerza que sea un entero
Estado <- 'Ocupado' #cadena de caracteres
busca_trabajo <- FALSE #logic

# identificar el tipo con la funcion class()
class(Estado)
class(ingreso)

#funciones utiles: paste(), grepl(), nchar()
# unir textos para un reporte 
paste("El ingreso del hogar es de", ingreso, "pesos mensuales cuya ocupacion es", Estado)
# verificar si el texto contiene una palabra
grepl("propia", "cuenta propia con local") # Devuelve true si la palabra esta en el texto
salario_mensual <- 12000
salario_anual <- salario_mensual * 12 # calcular el salario anual a partir del mensual
rm(salario_mensual) # eliminar la variable salario_mensual

# Operadores condicionales
es_mayor_edad <- edad_anios >= 18
es_desocupado <- Estado == "Desocupado"

estado <- 'ocupado'
edad_anios <- 25
# operadores logicos & es AND, el or es |
es_pea <- (estado == 'ocupado' | estado == 'desocupado') & edad_anios >= 18
print(es_pea)


# Estructura basica de if
salario <- 500000
if (salario > 800000) {
  decil <- 'Alto'
} else if (salario >= 1000) {
  decil <- 'Medio'
} else {
  decil <- 'Bajo'
}
print(decil) # Antes me daba error porque el else estaba mal ubicado. ya corregido, otra vez actualizo el archivo. 

# Flujos de prueba
meses_busqueda <- 0
while(meses_busqueda < 3) {
  print(paste("Mes", meses_busqueda, "de busqueda"))
  meses_busqueda <- meses_busqueda + 1 # Se actualiza el valor de la variable. 
}

# romper un bucle infinito con el break
meses_busqueda <- 0
while(TRUE) {
  meses_busqueda <- meses_busqueda +1
  if (meses_busqueda == 2) {
    print("el empleo es igual a 2 meses, se rompe el bucle")
    break
  }
} 

# Ciclo for
salarios_hora <- c(1500, 2200, 1800, 3100)
for (salario in salarios_hora) {
  print(salario * 8) # Imprime el salario por jornada de 8 horas
}

# TIPOS DE DATOS
# Vectores: Elementos del mismo tipo (ideal para columnas de variables).
edades_hogar <- c(45, 42, 16, 12)
promedio_edad <- mean(edades_hogar)


# Listas: Contenedores heterogéneos (ideal para perfiles completos).
jefe_hogar <- list(
  id = 101,
  nombre = "Carlos",
  edades_familia = edades_hogar,
  es_propietario = TRUE
)

class(jefe_hogar) # Es una lista
length(jefe_hogar) # Tiene 4 elementos

jefe_hogar$canasta <- list( # Listas anidadas!!
  x1='carne', x2='verduras', x3='frutas', x4='lacteos'
)
jefe_hogar$canasta

jefe_hogar$canasta$x1 <-list( # Listas adentro de otra lsita adentro de otra lista !
  carne1 = 'res', carne2 = 'cerdo', carne3 = 'pollo'
)

#Matrices: Estructura 2D del mismo tipo (ej. matriz de transición de ocupaciones).
# Transición Ocupado/Desocupado (T1 a T2)
datos_transicion <- c(80, 20, 15, 85)
matriz_transicion <- matrix(datos_transicion, nrow = 2, byrow = TRUE)
print(matriz_transicion)
#nrow lo que hace es dividirlo x 2 entonces nos queda una matriz 2x2

#Arrays: Estructuras N-dimensionales (ej. datos de panel por varios trimestres).
# 2 filas, 2 columnas, 3 "capas" (trimestres)
panel_laboral <- array(1:12, dim = c(2, 2, 3)) # matriz 2x2 en 3 dimensiones
print(panel_laboral)


# DATA FRAMES: Estructura tabular heterogénea (ideal para datasets). O Tablas de una database.
#La estructura central: variables en columnas, observaciones en filas.
# Creando una "mini base de microdatos"
microdatos <- data.frame(
  id_persona = c(1, 2, 3),
  edad = c(34, 19, 52),
  ingreso = c(450000, 0, 780000),
  trabajo_semana_pasada = c(TRUE, FALSE, TRUE)
)
# Inspeccionamos el Data Frame.
str(microdatos)      # Estructura y tipos de datos de cada columna
summary(microdatos)  # Resumen estadístico (min, media, max, etc.)
# Acceso a columnas específicas.
microdatos$ingreso   # Extrae solo el vector de ingresos

colnames(microdatos) #devuelve el nombre de las columnas del dataframe

# Factores
#Uso específico para datos categóricos de encuestas.
vector_estados <- c("Ocupado", "Desocupado", "Inactivo", "Ocupado")
estado_factor <- factor(vector_estados)


#Visualización y manejo de los "Niveles".
levels(estado_factor) # Devuelve: "Desocupado" "Inactivo" "Ocupado"

# Forzar un orden lógico en los niveles (Ordinales)
nivel_edu <- factor(c("Secundario", "Universitario", "Primario"),
                    levels = c("Primario", "Secundario", "Universitario"),
                    ordered = TRUE)
summary(nivel_edu) # Muestra la frecuencia de cada nivel

