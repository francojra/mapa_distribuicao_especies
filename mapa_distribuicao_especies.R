
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

# Carregar dados ---------------------------------------------------------------------------------------------------------------------------

# Buscar dados de ocorrência no GBIF para uma espécie específica
# Exemplo: Panthera onca (onça-pintada)

species_name <- "Panthera onca"
occ_data <- occ_search(scientificName = species_name, limit = 500)

# Extrair coordenadas

coords <- occ_data$data %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>%
  select(decimalLongitude, decimalLatitude)

# Converter para objeto sf

coords_sf <- st_as_sf(coords, coords = c("decimalLongitude", 
                                         "decimalLatitude"), 
                      crs = 4326)

# Obter dados das fronteiras dos países

world <- ne_countries(scale = "medium", returnclass = "sf")

# Filtrar para um país específico (por exemplo, Brasil)

brazil <- world %>% filter(name == "Brazil")

# Visualizar mapa --------------------------------------------------------------------------------------------------------------------------

# Criar mapa básico com ggplot2

ggplot() +
  geom_sf(data = brazil, fill = "gray80", color = "white") +  # Fronteiras dos países
  geom_sf(data = coords_sf, aes(color = "red"), 
          size = 2, show.legend = F) +  # Ocorrências da espécie
  coord_sf() +
  labs(title = paste("Distribuição Geográfica de", species_name),
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()
 
