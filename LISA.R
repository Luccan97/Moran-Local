####

### Moran Local (LISA)


# Definindo diretório de trabalho
setwd("C:\\GISA_Lucca\\Projetos_Lucca_GISA\\Demandas_CEINFO\\20201008_TAE_surtos_fiocruz\\LISA")

library(spdep)
library(maptools)
library(magrittr)
library(dplyr)
library(rgdal)
# Variáveis, parâmetros que devem ser alterados no scrip:
# 'ds_nome' = trocar pelo nome da variável identificadora das linhas da sua base de dados!
# 'taxa' = trocar pelo nome da variável que contém as taxas as serem analisadas!
# Atentar-se para mudança dos diretórios trabalhados!


# Importando a camala shapefile (polígono) com as informações necessárias para a análise.
Layer <- readOGR("shapefiles\\Layer.shp", encoding = 'windows-1250')


# Definir o 'ds_nome' como a variável que identfica as linhas!
X <- poly2nb(Layer, queen = TRUE, row.names = Layer$ds_nome)

X_mat <- nb2listw(X, style="B", zero.policy = TRUE)

LISA <- localmoran(Layer$taxa, listw = X_mat, zero.policy= TRUE)

# Padronização da variavél, salvando em uma outra coluna! 
# A técnica Moran Local (LISA) utiliza valores (taxas) associados à polígonos para
#verificar a ocorerência de clusters locais. Definir 'taxa' com o nome da variável
# que será utilizada.

Layer$taxa <- scale(Layer[["taxa"]])  %>% as.vector()

# Criando spatial lagged variable and associatind in a new column
Layer$lag_taxa <- lag.listw(X_mat, Layer$taxa)

# moran sccaterplot, in basic graphics (with ds_nome entification of influential observations)
x <- Layer$taxa
y <- Layer$lag_taxa %>% as.vector()
xx <- data_frame(x, y)

Layer$pvalor <- LISA[, 5]

# Criar nova variável ds_nome identificando moran plot quadrant  para cada observação.

Layer$quad_sig <- NA

# high-high quadrant
Layer@data[(Layer$taxa >= 0 &
              Layer$lag_taxa >= 0) &
             
             (LISA[, 5] <= 0.05), "quad_sig"] <- "high-high"

# low-low quadrant
Layer@data[(Layer$taxa <= 0 &
              Layer$lag_taxa <= 0) &
             
             (LISA[, 5] <= 0.05), "quad_sig"] <- "low-low"

# high-low quadrant
Layer@data[(Layer$taxa >= 0 &
              Layer$lag_taxa <= 0) &
             (LISA[, 5] <= 0.05), "quad_sig"] <- "high-low"

# low-high quadrant
Layer@data[(Layer$taxa <= 0
    
                    & Layer$lag_taxa >= 0) &
             (LISA[, 5] <= 0.05), "quad_sig"] <- "low-high"

# non-significant observations
Layer@data[(LISA[, 5] > 0.05), "quad_sig"] <- "não significante"



ds_nome <- Layer[['ds_nome']]

ID_LISA <- cbind (ds_nome,LISA, Layer$quad_sig)

ID_LISA <- as.data.frame(ID_LISA, row.names = NULL, optional = FALSE)

colnames(ID_LISA) <- c("ds_nome","LISA","LISA.E","LISA.Var","Z-score","P-value","Quad")

Layer$quad_sig <- as.factor(Layer$quad_sig)

#Criando uma tabela com os resultados da análise de Moran Local.
#O arquivo ficará hospeado no mesmo diretório onde estão arquivos shapefile que foram utilizados

write.table(ID_LISA, file = "LISA_MORAN_RESULTADO.csv",  sep = "\t", na = "", quote = FALSE, dec = ",")

# Outputs

moran.plot(x, X_mat)

Camada_output <- Layer

print(LISA)

# Exportando nova camada shapefile com os resultados calculados!
writeOGR(Camada_output, dsn = 'shapefiles', 
         driver = 'ESRI Shapefile', layer = 'Camada_output_1.SHP')

