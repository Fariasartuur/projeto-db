
/*
================================================================================
SCRIPT DE CRIAÇÃO DAS STORED PROCEDURES PARA O PLANO DE ANÁLISE
================================================================================
Este script cria as 13 Stored Procedures (SPs) necessárias para responder
às perguntas de negócio definidas no plano de análise do projeto.

Cada SP encapsula uma consulta específica e pode ser executada de forma
independente.

REQUISITO: Semana 8 do documento "Projeto de Banco de Dados.pdf".
*/

USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGRÁFICO E SOCIAL DOS ÓBITOS
--------------------------------------------------------------------------------

-- Pergunta 1.1: Qual é a distribuição de óbitos por faixa etária, sexo e raça/cor?

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
        END AS [Faixa Etária],
        sexo AS [Sexo], 
        raca_cor AS [Cor],
        COUNT(id_obito) AS [Total Óbitos]
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
    ORDER BY [Faixa Etária], [Total Óbitos] DESC;
END;
GO

-- Pergunta 1.2: Qual a correlação entre o nível de escolaridade do falecido e a idade ao morrer?

CREATE OR ALTER PROCEDURE sp_1_2_correlacao_escolaridade_idade_morrer
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        descricao AS [Escolaridade],
        COUNT(id_obito) AS [Total Óbitos],
        AVG(CAST(quantidade AS FLOAT)) AS [Média de Idade ao Morrer]
    FROM vw_1_2_correlacao_escolaridade_idade_morrer
    WHERE id_idade_unidade = 4
    GROUP BY descricao
    ORDER BY descricao;
END;
GO

-- Pergunta 1.3: Quais são as 3 principais causas de morte por estado civil?

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
        estado_civil AS [Estado Civíl],
        causabas AS [Causa],
        descricao_causa [Descrição],
        total_obitos [Total Óbitos]
    FROM CausasPorEstadoCivil
    WHERE ranking <= 3
    ORDER BY estado_civil, ranking;
END;
GO

-- Pergunta 1.4: Quais são as ocupações (CBO) mais frequentes entre os óbitos por acidentes de trabalho?

CREATE OR ALTER PROCEDURE sp_1_4_ocupacoes_obitos_acidente_trabalho
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        cbo_ocupacao AS [Código],
        descricao_ocupacao AS [Ocupação],
        COUNT(id_obito) AS [Acidentes]
    FROM vw_1_4_ocupacoes_obitos_acidente_trabalho
    WHERE id_acidtrab = 1 AND cbo_ocupacao IS NOT NULL
    GROUP BY cbo_ocupacao, descricao_ocupacao
    ORDER BY [Acidentes] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 2: ANÁLISE GEOGRÁFICA E DE LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------

-- Pergunta 2.1: Qual o ranking de municípios com os maiores totais de mortalidade por causas violentas?

CREATE OR ALTER PROCEDURE sp_2_1_ranking_municipios_causas_violentas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        ISNULL(nome_municipio, 'Município de Ocorrência Faltando') AS [Município],
        ISNULL(nome_uf, 'UF') as [Estado],
        COUNT(id_obito) AS [Total Óbitos]
    FROM vw_2_1_ranking_municipios_causas_violentas
    WHERE id_circobito IN (1, 2, 3)
    GROUP BY nome_municipio, nome_uf
    ORDER BY [Total Óbitos] DESC;
END;
GO

-- Pergunta 2.2: Qual a porcentagem de óbitos que ocorrem fora de um estabelecimento de saúde por município de residência?

CREATE OR ALTER PROCEDURE sp_2_2_percentual_obitos_fora_estab_saude
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        nome_municipio AS [Município],
        nome_uf AS [Estado],
        COUNT(id_obito) AS [Total de Óbitos],
        SUM(CASE WHEN id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) AS [Óbitos fora do estabelecimento de saúde],
        (SUM(CASE WHEN id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) * 100.0) / COUNT(id_obito) AS [Percentual]
    FROM vw_2_2_percentual_obitos_fora_estab_saude
    GROUP BY nome_municipio, nome_uf
    HAVING COUNT(id_obito) > 50
    ORDER BY [Percentual] DESC;
