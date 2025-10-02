USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: VIEWS DE PERFIL DEMOGRÁFICO E SOCIAL
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 1.1: Distribuição de óbitos por faixa etária, sexo e raça/cor.
CREATE OR ALTER VIEW vw_1_1_distribuicao_obitos_perfil_demografico AS
SELECT 
    CASE 
        WHEN idad.id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 1 AND 4 THEN '01- 1 a 4 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 5 AND 9 THEN '02- 5 a 9 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 10 AND 14 THEN '03- 10 a 14 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 15 AND 19 THEN '04- 15 a 19 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 20 AND 29 THEN '05- 20 a 29 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 30 AND 39 THEN '06- 30 a 39 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 40 AND 49 THEN '07- 40 a 49 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 50 AND 59 THEN '08- 50 a 59 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 60 AND 69 THEN '09- 60 a 69 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 70 AND 79 THEN '10- 70 a 79 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade >= 80 THEN '11- 80 anos e mais'
        ELSE 'Idade Ignorada'
    END AS faixa_etaria,
    s.descricao AS sexo, 
    rc.descricao AS raca_cor,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
LEFT JOIN sexo s ON pf.id_sexo = s.id_sexo
LEFT JOIN raca_cor rc ON pf.id_racacor = rc.id_racacor
LEFT JOIN idade idad ON pf.id_idade = idad.id_idade
GROUP BY 
    CASE 
        WHEN idad.id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 1 AND 4 THEN '01- 1 a 4 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 5 AND 9 THEN '02- 5 a 9 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 10 AND 14 THEN '03- 10 a 14 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 15 AND 19 THEN '04- 15 a 19 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 20 AND 29 THEN '05- 20 a 29 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 30 AND 39 THEN '06- 30 a 39 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 40 AND 49 THEN '07- 40 a 49 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 50 AND 59 THEN '08- 50 a 59 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 60 AND 69 THEN '09- 60 a 69 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 70 AND 79 THEN '10- 70 a 79 anos'
        WHEN idad.id_idade_unidade = 4 AND idad.quantidade >= 80 THEN '11- 80 anos e mais'
        ELSE 'Idade Ignorada'
    END, s.descricao, rc.descricao;
GO

-- VIEW para a Pergunta 1.2: Correlação entre escolaridade e idade ao morrer.
CREATE OR ALTER VIEW vw_1_2_correlacao_escolaridade_idade_morrer AS
SELECT 
    e.descricao AS escolaridade,
    COUNT(o.id_obito) AS total_obitos,
    AVG(CAST(idad.quantidade AS FLOAT)) AS media_idade_ao_morrer
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN idade idad ON pf.id_idade = idad.id_idade
JOIN escolaridade_falecido ef ON pf.id_escol = ef.id_escol
JOIN esc2010 e ON ef.id_esc2010 = e.id_esc2010
WHERE idad.id_idade_unidade = 4
GROUP BY e.descricao;
GO

-- VIEW para a Pergunta 1.3: Top 3 causas de morte por estado civil.
CREATE OR ALTER VIEW vw_1_3_top3_causas_morte_estado_civil AS
WITH CausasPorEstadoCivil AS (
    SELECT
        ec.descricao AS estado_civil,
        cc.causabas,
        cid.descricao AS descricao_causa,
        COUNT(o.id_obito) as total_obitos,
        ROW_NUMBER() OVER(PARTITION BY ec.descricao ORDER BY COUNT(o.id_obito) DESC) as ranking
    FROM obito o
    JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
    JOIN estado_civil ec ON pf.id_estciv = ec.id_estciv
    JOIN cid_causa cc ON o.id_obito = cc.id_obito
    LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat
    WHERE cc.causabas IS NOT NULL AND ec.descricao <> 'Ignorado'
    GROUP BY ec.descricao, cc.causabas, cid.descricao
)
SELECT 
    estado_civil,
    causabas,
    descricao_causa,
    total_obitos,
    ranking 
