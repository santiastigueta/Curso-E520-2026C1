
# Clase Data Visualization ------------------------------------------------

install.packages("tidyverse") # Tidyverse ayuda a que la curva de aprendizaje de R no sea tan empinada.
library(tidyverse)

install.packages("palmerpenguins") # Palmerpenguins es un dataset de pingüinos que se utiliza para aprender a usar R.
library(palmerpenguins)

install.packages("ggthemes") # ggthemes es un paquete que contiene temas para ggplot2, que es una librería de visualización de datos.
library(ggthemes)

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g) #aes significa aesthetics
) + 
  geom_point(mapping = aes(color = species, shape = species)) + # geom_point es una función que crea un gráfico de dispersión.
  geom_smooth(method = "lm") + # geom_smooth es una función que agrega una línea de tendencia al gráfico.
  theme_economist() + # theme_economist es un tema para ggplot2 que imita el estilo de los gráficos de The Economist.
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()


# Ejercicios (Tarea 03) ---------------------------------------------------

# 1.2.5 ejercicios Data Visualizations con R First Steps.
# 1) How many rows are in penguins? How many columns?
penguins
# Hay 8 columnas y 344 filas. 

# 2) What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.
# Segun la fuente 'help': bill_depth_mm : a number denoting bill depth (millimeters)

# 3) Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis 
# and bill_length_mm on the x-axis. Describe the relationship between these two variables.
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_economist() + 
  labs(
    title = "Bill depth y bill length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Bill length (mm)", y = "Bill depth (mm)"
  ) +
  scale_color_colorblind()
# La relacion entre estas variables es negativa, es decir, a medida que aumenta el bill_length_mm, el bill_depth_mm disminuye.
# Sin embargo, el grafico scatterplot está bastante disperso, lo mas probable a simple vista es que no haya una fuerte correlacion.

# 4) What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
ggplot(
  data = penguins,
  mapping = aes(x = species, y = bill_depth_mm)
) + 
  geom_boxplot()

#El grafico de puntos no parece ser el mas adecuado, ya que species es categorica, no numerica continua. 
# En su lugar, he optado por realizar un boxplot, para identificar (a ojo) la distribucion de biull_depth_mm de cada grupo de pinguino. 

# 5) Why does the following give an error and how would you fix it?

ggplot(data = penguins) + 
  geom_point()
# El error en la consola explica que no hemos especificado las variables x e y en la "aesthetics" aes. `geom_point()` requires the following missing aesthetics: x and y.


# 6) What does the na.rm argument do in geom_point()? What is the default value of the argument? 
# Create a scatterplot where you successfully use this argument set to TRUE.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g) #aes significa aesthetics
) + 
  geom_point(mapping = aes(color = species, shape = species), na.rm = TRUE) +
  labs(title = "Data come from the palmerpenguins package.") # Ejercicio 7 

# El argumento na.rm en geom_point() se utiliza para eliminar los valores NA (missing values) del conjunto de datos antes de crear el gráfico. (lo vimos en clase)



# 8) Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? 
# And should it be mapped at the global level or at the geom level?

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g) #aes significa aesthetics
) + 
  geom_point(mapping = aes(color = bill_depth_mm), na.rm = TRUE)# El color de los puntos se mapea a bill_depth_mm, y se hace a nivel geométrico para que solo afecte a los puntos.
  geom_smooth(method = "loess") + # geom_smooth es una función que agrega una línea de tendencia al gráfico. En este caso, se utiliza el método "loess" para ajustar una curva suave a los datos.
  scale_color_gradient(low = "#132B43", high = "#56B1F7") +
  theme_minimal() 

# Y asi, queda exactamente igual al grafico del libro. :)



# 9) Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

# Mi prediccion: se trata de un diagrama de dispersion, donde el eje x sera flipper lenght y el eje y sera la masa corporal del pinguino,
# el color de los pinguinos va a estar divididos en su ubicacion (segun la isla deonde vive, torguensen, biscoe, etc)
# geom smooth agrega una linea de tendencia que segun la fuente, el atributo se agrega una banda de confianza, pero al ponerle false, esta no aparece.(por defecto es true)

# Resultado: El resultado es bastante similar a mi prediccion, mi unico error fue ignorar que iban a haber distintas rectas de regresion para
# cada isla. 

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = island)) +
  geom_smooth(se = FALSE)

# Al parecer, la linea de tendencia se vuelve unica cuando la distincion entre pinguinos se hace a nivel geométrico, y no a nivel global.


# 10) Will these two graphs look different? Why/why not?

ggplot(
data = penguins,
mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()


ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )
# No, ambos gráficos se verán iguales. Solo que uno define las cosas de manera global y el otro dentro de geom.
# Se usan las mismas variables y datos para armar los graficos por eso son los dos iguales. 




