/*
================================================================================
SCRIPT DE EXECU��O DO PLANO DE AN�LISE
================================================================================
Este script executa as 13 Stored Procedures (SPs) do plano de an�lise
em sequ�ncia para gerar um relat�rio completo dos dados de mortalidade.

Cada bloco executa uma SP e imprime um cabe�alho para identificar a
pergunta de neg�cio correspondente.

REQUISITO: Semana 8 do documento "Projeto de Banco de Dados.pdf".
*/

USE mortalidade;
GO

--------------------------------------------------------------------------------
-- EIXO 1: PERFIL DEMOGR�FICO E SOCIAL DOS �BITOS
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 1: PERFIL DEMOGR�FICO E SOCIAL DOS �BITOS';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 1.1: Distribui��o de �bitos por faixa et�ria, sexo e ra�a/cor.';
EXEC sp_1_1_distribuicao_obitos_perfil_demografico;
GO

PRINT 'Executando Pergunta 1.2: Correla��o entre escolaridade e idade ao morrer.';
EXEC sp_1_2_correlacao_escolaridade_idade_morrer;
GO

PRINT 'Executando Pergunta 1.3: Top 3 causas de morte por estado civil.';
EXEC sp_1_3_top3_causas_morte_estado_civil;
GO

PRINT 'Executando Pergunta 1.4: Ocupa��es mais frequentes em �bitos por acidentes de trabalho.';
EXEC sp_1_4_ocupacoes_obitos_acidente_trabalho;
GO

--------------------------------------------------------------------------------
-- EIXO 2: AN�LISE GEOGR�FICA E DE LOCAL DE OCORR�NCIA
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 2: AN�LISE GEOGR�FICA E DE LOCAL DE OCORR�NCIA';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 2.1: Ranking de munic�pios com mais �bitos por causas violentas.';
EXEC sp_2_1_ranking_municipios_causas_violentas;
GO

PRINT 'Executando Pergunta 2.2: Percentual de �bitos fora de estabelecimento de sa�de por munic�pio.';
EXEC sp_2_2_percentual_obitos_fora_estab_saude;
GO

PRINT 'Executando Pergunta 2.3: Fluxo de �bitos entre munic�pio de resid�ncia e de ocorr�ncia.';
EXEC sp_2_3_fluxo_obitos_residencia_ocorrencia;
GO

--------------------------------------------------------------------------------
-- EIXO 3: AN�LISE DAS CAUSAS DE MORTE
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 3: AN�LISE DAS CAUSAS DE MORTE';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 3.1: Top 10 causas de morte por faixa et�ria e sexo.';
EXEC sp_3_1_top10_causas_morte_faixa_etaria_sexo;
GO

PRINT 'Executando Pergunta 3.2: Rela��o entre falta de assist�ncia m�dica e causa do �bito.';
EXEC sp_3_2_relacao_assistencia_medica_causa_morte;
GO

PRINT 'Executando Pergunta 3.3: Associa��o entre fonte de informa��o e causas violentas.';
EXEC sp_3_3_fonte_informacao_causas_violentas;
GO

--------------------------------------------------------------------------------
-- EIXO 4: AN�LISE DE MORTALIDADE MATERNO-INFANTIL
--------------------------------------------------------------------------------
PRINT '================================================================================';
PRINT 'EIXO 4: AN�LISE DE MORTALIDADE MATERNO-INFANTIL';
PRINT '================================================================================';
GO

PRINT 'Executando Pergunta 4.1: Rela��o entre escolaridade da m�e e �bito fetal.';
EXEC sp_4_1_relacao_escolaridade_mae_obito_fetal;
GO

PRINT 'Executando Pergunta 4.2: Correla��o entre tipo de parto e momento do �bito.';
EXEC sp_4_2_correlacao_parto_momento_obito;
GO

PRINT 'Executando Pergunta 4.3: Distribui��o do peso ao nascer para �bitos no primeiro ano.';
EXEC sp_4_3_distribuicao_peso_obitos_primeiro_ano;
GO

PRINT 'Executando Pergunta 4.4: Distribui��o de m�es cujos �bitos ocorreram durante a gravidez ou puerp�rio';
EXEC sp_4_4_perfil_maes_obitos_maternos;
GO

PRINT '================================================================================';
PRINT 'Execu��o do plano de an�lise conclu�da.';
PRINT '================================================================================';
GO