END;
GO

-- Pergunta 2.3: Existe uma diferença entre o município de residência e o município de ocorrência do óbito?

CREATE OR ALTER PROCEDURE sp_2_3_fluxo_obitos_residencia_ocorrencia
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        municipio_residencia [Município Residência],
        nome_uf_residencia [Estado Residência],
        municipio_ocorrencia [Município Ocorrência],
        nome_uf_ocorrencia [Estado Ocorrência],
        COUNT(id_obito) AS [Obitos em Trânsito]
    FROM vw_2_3_fluxo_obitos_residencia_ocorrencia
    WHERE codmunres <> codmunocor
    GROUP BY municipio_residencia, nome_uf_residencia, municipio_ocorrencia, nome_uf_ocorrencia
    ORDER BY [Obitos em Trânsito] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 3: ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- Pergunta 3.1: Quais são as 10 principais causas de morte para homens e mulheres em diferentes faixas etárias?

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
        faixa_etaria AS [Faixa Etária],
        sexo AS [Sexo],
        causabas AS [Causa],
        descricao_causa AS [Descrição],
        total_obitos AS [Total Óbitos],
        ranking AS [Ranking]
    FROM ranking_causas
    WHERE ranking <= 10
    ORDER BY faixa_etaria, sexo, ranking;
END;
GO

-- Pergunta 3.2: Como a falta de assistência médica se relaciona com a causa do óbito?

CREATE OR ALTER PROCEDURE sp_3_2_relacao_assistencia_medica_causa_morte
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        causabas AS [Causa],
        descricao AS [Descrição],
        COUNT(id_obito) AS [Total Óbitos],
        SUM(CASE WHEN id_assistmed = 2 THEN 1 ELSE 0 END) AS [Óbitos sem assistência],
        (SUM(CASE WHEN id_assistmed = 2 THEN 1 ELSE 0 END) * 100.0) / COUNT(id_obito) AS [Percentual sem assistência]
    FROM vw_3_2_relacao_assistencia_medica_causa_morte
    WHERE causabas IS NOT NULL AND id_assistmed IN (1, 2)
    GROUP BY causabas, descricao
    HAVING COUNT(id_obito) > 100
    ORDER BY [Percentual sem assistência] DESC;
END;
GO

-- Pergunta 3.3: Óbitos por causas violentas estão mais associados a qual fonte de informação?

CREATE OR ALTER PROCEDURE sp_3_3_fonte_informacao_causas_violentas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        circunstancia_obito AS [Circunstância],
        fonte_informacao AS [Fonte],
        COUNT(id_obito) AS [Total Óbitos]
    FROM vw_3_3_fonte_informacao_causas_violentas
    WHERE circunstancia_obito <> 'Ignorado'
    GROUP BY circunstancia_obito, fonte_informacao
    ORDER BY [Circunstância], [Total Óbitos] DESC;
END;
GO

--------------------------------------------------------------------------------
-- EIXO 4: ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- Pergunta 4.1: Qual é a distribuição da idade materna entre os casos de óbitos no primeiro ano de vida?
CREATE OR ALTER PROCEDURE sp_4_1_idade_mae_obito_infantil
AS BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE
            WHEN idade_mae < 20 THEN 'Menor de 20'
            WHEN idade_mae BETWEEN 20 AND 29 THEN '20 a 29'
            WHEN idade_mae BETWEEN 30 AND 39 THEN '30 a 39'
            WHEN idade_mae >= 40 THEN '40 ou mais'
            ELSE 'Ignorado'
        END AS faixa_etaria_mae,
    COUNT(id_obito_pessoa) AS total_obitos
    FROM vw_4_1_idade_mae_obito_infantil
    GROUP BY 
        CASE 
            WHEN idade_mae < 20 THEN 'Menor de 20'
            WHEN idade_mae BETWEEN 20 AND 29 THEN '20 a 29'
            WHEN idade_mae BETWEEN 30 AND 39 THEN '30 a 39'
            WHEN idade_mae >= 40 THEN '40 ou mais'
            ELSE 'Ignorado'
        END
    ORDER BY faixa_etaria_mae;
