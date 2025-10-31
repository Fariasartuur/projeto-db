
/*
================================================================================
SCRIPT DE CRIA��O DAS STORED PROCEDURES PARA O PLANO DE AN�LISE
================================================================================
Este script cria as 13 Stored Procedures (SPs) necess�rias para responder
�s perguntas de neg�cio definidas no plano de an�lise do projeto.

Cada SP encapsula uma consulta espec�fica e pode ser executada de forma
independente.

REQUISITO: Semana 8 do documento "Projeto de Banco de Dados.pdf".
*/

USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGR�FICO E SOCIAL DOS �BITOS
--------------------------------------------------------------------------------

-- Pergunta 1.1: Qual � a distribui��o de �bitos por faixa et�ria, sexo e ra�a/cor?

CREATE OR ALTER PROCEDURE sp_1_1_distribuicao_obitos_perfil_demografico
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        CASE 
            WHEN id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 1 AND 4 THEN '01- 1 a 4 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 5 AND 9 THEN '02- 5 a 9 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 10 AND 14 THEN '03- 10 a 14 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 15 AND 19 THEN '04- 15 a 19 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 20 AND 29 THEN '05- 20 a 29 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 30 AND 39 THEN '06- 30 a 39 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 40 AND 49 THEN '07- 40 a 49 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 50 AND 59 THEN '08- 50 a 59 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 60 AND 69 THEN '09- 60 a 69 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 70 AND 79 THEN '10- 70 a 79 anos'
            WHEN id_idade_unidade = 4 AND quantidade >= 80 THEN '11- 80 anos e mais'
            ELSE 'Idade Ignorada'
        END AS [Faixa Et�ria],
        sexo AS [Sexo], 
        raca_cor AS [Cor],
        COUNT(id_obito) AS [Total �bitos]
    FROM vw_1_1_distribuicao_obitos_perfil_demografico
    GROUP BY 
        CASE 
            WHEN id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 1 AND 4 THEN '01- 1 a 4 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 5 AND 9 THEN '02- 5 a 9 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 10 AND 14 THEN '03- 10 a 14 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 15 AND 19 THEN '04- 15 a 19 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 20 AND 29 THEN '05- 20 a 29 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 30 AND 39 THEN '06- 30 a 39 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 40 AND 49 THEN '07- 40 a 49 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 50 AND 59 THEN '08- 50 a 59 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 60 AND 69 THEN '09- 60 a 69 anos'
            WHEN id_idade_unidade = 4 AND quantidade BETWEEN 70 AND 79 THEN '10- 70 a 79 anos'
            WHEN id_idade_unidade = 4 AND quantidade >= 80 THEN '11- 80 anos e mais'
            ELSE 'Idade Ignorada'
        END, sexo, raca_cor
    ORDER BY [Faixa Et�ria], [Total �bitos] DESC;
END;
GO

-- Pergunta 1.2: Qual a correla��o entre o n�vel de escolaridade do falecido e a idade ao morrer?

CREATE OR ALTER PROCEDURE sp_1_2_correlacao_escolaridade_idade_morrer
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        descricao AS [Escolaridade],
        COUNT(id_obito) AS [Total �bitos],
        AVG(CAST(quantidade AS FLOAT)) AS [M�dia de Idade ao Morrer]
    FROM vw_1_2_correlacao_escolaridade_idade_morrer
    WHERE id_idade_unidade = 4
    GROUP BY descricao
    ORDER BY descricao;
END;
GO

-- Pergunta 1.3: Quais s�o as 3 principais causas de morte por estado civil?

CREATE OR ALTER PROCEDURE sp_1_3_top3_causas_morte_estado_civil
AS
BEGIN
    SET NOCOUNT ON;
    WITH CausasPorEstadoCivil AS ( 
        SELECT
            estado_civil,
            causabas,
            descricao_causa,
            COUNT(id_obito) as total_obitos,
            ROW_NUMBER() OVER(PARTITION BY estado_civil ORDER BY COUNT(id_obito) DESC) as ranking
        FROM vw_1_3_top3_causas_morte_estado_civil
        WHERE causabas IS NOT NULL AND estado_civil <> 'Ignorado'
        GROUP BY estado_civil, causabas, descricao_causa
    )
    SELECT 
        estado_civil AS [Estado Civ�l],
        causabas AS [Causa],
        descricao_causa [Descri��o],
        total_obitos [Total �bitos]
    FROM CausasPorEstadoCivil
    WHERE ranking <= 3
    ORDER BY estado_civil, ranking;
END;
GO

-- Pergunta 1.4: Quais s�o as ocupa��es (CBO) mais frequentes entre os �bitos por acidentes de trabalho?

CREATE OR ALTER PROCEDURE sp_1_4_ocupacoes_obitos_acidente_trabalho
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        cbo_ocupacao AS [C�digo],
        descricao_ocupacao AS [Ocupa��o],
        COUNT(id_obito) AS [Acidentes]
    FROM vw_1_4_ocupacoes_obitos_acidente_trabalho
    WHERE id_acidtrab = 1 AND cbo_ocupacao IS NOT NULL
    GROUP BY cbo_ocupacao, descricao_ocupacao
    ORDER BY [Acidentes] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 2: AN�LISE GEOGR�FICA E DE LOCAL DE OCORR�NCIA
