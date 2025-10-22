USE mortalidade;
GO

--------------------------------------------------------------------------------
-- PARTE 1: VALIDAÇÃO DA CARGA DO ETL
-- Objetivo: Garantir que o processo de ETL foi executado com sucesso,
-- os dados foram carregados e a integridade básica está mantida.
--------------------------------------------------------------------------------

-- Validação 1.1: Checagem de Volume na Tabela Fato Principal
-- Requisito do Projeto: Mínimo de 200.000 registros na tabela fato principal[cite: 28].
PRINT '---------------------------------------------------';
PRINT 'VALIDAÇÃO 1.1: Contagem de Registros em [obito]';
SELECT 
    COUNT(id_obito) AS total_registros_obito
FROM dbo.obito;
GO
-- Resultado esperado: Um número igual ou superior a 200.000.


-- Validação 1.2: Checagem de Volume nas Principais Tabelas de Dimensão
PRINT '---------------------------------------------------';
PRINT 'VALIDAÇÃO 1.2: Contagem de Registros em Dimensões';
SELECT 'pessoa_falecida' AS tabela, COUNT(*) AS total_registros FROM dbo.pessoa_falecida
UNION ALL
SELECT 'local_ocorrencia' AS tabela, COUNT(*) AS total_registros FROM dbo.local_ocorrencia
UNION ALL
SELECT 'cid_causa' AS tabela, COUNT(*) AS total_registros FROM dbo.cid_causa
UNION ALL
SELECT 'municipio' AS tabela, COUNT(*) AS total_registros FROM dbo.municipio;
GO
-- Resultado esperado: Números de registros coerentes e não zerados em todas as tabelas.


-- Validação 1.3: Verificação de Integridade Referencial (Chaves Estrangeiras)
-- Exemplo: Verificar se há óbitos em pessoa_falecida que não possuem um sexo válido associado.
PRINT '---------------------------------------------------';
PRINT 'VALIDAÇÃO 1.3: Checagem de Chaves Estrangeiras Nulas';
SELECT 
    COUNT(id_obito) AS total_registros,
    SUM(CASE WHEN id_sexo IS NULL THEN 1 ELSE 0 END) AS total_sexo_nulo,
    SUM(CASE WHEN codmunres IS NULL THEN 1 ELSE 0 END) AS total_mun_residencia_nulo
FROM dbo.pessoa_falecida;
GO
-- Resultado esperado: O número de nulos deve ser baixo ou zero, indicando que os JOINs no ETL funcionaram.


--------------------------------------------------------------------------------
-- PARTE 2: CONSULTAS EXPLORATÓRIAS INICIAIS
-- Objetivo: Ter um primeiro contato com os dados para entender a distribuição
-- e identificar padrões gerais.
--------------------------------------------------------------------------------

-- Exploração 2.1: Distribuição de Óbitos por Local de Ocorrência
PRINT '---------------------------------------------------';
PRINT 'EXPLORAÇÃO 2.1: Distribuição por Local de Ocorrência';
SELECT 
    lc.descricao AS local_ocorrencia,
    COUNT(o.id_obito) AS total_obitos,
    (COUNT(o.id_obito) * 100.0 / (SELECT COUNT(*) FROM obito)) AS percentual
FROM dbo.obito o
JOIN dbo.local_ocorrencia lo ON o.id_obito = lo.id_obito
JOIN dbo.lococor lc ON lo.id_lococor = lc.id_lococor
GROUP BY lc.descricao
ORDER BY total_obitos DESC;
GO


-- Exploração 2.2: Top 10 Municípios de Residência com Mais Óbitos
PRINT '---------------------------------------------------';
PRINT 'EXPLORAÇÃO 2.2: Top 10 Municípios por Óbitos';
SELECT TOP 10
    m.nome_municipio,
    m.uf,
    COUNT(o.id_obito) AS total_obitos
FROM dbo.obito o
JOIN dbo.pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN dbo.municipio m ON pf.codmunres = m.cod_municipio
GROUP BY m.nome_municipio, m.uf
ORDER BY total_obitos DESC;
GO


-- Exploração 2.3: Contagem de Óbitos por Causa Básica (Top 10)
PRINT '---------------------------------------------------';
PRINT 'EXPLORAÇÃO 2.3: Top 10 Causas Básicas de Morte';
SELECT TOP 10
    cc.causabas,
    cid.descricao AS descricao_causa,
    COUNT(o.id_obito) AS total_obitos
FROM dbo.obito o
JOIN dbo.cid_causa cc ON o.id_obito = cc.id_obito
LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat
WHERE cc.causabas IS NOT NULL
GROUP BY cc.causabas, cid.descricao
ORDER BY total_obitos DESC;
GO