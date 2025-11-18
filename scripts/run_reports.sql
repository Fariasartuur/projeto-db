USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGRÁFICO E SOCIAL DOS ÓBITOS
--------------------------------------------------------------------------------

-- Pergunta 1.1: Distribuição de óbitos por faixa etária, sexo e raça/cor.
PRINT 'Executando: vw_1_1_distribuicao_obitos_perfil_demografico';
SELECT 
    id_idade_unidade,
    quantidade AS idade_quantidade,
    sexo,
    raca_cor,
    id_obito
FROM vw_1_1_distribuicao_obitos_perfil_demografico
ORDER BY id_idade_unidade, quantidade DESC;
GO

-- Pergunta 1.2: Correlação entre escolaridade e idade ao morrer.
PRINT 'Executando: vw_1_2_correlacao_escolaridade_idade_morrer';
SELECT 
    descricao AS escolaridade,
    id_obito,
    quantidade AS idade_quantidade,
    id_idade_unidade
FROM vw_1_2_correlacao_escolaridade_idade_morrer
ORDER BY escolaridade;
GO

-- Pergunta 1.3: Top 3 causas de morte por estado civil.
PRINT 'Executando: vw_1_3_top3_causas_morte_estado_civil';
SELECT
    estado_civil,
    causabas,
    descricao_causa,
    id_obito
FROM vw_1_3_top3_causas_morte_estado_civil
ORDER BY estado_civil, causabas;
GO

-- Pergunta 1.4: Ocupações mais frequentes em óbitos por acidentes de trabalho.
PRINT 'Executando: vw_1_4_ocupacoes_obitos_acidente_trabalho';
SELECT
    cbo_ocupacao,
    descricao_ocupacao,
    id_acidtrab,
    id_obito
FROM vw_1_4_ocupacoes_obitos_acidente_trabalho
ORDER BY id_acidtrab DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 2: ANÁLISE GEOGRÁFICA E DE LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------

-- Pergunta 2.1: Ranking de municípios com mais óbitos por causas violentas.
PRINT 'Executando: vw_2_1_ranking_municipios_causas_violentas';
SELECT
    nome_municipio,
    nome_uf,
    id_obito,
    id_circobito
FROM vw_2_1_ranking_municipios_causas_violentas
ORDER BY id_circobito DESC;
GO

-- Pergunta 2.2: Percentual de óbitos fora de estabelecimento de saúde por município.
PRINT 'Executando: vw_2_2_percentual_obitos_fora_estab_saude';
SELECT
    nome_municipio,
    nome_uf,
    id_obito,
    id_lococor
FROM vw_2_2_percentual_obitos_fora_estab_saude
ORDER BY id_lococor DESC;
GO

-- Pergunta 2.3: Fluxo de óbitos entre município de residência e de ocorrência.
PRINT 'Executando: vw_2_3_fluxo_obitos_residencia_ocorrencia';
SELECT 
    municipio_residencia,
    nome_uf_residencia,
    municipio_ocorrencia,
    nome_uf_ocorrencia,
    codmunres,
    codmunocor,
    id_obito
FROM vw_2_3_fluxo_obitos_residencia_ocorrencia
ORDER BY id_obito;
GO

--------------------------------------------------------------------------------
-- EIXO 3: ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- Pergunta 3.1: Top 10 causas de morte por faixa etária e sexo.
PRINT 'Executando: vw_3_1_top10_causas_morte_faixa_etaria_sexo';
SELECT 
    id_idade_unidade,
    quantidade,
    sexo,
    causabas,
    descricao_causa,
    id_obito
FROM vw_3_1_top10_causas_morte_faixa_etaria_sexo
ORDER BY id_idade_unidade, sexo;
GO

-- Pergunta 3.2: Relação entre falta de assistência médica e causa do óbito.
PRINT 'Executando: vw_3_2_relacao_assistencia_medica_causa_morte';
SELECT
    causabas,
    descricao,
    id_obito,
    id_assistmed
FROM vw_3_2_relacao_assistencia_medica_causa_morte
ORDER BY id_assistmed DESC;
GO

-- Pergunta 3.3: Associação entre fonte de informação e causas violentas.
PRINT 'Executando: vw_3_3_fonte_informacao_causas_violentas';
SELECT
    circunstancia_obito,
    fonte_informacao,
    id_obito
FROM vw_3_3_fonte_informacao_causas_violentas
ORDER BY circunstancia_obito;
GO

--------------------------------------------------------------------------------
-- EIXO 4: ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- Pergunta 4.1: Relação entre escolaridade da mãe e óbito fetal.
PRINT 'Executando: vw_4_1_idade_mae_obito_infantil';
SELECT
    id_obito_pessoa,
    idade_mae,
    tipo_obito
FROM vw_4_1_idade_mae_obito_infantil
ORDER BY tipo_obito;
GO

-- Pergunta 4.2: Correlação entre tipo de parto e momento do óbito.
PRINT 'Executando: vw_4_2_obito_infantil_local_ocorrencia';
SELECT
    id_obito_pessoa,
    idade,
    lococor
FROM vw_4_2_obito_infantil_local_ocorrencia
ORDER BY lococor;
GO

-- Pergunta 4.3: Distribuição do peso ao nascer para óbitos no primeiro ano.
PRINT 'Executando: vw_4_3_distribuicao_peso_obitos_primeiro_ano';
SELECT
    peso,
    id_obito,
    id_tipobito,
    id_idade_unidade
FROM vw_4_3_distribuicao_peso_obitos_primeiro_ano
ORDER BY peso;
GO

-- Pergunta 4.4: Perfil de mães em óbitos maternos.
PRINT 'Executando: vw_4_4_idade_gestacional_obito_infantil';
SELECT
    id_obito_pessoa,
    semana_gestacao,
    idade
FROM vw_4_4_idade_gestacional_obito_infantil
ORDER BY semana_gestacao ASC;
GO
