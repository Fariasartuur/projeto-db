USE mortalidade
GO

CREATE OR ALTER PROCEDURE sp_extract_municipios
    @caminho VARCHAR(500)
AS
BEGIN
    CREATE TABLE ##temp_municipio (
        CD_MUN VARCHAR(MAX), 
        NM_MUN VARCHAR(MAX), 
        CD_RGI VARCHAR(MAX), 
        NM_RGI VARCHAR(MAX), 
        CD_RGINT VARCHAR(MAX),
        NM_RGINT VARCHAR(MAX), 
        CD_UF VARCHAR(MAX), 
        NM_UF VARCHAR(MAX), 
        SIGLA_UF VARCHAR(MAX), 
        CD_REGIA VARCHAR(MAX),
        NM_REGIA VARCHAR(MAX), 
        SIGLA_RG VARCHAR(MAX), 
        CD_CONCU VARCHAR(MAX), 
        NM_CONCU VARCHAR(MAX)
    );

    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
    BULK INSERT ##temp_municipio 
    FROM ''' + @caminho + N'''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
        CODEPAGE = ''1252''
    );';

    EXEC sp_executesql @sql;
END
GO

CREATE OR ALTER PROCEDURE sp_transform_municipios
AS
BEGIN

    ALTER TABLE ##temp_municipio
    DROP COLUMN CD_RGI, NM_RGI, CD_RGINT,NM_RGINT, NM_UF, SIGLA_UF, CD_REGIA,NM_REGIA, SIGLA_RG, CD_CONCU, NM_CONCU

    CREATE TABLE ##temp_municipio_trans (
            CD_MUN CHAR(7), 
            NM_MUN VARCHAR(60), 
            CD_UF CHAR(2)
        );

    INSERT INTO ##temp_municipio_trans (CD_MUN, NM_MUN, CD_UF)
    SELECT 
        CAST(CD_MUN AS CHAR(7)),
        CAST(NM_MUN AS VARCHAR(60)),
        CAST(CD_UF AS CHAR(2))
    FROM ##temp_municipio;

DROP TABLE ##temp_municipio
END
GO

CREATE OR ALTER PROCEDURE sp_load_municipios
AS
BEGIN

    INSERT INTO municipio (cod_municipio, nome_municipio, uf)
    SELECT
        temp.CD_MUN,
        temp.NM_MUN,
        temp.CD_UF
    FROM ##temp_municipio_trans AS temp
    WHERE NOT EXISTS (
        SELECT 1 
        FROM municipio AS m 
        WHERE m.cod_municipio = temp.CD_MUN
    );

END
GO

CREATE OR ALTER PROCEDURE sp_ETL_municipios
    @caminhoArquivo VARCHAR(500)
AS
BEGIN
EXEC sp_extract_municipios @caminho = @caminhoArquivo
EXEC sp_transform_municipios
EXEC sp_load_municipios
DROP TABLE ##temp_municipio_trans;
END
GO

