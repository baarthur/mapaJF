# setup -------------------------------------------------------------------
library("basedosdados")
set_billing_id("tse22-364418")

# queries -------------------------------------------------------------------
query_tse_completa <- "SELECT zona, secao, melhor_urbano, melhor_rural, tse_recente, tse_distribuido, escolas_inep, 
escolas_municipais, ibge_cnefe_endereco, ibge_cnefe_local, google, google_relaxado, google_centro_geometrico,
ibge_povoados, ano
              FROM `basedosdados.br_tse_eleicoes.local_secao` 
              WHERE id_municipio = 3136702 AND ano = 2020
              LIMIT 500"

query_tse <- "SELECT zona, secao, melhor_urbano, melhor_rural
              FROM `basedosdados.br_tse_eleicoes.local_secao` 
              WHERE id_municipio = 3136702 AND ano = 2020
              "



# baixando dados -------------------------------------------------------------------
df_tse <- basedosdados::download(query = query_tse, path = ("data/tse_jf_20221002.csv"))

df_tse <- read.csv(df_tse)



# verificando os NAs -------------------------------------------------------------------
df_tse_null <- df_tse %>% 
  filter(
    !str_detect(melhor_urbano, "POINT")
  ) 

df_tse_2 <- df_tse %>% 
  filter(
    str_detect(melhor_urbano, "POINT")
  )

df_tse_2 %>% 
  select(-melhor_rural) %>% 
  st_as_sf(coords = "melhor_urbano")

  st_as_sf(coords = "melhor_urbano") %>% 
  tm_shape() +
  tm_dots()