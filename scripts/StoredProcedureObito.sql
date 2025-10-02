USE mortalidade;
GO

CREATE OR ALTER PROCEDURE sp_Extract_Obitos_from_CSV
    @CaminhoArquivoCSV NVARCHAR(MAX)
AS
BEGIN

    IF OBJECT_ID('tempdb..##stg_dados_brutos') IS NOT NULL
        DROP TABLE ##stg_dados_brutos;

    CREATE TABLE ##stg_dados_brutos (
        contador VARCHAR(MAX),
        ORIGEM VARCHAR(MAX),
        TIPOBITO VARCHAR(MAX),
        DTOBITO VARCHAR(MAX),
        HORAOBITO VARCHAR(MAX),
        NATURAL VARCHAR(MAX),
        CODMUNNATU VARCHAR(MAX),
        DTNASC VARCHAR(MAX),
        IDADE VARCHAR(MAX),
        SEXO VARCHAR(MAX),
        RACACOR VARCHAR(MAX),
        ESTCIV VARCHAR(MAX),
        ESC VARCHAR(MAX),
        ESC2010 VARCHAR(MAX),
        SERIESCFAL VARCHAR(MAX),
        OCUP VARCHAR(MAX),
        CODMUNRES VARCHAR(MAX),
        LOCOCOR VARCHAR(MAX),
        CODESTAB VARCHAR(MAX),
        CODMUNOCOR VARCHAR(MAX),
        IDADEMAE VARCHAR(MAX),
        ESCMAE VARCHAR(MAX),
        ESCMAE2010 VARCHAR(MAX),
        SERIESCMAE VARCHAR(MAX),
        OCUPMAE VARCHAR(MAX),
        QTDFILVIVO VARCHAR(MAX),
        QTDFILMORT VARCHAR(MAX),
        GRAVIDEZ VARCHAR(MAX),
        SEMAGESTAC VARCHAR(MAX),
        GESTACAO VARCHAR(MAX),
        PARTO VARCHAR(MAX),
        OBITOPARTO VARCHAR(MAX),
        PESO VARCHAR(MAX),
        TPMORTEOCO VARCHAR(MAX),
        OBITOGRAV VARCHAR(MAX),
        OBITOPUERP VARCHAR(MAX),
        ASSISTMED VARCHAR(MAX),
        EXAME VARCHAR(MAX),
        CIRURGIA VARCHAR(MAX),
        NECROPSIA VARCHAR(MAX),
        LINHAA VARCHAR(MAX),
        LINHAB VARCHAR(MAX),
        LINHAC VARCHAR(MAX),
        LINHAD VARCHAR(MAX),
        LINHAII VARCHAR(MAX),
        CAUSABAS VARCHAR(MAX),
        CB_PRE VARCHAR(MAX),
        COMUNSVOIM VARCHAR(MAX),
        DTATESTADO VARCHAR(MAX),
        CIRCOBITO VARCHAR(MAX),
        ACIDTRAB VARCHAR(MAX),
        FONTE VARCHAR(MAX),
        NUMEROLOTE VARCHAR(MAX),
        DTINVESTIG VARCHAR(MAX),
        DTCADASTRO VARCHAR(MAX),
        ATESTANTE VARCHAR(MAX),
        STCODIFICA VARCHAR(MAX),
        CODIFICADO VARCHAR(MAX),
        VERSAOSIST VARCHAR(MAX),
        VERSAOSCB VARCHAR(MAX),
        FONTEINV VARCHAR(MAX),
        DTRECEBIM VARCHAR(MAX),
        ATESTADO VARCHAR(MAX),
        DTRECORIGA VARCHAR(MAX),
        OPOR_DO VARCHAR(MAX),
        CAUSAMAT VARCHAR(MAX),
        ESCMAEAGR1 VARCHAR(MAX),
        ESCFALAGR1 VARCHAR(MAX),
        STDOEPIDEM VARCHAR(MAX),
        STDONOVA VARCHAR(MAX),
        DIFDATA VARCHAR(MAX),
        NUDIASOBCO VARCHAR(MAX),
        DTCADINV VARCHAR(MAX),
        TPOBITOCOR VARCHAR(MAX),
        DTCONINV VARCHAR(MAX),
        FONTES VARCHAR(MAX),
        TPRESGINFO VARCHAR(MAX),
        TPNIVELINV VARCHAR(MAX),
        DTCADINF VARCHAR(MAX),
        MORTEPARTO VARCHAR(MAX),
        DTCONCASO VARCHAR(MAX),
        ALTCAUSA VARCHAR(MAX),
        CAUSABAS_O VARCHAR(MAX),
        TPPOS VARCHAR(MAX),
        TP_ALTERA VARCHAR(MAX),
        CB_ALT VARCHAR(MAX)
);
    
    DECLARE @Sql NVARCHAR(MAX);
    SET @Sql = N'
    BULK INSERT ##stg_dados_brutos 
    FROM ''' + @CaminhoArquivoCSV + N'''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
        CODEPAGE = ''1252''
    );';

    EXEC sp_executesql @sql;
   
