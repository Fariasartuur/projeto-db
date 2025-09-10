USE mortalidade;
GO

-- **VERS�O ATUALIZADA**
-- Esta Stored Procedure agora assume que a tabela tempor�ria #stg_dados_brutos
-- J� EXISTE na sess�o. Sua �nica responsabilidade � limpar a tabela
-- e carregar os dados do CSV nela.

CREATE OR ALTER PROCEDURE sp_Extract_Obitos_from_CSV
    @CaminhoArquivoCSV NVARCHAR(MAX) -- Par�metro para o caminho do arquivo de �bitos
AS
BEGIN
    SET NOCOUNT ON;

    -- PASSO 1: Valida��o
    -- Verifica se a tabela tempor�ria realmente existe antes de continuar.
    IF OBJECT_ID('tempdb..#stg_dados_brutos') IS NULL
    BEGIN
        PRINT 'ERRO CR�TICO: A tabela tempor�ria #stg_dados_brutos n�o foi encontrada. O script de orquestra��o deve cri�-la.';
        -- Lan�a um erro para interromper a execu��o.
        THROW 50001, 'Tabela tempor�ria #stg_dados_brutos n�o existe.', 1;
    END;

    -- PASSO 2: Limpeza da Tabela Tempor�ria
    -- Limpa a tabela para garantir que n�o haja dados de execu��es anteriores.
    TRUNCATE TABLE #stg_dados_brutos;
    PRINT 'Tabela tempor�ria #stg_dados_brutos limpa com sucesso.';

    -- PASSO 3: Execu��o do BULK INSERT
    BEGIN TRY
        DECLARE @SQL NVARCHAR(MAX);

        -- Constr�i o comando BULK INSERT dinamicamente
        SET @SQL = N'
            BULK INSERT #stg_dados_brutos
            FROM ''' + @CaminhoArquivoCSV + N'''
            WITH (
                FIRSTROW = 2,
                LASTROW = 101,
                FIELDTERMINATOR = '';'',
                ROWTERMINATOR = ''\r\n'',
                TABLOCK
            );';
        
        EXEC sp_executesql @SQL;
        
        DECLARE @RowCount INT = @@ROWCOUNT;
        PRINT 'BULK INSERT conclu�do com sucesso. ' + CAST(@RowCount AS VARCHAR(10)) + ' linhas foram extra�das para a tabela tempor�ria.';

    END TRY
    BEGIN CATCH
        PRINT 'ERRO GRAVE: A extra��o dos dados do CSV falhou. Mensagem: ' + ERROR_MESSAGE();
        THROW; -- Propaga o erro
    END CATCH

    SET NOCOUNT OFF;
END
GO