END
GO

-- Pergunta 4.2: Onde esses óbitos ocorrem com maior frequência (hospital, domicílio, via pública)?
CREATE OR ALTER PROCEDURE sp_4_2_obito_infantil_local_ocorrencia
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE lococor
            WHEN '1' THEN 'Hospital'
            WHEN '2' THEN 'Outro Estabelecimento de Saúde'
            WHEN '3' THEN 'Domicílio'
            WHEN '4' THEN 'Via Pública'
            WHEN '5' THEN 'Outros'
            WHEN '6' THEN 'Aldeia Indígena'
            WHEN '7' THEN 'Estabelecimento não identificado'
            ELSE 'Ignorado'
        END AS local_do_obito,
        COUNT(*) AS Total_Obitos
    FROM vw_4_2_obito_infantil_local_ocorrencia
    GROUP BY lococor
    ORDER BY Total_Obitos DESC;
END
GO

-- Pergunta 4.3: Qual é a distribuição do peso ao nascer para óbitos não fetais no primeiro ano de vida?

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
            ELSE 'Peso ignorado ou não aplicável'
        END AS [Faixa de Peso],
        COUNT(id_obito) AS [Total Óbitos]
    FROM vw_4_3_distribuicao_peso_obitos_primeiro_ano
    WHERE id_tipobito = 2 AND id_idade_unidade IN (1, 2, 3) AND peso IS NOT NULL
    GROUP BY
        CASE
            WHEN peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
            WHEN peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
            WHEN peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
            WHEN peso >= 2500 THEN '04- Peso adequado (>=2500g)'
            ELSE 'Peso ignorado ou não aplicável'
        END
    ORDER BY [Faixa de Peso];
END;
GO

-- Pergunta 4.4: Como a idade gestacional se relaciona com a ocorrência de óbito infantil?

CREATE OR ALTER PROCEDURE sp_4_4_idade_gestacional_obito_infantil
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        CASE 
        WHEN semana_gestacao < 28 THEN '01 - Extrema prematuridade (<28 semanas)'
        WHEN semana_gestacao BETWEEN 28 AND 31 THEN '02 - Muito prematuro (28-31 semanas)'
        WHEN semana_gestacao BETWEEN 32 AND 36 THEN '03 - Prematuro tardio (32-36 semanas)'
        WHEN semana_gestacao BETWEEN 37 AND 41 THEN '04 - Termo (37-41 semanas)'
        WHEN semana_gestacao >= 42 THEN '05 - Pós-termo (>=42 semanas)'
        ELSE 'Ignorado'
    END AS Faixa_Gestacional,
    COUNT(*) AS Total_Obitos
    FROM vw_4_4_idade_gestacional_obito_infantil
    GROUP BY 
    CASE 
        WHEN semana_gestacao < 28 THEN '01 - Extrema prematuridade (<28 semanas)'
        WHEN semana_gestacao BETWEEN 28 AND 31 THEN '02 - Muito prematuro (28-31 semanas)'
        WHEN semana_gestacao BETWEEN 32 AND 36 THEN '03 - Prematuro tardio (32-36 semanas)'
        WHEN semana_gestacao BETWEEN 37 AND 41 THEN '04 - Termo (37-41 semanas)'
        WHEN semana_gestacao >= 42 THEN '05 - Pós-termo (>=42 semanas)'
        ELSE 'Ignorado'
    END
ORDER BY 1;
END
GO

PRINT '13 Stored Procedures do plano de análise foram criadas/atualizadas com sucesso.';
GO