END
GO

CREATE OR ALTER PROCEDURE sp_Transform_Obitos
AS
BEGIN
    UPDATE ##stg_dados_brutos
    SET
        contador = REPLACE(contador, '"', ''),
        ORIGEM = REPLACE(ORIGEM, '"', ''),
        TIPOBITO = REPLACE(TIPOBITO, '"', ''),
        DTOBITO = REPLACE(DTOBITO, '"', ''),
        HORAOBITO = REPLACE(HORAOBITO, '"', ''),
        NATURAL = REPLACE(NATURAL, '"', ''),
        CODMUNNATU = REPLACE(CODMUNNATU, '"', ''),
        DTNASC = REPLACE(DTNASC, '"', ''),
        IDADE = REPLACE(IDADE, '"', ''),
        SEXO = REPLACE(SEXO, '"', ''),
        RACACOR = REPLACE(RACACOR, '"', ''),
        ESTCIV = REPLACE(ESTCIV, '"', ''),
        ESC = REPLACE(ESC, '"', ''),
        ESC2010 = REPLACE(ESC2010, '"', ''),
        SERIESCFAL = REPLACE(SERIESCFAL, '"', ''),
        OCUP = REPLACE(OCUP, '"', ''),
        CODMUNRES = REPLACE(CODMUNRES, '"', ''),
        LOCOCOR = REPLACE(LOCOCOR, '"', ''),
        CODESTAB = REPLACE(CODESTAB, '"', ''),
        CODMUNOCOR = REPLACE(CODMUNOCOR, '"', ''),
        IDADEMAE = REPLACE(IDADEMAE, '"', ''),
        ESCMAE = REPLACE(ESCMAE, '"', ''),
        ESCMAE2010 = REPLACE(ESCMAE2010, '"', ''),
        SERIESCMAE = REPLACE(SERIESCMAE, '"', ''),
        OCUPMAE = REPLACE(OCUPMAE, '"', ''),
        QTDFILVIVO = REPLACE(QTDFILVIVO, '"', ''),
        QTDFILMORT = REPLACE(QTDFILMORT, '"', ''),
        GRAVIDEZ = REPLACE(GRAVIDEZ, '"', ''),
        SEMAGESTAC = REPLACE(SEMAGESTAC, '"', ''),
        GESTACAO = REPLACE(GESTACAO, '"', ''),
        PARTO = REPLACE(PARTO, '"', ''),
        OBITOPARTO = REPLACE(OBITOPARTO, '"', ''),
        PESO = REPLACE(PESO, '"', ''),
        TPMORTEOCO = REPLACE(TPMORTEOCO, '"', ''),
        OBITOGRAV = REPLACE(OBITOGRAV, '"', ''),
        OBITOPUERP = REPLACE(OBITOPUERP, '"', ''),
        ASSISTMED = REPLACE(ASSISTMED, '"', ''),
        EXAME = REPLACE(EXAME, '"', ''),
        CIRURGIA = REPLACE(CIRURGIA, '"', ''),
        NECROPSIA = REPLACE(NECROPSIA, '"', ''),
        LINHAA = REPLACE(LINHAA, '"', ''),
        LINHAB = REPLACE(LINHAB, '"', ''),
        LINHAC = REPLACE(LINHAC, '"', ''),
        LINHAD = REPLACE(LINHAD, '"', ''),
        LINHAII = REPLACE(LINHAII, '"', ''),
        CAUSABAS = REPLACE(CAUSABAS, '"', ''),
        CB_PRE = REPLACE(CB_PRE, '"', ''),
        COMUNSVOIM = REPLACE(COMUNSVOIM, '"', ''),
        DTATESTADO = REPLACE(DTATESTADO, '"', ''),
        CIRCOBITO = REPLACE(CIRCOBITO, '"', ''),
        ACIDTRAB = REPLACE(ACIDTRAB, '"', ''),
        FONTE = REPLACE(FONTE, '"', ''),
        NUMEROLOTE = REPLACE(NUMEROLOTE, '"', ''),
        DTINVESTIG = REPLACE(DTINVESTIG, '"', ''),
        DTCADASTRO = REPLACE(DTCADASTRO, '"', ''),
        ATESTANTE = REPLACE(ATESTANTE, '"', ''),
        STCODIFICA = REPLACE(STCODIFICA, '"', ''),
        CODIFICADO = REPLACE(CODIFICADO, '"', ''),
        VERSAOSIST = REPLACE(VERSAOSIST, '"', ''),
        VERSAOSCB = REPLACE(VERSAOSCB, '"', ''),
        FONTEINV = REPLACE(FONTEINV, '"', ''),
        DTRECEBIM = REPLACE(DTRECEBIM, '"', ''),
        ATESTADO = REPLACE(ATESTADO, '"', ''),
        DTRECORIGA = REPLACE(DTRECORIGA, '"', ''),
        OPOR_DO = REPLACE(OPOR_DO, '"', ''),
        CAUSAMAT = REPLACE(CAUSAMAT, '"', ''),
        ESCMAEAGR1 = REPLACE(ESCMAEAGR1, '"', ''),
        ESCFALAGR1 = REPLACE(ESCFALAGR1, '"', ''),
        STDOEPIDEM = REPLACE(STDOEPIDEM, '"', ''),
        STDONOVA = REPLACE(STDONOVA, '"', ''),
        DIFDATA = REPLACE(DIFDATA, '"', ''),
        NUDIASOBCO = REPLACE(NUDIASOBCO, '"', ''),
        DTCADINV = REPLACE(DTCADINV, '"', ''),
        TPOBITOCOR = REPLACE(TPOBITOCOR, '"', ''),
        DTCONINV = REPLACE(DTCONINV, '"', ''),
        FONTES = REPLACE(FONTES, '"', ''),
        TPRESGINFO = REPLACE(TPRESGINFO, '"', ''),
        TPNIVELINV = REPLACE(TPNIVELINV, '"', ''),
        DTCADINF = REPLACE(DTCADINF, '"', ''),
        MORTEPARTO = REPLACE(MORTEPARTO, '"', ''),
        DTCONCASO = REPLACE(DTCONCASO, '"', ''),
        ALTCAUSA = REPLACE(ALTCAUSA, '"', ''),
        CAUSABAS_O = REPLACE(CAUSABAS_O, '"', ''),
        TPPOS = REPLACE(TPPOS, '"', ''),
        TP_ALTERA = REPLACE(TP_ALTERA, '"', ''),
        CB_ALT = REPLACE(CB_ALT, '"', '');

