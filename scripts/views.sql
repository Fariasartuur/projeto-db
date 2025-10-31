USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: VIEWS DE PERFIL DEMOGRÁFICO E SOCIAL
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 1.1: Distribuição de óbitos por faixa etária, sexo e raça/cor.
CREATE OR ALTER VIEW vw_1_1_distribuicao_obitos_perfil_demografico AS
SELECT 
    idad.id_idade_unidade,
    idad.quantidade,
    s.descricao AS sexo, 
    rc.descricao AS raca_cor,
    obito.id_obito
FROM obito
JOIN pessoa_falecida pf ON obito.id_obito = pf.id_obito
LEFT JOIN sexo s ON pf.id_sexo = s.id_sexo
LEFT JOIN raca_cor rc ON pf.id_racacor = rc.id_racacor
LEFT JOIN idade idad ON pf.id_idade = idad.id_idade;
GO

-- VIEW para a Pergunta 1.2: Correlação entre escolaridade e idade ao morrer.
CREATE OR ALTER VIEW vw_1_2_correlacao_escolaridade_idade_morrer AS
SELECT 
    e.descricao,
    o.id_obito,
    idad.quantidade,
    idad.id_idade_unidade 
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN idade idad ON pf.id_idade = idad.id_idade
JOIN escolaridade_falecido ef ON pf.id_escol = ef.id_escol
JOIN esc2010 e ON ef.id_esc2010 = e.id_esc2010
GO

-- VIEW para a Pergunta 1.3: Top 3 causas de morte por estado civil.
CREATE OR ALTER VIEW vw_1_3_top3_causas_morte_estado_civil AS
SELECT
    ec.descricao AS estado_civil,
    cc.causabas,
    cid.descricao AS descricao_causa,
    o.id_obito
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN estado_civil ec ON pf.id_estciv = ec.id_estciv
JOIN cid_causa cc ON o.id_obito = cc.id_obito
LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat;

-- Esse código está estranho
GO

-- VIEW para a Pergunta 1.4: Ocupações mais frequentes em óbitos por acidentes de trabalho.
CREATE OR ALTER VIEW vw_1_4_ocupacoes_obitos_acidente_trabalho AS
SELECT
    pf.ocup AS cbo_ocupacao,
    cbo.titulo AS descricao_ocupacao,
    co.id_acidtrab,
    o.id_obito
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
LEFT JOIN cbo2002 cbo ON pf.ocup = cbo.codigo;
GO

--------------------------------------------------------------------------------
-- EIXO 2: VIEWS DE ANÁLISE GEOGRÁFICA E LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 2.1: Ranking de municípios com mais óbitos por causas violentas.
CREATE OR ALTER VIEW vw_2_1_ranking_municipios_causas_violentas AS
SELECT
    m.nome_municipio,
    m.nome_uf,
    o.id_obito,
    co.id_circobito
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
LEFT JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
LEFT JOIN municipio m ON lo.codmunocor = m.cod_municipio;
GO

-- VIEW para a Pergunta 2.2: Percentual de óbitos fora de estabelecimento de saúde por município.
CREATE OR ALTER VIEW vw_2_2_percentual_obitos_fora_estab_saude AS
SELECT
    m.nome_municipio,
    m.nome_uf,
    o.id_obito,
    lo.id_lococor
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN municipio m ON pf.codmunres = m.cod_municipio
JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito;
GO

-- VIEW para a Pergunta 2.3: Fluxo de óbitos entre município de residência e de ocorrência.
CREATE OR ALTER VIEW vw_2_3_fluxo_obitos_residencia_ocorrencia AS
SELECT 
    mun_res.nome_municipio AS municipio_residencia,
    mun_res.nome_uf AS nome_uf_residencia,
    mun_ocor.nome_municipio AS municipio_ocorrencia,
    mun_ocor.nome_uf AS nome_uf_ocorrencia,
    pf.codmunres,
    lo.codmunocor,
    o.id_obito
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN local_ocorrencia lo ON o.id_obito = lo.id_obito
JOIN municipio mun_res ON pf.codmunres = mun_res.cod_municipio
JOIN municipio mun_ocor ON lo.codmunocor = mun_ocor.cod_municipio;
GO

--------------------------------------------------------------------------------
-- EIXO 3: VIEWS DE ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 3.1: Top 10 causas de morte por faixa etária e sexo.
CREATE OR ALTER VIEW vw_3_1_top10_causas_morte_faixa_etaria_sexo AS
SELECT 
    idad.id_idade_unidade, 
    idad.quantidade,
    s.descricao AS sexo,
    c.causabas,
    cid.descricao AS descricao_causa,
    o.id_obito
