USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGR�FICO E SOCIAL DOS �BITOS
--------------------------------------------------------------------------------

-- Pergunta 1.1: Distribui��o de �bitos por faixa et�ria, sexo e ra�a/cor.
PRINT 'Executando: vw_1_1_distribuicao_obitos_perfil_demografico';
SELECT * FROM vw_1_1_distribuicao_obitos_perfil_demografico
ORDER BY faixa_etaria, total_obitos DESC;
GO

-- Pergunta 1.2: Correla��o entre escolaridade e idade ao morrer.
PRINT 'Executando: vw_1_2_correlacao_escolaridade_idade_morrer';
SELECT * FROM vw_1_2_correlacao_escolaridade_idade_morrer
ORDER BY escolaridade;
GO

-- Pergunta 1.3: Top 3 causas de morte por estado civil.
PRINT 'Executando: vw_1_3_top3_causas_morte_estado_civil';
SELECT * FROM vw_1_3_top3_causas_morte_estado_civil
ORDER BY estado_civil, total_obitos DESC;
GO

-- Pergunta 1.4: Ocupa��es mais frequentes em �bitos por acidentes de trabalho.
PRINT 'Executando: vw_1_4_ocupacoes_obitos_acidente_trabalho';
SELECT * FROM vw_1_4_ocupacoes_obitos_acidente_trabalho
ORDER BY total_obitos_acid_trabalho DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 2: AN�LISE GEOGR�FICA E DE LOCAL DE OCORR�NCIA
--------------------------------------------------------------------------------

-- Pergunta 2.1: Ranking de munic�pios com mais �bitos por causas violentas.
PRINT 'Executando: vw_2_1_ranking_municipios_causas_violentas';
SELECT * FROM vw_2_1_ranking_municipios_causas_violentas
ORDER BY total_obitos_violentos DESC;
GO

-- Pergunta 2.2: Percentual de �bitos fora de estabelecimento de sa�de por munic�pio.
PRINT 'Executando: vw_2_2_percentual_obitos_fora_estab_saude';
SELECT * FROM vw_2_2_percentual_obitos_fora_estab_saude
ORDER BY percentual_fora_estab_saude DESC;
GO

-- Pergunta 2.3: Fluxo de �bitos entre munic�pio de resid�ncia e de ocorr�ncia.
PRINT 'Executando: vw_2_3_fluxo_obitos_residencia_ocorrencia';
SELECT * FROM vw_2_3_fluxo_obitos_residencia_ocorrencia
ORDER BY total_obitos_em_transito DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 3: AN�LISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------

-- Pergunta 3.1: Top 10 causas de morte por faixa et�ria e sexo.
PRINT 'Executando: vw_3_1_top10_causas_morte_faixa_etaria_sexo';
SELECT * FROM vw_3_1_top10_causas_morte_faixa_etaria_sexo
ORDER BY faixa_etaria, sexo, ranking;
GO

-- Pergunta 3.2: Rela��o entre falta de assist�ncia m�dica e causa do �bito.
PRINT 'Executando: vw_3_2_relacao_assistencia_medica_causa_morte';
SELECT * FROM vw_3_2_relacao_assistencia_medica_causa_morte
ORDER BY percentual_sem_assistencia DESC;
GO

-- Pergunta 3.3: Associa��o entre fonte de informa��o e causas violentas.
PRINT 'Executando: vw_3_3_fonte_informacao_causas_violentas';
SELECT * FROM vw_3_3_fonte_informacao_causas_violentas
ORDER BY circunstancia_obito, total_obitos DESC;
GO

--------------------------------------------------------------------------------
-- EIXO 4: AN�LISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------

-- Pergunta 4.1: Rela��o entre escolaridade da m�e e �bito fetal.
PRINT 'Executando: vw_4_1_relacao_escolaridade_mae_obito_fetal';
SELECT * FROM vw_4_1_relacao_escolaridade_mae_obito_fetal
ORDER BY escolaridade_mae, tipo_obito;
GO

-- Pergunta 4.2: Correla��o entre tipo de parto e momento do �bito.
PRINT 'Executando: vw_4_2_correlacao_parto_momento_obito';
SELECT * FROM vw_4_2_correlacao_parto_momento_obito
ORDER BY tipo_parto, momento_obito_parto;
GO

-- Pergunta 4.3: Distribui��o do peso ao nascer para �bitos no primeiro ano.
PRINT 'Executando: vw_4_3_distribuicao_peso_obitos_primeiro_ano';
SELECT * FROM vw_4_3_distribuicao_peso_obitos_primeiro_ano
ORDER BY faixa_de_peso;
GO

-- Pergunta 4.4: Perfil de m�es em �bitos maternos.
PRINT 'Executando: vw_4_4_perfil_maes_obitos_maternos';
SELECT * FROM vw_4_4_perfil_maes_obitos_maternos
ORDER BY total_obitos_maternos DESC;
GO