ALTER TABLE ##stg_dados_brutos
DROP COLUMN contador, CB_PRE

IF OBJECT_ID('tempdb..##stg_obitos_trans_conv') IS NOT NULL
        DROP TABLE ##stg_obitos_trans_conv;

CREATE TABLE ##stg_obitos_trans_conv (
    stg_id INT IDENTITY PRIMARY KEY,
    ORIGEM TINYINT,
    TIPOBITO TINYINT,
    DTOBITO DATE,
    HORAOBITO TIME,
    NATURAL VARCHAR(4),
    CODMUNNATU CHAR(7),
    DTNASC DATE,
    IDADE VARCHAR(3),
    SEXO TINYINT,
    RACACOR TINYINT,
    ESTCIV TINYINT,
    ESC TINYINT,
    ESC2010 TINYINT,
    SERIESCFAL TINYINT,
    OCUP CHAR(6),
    CODMUNRES CHAR(7),
    LOCOCOR TINYINT,
    CODESTAB CHAR(8),
    CODMUNOCOR CHAR(7),
    IDADEMAE TINYINT,
    ESCMAE TINYINT,
    ESCMAE2010 TINYINT,
    SERIESCMAE TINYINT,
    OCUPMAE CHAR(6),
    QTDFILVIVO TINYINT,
    QTDFILMORT TINYINT,
    GRAVIDEZ TINYINT,
    SEMAGESTAC TINYINT,
    GESTACAO TINYINT,
    PARTO TINYINT,
    OBITOPARTO TINYINT,
    PESO SMALLINT,
    TPMORTEOCO TINYINT,
    OBITOGRAV TINYINT,
    OBITOPUERP TINYINT,
    ASSISTMED TINYINT,
    EXAME TINYINT,
    CIRURGIA TINYINT,
    NECROPSIA TINYINT,
    LINHAA VARCHAR(45),
    LINHAB VARCHAR(45),
    LINHAC VARCHAR(45),
    LINHAD VARCHAR(45),
    LINHAII VARCHAR(45),
    CAUSABAS CHAR(4),
    COMUNSVOIM CHAR(7),
    DTATESTADO DATE,
    CIRCOBITO TINYINT,
    ACIDTRAB TINYINT,
    FONTE TINYINT,
    NUMEROLOTE VARCHAR(8),
    DTINVESTIG DATE,
    DTCADASTRO DATE,
    ATESTANTE TINYINT,
    STCODIFICA CHAR(1),
    CODIFICADO CHAR(1),
    VERSAOSIST CHAR(7),
    VERSAOSCB CHAR(7),
    FONTEINV TINYINT,
    DTRECEBIM DATE,
    ATESTADO VARCHAR(70),
    DTRECORIGA DATE,
    OPOR_DO INT,
    CAUSAMAT VARCHAR(4),
    ESCMAEAGR1 TINYINT,
    ESCFALAGR1 TINYINT,
    STDOEPIDEM TINYINT,
    STDONOVA TINYINT,
    DIFDATA INT,
    NUDIASOBCO INT,
    DTCADINV DATE,
    TPOBITOCOR TINYINT,
    DTCONINV DATE,
    FONTES VARCHAR(10),
    TPRESGINFO TINYINT,
    TPNIVELINV CHAR(1),
    DTCADINF DATE,
    MORTEPARTO TINYINT,
    DTCONCASO DATE,
    ALTCAUSA TINYINT,
    CAUSABAS_O CHAR(4),
    TPPOS CHAR(1),
    TP_ALTERA TINYINT,
    CB_ALT VARCHAR(10)
);

