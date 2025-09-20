USE mortalidade;
GO

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de MUNIC�PIOS.
DECLARE @CaminhoArquivoMunicipios VARCHAR(500) = 'C:\caminho\completo\para\seu\arquivo_municipios.csv';

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de �BITOS.
DECLARE @CaminhoArquivoObitos VARCHAR(500) = 'C:\caminho\completo\para\seu\arquivo_obitos.csv';


-- Chama a procedure mestra para o ETL de munic�pios
EXEC sp_ETL_municipios @caminhoArquivo = @CaminhoArquivoMunicipios;

-- Chama a procedure mestra para o ETL de �bitos
EXEC sp_ETL_obitos @caminhoArquivo = @CaminhoArquivoObitos;
GO
