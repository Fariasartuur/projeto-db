USE mortalidade;
GO

-- **VERSÃO ATUALIZADA**
-- Esta Stored Procedure agora assume que a tabela temporária #stg_dados_brutos
-- JÁ EXISTE na sessão. Sua única responsabilidade é limpar a tabela
-- e carregar os dados do CSV nela.

CREATE OR ALTER PROCEDURE sp_Extract_Obitos_from_CSV
    @CaminhoArquivoCSV NVARCHAR(MAX) -- Parâmetro para o caminho do arquivo de óbitos
AS
BEGIN
    SET NOCOUNT ON;

    -- PASSO 1: Validação
    -- Verifica se a tabela temporária realmente existe antes de continuar.
    IF OBJECT_ID('tempdb..#stg_dados_brutos') IS NULL
    BEGIN
        PRINT 'ERRO CRÍTICO: A tabela temporária #stg_dados_brutos não foi encontrada. O script de orquestração deve criá-la.';
        -- Lança um erro para interromper a execução.
        THROW 50001, 'Tabela temporária #stg_dados_brutos não existe.', 1;
    END;

    -- PASSO 2: Limpeza da Tabela Temporária
    -- Limpa a tabela para garantir que não haja dados de execuções anteriores.
    TRUNCATE TABLE #stg_dados_brutos;
    PRINT 'Tabela temporária #stg_dados_brutos limpa com sucesso.';

    -- PASSO 3: Execução do BULK INSERT
    BEGIN TRY
        DECLARE @SQL NVARCHAR(MAX);

        -- Constrói o comando BULK INSERT dinamicamente
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
        PRINT 'BULK INSERT concluído com sucesso. ' + CAST(@RowCount AS VARCHAR(10)) + ' linhas foram extraídas para a tabela temporária.';

    END TRY
    BEGIN CATCH
        PRINT 'ERRO GRAVE: A extração dos dados do CSV falhou. Mensagem: ' + ERROR_MESSAGE();
        THROW; -- Propaga o erro
    END CATCH

    SET NOCOUNT OFF;
END
GO

