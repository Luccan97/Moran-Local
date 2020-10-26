# Moran-Local

Utilizando o ambiente do R para rodar Moran Local, técnica de análise espacial.

O script apresentado é uma adaptação de um script disponibilizado pelo curso Técnicas de Análise aplicados em surtos e epidemias da Fiocruz!

Bom, o método Moran Local de Anselin (LISA) pode ser utilizado para identificação de aglomerados. Aponta autocorrelação positiva e negativa, a partir de uma matriz de vizinhança que permite boa adaptação, inclusive para testar hipóteses que não incluem vizinhos de primeira ordem ou contiguidade!

Vamos aplicar o script de LISA para verificar se existe correlação espacial entre óbitos cuja causa esteja associada a neoplasia (câncer) e os distritos administrativos de residências no município de São Paulo.

Para funcionar, precisamos de uma camada shapefile (polígonos) com as unidades territóriais de interesse e as informações/valores que serão estudados (taxas de mortalidade por neoplasia (a cada 10.000 pessoas) por distrito administrativo.