FROM CausasPorEstadoCivil
WHERE ranking <= 3;
GO

-- VIEW para a Pergunta 1.4: Ocupações mais frequentes em óbitos por acidentes de trabalho.
CREATE OR ALTER VIEW vw_1_4_ocupacoes_obitos_acidente_trabalho AS
SELECT
    pf.ocup AS cbo_ocupacao,
    cbo.titulo AS descricao_ocupacao,
    COUNT(o.id_obito) AS total_obitos_acid_trabalho
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
LEFT JOIN cbo2002 cbo ON pf.ocup = cbo.codigo
WHERE co.id_acidtrab = 1 AND pf.ocup IS NOT NULL
GROUP BY 
    pf.ocup, 
    cbo.titulo;
GO

--------------------------------------------------------------------------------
-- EIXO 2: VIEWS DE ANÁLISE GEOGRÁFICA E LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 2.1: Ranking de municípios com mais óbitos por causas violentas.
CREATE OR ALTER VIEW vw_2_1_ranking_municipios_causas_violentas AS
SELECT
    ISNULL(m.nome_municipio, 'Município de Ocorrência Faltando') AS municipio_ocorrencia,
    ISNULL(m.uf, 'UF') as uf,
    COUNT(o.id_obito) AS total_obitos_violentos
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
LEFT JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
LEFT JOIN municipio m ON lo.codmunocor = m.cod_municipio
WHERE co.id_circobito IN (1, 2, 3)
GROUP BY m.nome_municipio, m.uf;
GO

-- VIEW para a Pergunta 2.2: Percentual de óbitos fora de estabelecimento de saúde por município.
CREATE OR ALTER VIEW vw_2_2_percentual_obitos_fora_estab_saude AS
SELECT
    m.nome_municipio AS municipio_residencia,
    m.uf,
    COUNT(o.id_obito) AS total_de_obitos,
    SUM(CASE WHEN lo.id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) AS obitos_fora_estab_saude,
    (SUM(CASE WHEN lo.id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) * 100.0) / COUNT(o.id_obito) AS percentual_fora_estab_saude
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN municipio m ON pf.codmunres = m.cod_municipio
JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
GROUP BY m.nome_municipio, m.uf
HAVING COUNT(o.id_obito) > 50;
GO

-- VIEW para a Pergunta 2.3: Fluxo de óbitos entre município de residência e de ocorrência.
CREATE OR ALTER VIEW vw_2_3_fluxo_obitos_residencia_ocorrencia AS
SELECT 
    mun_res.nome_municipio AS municipio_residencia,
    mun_res.uf AS uf_residencia,
    mun_ocor.nome_municipio AS municipio_ocorrencia,
    mun_ocor.uf AS uf_ocorrencia,
    COUNT(o.id_obito) AS total_obitos_em_transito
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
JOIN municipio mun_res ON pf.codmunres = mun_res.cod_municipio
JOIN municipio mun_ocor ON lo.codmunocor = mun_ocor.cod_municipio
WHERE pf.codmunres <> lo.codmunocor
GROUP BY mun_res.nome_municipio, mun_res.uf, mun_ocor.nome_municipio, mun_ocor.uf;
GO

