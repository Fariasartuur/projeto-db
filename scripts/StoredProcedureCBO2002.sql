USE mortalidade;
GO

IF OBJECT_ID('sp_extract_cbo2002', 'P') IS NOT NULL
    DROP PROCEDURE sp_extract_cbo2002;
GO

CREATE PROCEDURE sp_extract_cbo2002
    @caminho VARCHAR(500)
AS
BEGIN
    CREATE TABLE ##temp_cbo2002 (
        CODIGO VARCHAR(MAX), 
        TITULO VARCHAR(MAX)
      
    );

    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
    BULK INSERT ##temp_cbo2002
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

IF OBJECT_ID('sp_transform_cbo2002', 'P') IS NOT NULL
    DROP PROCEDURE sp_transform_cbo2002;
GO

CREATE PROCEDURE sp_transform_cbo2002
AS
BEGIN

    IF OBJECT_ID('tempdb..##temp_cbo2002_trans') IS NOT NULL
        DROP TABLE ##temp_cbo2002_trans;

    CREATE TABLE ##temp_cbo2002_trans (
           CODIGO CHAR(6), 
           TITULO VARCHAR(256)
        );

    INSERT INTO ##temp_cbo2002_trans (CODIGO, TITULO)
    SELECT 
        CAST(REPLACE(CODIGO, '"', '') AS CHAR(6)),
        CAST(REPLACE(TITULO, '"', '') AS VARCHAR(256))
    FROM ##temp_cbo2002;

    DROP TABLE ##temp_cbo2002;
END;
GO

IF OBJECT_ID('sp_load_cbo2002', 'P') IS NOT NULL
    DROP PROCEDURE sp_load_cbo2002;
GO

CREATE PROCEDURE sp_load_cbo2002
AS
BEGIN
    INSERT INTO cbo2002 (codigo, titulo)
    SELECT
        temp.CODIGO,
        temp.TITULO    
    FROM ##temp_cbo2002_trans AS temp
    WHERE NOT EXISTS (
        SELECT 1 
        FROM cbo2002 AS c 
        WHERE c.codigo = temp.CODIGO
    );
END;
GO

IF OBJECT_ID('sp_ETL_cbo2002', 'P') IS NOT NULL
    DROP PROCEDURE sp_ETL_cbo2002;
GO

CREATE PROCEDURE sp_ETL_cbo2002
    @caminhoArquivo VARCHAR(500)
AS
BEGIN
    EXEC sp_extract_cbo2002 @caminho = @caminhoArquivo;
    EXEC sp_transform_cbo2002;
    EXEC sp_load_cbo2002;
    DROP TABLE ##temp_cbo2002_trans;
END;
GO