FROM obito o
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN cid_causa c ON o.id_obito = c.id_obito
JOIN sexo s ON pf.id_sexo = s.id_sexo
JOIN idade idad ON pf.id_idade = idad.id_idade
LEFT JOIN cid10_subcategorias cid ON c.causabas = cid.subcat;
GO

-- VIEW para a Pergunta 3.2: Relação entre falta de assistência médica e causa do óbito.
CREATE OR ALTER VIEW vw_3_2_relacao_assistencia_medica_causa_morte AS
SELECT
    cc.causabas,
    cid.descricao,
    o.id_obito,
    a.id_assistmed
FROM obito o
JOIN atestado at ON o.id_obito = at.id_obito
JOIN assistmed a ON at.id_assistmed = a.id_assistmed
JOIN cid_causa cc ON o.id_obito = cc.id_obito
LEFT JOIN dbo.cid10_subcategorias cid ON cc.causabas = cid.subcat;
GO

-- VIEW para a Pergunta 3.3: Associação entre fonte de informação e causas violentas.
CREATE OR ALTER VIEW vw_3_3_fonte_informacao_causas_violentas AS
SELECT
    c.descricao AS circunstancia_obito,
    f.descricao AS fonte_informacao,
    o.id_obito
FROM obito o
JOIN circunstancia_obito co ON o.id_obito = co.id_obito
JOIN circobito c ON co.id_circobito = c.id_circobito
JOIN fonte f ON co.id_fonte = f.id_fonte;
GO

--------------------------------------------------------------------------------
-- EIXO 4: VIEWS DE ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- VIEW para a Pergunta 4.1: Relação entre escolaridade da mãe e óbito fetal.
CREATE OR ALTER VIEW vw_4_1_relacao_escolaridade_mae_obito_fetal AS
SELECT 
    em.descricao AS escolaridade_mae,
    tb.descricao AS tipo_obito,
    o.id_obito AS id_obito_pessoa,
    ma.id_obito AS id_obito_mae
FROM obito o
LEFT JOIN mae ma ON o.id_obito = ma.id_obito
LEFT JOIN escolaridade_mae em_id ON ma.id_escol_mae = em_id.id_escol_mae
LEFT JOIN escmae2010 em ON em_id.id_escmae2010 = em.id_escmae2010
JOIN tipobito tb ON o.id_tipobito = tb.id_tipobito;
GO

-- VIEW para a Pergunta 4.2: Correlação entre tipo de parto e momento do óbito.
CREATE OR ALTER VIEW vw_4_2_correlacao_parto_momento_obito AS
SELECT
    p.tipo AS tipo_parto,
    op.momento AS momento_obito_parto,
    o.id_obito
FROM obito o
JOIN mae m ON o.id_obito = m.id_obito
JOIN parto p ON m.id_parto = p.id_parto
JOIN obitoparto op ON m.id_obitoparto = op.id_obitoparto;
GO

-- VIEW para a Pergunta 4.3: Distribuição do peso ao nascer para óbitos no primeiro ano.
CREATE OR ALTER VIEW vw_4_3_distribuicao_peso_obitos_primeiro_ano AS
SELECT
    m.peso,
    o.id_obito,
    tb.id_tipobito,
    idad.id_idade_unidade 
FROM obito o
JOIN tipobito tb ON o.id_tipobito = tb.id_tipobito
JOIN pessoa_falecida pf ON o.id_obito = pf.id_obito
JOIN idade idad ON pf.id_idade = idad.id_idade
JOIN mae m ON o.id_obito = m.id_obito;
GO

-- VIEW para a Pergunta 4.4: Perfil de mães em óbitos maternos.
CREATE OR ALTER VIEW vw_4_4_perfil_maes_obitos_maternos AS
SELECT
    em.id_escmae2010,
    em.descricao,
    m.idademae,
    m.qtdfilvivo,
    m.qtdfilmorto,
    o.id_obito,
    m.id_tpmorteoco
FROM obito o
JOIN mae m ON o.id_obito = m.id_obito
JOIN tpmorteoco tmo ON m.id_tpmorteoco = tmo.id_tpmorteoco
LEFT JOIN escolaridade_mae em_id ON m.id_escol_mae = em_id.id_escol_mae
LEFT JOIN escmae2010 em ON em_id.id_escmae2010 = em.id_escmae2010;
GO