--------------------------------------------------------------------------------
-- EIXO 3: VIEWS DE ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 3.1: Top 10 causas de morte por faixa etária e sexo.
CREATE OR ALTER VIEW vw_3_1_top10_causas_morte_faixa_etaria_sexo AS
WITH ranking_causas AS (
    SELECT
        CASE 
            WHEN idad.id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade >= 60 THEN '04- 60 anos e mais'
            ELSE 'Idade Ignorada'
        END AS faixa_etaria,
        s.descricao AS sexo,
        c.causabas,
        cid.descricao AS descricao_causa,
        COUNT(o.id_obito) AS total_obitos,
        ROW_NUMBER() OVER(PARTITION BY 
            CASE 
                WHEN idad.id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
                WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
                WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
                WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
                WHEN idad.id_idade_unidade = 4 AND idad.quantidade >= 60 THEN '04- 60 anos e mais'
                ELSE 'Idade Ignorada'
            END, s.descricao ORDER BY COUNT(o.id_obito) DESC) AS ranking
    FROM obito o
    JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
    JOIN cid_causa c ON o.id_obito = c.id_obito
    JOIN sexo s ON pf.id_sexo = s.id_sexo
    JOIN idade idad ON pf.id_idade = idad.id_idade
    LEFT JOIN cid10_subcategorias cid ON c.causabas = cid.subcat
    WHERE c.causabas IS NOT NULL AND s.descricao <> 'Ignorado'
    GROUP BY
        CASE 
            WHEN idad.id_idade_unidade IN (1, 2, 3) THEN '00- Menos de 1 ano'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 1 AND 19 THEN '01- 1 a 19 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 20 AND 39 THEN '02- 20 a 39 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade BETWEEN 40 AND 59 THEN '03- 40 a 59 anos'
            WHEN idad.id_idade_unidade = 4 AND idad.quantidade >= 60 THEN '04- 60 anos e mais'
            ELSE 'Idade Ignorada'
        END,
        s.descricao,
        c.causabas,
        cid.descricao
)
SELECT
    faixa_etaria,
    sexo,
    causabas,
    descricao_causa,
    total_obitos,
    ranking
FROM ranking_causas
WHERE ranking <= 10;
GO

-- VIEW para a Pergunta 3.2: Relação entre falta de assistência médica e causa do óbito.
CREATE OR ALTER VIEW vw_3_2_relacao_assistencia_medica_causa_morte AS
SELECT
    cc.causabas,
    cid.descricao AS descricao_causa,
    COUNT(o.id_obito) AS total_obitos,
    SUM(CASE WHEN a.id_assistmed = 2 THEN 1 ELSE 0 END) AS obitos_sem_assistencia,
    (SUM(CASE WHEN a.id_assistmed = 2 THEN 1 ELSE 0 END) * 100.0) / COUNT(o.id_obito) AS percentual_sem_assistencia
FROM obito o
JOIN atestado at ON o.id_obito = at.id_obito
JOIN assistmed a ON at.id_assistmed = a.id_assistmed
JOIN cid_causa cc ON o.id_obito = cc.id_obito
LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat
WHERE cc.causabas IS NOT NULL AND a.id_assistmed IN (1, 2)
GROUP BY cc.causabas, cid.descricao
HAVING COUNT(o.id_obito) > 100;
GO

-- VIEW para a Pergunta 3.3: Associação entre fonte de informação e causas violentas.
CREATE OR ALTER VIEW vw_3_3_fonte_informacao_causas_violentas AS
SELECT
    c.descricao AS circunstancia_obito,
    f.descricao AS fonte_informacao,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN circobito c ON co.id_circobito = c.id_circobito
JOIN fonte f ON co.id_fonte = f.id_fonte
WHERE c.descricao <> 'Ignorado'
GROUP BY c.descricao, f.descricao;
GO

--------------------------------------------------------------------------------
-- EIXO 4: VIEWS DE ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 4.1: Relação entre escolaridade da mãe e óbito fetal.
CREATE OR ALTER VIEW vw_4_1_relacao_escolaridade_mae_obito_fetal AS
SELECT 
    em.descricao AS escolaridade_mae,
    tb.descricao AS tipo_obito,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
LEFT JOIN mae ma ON o.id_obito = ma.id_obito
LEFT JOIN escolaridade_mae em_id ON ma.id_escol_mae = em_id.id_escol_mae
LEFT JOIN escmae2010 em ON em_id.id_escmae2010 = em.id_escmae2010
JOIN tipobito tb ON o.id_tipobito = tb.id_tipobito
WHERE ma.id_obito IS NOT NULL AND em.descricao IS NOT NULL AND em.descricao <> 'Ignorado'
GROUP BY em.descricao, tb.descricao;
GO

