shp_bairros_jf <- readRDS("data/shp_bairros_jf.RDS")
shp_secoes_jf <- readRDS("data/shp_secoes_2020.RDS")

## ggplot
mapa_secoes_ggp <- ggplot() +
  geom_sf(
    data = shp_bairros_jf,
    fill = "steelblue4", 
    color = "#FEBF57", 
    size = .15) +
  geom_sf(
    data = shp_secoes_jf,
    color = "red") +
  labs(title = "Seções eleitorais de Juiz de Fora",
       caption = "Fonte: elaboração própria com base nos dados do IBGE e do TSE") +
  theme_void()

ggsave(filename = "mapa_secoes_ggplot.png", plot = mapa_secoes_ggp, dev = "png", path = "output/")


## tmap
mapa_secoes %>% 
  tm_shape(shp_bairros_jf) +
  tm_fill(col = "steelblue4", alpha = 0.75) +
  tm_borders(col = "#FEBF57") +
  tm_shape(shp_secoes_jf) +
  tm_dots(col = "red")


