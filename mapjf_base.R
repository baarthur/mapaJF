library(tidyverse)
library(geobr)
library(sf)


##mapa geobr

juiz_de_fora <- geobr::read_municipality(code_muni = 3136702)
juiz_de_fora_zonas <- geobr::read_census_tract(code_tract  = 3136702, year = 2000 )

juiz_de_fora_zonas_urbanas <- geobr::read_census_tract(code_tract  = 3136702, year = 2000, zone = "urban" )
juiz_de_fora_zonas_rurais <- geobr::read_census_tract(code_tract  = 3136702, year = 2000, zone = "rural" )

ggplot() +geom_sf(data= juiz_de_fora_zonas_urbanas, fill= "steelblue4", color= "#FEBF57", size= .15, show.legend = F)

#grupamento de bairros IBGE

library(readxl)
Base_informacoes_setores2010_sinopse_MG <- read_excel("base_ibge_censo/Base_informacoes_setores2010_sinopse_MG.xls")
saveRDS(Base_informacoes_setores2010_sinopse_MG, file = "base_ibge.rds")


base_ibge_select<-base_ibge%>%
  select(Cod_setor, Cod_municipio:Nome_do_bairro)

base_ibge_jf<- base_ibge_select%>%
  filter(Nome_do_municipio== "JUIZ DE FORA")%>%
  rename(code_tract= Cod_setor)

#juntando geobr X IBGE com inner_join 

juiz_de_fora_agregado <- inner_join(juiz_de_fora_zonas, base_ibge_jf, by= "code_tract")


#Cruzando geobr e ibge com full_join

juiz_de_fora_agregado2 <- full_join(juiz_de_fora_zonas, base_ibge_jf, by= "code_tract")

juiz_de_fora_bairros2<- juiz_de_fora_agregado2%>%
  group_by(Nome_do_bairro)%>%
  summarize()%>%
  st_simplify(dTolerance = 0.0007)

ggplot() +geom_sf(data= juiz_de_fora_bairros2, fill= "steelblue4", color= "#FEBF57", size= .15, show.legend = F)