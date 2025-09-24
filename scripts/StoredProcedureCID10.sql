USE mortalidade;
GO

IF OBJECT_ID('sp_extract_cid10', 'P') IS NOT NULL
    DROP PROCEDURE sp_extract_cid10;
GO

CREATE PROCEDURE sp_extract_cid10
    @caminho VARCHAR(500)
AS
BEGIN
    CREATE TABLE ##temp_cid10 (
        SUBCAT VARCHAR(MAX), 
        CLASSIF VARCHAR(MAX), 
        RESTRSEXO VARCHAR(MAX), 
        CAUSAOBITO VARCHAR(MAX), 
        DESCRICAO VARCHAR(MAX)
    );

    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
    BULK INSERT ##temp_cid10
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

IF OBJECT_ID('sp_transform_cid10', 'P') IS NOT NULL
    DROP PROCEDURE sp_transform_cid10;
GO

CREATE PROCEDURE sp_transform_cid10
AS
BEGIN
    ALTER TABLE ##temp_cid10
    DROP COLUMN CLASSIF, RESTRSEXO, CAUSAOBITO;

    IF OBJECT_ID('tempdb..##temp_cid10_trans') IS NOT NULL
        DROP TABLE ##temp_cid10_trans;

    CREATE TABLE ##temp_cid10_trans (
            SUBCAT CHAR(4), 
            DESCRICAO VARCHAR(256)
        );

    INSERT INTO ##temp_cid10_trans (SUBCAT, DESCRICAO)
    SELECT 
        CAST(REPLACE(SUBCAT, '"', '') AS CHAR(4)),
        CAST(REPLACE(DESCRICAO, '"', '') AS VARCHAR(256))
    FROM ##temp_cid10;

    DROP TABLE ##temp_cid10;
END;
GO

IF OBJECT_ID('sp_load_cid10', 'P') IS NOT NULL
    DROP PROCEDURE sp_load_cid10;
GO

CREATE PROCEDURE sp_load_cid10
AS
BEGIN
    INSERT INTO cid10_subcategorias (subcat, descricao)
    SELECT
        temp.SUBCAT,
        temp.DESCRICAO    
    FROM ##temp_cid10_trans AS temp
    WHERE NOT EXISTS (
        SELECT 1 
        FROM cid10_subcategorias AS c 
        WHERE c.subcat = temp.SUBCAT
    );
END;
GO

IF OBJECT_ID('sp_ETL_cid10', 'P') IS NOT NULL
    DROP PROCEDURE sp_ETL_cid10;
GO

CREATE PROCEDURE sp_ETL_cid10
    @caminhoArquivo VARCHAR(500)
AS
BEGIN
    EXEC sp_extract_cid10 @caminho = @caminhoArquivo;
    EXEC sp_transform_cid10;
    EXEC sp_load_cid10;
    DROP TABLE ##temp_cid10_trans;
END;
GO
