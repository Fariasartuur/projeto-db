USE mortalidade;
GO

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de MUNICÍPIOS.
DECLARE @CaminhoArquivoMunicipios VARCHAR(500) = 'C:\caminho\completo\para\seu\arquivo_municipios.csv';

-- SUBSTITUA o caminho abaixo pelo caminho real do seu arquivo de ÓBITOS.
DECLARE @CaminhoArquivoObitos VARCHAR(500) = 'C:\caminho\completo\para\seu\arquivo_obitos.csv';


-- Chama a procedure mestra para o ETL de municípios
EXEC sp_ETL_municipios @caminhoArquivo = @CaminhoArquivoMunicipios;

-- Chama a procedure mestra para o ETL de óbitos
EXEC sp_ETL_obitos @caminhoArquivo = @CaminhoArquivoObitos;
GO
