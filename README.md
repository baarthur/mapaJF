# mapaJF
Repositório separado do mapa de JF para organizar na hora de copiar para outros projetos. Faça branchs se achar uma forma melhor de fazer.
 
 
Esse mapa veio do projeto covid19jf. 

o Base_censo_ibge_2010 alguma coisa veio do site oficial do IBGE, que salvei baixei no https://www.ibge.gov.br/estatisticas/downloads-estatisticas.html  
caminho do site é Censos > Censo_Demografico_2010 > Resultados por Universo > Agregados_por_Setores_Censitarios . Salvei no base_ibge.rds

O full_join funcionou melhor que o inner_join, que apaga alguns bairros.

o st_simplify simplifica os polígonnos e resolve o problea, mas deixa alguns riscos no meio do mapa pra tras. No mapa do Pindograma não acontece. Poderia achar um jeito de melhorar
 main