-- VIEW para a Pergunta 4.2: Correlação entre tipo de parto e momento do óbito.
CREATE OR ALTER VIEW vw_4_2_correlacao_parto_momento_obito AS
SELECT
    p.tipo AS tipo_parto,
    op.momento AS momento_obito_parto,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN mae m ON o.id_obito = m.id_obito
JOIN parto p ON m.id_parto = p.id_parto
JOIN obitoparto op ON m.id_obitoparto = op.id_obitoparto
WHERE p.tipo <> 'ignorado' AND op.momento <> 'ignorado'
GROUP BY p.tipo, op.momento;
GO

-- VIEW para a Pergunta 4.3: Distribuição do peso ao nascer para óbitos no primeiro ano.
CREATE OR ALTER VIEW vw_4_3_distribuicao_peso_obitos_primeiro_ano AS
SELECT
    CASE
        WHEN m.peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
        WHEN m.peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
        WHEN m.peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
        WHEN m.peso >= 2500 THEN '04- Peso adequado (>=2500g)'
        ELSE 'Peso ignorado ou não aplicável'
    END AS faixa_de_peso,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN tipobito tb ON o.id_tipobito = tb.id_tipobito
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN idade idad ON pf.id_idade = idad.id_idade
JOIN mae m ON o.id_obito = m.id_obito
WHERE tb.id_tipobito = 2 AND idad.id_idade_unidade IN (1, 2, 3) AND m.peso IS NOT NULL
GROUP BY
    CASE
        WHEN m.peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
        WHEN m.peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
        WHEN m.peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
        WHEN m.peso >= 2500 THEN '04- Peso adequado (>=2500g)'
        ELSE 'Peso ignorado ou não aplicável'
    END;
GO

-- VIEW para a Pergunta 4.4: Perfil de mães em óbitos maternos.
CREATE OR ALTER VIEW vw_4_4_perfil_maes_obitos_maternos AS
SELECT
    COALESCE(em.descricao, 'Escolaridade Ignorada') AS escolaridade_predominante,
    AVG(m.idademae) AS media_idade_mae,
    AVG(m.qtdfilvivo) AS media_filhos_vivos,
    AVG(m.qtdfilmorto) AS media_filhos_mortos,
    COUNT(o.id_obito) AS total_obitos_maternos
FROM obito o
JOIN mae m ON o.id_obito = m.id_obito
JOIN tpmorteoco tmo ON m.id_tpmorteoco = tmo.id_tpmorteoco
LEFT JOIN escolaridade_mae em_id ON m.id_escol_mae = em_id.id_escol_mae
LEFT JOIN escmae2010 em ON em_id.id_escmae2010 = em.id_escmae2010
WHERE m.id_tpmorteoco IN (1, 2, 3, 4, 5)
GROUP BY COALESCE(em.descricao, 'Escolaridade Ignorada');
GO

-- Apaga a VIEW antiga e simplificada
IF OBJECT_ID('vw_ObitoCompleto', 'V') IS NOT NULL
    DROP VIEW vw_ObitoCompleto;
GO

-- Recria a VIEW expondo as duas colunas da idade
CREATE VIEW vw_ObitoCompleto AS
SELECT
    -- Colunas da tabela OBITO
    o.id_obito,
    o.id_tipobito,
    o.dtobito,
    o.horaobito,

    -- Colunas da tabela PESSOA_FALECIDA
    pf.dtnasc,
    pf.id_sexo,
    pf.id_estciv,
    pf.id_racacor,
    pf.codmunres,
    pf.ocup,
    pf.id_escol,

    -- Colunas da tabela IDADE (agora de forma completa)
    id.id_idade_unidade, -- <-- A UNIDADE DA IDADE
    id.quantidade AS idade_quantidade -- <-- O VALOR NUMÉRICO

FROM
    obito AS o
LEFT JOIN
    pessoa_falecida AS pf ON o.id_obito = pf.id_obito
LEFT JOIN
    idade AS id ON pf.id_idade = id.id_idade;
GO