INSERT INTO ##stg_obitos_trans_conv
SELECT
    TRY_CAST(NULLIF(ORIGEM, '') AS TINYINT),
    TRY_CAST(NULLIF(TIPOBITO, '') AS TINYINT),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTOBITO, ''), 5, 4) + SUBSTRING(NULLIF(DTOBITO, ''), 3, 2) + SUBSTRING(NULLIF(DTOBITO, ''), 1, 2)),
    TRY_CAST(STUFF(NULLIF(HORAOBITO, ''), 3, 0, ':') AS TIME),
    CAST(NULLIF(NATURAL, '') AS VARCHAR(4)),
    CAST(NULLIF(CODMUNNATU, '') AS CHAR(7)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTNASC, ''), 5, 4) + SUBSTRING(NULLIF(DTNASC, ''), 3, 2) + SUBSTRING(NULLIF(DTNASC, ''), 1, 2)),
    CAST(NULLIF(IDADE, '') AS VARCHAR(3)),
    TRY_CAST(NULLIF(SEXO, '') AS TINYINT),
    TRY_CAST(NULLIF(RACACOR, '') AS TINYINT),
    TRY_CAST(NULLIF(ESTCIV, '') AS TINYINT),
    TRY_CAST(NULLIF(ESC, '') AS TINYINT),
    TRY_CAST(NULLIF(ESC2010, '') AS TINYINT),
    TRY_CAST(NULLIF(SERIESCFAL, '') AS TINYINT),
    CAST(NULLIF(OCUP, '') AS CHAR(6)),
    CAST(NULLIF(CODMUNRES, '') AS CHAR(7)),
    TRY_CAST(NULLIF(LOCOCOR, '') AS TINYINT),
    CAST(NULLIF(CODESTAB, '') AS CHAR(8)),
    CAST(NULLIF(CODMUNOCOR, '') AS CHAR(7)),
    TRY_CAST(NULLIF(IDADEMAE, '') AS TINYINT),
    TRY_CAST(NULLIF(ESCMAE, '') AS TINYINT),
    TRY_CAST(NULLIF(ESCMAE2010, '') AS TINYINT),
    TRY_CAST(NULLIF(SERIESCMAE, '') AS TINYINT),
    CAST(NULLIF(OCUPMAE, '') AS CHAR(6)),
    TRY_CAST(NULLIF(QTDFILVIVO, '') AS TINYINT),
    TRY_CAST(NULLIF(QTDFILMORT, '') AS TINYINT),
    TRY_CAST(NULLIF(GRAVIDEZ, '') AS TINYINT),
    TRY_CAST(NULLIF(SEMAGESTAC, '') AS TINYINT),
    TRY_CAST(NULLIF(GESTACAO, '') AS TINYINT),
    TRY_CAST(NULLIF(PARTO, '') AS TINYINT),
    TRY_CAST(NULLIF(OBITOPARTO, '') AS TINYINT),
    TRY_CAST(NULLIF(PESO, '') AS SMALLINT),
    TRY_CAST(NULLIF(TPMORTEOCO, '') AS TINYINT),
    TRY_CAST(NULLIF(OBITOGRAV, '') AS TINYINT),
    TRY_CAST(NULLIF(OBITOPUERP, '') AS TINYINT),
    TRY_CAST(NULLIF(ASSISTMED, '') AS TINYINT),
    TRY_CAST(NULLIF(EXAME, '') AS TINYINT),
    TRY_CAST(NULLIF(CIRURGIA, '') AS TINYINT),
    TRY_CAST(NULLIF(NECROPSIA, '') AS TINYINT),
    CAST(NULLIF(LINHAA, '') AS VARCHAR(45)),
    CAST(NULLIF(LINHAB, '') AS VARCHAR(45)),
    CAST(NULLIF(LINHAC, '') AS VARCHAR(45)),
    CAST(NULLIF(LINHAD, '') AS VARCHAR(45)),
    CAST(NULLIF(LINHAII, '') AS VARCHAR(45)),
    CAST(NULLIF(CAUSABAS, '') AS CHAR(4)),
    CAST(NULLIF(COMUNSVOIM, '') AS CHAR(7)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTATESTADO, ''), 5, 4) + SUBSTRING(NULLIF(DTATESTADO, ''), 3, 2) + SUBSTRING(NULLIF(DTATESTADO, ''), 1, 2)),
    TRY_CAST(NULLIF(CIRCOBITO, '') AS TINYINT),
    TRY_CAST(NULLIF(ACIDTRAB, '') AS TINYINT),
    TRY_CAST(NULLIF(FONTE, '') AS TINYINT),
    CAST(NULLIF(NUMEROLOTE, '') AS VARCHAR(8)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTINVESTIG, ''), 5, 4) + SUBSTRING(NULLIF(DTINVESTIG, ''), 3, 2) + SUBSTRING(NULLIF(DTINVESTIG, ''), 1, 2)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTCADASTRO, ''), 5, 4) + SUBSTRING(NULLIF(DTCADASTRO, ''), 3, 2) + SUBSTRING(NULLIF(DTCADASTRO, ''), 1, 2)),
    TRY_CAST(NULLIF(ATESTANTE, '') AS TINYINT),
    CAST(NULLIF(STCODIFICA, '') AS CHAR(1)),
    CAST(NULLIF(CODIFICADO, '') AS CHAR(1)),
    CAST(NULLIF(VERSAOSIST, '') AS CHAR(7)),
    CAST(NULLIF(VERSAOSCB, '') AS CHAR(7)),
    TRY_CAST(NULLIF(FONTEINV, '') AS TINYINT),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTRECEBIM, ''), 5, 4) + SUBSTRING(NULLIF(DTRECEBIM, ''), 3, 2) + SUBSTRING(NULLIF(DTRECEBIM, ''), 1, 2)),
    CAST(NULLIF(ATESTADO, '') AS VARCHAR(70)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTRECORIGA, ''), 5, 4) + SUBSTRING(NULLIF(DTRECORIGA, ''), 3, 2) + SUBSTRING(NULLIF(DTRECORIGA, ''), 1, 2)),
    TRY_CAST(NULLIF(OPOR_DO, '') AS INT),
    CAST(NULLIF(CAUSAMAT, '') AS VARCHAR(4)),
    TRY_CAST(NULLIF(ESCMAEAGR1, '') AS TINYINT),
    TRY_CAST(NULLIF(ESCFALAGR1, '') AS TINYINT),
    TRY_CAST(NULLIF(STDOEPIDEM, '') AS TINYINT),
    TRY_CAST(NULLIF(STDONOVA, '') AS TINYINT),
    TRY_CAST(NULLIF(DIFDATA, '') AS INT),
    TRY_CAST(NULLIF(NUDIASOBCO, '') AS INT),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTCADINV, ''), 5, 4) + SUBSTRING(NULLIF(DTCADINV, ''), 3, 2) + SUBSTRING(NULLIF(DTCADINV, ''), 1, 2)),
    TRY_CAST(NULLIF(TPOBITOCOR, '') AS TINYINT),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTCONINV, ''), 5, 4) + SUBSTRING(NULLIF(DTCONINV, ''), 3, 2) + SUBSTRING(NULLIF(DTCONINV, ''), 1, 2)),
    CAST(NULLIF(FONTES, '') AS VARCHAR(10)),
    TRY_CAST(NULLIF(TPRESGINFO, '') AS TINYINT),
    CAST(NULLIF(TPNIVELINV, '') AS CHAR(1)),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTCADINF, ''), 5, 4) + SUBSTRING(NULLIF(DTCADINF, ''), 3, 2) + SUBSTRING(NULLIF(DTCADINF, ''), 1, 2)),
    TRY_CAST(NULLIF(MORTEPARTO, '') AS TINYINT),
    TRY_CONVERT(DATE, SUBSTRING(NULLIF(DTCONCASO, ''), 5, 4) + SUBSTRING(NULLIF(DTCONCASO, ''), 3, 2) + SUBSTRING(NULLIF(DTCONCASO, ''), 1, 2)),
    TRY_CAST(NULLIF(ALTCAUSA, '') AS TINYINT),
    CAST(NULLIF(CAUSABAS_O, '') AS CHAR(4)),
    CAST(NULLIF(TPPOS, '') AS CHAR(1)),
    TRY_CAST(NULLIF(TP_ALTERA, '') AS TINYINT),
    CAST(NULLIF(CB_ALT, '') AS VARCHAR(10))
