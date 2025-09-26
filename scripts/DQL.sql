USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGRÁFICO E SOCIAL DOS ÓBITOS
--------------------------------------------------------------------------------

-- Pergunta 1.1: Qual é a distribuição de óbitos por faixa etária, sexo e raça/cor?
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
    END, s.descricao, rc.descricao
ORDER BY faixa_etaria, total_obitos DESC;
GO

-- Pergunta 1.2: Qual a correlação entre o nível de escolaridade do falecido e a idade ao morrer?
SELECT 
    e.descricao AS escolaridade,
    COUNT(o.id_obito) AS total_obitos,
    AVG(CAST(idad.quantidade AS FLOAT)) AS media_idade_ao_morrer
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN idade idad ON pf.id_idade = idad.id_idade
JOIN escolaridade_falecido ef ON pf.id_escol = ef.id_escol
JOIN esc2010 e ON ef.id_esc2010 = e.id_esc2010
-- Filtra para considerar apenas idades registradas em anos para que a média faça sentido
WHERE idad.id_idade_unidade = 4
GROUP BY e.descricao
ORDER BY e.descricao;
GO

-- Pergunta 1.3: Qual é o perfil de mortalidade por estado civil?
WITH CausasPorEstadoCivil AS (
    SELECT
        ec.descricao AS estado_civil,
        cc.causabas,
        cid.descricao AS descricao_causa, -- Adicionado
        COUNT(o.id_obito) as total_obitos,
        ROW_NUMBER() OVER(PARTITION BY ec.descricao ORDER BY COUNT(o.id_obito) DESC) as ranking
    FROM obito o
    JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
    JOIN estado_civil ec ON pf.id_estciv = ec.id_estciv
    JOIN cid_causa cc ON o.id_obito = cc.id_obito
    -- Join para buscar a descrição da causa
    LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat
    WHERE cc.causabas IS NOT NULL AND ec.descricao <> 'Ignorado'
    -- Adicionado ao GROUP BY
    GROUP BY ec.descricao, cc.causabas, cid.descricao
)
SELECT 
    estado_civil,
    causabas,
    descricao_causa, -- Adicionado
    total_obitos
FROM CausasPorEstadoCivil
WHERE ranking <= 3
ORDER BY estado_civil, ranking;
GO

-- Pergunta 1.4: Quais são as ocupações (CBO) mais frequentes entre os óbitos por acidentes de trabalho?
SELECT
    pf.ocup AS cbo_ocupacao,
    cbo.titulo AS descricao_ocupacao, -- 2. Adicionamos a descrição da ocupação
    COUNT(o.id_obito) AS total_obitos_acid_trabalho
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
LEFT JOIN dbo.cbo2002 cbo ON pf.ocup = cbo.codigo
-- Filtra apenas os óbitos marcados como acidente de trabalho (id_acidtrab = 1 -> 'Sim')
WHERE co.id_acidtrab = 1 AND pf.ocup IS NOT NULL
GROUP BY 
    pf.ocup, 
    cbo.titulo
ORDER BY total_obitos_acid_trabalho DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 2: ANÁLISE GEOGRÁFICA E DE LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------

-- Pergunta 2.1: Qual o ranking de municípios com os maiores totais de mortalidade por causas violentas?
-- OBS: A pergunta original pedia "taxas", mas sem dados populacionais, calculamos o "total".
SELECT
    -- Usamos ISNULL para mostrar um texto caso o município não seja encontrado
    ISNULL(m.nome_municipio, 'Município de Ocorrência Faltando') AS municipio_ocorrencia,
    ISNULL(m.uf, 'UF') as uf,
    COUNT(o.id_obito) AS total_obitos_violentos
FROM obito o
-- Mantém o JOIN com a tabela de circunstância, pois sabemos que os dados estão lá
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
-- MUDANÇA PRINCIPAL: Usamos LEFT JOIN para a tabela de local de ocorrência
LEFT JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
LEFT JOIN municipio m ON lo.codmunocor = m.cod_municipio
-- O filtro permanece o mesmo, pois ele funciona na tabela circunstancia_obito
WHERE co.id_circobito IN (1, 2, 3)
GROUP BY m.nome_municipio, m.uf
ORDER BY total_obitos_violentos DESC;
GO

-- Pergunta 2.2: Qual a porcentagem de óbitos que ocorrem fora de um estabelecimento de saúde por município de residência?
SELECT
    m.nome_municipio AS municipio_residencia,
    m.uf,
    COUNT(o.id_obito) AS total_de_obitos,
    -- Contagem condicional para óbitos fora de hospital/outro estab. de saúde
    SUM(CASE WHEN lo.id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) AS obitos_fora_estab_saude,
    -- Cálculo da porcentagem
    (SUM(CASE WHEN lo.id_lococor NOT IN (1, 2) THEN 1 ELSE 0 END) * 100.0) / COUNT(o.id_obito) AS percentual_fora_estab_saude
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN municipio m ON pf.codmunres = m.cod_municipio
JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
GROUP BY m.nome_municipio, m.uf
HAVING COUNT(o.id_obito) > 50 -- Filtra para municípios com um número mínimo de óbitos para relevância estatística
ORDER BY percentual_fora_estab_saude DESC;
GO

