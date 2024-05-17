
# Mapa de distribuição de espécies ---------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 16/05/24 ---------------------------------------------------------------------------------------------------------------------------

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(rgbif)
library(dplyr)
library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(cols4all)

# Carregar dados ---------------------------------------------------------------------------------------------------------------------------

# Buscar dados de ocorrência no GBIF para uma espécie específica
# Exemplo: Panthera onca (onça-pintada)

species_name <- c("Monachus schauinslandi")
occ_data <- occ_search(scientificName = species_name, limit = 500)

species_name1 <- c("Bison bison")
occ_data1 <- occ_search(scientificName = species_name1, limit = 500)

species_name2 <- c("Gymnogyps californianus")
occ_data2 <- occ_search(scientificName = species_name2, limit = 500)

species_name3 <- c("Oncorhynchus nerka")
occ_data3 <- occ_search(scientificName = species_name3, limit = 500)

species_name4 <- c("Canis rufus")
occ_data4 <- occ_search(scientificName = species_name4, limit = 500)

# Extrair coordenadas

coords <- occ_data$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

coords1 <- occ_data1$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

coords2 <- occ_data2$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

coords3 <- occ_data3$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

coords4 <- occ_data4$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

# Converter para objeto sf

coords_sf <- st_as_sf(coords, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

coords_sf1 <- st_as_sf(coords1, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

coords_sf2 <- st_as_sf(coords2, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

coords_sf3 <- st_as_sf(coords3, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

coords_sf4 <- st_as_sf(coords4, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

# Obter dados das fronteiras dos países

world <- ne_countries(scale = "medium", returnclass = "sf")

# Filtrar para um país específico (por exemplo, Brasil)

america <- world %>%
  filter(continent %in% c("North America")) 

# Ajustar os limites do mapa para focar na América do Norte
xlim <- c(-180, -60)  # Ajuste conforme necessário para cobrir a América do Norte
ylim <- c(10, 70)     # Ajuste conforme necessário para cobrir a América do Norte

# Visualizar mapa --------------------------------------------------------------------------------------------------------------------------

# Definir cores

cols4all::c4a_table(type = "cat", n = 5)

# Criar mapa básico com ggplot2

ggplot() +
  geom_sf(data = america, fill = "#69b3a2", 
          color = "white", alpha = 0.5) +  # Fronteiras dos países
  geom_sf(data = coords_sf, aes(color = "#123134"),
          size = 1.7) + 
  geom_sf(data = coords_sf1, aes(color = "#096876"), 
          size = 1.7) + 
  geom_sf(data = coords_sf2, aes(color = "#453256"),
          size = 1.7) + 
  geom_sf(data = coords_sf3, aes(color = "brown"),
          size = 1.7) +
  geom_sf(data = coords_sf4, aes(color = "forestgreen"),
          size = 1.7) +
  coord_sf(xlim = xlim, ylim = ylim) +
  labs(title = paste("Distribuição Geográfica de", species_name),
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()
 