FROM ##stg_dados_brutos;

DROP TABLE ##stg_dados_brutos
END
GO

CREATE OR ALTER PROCEDURE sp_load_obitos
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @ObitoMap TABLE (
            id_obito INT PRIMARY KEY,
            stg_id INT NOT NULL UNIQUE
        );

        INSERT INTO escolaridade_falecido (id_esc, id_esc2010, seriescfal, id_escfalagr1)
        SELECT DISTINCT
            stg.ESC, stg.ESC2010, stg.SERIESCFAL, stg.ESCFALAGR1
        FROM ##stg_obitos_trans_conv AS stg
        WHERE 
            (stg.ESC IS NOT NULL OR stg.ESC2010 IS NOT NULL OR stg.ESCFALAGR1 IS NOT NULL)
            AND NOT EXISTS (
                SELECT 1 FROM escolaridade_falecido ef
                WHERE ef.id_esc = stg.ESC 
                  AND ef.id_esc2010 = stg.ESC2010 
                  AND ef.seriescfal = stg.SERIESCFAL 
                  AND ef.id_escfalagr1 = stg.ESCFALAGR1
            );

        INSERT INTO escolaridade_mae (id_escmae, id_escmae2010, seriescmae, id_escmaeagr1)
        SELECT DISTINCT 
            stg.ESCMAE, 
            stg.ESCMAE2010, 
            stg.SERIESCMAE, 
            stg.ESCMAEAGR1
        FROM ##stg_obitos_trans_conv AS stg
        WHERE 
            NOT (stg.ESCMAE2010 IN (1, 2, 3) AND stg.SERIESCMAE IS NULL)
            AND (stg.ESCMAE IS NOT NULL OR stg.ESCMAE2010 IS NOT NULL OR stg.ESCMAEAGR1 IS NOT NULL)
            AND NOT EXISTS (SELECT 1 FROM escolaridade_mae em WHERE em.id_escmae = stg.ESCMAE 
                                AND em.id_escmae2010 = stg.ESCMAE2010 
                                AND em.seriescmae = stg.SERIESCMAE 
                                AND em.id_escmaeagr1 = stg.ESCMAEAGR1);



        INSERT INTO idade (id_idade_unidade, quantidade)
        SELECT DISTINCT
            TRY_CAST(SUBSTRING(stg.IDADE, 1, 1) AS TINYINT),
            TRY_CAST(SUBSTRING(stg.IDADE, 2, 2) AS INT)
        FROM ##stg_obitos_trans_conv AS stg
        WHERE 
            stg.IDADE IS NOT NULL AND LEN(stg.IDADE) = 3
            AND NOT EXISTS (
                SELECT 1 FROM idade i
                WHERE i.id_idade_unidade = TRY_CAST(SUBSTRING(stg.IDADE, 1, 1) AS TINYINT)
                  AND i.quantidade = TRY_CAST(SUBSTRING(stg.IDADE, 2, 2) AS INT)
            );

        MERGE INTO obito AS Target
        USING ##stg_obitos_trans_conv AS Source
        ON 1 = 0
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (id_tipobito, dtobito, horaobito)
            VALUES (Source.TIPOBITO, Source.DTOBITO, Source.HORAOBITO)
        OUTPUT
            INSERTED.id_obito,
            Source.stg_id
        INTO @ObitoMap (id_obito, stg_id);

        INSERT INTO pessoa_falecida (id_obito, codmunnatu, codmunres, id_escol, id_racacor, id_estciv, id_sexo, id_idade, dtnasc, ocup, natural)
        SELECT
            map.id_obito, 
            mun_natu.cod_municipio,
            mun_res.cod_municipio, 
            ef.id_escol, 
            stg.RACACOR, 
            stg.ESTCIV, 
            stg.SEXO, 
            i.id_idade, 
            stg.DTNASC, 
            cbo.codigo, 
            stg.NATURAL
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        LEFT JOIN dbo.cbo2002 AS cbo ON stg.OCUP = cbo.codigo
        LEFT JOIN escolaridade_falecido ef ON stg.ESC = ef.id_esc AND stg.ESC2010 = ef.id_esc2010 AND stg.SERIESCFAL = ef.seriescfal AND stg.ESCFALAGR1 = ef.id_escfalagr1
        LEFT JOIN idade i ON i.id_idade_unidade = TRY_CAST(SUBSTRING(stg.IDADE, 1, 1) AS TINYINT) AND i.quantidade = TRY_CAST(SUBSTRING(stg.IDADE, 2, 2) AS INT)
        OUTER APPLY (SELECT TOP 1 m.cod_municipio FROM municipio m WHERE LEFT(m.cod_municipio, 6) = stg.CODMUNNATU) AS mun_natu
        OUTER APPLY (SELECT TOP 1 m.cod_municipio FROM municipio m WHERE LEFT(m.cod_municipio, 6) = stg.CODMUNRES) AS mun_res;   
    
        INSERT INTO local_ocorrencia (id_obito, id_lococor, codestab, codmunocor)
        SELECT 
            map.id_obito, 
            stg.LOCOCOR, 
            stg.CODESTAB,
            -- Lógica para tratar os códigos ignorados
            CASE 
                WHEN stg.CODMUNOCOR = '150000' THEN '1501402' -- Belém, PA
                WHEN stg.CODMUNOCOR = '220000' THEN '2211001' -- Teresina, PI
                WHEN stg.CODMUNOCOR = '110000' THEN '1100205' -- Porto Velho, RO
                WHEN stg.CODMUNOCOR = '410000' THEN '4106902' -- Curitiba, PR
                WHEN stg.CODMUNOCOR = '290000' THEN '2927408' -- Salvador, BA
                -- Se não for um dos códigos ignorados, usa a busca normal
                ELSE mun_ocor.cod_municipio
            END AS codmunocor_final
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        OUTER APPLY (SELECT TOP 1 m.cod_municipio FROM municipio m WHERE LEFT(m.cod_municipio, 6) = stg.CODMUNOCOR) AS mun_ocor;

        INSERT INTO mae (id_obito, id_gestacao, id_gravidez, id_parto, id_obitoparto, id_tpmorteoco, id_obitograv, id_obitopuerp, id_morteparto, id_escol_mae, idademae, ocupmae, qtdfilvivo, qtdfilmorto, semagestac, peso, causamat)
        SELECT
            map.id_obito, 
            stg.GESTACAO, 
            stg.GRAVIDEZ, 
            stg.PARTO, 
            stg.OBITOPARTO, 
            stg.TPMORTEOCO, 
            stg.OBITOGRAV, 
            stg.OBITOPUERP, 
            stg.MORTEPARTO, 
            em.id_escol_mae, 
            stg.IDADEMAE, 
            cbo_mae.codigo,
            stg.QTDFILVIVO, stg.QTDFILMORT, stg.SEMAGESTAC, stg.PESO, stg.CAUSAMAT
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        LEFT JOIN dbo.cbo2002 AS cbo_mae ON stg.OCUPMAE = cbo_mae.codigo
        LEFT JOIN escolaridade_mae em ON stg.ESCMAE = em.id_escmae AND stg.ESCMAE2010 = em.id_escmae2010 AND stg.SERIESCMAE = em.seriescmae AND stg.ESCMAEAGR1 = em.id_escmaeagr1;
    
    
        INSERT INTO circunstancia_obito (id_obito, id_circobito, id_acidtrab, id_fonte, id_tpobitocor)
        SELECT 
            map.id_obito, 
            circ.id_circobito,
            acid.id_acidtrab, 
            f.id_fonte, 
            tpo.id_tpobitocor
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        LEFT JOIN circobito circ ON circ.id_circobito = stg.CIRCOBITO
        LEFT JOIN acidtrab acid ON acid.id_acidtrab = stg.ACIDTRAB
        LEFT JOIN fonte f ON f.id_fonte = stg.FONTE
        LEFT JOIN tpobitocor tpo ON tpo.id_tpobitocor = stg.TPOBITOCOR;
    
        INSERT INTO atestado (id_obito, id_necropsia, id_exame, id_cirurgia, id_atestante, id_assistmed, dtatestado, atestado, comunsvoim)
        SELECT 
            map.id_obito, 
            stg.NECROPSIA, 
            stg.EXAME, 
            stg.CIRURGIA, 
            stg.ATESTANTE, 
            stg.ASSISTMED, 
            stg.DTATESTADO, 
            stg.ATESTADO, 
            CASE
                WHEN stg.ATESTANTE IN (3, 4) AND (stg.COMUNSVOIM IS NULL OR LTRIM(RTRIM(stg.COMUNSVOIM)) = '')
                THEN 'N/A'
                ELSE stg.COMUNSVOIM
            END AS comunsvoim
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id;
    
        INSERT INTO info_sistema(id_obito, id_fonteinv, id_tpresginfo, id_tpnivelinv, id_altcausa, id_stdoepidem, id_stdonova, id_tppos, id_origem, id_tp_altera, numerolote, dtinvestig, dtcadastro, stcodifica, codificado, versaosist, versaoscb, dtrecebim, dtrecoriga, opor_do, difdata, nudiasobco, dtcadinv, dtconinv, fontentrev, fonteambul, fontepront, fontesvo, fonteiml, fonteprof, dtcadinf, dtconcaso)
        SELECT 
            map.id_obito,
            fi.id_fonteinv,
            tpi.id_tpresginfo, 
            tpn.id_tpnivelinv, 
            alt.id_altcausa,
            epi.id_stdoepidem, 
            nova.id_stdonova, 
            pos.id_tppos, 
            org.id_origem, 
            tpa.id_tp_altera,
            stg.NUMEROLOTE,
            stg.DTINVESTIG, 
            stg.DTCADASTRO, 
            stg.STCODIFICA, 
            stg.CODIFICADO,
            stg.VERSAOSIST, 
            stg.VERSAOSCB, 
            stg.DTRECEBIM,
            stg.DTRECORIGA,
            stg.OPOR_DO,
            stg.DIFDATA, 
            stg.NUDIASOBCO, 
            stg.DTCADINV, 
            stg.DTCONINV, 
            SUBSTRING(stg.FONTES, 1, 1), SUBSTRING(stg.FONTES, 2, 1), SUBSTRING(stg.FONTES, 3, 1), 
            SUBSTRING(stg.FONTES, 4, 1), SUBSTRING(stg.FONTES, 5, 1), SUBSTRING(stg.FONTES, 6, 1), 
            stg.DTCADINF, 
            stg.DTCONCASO
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        LEFT JOIN fonteinv fi ON fi.id_fonteinv = stg.FONTEINV
        LEFT JOIN tpresginfo tpi ON tpi.id_tpresginfo = stg.TPRESGINFO
        LEFT JOIN tpnivelinv tpn ON tpn.id_tpnivelinv = stg.TPNIVELINV
        LEFT JOIN altcausa alt ON alt.id_altcausa = stg.ALTCAUSA
        LEFT JOIN stdoepidem epi ON epi.id_stdoepidem = stg.STDOEPIDEM
        LEFT JOIN stdonova nova ON nova.id_stdonova = stg.STDONOVA
        LEFT JOIN tppos pos ON pos.id_tppos = stg.TPPOS
        LEFT JOIN origem org ON org.id_origem = stg.ORIGEM
        LEFT JOIN tp_altera tpa ON tpa.id_tp_altera = stg.TP_ALTERA;

        INSERT INTO cid_causa (id_obito, id_tipo_linha, cid_cod, causabas, causabas_original, cb_alt)
        SELECT
            map.id_obito,
            unpvt.id_tipo_linha,
            unpvt.cid_cod,
            cid.subcat,        
            cid_o.subcat, 
            stg.CB_ALT
        FROM ##stg_obitos_trans_conv AS stg
        JOIN @ObitoMap AS map ON stg.stg_id = map.stg_id
        LEFT JOIN dbo.cid10_subcategorias AS cid ON stg.CAUSABAS = cid.subcat
        LEFT JOIN dbo.cid10_subcategorias AS cid_o ON stg.CAUSABAS_O = cid_o.subcat
        CROSS APPLY (
            VALUES
                (1, stg.LINHAA), (2, stg.LINHAB), (3, stg.LINHAC),
                (4, stg.LINHAD), (5, stg.LINHAII)
        ) AS unpvt(id_tipo_linha, cid_cod)
        WHERE unpvt.cid_cod IS NOT NULL;

        COMMIT TRANSACTION;
        PRINT 'Carga de óbitos concluída com sucesso. Todas as alterações foram salvas.';

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Ocorreu um erro durante a carga. Todas as alterações foram desfeitas.';
        THROW;
    END CATCH;


END
GO

CREATE OR ALTER PROCEDURE sp_ETL_obitos
    @caminhoArquivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        EXEC sp_Extract_Obitos_from_CSV @CaminhoArquivoCSV = @caminhoArquivo;
        EXEC sp_Transform_Obitos;
        EXEC sp_load_obitos;

        -- O Drop da tabela só acontece se TUDO deu certo
        DROP TABLE ##stg_obitos_trans_conv;

        PRINT 'Processo de ETL concluído com SUCESSO.';

    END TRY
    BEGIN CATCH
        PRINT '============================================================';
        PRINT 'ERRO CRÍTICO NO PROCESSO DE ETL. A OPERAÇÃO FOI INTERROMPIDA.';
        PRINT 'As tabelas temporárias ##stg... podem ainda existir para análise.';
        PRINT '============================================================';
        
        -- Re-lança o erro original para sabermos o que aconteceu
        THROW;
    END CATCH
END;
GO


