USE mortalidade;
GO

-- Esta procedure representa as fases de Transformação (T) e Carga (L) do processo de ETL.
-- Ela assume que a tabela temporária #stg_dados_brutos já foi populada pela
-- procedure de extração (sp_Extract_Obitos_from_CSV).

CREATE OR ALTER PROCEDURE sp_Transform_and_Load_Obitos
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Iniciando o processo de Transformação e Carga...';

    -- 1. DECLARAÇÃO DE VARIÁVEIS para o cursor
    DECLARE @contador VARCHAR(10), @CB_PRE VARCHAR(10);
    DECLARE @id_obito_inserido INT, @id_escol_falecido_inserido INT, @id_escol_mae_inserida INT, @id_idade_inserido INT;
    DECLARE @TIPOBITO VARCHAR(1), @DTOBITO VARCHAR(8), @HORAOBITO VARCHAR(5);
    DECLARE @LOCOCOR VARCHAR(1), @CODESTAB VARCHAR(8), @CODMUNOCOR VARCHAR(8), @NATURAL VARCHAR(3), @CODMUNNATU VARCHAR(7);
    DECLARE @CIRCOBITO VARCHAR(1), @ACIDTRAB VARCHAR(1), @FONTE VARCHAR(1), @TPOBITOCOR VARCHAR(1);
    DECLARE @ESC2010 VARCHAR(1), @ESC VARCHAR(1), @ESCFALAGR1 VARCHAR(2), @SERIESCFAL VARCHAR(1);
    DECLARE @DTNASC VARCHAR(8), @OCUP VARCHAR(6), @CODMUNRES VARCHAR(7), @ESTCIV VARCHAR(1), @RACACOR VARCHAR(1), @SEXO VARCHAR(1);
    DECLARE @IDADE VARCHAR(3);
    DECLARE @IDADEMAE VARCHAR(2), @ESCMAE2010 VARCHAR(1), @ESCMAE VARCHAR(1), @ESCMAEAGR1 VARCHAR(2), @SERIESCMAE VARCHAR(1);
    DECLARE @OCUPMAE VARCHAR(6), @QTDFILVIVO VARCHAR(2), @QTDFILMORT VARCHAR(2), @SEMAGESTAC VARCHAR(3), @GRAVIDEZ VARCHAR(1);
    DECLARE @GESTACAO VARCHAR(1), @PARTO VARCHAR(1), @OBITOPARTO VARCHAR(1), @PESO VARCHAR(4), @TPMORTEOCO VARCHAR(1);
    DECLARE @OBITOGRAV VARCHAR(1), @OBITOPUERP VARCHAR(1), @MORTEPARTO VARCHAR(1), @CAUSAMAT VARCHAR(4);
    DECLARE @ASSISTMED VARCHAR(1), @NECROPSIA VARCHAR(1), @EXAME VARCHAR(1), @CIRURGIA VARCHAR(1), @ATESTANTE VARCHAR(1);
    DECLARE @DTATESTADO VARCHAR(8), @ATESTADO VARCHAR(70), @COMUNSVOIM VARCHAR(7);
    DECLARE @LINHAA VARCHAR(20), @LINHAB VARCHAR(20), @LINHAC VARCHAR(20), @LINHAD VARCHAR(20), @LINHAII VARCHAR(45);
    DECLARE @CAUSABAS VARCHAR(4), @CAUSABAS_O VARCHAR(4), @CB_ALT VARCHAR(10);
    DECLARE @ORIGEM VARCHAR(10), @NUMEROLOTE VARCHAR(8), @DTINVESTIG VARCHAR(8), @DTCADASTRO VARCHAR(8);
    DECLARE @STCODIFICA VARCHAR(1), @CODIFICADO VARCHAR(1), @VERSAOSIST VARCHAR(7), @VERSAOSCB VARCHAR(7);
    DECLARE @DTRECEBIM VARCHAR(8), @DTRECORIGA VARCHAR(8), @OPOR_DO VARCHAR(4), @DIFDATA VARCHAR(8);
    DECLARE @NUDIASOBCO VARCHAR(4), @DTCADINV VARCHAR(8), @DTCONINV VARCHAR(8);
    DECLARE @DTCADINF VARCHAR(8), @DTCONCASO VARCHAR(8), @FONTEINV VARCHAR(8);
    DECLARE @TPRESGINFO VARCHAR(2), @TPNIVELINV VARCHAR(1), @ALTCAUSA VARCHAR(1), @TPPOS VARCHAR(1);
    DECLARE @STDOEPIDEM VARCHAR(1), @STDONOVA VARCHAR(1), @TP_ALTERA VARCHAR(2);
    DECLARE @FONTES VARCHAR(6);

    -- 2. DECLARAÇÃO DO CURSOR para ler da tabela de staging
    DECLARE cursor_obitos CURSOR FOR
        SELECT * FROM #stg_dados_brutos;

    -- 3. ABERTURA DO CURSOR E PRIMEIRA LEITURA
    OPEN cursor_obitos;
    FETCH NEXT FROM cursor_obitos INTO @contador, @ORIGEM, @TIPOBITO, @DTOBITO, @HORAOBITO, @NATURAL, @CODMUNNATU, @DTNASC, @IDADE, @SEXO, @RACACOR, @ESTCIV,
        @ESC, @ESC2010, @SERIESCFAL, @OCUP, @CODMUNRES, @LOCOCOR, @CODESTAB, @CODMUNOCOR, @IDADEMAE, @ESCMAE, @ESCMAE2010, @SERIESCMAE, @OCUPMAE,
        @QTDFILVIVO, @QTDFILMORT, @GRAVIDEZ, @SEMAGESTAC, @GESTACAO, @PARTO, @OBITOPARTO, @PESO, @TPMORTEOCO, @OBITOGRAV, @OBITOPUERP, @ASSISTMED,
        @EXAME, @CIRURGIA, @NECROPSIA, @LINHAA, @LINHAB, @LINHAC, @LINHAD, @LINHAII, @CAUSABAS, @CB_PRE, @COMUNSVOIM, @DTATESTADO, @CIRCOBITO, @ACIDTRAB,
        @FONTE, @NUMEROLOTE, @DTINVESTIG, @DTCADASTRO, @ATESTANTE, @STCODIFICA, @CODIFICADO, @VERSAOSIST, @VERSAOSCB, @FONTEINV, @DTRECEBIM, @ATESTADO,
        @DTRECORIGA, @OPOR_DO, @CAUSAMAT, @ESCMAEAGR1, @ESCFALAGR1, @STDOEPIDEM, @STDONOVA, @DIFDATA, @NUDIASOBCO, @DTCADINV, @TPOBITOCOR, @DTCONINV,
        @FONTES, @TPRESGINFO, @TPNIVELINV, @DTCADINF, @MORTEPARTO, @DTCONCASO, @ALTCAUSA, @CAUSABAS_O, @TPPOS, @TP_ALTERA, @CB_ALT;

    -- 4. LOOP PRINCIPAL para processar cada linha da tabela de staging
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Validação dos dados essenciais (ex: data do óbito e município de residência)
        IF LTRIM(RTRIM(ISNULL(@DTOBITO,''))) <> '' AND ISDATE(SUBSTRING(@DTOBITO, 5, 4) + SUBSTRING(@DTOBITO, 3, 2) + SUBSTRING(@DTOBITO, 1, 2)) = 1
        BEGIN
            -- Inicia uma transação para garantir a atomicidade das inserções
            BEGIN TRANSACTION;
            BEGIN TRY
                -- Inserir na tabela 'obito'
                INSERT INTO obito (id_tipobito, dtobito, horaobito)
                VALUES (
                    TRY_CONVERT(TINYINT, @TIPOBITO),
                    TRY_CONVERT(DATE, SUBSTRING(@DTOBITO, 5, 4) + SUBSTRING(@DTOBITO, 3, 2) + SUBSTRING(@DTOBITO, 1, 2)),
                    CASE WHEN LEN(@HORAOBITO) = 4 THEN TRY_CONVERT(TIME, STUFF(@HORAOBITO, 3, 0, ':')) ELSE NULL END
                );
                SET @id_obito_inserido = SCOPE_IDENTITY();

                -- Inserir em local_ocorrencia
                INSERT INTO local_ocorrencia(id_obito, id_lococor, codestab, codmunocor)
                VALUES (@id_obito_inserido, TRY_CONVERT(TINYINT, @LOCOCOR), @CODESTAB, 
                   (SELECT TOP 1 cod_municipio FROM municipio WHERE cod_municipio LIKE @CODMUNOCOR + '%'));

                -- Inserir em circunstancia_obito
                INSERT INTO circunstancia_obito(id_obito, id_circobito, id_acidtrab, id_fonte, id_tpobitocor)
                VALUES (@id_obito_inserido, TRY_CONVERT(TINYINT, @CIRCOBITO), TRY_CONVERT(TINYINT, @ACIDTRAB), TRY_CONVERT(TINYINT, @FONTE), (SELECT CASE WHEN TRY_CONVERT(TINYINT, @TPOBITOCOR) IN (1,2,3,4,5,9) THEN @TPOBITOCOR ELSE 9 END));

                -- Inserir em escolaridade_falecido
                INSERT INTO escolaridade_falecido (id_esc2010, id_esc, id_escfalagr1, seriescfal)
                VALUES (TRY_CONVERT(TINYINT, @ESC2010), TRY_CONVERT(TINYINT, @ESC), TRY_CONVERT(TINYINT, @ESCFALAGR1), TRY_CONVERT(TINYINT, @SERIESCFAL));
                SET @id_escol_falecido_inserido = SCOPE_IDENTITY();

                -- Inserir em idade
                INSERT INTO idade (id_idade_unidade, quantidade)
                VALUES (TRY_CONVERT(TINYINT, SUBSTRING(@IDADE, 1, 1)), TRY_CONVERT(INT, SUBSTRING(@IDADE, 2, 2)));
                SET @id_idade_inserido = SCOPE_IDENTITY();

                -- Inserir em pessoa_falecida
                INSERT INTO pessoa_falecida(id_obito, codmunnatu, codmunres, id_escol, id_racacor, id_estciv, id_sexo, id_idade, dtnasc, ocup)
                VALUES (
                    @id_obito_inserido, 
                    (SELECT TOP 1 cod_municipio FROM municipio WHERE cod_municipio LIKE @CODMUNNATU + '%'),
                    (SELECT TOP 1 cod_municipio FROM municipio WHERE cod_municipio LIKE @CODMUNRES + '%'),
                    @id_escol_falecido_inserido, 
                    TRY_CONVERT(TINYINT, @RACACOR), 
                    TRY_CONVERT(TINYINT, @ESTCIV), 
                    TRY_CONVERT(TINYINT, @SEXO), 
                    @id_idade_inserido, 
                    TRY_CONVERT(DATE, SUBSTRING(@DTNASC, 5, 4) + SUBSTRING(@DTNASC, 3, 2) + SUBSTRING(@DTNASC, 1, 2)), 
                    @OCUP
                );

                -- Inserir em escolaridade_mae e capturar o ID
                INSERT INTO escolaridade_mae (id_escmae2010, id_escmae, id_escmaeagr1, seriescmae)
                VALUES (
                    -- ** LÓGICA DE CORREÇÃO PARA O CHECK CONSTRAINT **
                    CASE
                        -- Se a escolaridade é Fundamental/Médio mas a série é nula, salva a escolaridade como 9 (Ignorado)
                        WHEN TRY_CONVERT(TINYINT, @ESCMAE2010) IN (1, 2, 3) AND TRY_CONVERT(TINYINT, @SERIESCMAE) IS NULL THEN 9
                        -- Senão, usa o valor que veio do arquivo ou 9 se for inválido
                        ELSE ISNULL(TRY_CONVERT(TINYINT, @ESCMAE2010), 9)
                    END,
                    ISNULL(TRY_CONVERT(TINYINT, @ESCMAE), 9),
                    ISNULL(TRY_CONVERT(TINYINT, @ESCMAEAGR1), 9),
                    TRY_CONVERT(TINYINT, @SERIESCMAE)
                );
                SET @id_escol_mae_inserida = SCOPE_IDENTITY();

                -- Inserir em mae
                INSERT INTO mae(id_obito, id_gestacao, id_gravidez, id_parto, id_obitoparto, id_tpmorteoco, id_obitograv, id_obitopuerp, id_morteparto, id_escol_mae, idademae, ocupmae, qtdfilvivo, qtdfilmorto, semagestac, peso, causamat)
                VALUES (@id_obito_inserido, (SELECT CASE WHEN TRY_CONVERT(TINYINT, @GESTACAO) IN (1,2,3,4,5,6,9) THEN @GESTACAO ELSE 9 END), TRY_CONVERT(TINYINT, @GRAVIDEZ), TRY_CONVERT(TINYINT, @PARTO), TRY_CONVERT(TINYINT, @OBITOPARTO), TRY_CONVERT(TINYINT, @TPMORTEOCO), TRY_CONVERT(TINYINT, @OBITOGRAV), TRY_CONVERT(TINYINT, @OBITOPUERP), TRY_CONVERT(TINYINT, @MORTEPARTO), @id_escol_mae_inserida, TRY_CONVERT(TINYINT, @IDADEMAE), @OCUPMAE, TRY_CONVERT(TINYINT, @QTDFILVIVO), TRY_CONVERT(TINYINT, @QTDFILMORT), TRY_CONVERT(TINYINT, @SEMAGESTAC), TRY_CONVERT(SMALLINT, @PESO), @CAUSAMAT);

                -- Inserir em atestado
                INSERT INTO atestado(id_obito, id_necropsia, id_exame, id_cirurgia, id_atestante, id_assistmed, dtatestado, atestado, comunsvoim)
                VALUES (@id_obito_inserido, TRY_CONVERT(TINYINT, @NECROPSIA), TRY_CONVERT(TINYINT, @EXAME), TRY_CONVERT(TINYINT, @CIRURGIA), TRY_CONVERT(TINYINT, @ATESTANTE), TRY_CONVERT(TINYINT, @ASSISTMED), TRY_CONVERT(DATE, SUBSTRING(@DTATESTADO, 5, 4) + SUBSTRING(@DTATESTADO, 3, 2) + SUBSTRING(@DTATESTADO, 1, 2)), @ATESTADO, @COMUNSVOIM);

                -- Inserir em cid_causa (desmembrando as linhas de causas da morte)
                IF LTRIM(RTRIM(ISNULL(@LINHAA,''))) <> '' INSERT INTO cid_causa(id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt) VALUES (@id_obito_inserido, 1, @LINHAA, @CAUSABAS, @CAUSABAS_O, @CB_ALT);
                IF LTRIM(RTRIM(ISNULL(@LINHAB,''))) <> '' INSERT INTO cid_causa(id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt) VALUES (@id_obito_inserido, 2, @LINHAB, @CAUSABAS, @CAUSABAS_O, @CB_ALT);
                IF LTRIM(RTRIM(ISNULL(@LINHAC,''))) <> '' INSERT INTO cid_causa(id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt) VALUES (@id_obito_inserido, 3, @LINHAC, @CAUSABAS, @CAUSABAS_O, @CB_ALT);
                IF LTRIM(RTRIM(ISNULL(@LINHAD,''))) <> '' INSERT INTO cid_causa(id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt) VALUES (@id_obito_inserido, 4, @LINHAD, @CAUSABAS, @CAUSABAS_O, @CB_ALT);
                IF LTRIM(RTRIM(ISNULL(@LINHAII,''))) <> '' INSERT INTO cid_causa(id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt) VALUES (@id_obito_inserido, 5, @LINHAII, @CAUSABAS, @CAUSABAS_O, @CB_ALT);

                -- Inserir em info_sistema
                INSERT INTO info_sistema(id_obito, id_fonteinv, id_tpresginfo, id_tpnivelinv, id_altcausa, id_stdoepidem, id_stdonova, id_tppos, id_origem, id_tp_altera, numerolote, dtinvestig, dtcadastro, stcodifica, codificado, versaosist, versaoscb, dtrecebim, dtrecoriga, opor_do, difdata, nudiasobco, dtcadinv, dtconinv, fontentrev, fonteambul, fontepront, fontesvo, fonteiml, fonteprof, dtcadinf, dtconcaso)
                VALUES (@id_obito_inserido, TRY_CONVERT(TINYINT, @FONTEINV), TRY_CONVERT(TINYINT, @TPRESGINFO), @TPNIVELINV, TRY_CONVERT(TINYINT, @ALTCAUSA), TRY_CONVERT(TINYINT, @STDOEPIDEM), TRY_CONVERT(TINYINT, @STDONOVA), @TPPOS, TRY_CONVERT(TINYINT, @ORIGEM), TRY_CONVERT(TINYINT, @TP_ALTERA), @NUMEROLOTE, TRY_CONVERT(DATE, SUBSTRING(@DTINVESTIG, 5, 4) + SUBSTRING(@DTINVESTIG, 3, 2) + SUBSTRING(@DTINVESTIG, 1, 2)), TRY_CONVERT(DATE, SUBSTRING(@DTCADASTRO, 5, 4) + SUBSTRING(@DTCADASTRO, 3, 2) + SUBSTRING(@DTCADASTRO, 1, 2)), @STCODIFICA, @CODIFICADO, @VERSAOSIST, @VERSAOSCB, TRY_CONVERT(DATE, SUBSTRING(@DTRECEBIM, 5, 4) + SUBSTRING(@DTRECEBIM, 3, 2) + SUBSTRING(@DTRECEBIM, 1, 2)), TRY_CONVERT(DATE, SUBSTRING(@DTRECORIGA, 5, 4) + SUBSTRING(@DTRECORIGA, 3, 2) + SUBSTRING(@DTRECORIGA, 1, 2)), TRY_CONVERT(INT, @OPOR_DO), TRY_CONVERT(INT, @DIFDATA), TRY_CONVERT(INT, @NUDIASOBCO), TRY_CONVERT(DATE, SUBSTRING(@DTCADINV, 5, 4) + SUBSTRING(@DTCADINV, 3, 2) + SUBSTRING(@DTCADINV, 1, 2)), TRY_CONVERT(DATE, SUBSTRING(@DTCONINV, 5, 4) + SUBSTRING(@DTCONINV, 3, 2) + SUBSTRING(@DTCONINV, 1, 2)), SUBSTRING(@FONTES, 1, 1), SUBSTRING(@FONTES, 2, 1), SUBSTRING(@FONTES, 3, 1), SUBSTRING(@FONTES, 4, 1), SUBSTRING(@FONTES, 5, 1), SUBSTRING(@FONTES, 6, 1), TRY_CONVERT(DATE, SUBSTRING(@DTCADINF, 5, 4) + SUBSTRING(@DTCADINF, 3, 2) + SUBSTRING(@DTCADINF, 1, 2)), TRY_CONVERT(DATE, SUBSTRING(@DTCONCASO, 5, 4) + SUBSTRING(@DTCONCASO, 3, 2) + SUBSTRING(@DTCONCASO, 1, 2)));
                
                COMMIT TRANSACTION;
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                PRINT 'ERRO ao processar a linha ' + ISNULL(@contador, 'N/A') + '. Mensagem: ' + ERROR_MESSAGE();
            END CATCH
        END
        ELSE
        BEGIN
             PRINT 'AVISO: Linha ' + ISNULL(@contador, 'N/A') + ' ignorada por conter dados essenciais inválidos.';
        END

        -- Pega a próxima linha para o loop
        FETCH NEXT FROM cursor_obitos INTO @contador, @ORIGEM, @TIPOBITO, @DTOBITO, @HORAOBITO, @NATURAL, @CODMUNNATU, @DTNASC, @IDADE, @SEXO, @RACACOR, @ESTCIV,
            @ESC, @ESC2010, @SERIESCFAL, @OCUP, @CODMUNRES, @LOCOCOR, @CODESTAB, @CODMUNOCOR, @IDADEMAE, @ESCMAE, @ESCMAE2010, @SERIESCMAE, @OCUPMAE,
            @QTDFILVIVO, @QTDFILMORT, @GRAVIDEZ, @SEMAGESTAC, @GESTACAO, @PARTO, @OBITOPARTO, @PESO, @TPMORTEOCO, @OBITOGRAV, @OBITOPUERP, @ASSISTMED,
            @EXAME, @CIRURGIA, @NECROPSIA, @LINHAA, @LINHAB, @LINHAC, @LINHAD, @LINHAII, @CAUSABAS, @CB_PRE, @COMUNSVOIM, @DTATESTADO, @CIRCOBITO, @ACIDTRAB,
            @FONTE, @NUMEROLOTE, @DTINVESTIG, @DTCADASTRO, @ATESTANTE, @STCODIFICA, @CODIFICADO, @VERSAOSIST, @VERSAOSCB, @FONTEINV, @DTRECEBIM, @ATESTADO,
            @DTRECORIGA, @OPOR_DO, @CAUSAMAT, @ESCMAEAGR1, @ESCFALAGR1, @STDOEPIDEM, @STDONOVA, @DIFDATA, @NUDIASOBCO, @DTCADINV, @TPOBITOCOR, @DTCONINV,
            @FONTES, @TPRESGINFO, @TPNIVELINV, @DTCADINF, @MORTEPARTO, @DTCONCASO, @ALTCAUSA, @CAUSABAS_O, @TPPOS, @TP_ALTERA, @CB_ALT;
    END;

    -- 5. FECHAMENTO E LIMPEZA DO CURSOR
    CLOSE cursor_obitos;
    DEALLOCATE cursor_obitos;

    PRINT 'Processo de Transformação e Carga concluído.';
    SET NOCOUNT OFF;
END
GO

