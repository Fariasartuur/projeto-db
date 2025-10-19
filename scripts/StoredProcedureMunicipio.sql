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
        CD_MUN NVARCHAR(MAX), 
        NM_MUN NVARCHAR(MAX), 
        CD_UF NVARCHAR(MAX), 
        SIGLA_UF NVARCHAR(MAX), 
        NM_UF NVARCHAR(MAX)
    );

    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
    BULK INSERT ##temp_municipio 
    FROM ''' + @caminho + N'''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
        CODEPAGE = ''65001''
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
    DROP COLUMN SIGLA_UF;

    IF OBJECT_ID('tempdb..##temp_municipio_trans') IS NOT NULL
        DROP TABLE ##temp_municipio_trans;

    CREATE TABLE ##temp_municipio_trans (
            CD_MUN CHAR(7), 
            NM_MUN NVARCHAR(60), 
            CD_UF CHAR(2),
            NM_UF VARCHAR(60)
        );

    INSERT INTO ##temp_municipio_trans (CD_MUN, NM_MUN, CD_UF, NM_UF)
    SELECT 
        CAST(REPLACE(CD_MUN, '"', '') AS CHAR(7)),
        CAST(REPLACE(NM_MUN, '"', '') AS NVARCHAR(60)),
        CAST(REPLACE(CD_UF, '"', '') AS CHAR(2)),
        CAST(REPLACE(NM_UF, '"', '') AS NVARCHAR(60))
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
    INSERT INTO municipio (cod_municipio, nome_municipio, uf, nome_uf)
    SELECT
        temp.CD_MUN,
        temp.NM_MUN,
        temp.CD_UF,
        temp.NM_UF
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