-- Pergunta 2.3: Existe uma diferença entre o município de residência e o município de ocorrência do óbito?
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
-- A condição principal: onde o óbito ocorreu fora do município de residência
WHERE pf.codmunres <> lo.codmunocor
GROUP BY mun_res.nome_municipio, mun_res.uf, mun_ocor.nome_municipio, mun_ocor.uf
ORDER BY total_obitos_em_transito DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 3: ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- Pergunta 3.1: Quais são as 10 principais causas de morte para homens e mulheres em diferentes faixas etárias?
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
WHERE ranking <= 10
ORDER BY faixa_etaria, sexo, ranking;
GO

-- Pergunta 3.2: Como a falta de assistência médica se relaciona com a causa do óbito?
SELECT
    cc.causabas,
    cid.descricao AS descricao_causa, -- 1. Adicionando a descrição da causa
    COUNT(o.id_obito) AS total_obitos,
    SUM(CASE WHEN a.id_assistmed = 2 THEN 1 ELSE 0 END) AS obitos_sem_assistencia,
    (SUM(CASE WHEN a.id_assistmed = 2 THEN 1 ELSE 0 END) * 100.0) / COUNT(o.id_obito) AS percentual_sem_assistencia
FROM obito o
JOIN atestado at ON o.id_obito = at.id_obito
JOIN assistmed a ON at.id_assistmed = a.id_assistmed
JOIN cid_causa cc ON o.id_obito = cc.id_obito
-- 2. Fazendo o JOIN com a tabela de descrições da CID-10
LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat
WHERE cc.causabas IS NOT NULL AND a.id_assistmed IN (1, 2) -- Considera apenas 'Sim' ou 'Não'
-- 3. Agrupando também pela descrição
GROUP BY
    cc.causabas,
    cid.descricao
HAVING COUNT(o.id_obito) > 100 -- Filtra para causas com volume mínimo
ORDER BY percentual_sem_assistencia DESC;
GO

-- Pergunta 3.3: Óbitos por causas violentas estão mais associados a qual fonte de informação?
SELECT
    c.descricao AS circunstancia_obito,
    f.descricao AS fonte_informacao,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN circobito c ON co.id_circobito = c.id_circobito
JOIN fonte f ON co.id_fonte = f.id_fonte
WHERE c.descricao <> 'Ignorado'
GROUP BY c.descricao, f.descricao
ORDER BY c.descricao, total_obitos DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 4: ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- Pergunta 4.1: Qual a relação entre a escolaridade da mãe e a ocorrência de óbito fetal?
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
GROUP BY em.descricao, tb.descricao
ORDER BY em.descricao, tb.descricao;
GO

-- Pergunta 4.2: O tipo de parto tem correlação com o momento do óbito em relação ao parto?
SELECT
    p.tipo AS tipo_parto,
    op.momento AS momento_obito_parto,
    COUNT(o.id_obito) AS total_obitos
FROM obito o
JOIN mae m ON o.id_obito = m.id_obito
JOIN parto p ON m.id_parto = p.id_parto
JOIN obitoparto op ON m.id_obitoparto = op.id_obitoparto
WHERE p.tipo <> 'ignorado' AND op.momento <> 'ignorado'
GROUP BY p.tipo, op.momento
ORDER BY p.tipo, op.momento;
GO

-- Pergunta 4.3: Qual é a distribuição do peso ao nascer para óbitos não fetais no primeiro ano de vida? [cite: 44]
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
-- Filtra para: Óbitos NÃO FETAIS (id 2) que ocorreram no primeiro ano de vida (unidade de idade em minutos, horas ou dias)
WHERE tb.id_tipobito = 2 AND idad.id_idade_unidade IN (1, 2, 3) AND m.peso IS NOT NULL
GROUP BY
    CASE
        WHEN m.peso < 1000 THEN '01- Extremamente baixo peso (<1000g)'
        WHEN m.peso BETWEEN 1000 AND 1499 THEN '02- Muito baixo peso (1000-1499g)'
        WHEN m.peso BETWEEN 1500 AND 2499 THEN '03- Baixo peso (1500-2499g)'
        WHEN m.peso >= 2500 THEN '04- Peso adequado (>=2500g)'
        ELSE 'Peso ignorado ou não aplicável'
    END
ORDER BY faixa_de_peso;
GO

-- Pergunta 4.4: Qual é o perfil de mães cujos óbitos ocorreram durante a gravidez ou puerpério?
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
GROUP BY COALESCE(em.descricao, 'Escolaridade Ignorada')
ORDER BY total_obitos_maternos DESC;
GO