--------------------------------------------------------------------------------

-- Pergunta 2.1: Qual o ranking de munic�pios com os maiores totais de mortalidade por causas violentas?

CREATE OR ALTER PROCEDURE sp_2_1_ranking_municipios_causas_violentas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        ISNULL(nome_municipio, 'Munic�pio de Ocorr�ncia Faltando') AS [Munic�pio],
        ISNULL(nome_uf, 'UF') as [Estado],
        COUNT(id_obito) AS [Total �bitos]
    FROM vw_2_1_ranking_municipios_causas_violentas
    WHERE id_circobito IN (1, 2, 3)
    GROUP BY nome_municipio, nome_uf
    ORDER BY [Total �bitos] DESC;
END;
GO

-- Pergunta 2.2: Qual a porcentagem de �bitos que ocorrem fora de um estabelecimento de sa�de por munic�pio de resid�ncia?

CREATE OR ALTER PROCEDURE sp_2_2_percentual_obitos_fora_estab_saude
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        nome_municipio AS [Munic�pio],
        nome_uf AS [Estado],
        COUNT(id_obito) AS [Total de �bitos],
        SUM(CASE WHEN id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) AS [�bitos fora do estabelecimento de sa�de],
        (SUM(CASE WHEN id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) * 100.0) / COUNT(id_obito) AS [Percentual]
    FROM vw_2_2_percentual_obitos_fora_estab_saude
    GROUP BY nome_municipio, nome_uf
    HAVING COUNT(id_obito) > 50
    ORDER BY [Percentual] DESC;
END;
GO

-- Pergunta 2.3: Existe uma diferen�a entre o munic�pio de resid�ncia e o munic�pio de ocorr�ncia do �bito?

CREATE OR ALTER PROCEDURE sp_2_3_fluxo_obitos_residencia_ocorrencia
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        municipio_residencia [Munic�pio Resid�ncia],
        nome_uf_residencia [Estado Resid�ncia],
        municipio_ocorrencia [Munic�pio Ocorr�ncia],
        nome_uf_ocorrencia [Estado Ocorr�ncia],
        COUNT(id_obito) AS [Obitos em Tr�nsito]
    FROM vw_2_3_fluxo_obitos_residencia_ocorrencia
    WHERE codmunres <> codmunocor
    GROUP BY municipio_residencia, nome_uf_residencia, municipio_ocorrencia, nome_uf_ocorrencia
    ORDER BY [Obitos em Tr�nsito] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 3: AN�LISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- Pergunta 3.1: Quais s�o as 10 principais causas de morte para homens e mulheres em diferentes faixas et�rias?

CREATE OR ALTER PROCEDURE sp_3_1_top10_causas_morte_faixa_etaria_sexo
AS
BEGIN
    SET NOCOUNT ON;
    WITH ranking_causas AS (
        SELECT
            CASE 
                WHEN id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
                WHEN id_idade_unidade = 4 AND quantidade >= 60 THEN '04- 60 anos e mais'
                ELSE 'Idade Ignorada'
            END AS faixa_etaria,
            sexo,
            causabas,
            descricao_causa AS descricao_causa,
            COUNT(id_obito) AS total_obitos,
            ROW_NUMBER() OVER(PARTITION BY 
                CASE 
                    WHEN id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
                    WHEN id_idade_unidade = 4 AND quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
                    WHEN id_idade_unidade = 4 AND quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
                    WHEN id_idade_unidade = 4 AND quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
                    WHEN id_idade_unidade = 4 AND quantidade >= 60 THEN '04- 60 anos e mais'
                    ELSE 'Idade Ignorada'
                END, sexo ORDER BY COUNT(id_obito) DESC) AS ranking
        FROM vw_3_1_top10_causas_morte_faixa_etaria_sexo
        WHERE causabas IS NOT NULL AND sexo <> 'Ignorado'
        GROUP BY
            CASE 
                WHEN id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
                WHEN id_idade_unidade = 4 AND quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
                WHEN id_idade_unidade = 4 AND quantidade >= 60 THEN '04- 60 anos e mais'
                ELSE 'Idade Ignorada'
            END,
            sexo,
            causabas,
            descricao_causa
    )
    SELECT
        faixa_etaria AS [Faixa Et�ria],
        sexo AS [Sexo],
        causabas AS [Causa],
        descricao_causa AS [Descri��o],
        total_obitos AS [Total �bitos],
        ranking AS [Ranking]
    FROM ranking_causas
    WHERE ranking <= 10
    ORDER BY faixa_etaria, sexo, ranking;
END;
GO

-- Pergunta 3.2: Como a falta de assist�ncia m�dica se relaciona com a causa do �bito?

