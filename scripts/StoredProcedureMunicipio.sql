USE mortalidade;
GO

IF OBJECT_ID('sp_extract_municipios', 'P') IS NOT NULL
    DROP PROCEDURE sp_extract_municipios;
GO

CREATE PROCEDURE sp_extract_municipios
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
END;
GO

IF OBJECT_ID('sp_transform_municipios', 'P') IS NOT NULL
    DROP PROCEDURE sp_transform_municipios;
GO

CREATE PROCEDURE sp_transform_municipios
AS
BEGIN
    ALTER TABLE ##temp_municipio
    DROP COLUMN CD_RGI, NM_RGI, CD_RGINT,NM_RGINT, NM_UF, SIGLA_UF, CD_REGIA,NM_REGIA, SIGLA_RG, CD_CONCU, NM_CONCU;

    IF OBJECT_ID('tempdb..##temp_municipio_trans') IS NOT NULL
        DROP TABLE ##temp_municipio_trans;

    CREATE TABLE ##temp_municipio_trans (
            CD_MUN CHAR(7), 
            NM_MUN VARCHAR(60), 
            CD_UF CHAR(2)
        );

    INSERT INTO ##temp_municipio_trans (CD_MUN, NM_MUN, CD_UF)
    SELECT 
        CAST(REPLACE(CD_MUN, '"', '') AS CHAR(7)),
        CAST(REPLACE(NM_MUN, '"', '') AS VARCHAR(60)),
        CAST(REPLACE(CD_UF, '"', '') AS CHAR(2))
    FROM ##temp_municipio;

    DROP TABLE ##temp_municipio;
END;
GO

IF OBJECT_ID('sp_load_municipios', 'P') IS NOT NULL
    DROP PROCEDURE sp_load_municipios;
GO

CREATE PROCEDURE sp_load_municipios
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
END;
GO

IF OBJECT_ID('sp_ETL_municipios', 'P') IS NOT NULL
    DROP PROCEDURE sp_ETL_municipios;
GO

CREATE PROCEDURE sp_ETL_municipios
    @caminhoArquivo VARCHAR(500)
AS
BEGIN
    EXEC sp_extract_municipios @caminho = @caminhoArquivo;
    EXEC sp_transform_municipios;
    EXEC sp_load_municipios;
    DROP TABLE ##temp_municipio_trans;
END;
GO
