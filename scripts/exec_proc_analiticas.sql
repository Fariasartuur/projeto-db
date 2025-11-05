/*
================================================================================
SCRIPT DE EXECUÇÃO DO PLANO DE ANÁLISE
================================================================================
Este script executa as 13 Stored Procedures (SPs) do plano de análise
em sequência para gerar um relatório completo dos dados de mortalidade.

Cada bloco executa uma SP e imprime um cabeçalho para identificar a
pergunta de negócio correspondente.

REQUISITO: Semana 8 do documento "Projeto de Banco de Dados.pdf".
*/

USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGRÁFICO E SOCIAL DOS ÓBITOS
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 1: PERFIL DEMOGRÁFICO E SOCIAL DOS ÓBITOS';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 1.1: Distribuição de óbitos por faixa etária, sexo e raça/cor.';
EXEC sp_1_1_distribuicao_obitos_perfil_demografico;
GO

PRINT 'Executando Pergunta 1.2: Correlação entre escolaridade e idade ao morrer.';
EXEC sp_1_2_correlacao_escolaridade_idade_morrer;
GO

PRINT 'Executando Pergunta 1.3: Top 3 causas de morte por estado civil.';
EXEC sp_1_3_top3_causas_morte_estado_civil;
GO

PRINT 'Executando Pergunta 1.4: Ocupações mais frequentes em óbitos por acidentes de trabalho.';
EXEC sp_1_4_ocupacoes_obitos_acidente_trabalho;
GO

--------------------------------------------------------------------------------
-- EIXO 2: ANÁLISE GEOGRÁFICA E DE LOCAL DE OCORRÊNCIA
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 2: ANÁLISE GEOGRÁFICA E DE LOCAL DE OCORRÊNCIA';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 2.1: Ranking de municípios com mais óbitos por causas violentas.';
EXEC sp_2_1_ranking_municipios_causas_violentas;
GO

PRINT 'Executando Pergunta 2.2: Percentual de óbitos fora de estabelecimento de saúde por município.';
EXEC sp_2_2_percentual_obitos_fora_estab_saude;
GO

PRINT 'Executando Pergunta 2.3: Fluxo de óbitos entre município de residência e de ocorrência.';
EXEC sp_2_3_fluxo_obitos_residencia_ocorrencia;
GO

--------------------------------------------------------------------------------
-- EIXO 3: ANÁLISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 3: ANÁLISE DAS CAUSAS DE MORTE';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 3.1: Top 10 causas de morte por faixa etária e sexo.';
EXEC sp_3_1_top10_causas_morte_faixa_etaria_sexo;
GO

PRINT 'Executando Pergunta 3.2: Relação entre falta de assistência médica e causa do óbito.';
EXEC sp_3_2_relacao_assistencia_medica_causa_morte;
GO

PRINT 'Executando Pergunta 3.3: Associação entre fonte de informação e causas violentas.';
EXEC sp_3_3_fonte_informacao_causas_violentas;
GO

--------------------------------------------------------------------------------
-- EIXO 4: ANÁLISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 4: ANÁLISE DE MORTALIDADE MATERNO-INFANTIL';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 4.1: Relação entre escolaridade da mãe e óbito fetal.';
EXEC sp_4_1_idade_mae_obito_infantil;
GO

PRINT 'Executando Pergunta 4.2: Correlação entre tipo de parto e momento do óbito.';
EXEC sp_4_2_obito_infantil_local_ocorrencia;
GO

PRINT 'Executando Pergunta 4.3: Distribuição do peso ao nascer para óbitos no primeiro ano.';
EXEC sp_4_3_distribuicao_peso_obitos_primeiro_ano;
GO

PRINT 'Executando Pergunta 4.4: Distribuição de mães cujos óbitos ocorreram durante a gravidez ou puerpério';
EXEC sp_4_4_idade_gestacional_obito_infantil;
GO

PRINT '================================================================================';
PRINT 'Execução do plano de análise concluída.';
PRINT '================================================================================';
GO