# setup -------------------------------------------------------------------
library(tidyverse)

library("basedosdados")
set_billing_id("tse22-364418")

# queries -------------------------------------------------------------------
query_tse_completa <- "SELECT zona, secao, melhor_urbano, melhor_rural, tse_recente, tse_distribuido, escolas_inep, 
escolas_municipais, ibge_cnefe_endereco, ibge_cnefe_local, google, google_relaxado, google_centro_geometrico,
ibge_povoados, ano
              FROM `basedosdados.br_tse_eleicoes.local_secao` 
              WHERE id_municipio = 3136702 AND ano = 2020
              "

query_tse <- "SELECT zona, secao, melhor_urbano, google_relaxado
              FROM `basedosdados.br_tse_eleicoes.local_secao` 
              WHERE id_municipio = 3136702 AND ano = 2020
              "



# baixando dados -------------------------------------------------------------------
df_tse <- basedosdados::download(query = query_tse, path = ("data/tse_jf_20221002.csv"))  

df_secoes <- read.csv("data/tse_jf_20221002.csv")


df_tse_completa <- basedosdados::download(query = query_tse_completa, path = ("data/tse_jf_completa_20221002.csv"))  

df_secoes_completa <- read.csv("data/tse_jf_completa_20221002.csv")


# organizando os dados -------------------------------------------------------------------

## verificando os NAs
library(tidyselect)

df_secoes_null <- df_secoes %>% 
  filter(
    !str_detect(melhor_urbano, "POINT") 
  ) 

df_secoes_recuperado <- df_secoes_null %>% 
  filter(
  str_detect(google_relaxado, "POINT")
  )

## base sem os NAs
### WIP IGNORAR
df_secoes2 <- df_secoes %>% 
  filter(
    str_detect(melhor_urbano, "POINT")
  ) %>% 
  mutate(melhor_urbano = str_replace(melhor_urbano, " ", ", ")) %>% 
  mutate(melhor_rural = str_replace(melhor_rural, " ", ", ")) %>% 
  mutate(melhor_urbano = str_replace(melhor_urbano, "POINT[(]", "")) %>%
  mutate(melhor_rural = str_replace(melhor_rural, "POINT[(]", ""))

df_secoes2 <- df_secoes2 %>%
  mutate(melhor_urbano = str_replace(melhor_urbano, "[)]", "")) %>%
  mutate(melhor_rural = str_replace(melhor_rural, "[)]", ""))

df_secoes2 <- df_secoes2 %>% 
  select(-melhor_rural) %>% 
  separate(melhor_urbano, c("lat", "lon"), sep = ", ")

### podemos ver que nenhuma das seções em df_secoes_null está em df_secoes2 (ou seja, não se tratam de entradas duplicadas) fazendo which(df_secoes_null %in% df_secoes2)


## shapefile das seções
shp_secoes <- df_secoes2 %>% 
  st_as_sf(coords = c("lat", "lon"), crs = st_crs(4326))

saveRDS(shp_secoes, "data/shp_secoes_2020.RDS")

## mapa para conferência
shp_secoes %>% 
  tm_shape() +
  tm_dots(col = "red")

tm_shape(shp_bairros_jf) +
  tm_fill(col = "steelblue4") +
  tm_borders(col = "#FEBF57") +
  tm_shape(shp_secoes_jf) +
  tm_dots(col = "red")


