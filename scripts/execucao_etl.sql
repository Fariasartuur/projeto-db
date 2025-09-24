USE mortalidade;
GO

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de MUNICÍPIOS.
DECLARE @CaminhoArquivoMunicipios VARCHAR(500) = 'C:\dataset\BR_Municipios_2024.csv';

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de CBO.
DECLARE @CaminhoArquivoCBO VARCHAR(500) = 'C:\dataset\cbo2002-ocupacao.csv';

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de CID.
DECLARE @CaminhoArquivoCID VARCHAR(500) = 'C:\dataset\CID-10-SUBCATEGORIAS.csv';

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de ÓBITOS.
DECLARE @CaminhoArquivoObitos VARCHAR(500) = 'C:\dataset\DO24OPEN.csv';


-- Chama a procedure mestra para o ETL de municípios
EXEC sp_ETL_municipios @caminhoArquivo = @CaminhoArquivoMunicipios;

-- Chama a procedure mestra para o ETL de CBO
EXEC sp_ETL_cbo2002 @caminhoArquivo = @CaminhoArquivoCBO;


-- Chama a procedure mestra para o ETL de CID
EXEC sp_ETL_cid10 @caminhoArquivo = @CaminhoArquivoCID;

-- Chama a procedure mestra para o ETL de óbitos
EXEC sp_ETL_obitos @caminhoArquivo = @CaminhoArquivoObitos;
GO