CREATE OR ALTER PROCEDURE sp_3_2_relacao_assistencia_medica_causa_morte
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        causabas AS [Causa],
        descricao AS [Descri��o],
        COUNT(id_obito) AS [Total �bitos],
        SUM(CASE WHEN id_assistmed = 2 THEN 1 ELSE 0 END) AS [�bitos sem assist�ncia],
        (SUM(CASE WHEN id_assistmed = 2 THEN 1 ELSE 0 END) * 100.0) / COUNT(id_obito) AS [Percentual sem assist�ncia]
    FROM vw_3_2_relacao_assistencia_medica_causa_morte
    WHERE causabas IS NOT NULL AND id_assistmed IN (1, 2)
    GROUP BY causabas, descricao
    HAVING COUNT(id_obito) > 100
    ORDER BY [Percentual sem assist�ncia] DESC;
END;
GO

-- Pergunta 3.3: �bitos por causas violentas est�o mais associados a qual fonte de informa��o?

CREATE OR ALTER PROCEDURE sp_3_3_fonte_informacao_causas_violentas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        circunstancia_obito AS [Circunst�ncia],
        fonte_informacao AS [Fonte],
        COUNT(id_obito) AS [Total �bitos]
    FROM vw_3_3_fonte_informacao_causas_violentas
    WHERE circunstancia_obito <> 'Ignorado'
    GROUP BY circunstancia_obito, fonte_informacao
    ORDER BY [Circunst�ncia], [Total �bitos] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 4: AN�LISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- Pergunta 4.1: Qual a rela��o entre a escolaridade da m�e e a ocorr�ncia de �bito fetal?

CREATE OR ALTER PROCEDURE sp_4_1_relacao_escolaridade_mae_obito_fetal
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        escolaridade_mae AS [Escolaridade da M�e],
        tipo_obito AS [Tipo �bito],
        COUNT(id_obito_pessoa) AS [Total �bitos]
    FROM vw_4_1_relacao_escolaridade_mae_obito_fetal
    WHERE id_obito_mae IS NOT NULL AND escolaridade_mae IS NOT NULL AND escolaridade_mae <> 'Ignorado'
    GROUP BY escolaridade_mae, tipo_obito
    ORDER BY escolaridade_mae, tipo_obito;
END;
GO

-- Pergunta 4.2: O tipo de parto tem correla��o com o momento do �bito em rela��o ao parto?

CREATE OR ALTER PROCEDURE sp_4_2_correlacao_parto_momento_obito
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        tipo_parto AS [Tipo Parto],
        momento_obito_parto AS [Momento �bito],
        COUNT(id_obito) AS [Total �bitos]
    FROM vw_4_2_correlacao_parto_momento_obito
    WHERE tipo_parto <> 'ignorado' AND momento_obito_parto <> 'ignorado'
    GROUP BY tipo_parto, momento_obito_parto
    ORDER BY [Tipo Parto], [Momento �bito];
END;
GO

-- Pergunta 4.3: Qual � a distribui��o do peso ao nascer para �bitos n�o fetais no primeiro ano de vida?

CREATE OR ALTER PROCEDURE sp_4_3_distribuicao_peso_obitos_primeiro_ano
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE
            WHEN peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
            WHEN peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
            WHEN peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
            WHEN peso >= 2500 THEN '04- Peso adequado (>=2500g)'
            ELSE 'Peso ignorado ou n�o aplic�vel'
        END AS [Faixa de Peso],
        COUNT(id_obito) AS [Total �bitos]
    FROM vw_4_3_distribuicao_peso_obitos_primeiro_ano
    WHERE id_tipobito = 2 AND id_idade_unidade IN (1, 2, 3) AND peso IS NOT NULL
    GROUP BY
        CASE
            WHEN peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
            WHEN peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
            WHEN peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
            WHEN peso >= 2500 THEN '04- Peso adequado (>=2500g)'
            ELSE 'Peso ignorado ou n�o aplic�vel'
        END
    ORDER BY [Faixa de Peso];
END;
GO


-- Pergunta 4.4: Qual � o perfil de m�es cujos �bitos ocorreram durante a gravidez ou puerp�rio?


CREATE OR ALTER PROCEDURE sp_4_4_perfil_maes_obitos_maternos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        COALESCE(id_escmae2010, '99') AS [ID Escolaridade],
        COALESCE(descricao, 'Escolaridade Ignorada') AS [Escolaridade Predominante],
        AVG(idademae) AS [M�dia Idade M�e],
        AVG(qtdfilvivo) AS [M�dia Filhos Vivos],
        AVG(qtdfilmorto) AS [M�dia Filhos Mortos],
        COUNT(id_obito) AS [Total �bitos Maternos]
    FROM vw_4_4_perfil_maes_obitos_maternos
    WHERE id_tpmorteoco IN (1, 2, 3, 4, 5)
    GROUP BY
        id_escmae2010,
        descricao;
END;
GO


PRINT '13 Stored Procedures do plano de an�lise foram criadas/atualizadas com sucesso.';
GO
