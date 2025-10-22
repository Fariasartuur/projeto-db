USE master;
GO
--------------------------------------------------------------------------------
-- SEMANA 10: SEGURANÇA (DCL)
--------------------------------------------------------------------------------

--==============================================================================
-- PARTE 1: CRIAÇÃO DE LOGINS NO NÍVEL DO SERVIDOR
--==============================================================================
PRINT 'Criando Logins para os perfis de usuário...';

IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_analista')
    CREATE LOGIN login_analista WITH PASSWORD = 'PasswordAnalista123!';
GO
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_engenheiro_etl')
    CREATE LOGIN login_engenheiro_etl WITH PASSWORD = 'PasswordEtl456!';
GO
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_leitor_bi')
    CREATE LOGIN login_leitor_bi WITH PASSWORD = 'PasswordLeitor789!';
GO

ALTER SERVER ROLE sysadmin ADD MEMBER login_engenheiro_etl;
GO

USE mortalidade;
GO
--==============================================================================
-- PARTE 2: CRIAÇÃO DAS ROLES (PERFIS DE ACESSO) NO BANCO DE DADOS
--==============================================================================
PRINT 'Criando Roles (perfis de acesso) no banco de dados mortalidade...';

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_analista' AND type = 'R')
    CREATE ROLE role_analista;
GO
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_engenheiro_etl' AND type = 'R')
    CREATE ROLE role_engenheiro_etl;
GO
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_leitor_bi' AND type = 'R')
    CREATE ROLE role_leitor_bi;
GO

--==============================================================================
-- PARTE 3: CONCESSÃO DE PERMISSÕES (GRANT) PARA CADA ROLE
--==============================================================================
PRINT 'Concedendo permissões para as Roles...';

-- (O restante das permissões permanece o mesmo, pois o erro estava na existência dos objetos)
GRANT SELECT ON SCHEMA :: dbo TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_1_1_distribuicao_demografica TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_1_2_escolaridade_vs_idade_morrer TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_1_3_top_causas_por_estado_civil TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_1_4_ocupacoes_acidente_trabalho TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_2_1_ranking_municipios_causas_violentas TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_2_2_percentual_obitos_fora_estab_saude TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_2_3_fluxo_obitos_intermunicipal TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_3_1_top10_causas_morte_por_perfil TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_3_2_relacao_assist_medica_causa TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_3_3_fonte_informacao_causas_violentas TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_4_1_relacao_escolaridade_mae_obito_fetal TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_4_2_correlacao_parto_momento_obito TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_4_3_distribuicao_peso_obitos_primeiro_ano TO role_analista;
GRANT EXECUTE ON OBJECT::sp_analise_4_4_perfil_maes_obitos_maternos TO role_analista;
GO

GRANT EXECUTE ON OBJECT::sp_ETL_municipios TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_ETL_cbo2002 TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_ETL_cid10 TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_ETL_obitos TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_crud_inserir_obito_simplificado TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_crud_atualizar_escolaridade_falecido TO role_engenheiro_etl;
GRANT EXECUTE ON OBJECT::sp_crud_deletar_obito TO role_engenheiro_etl;
GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA :: dbo TO role_engenheiro_etl;
GO

GRANT EXECUTE ON OBJECT::sp_analise_2_1_ranking_municipios_causas_violentas TO role_leitor_bi;
GRANT EXECUTE ON OBJECT::sp_analise_3_1_top10_causas_morte_por_perfil TO role_leitor_bi;
GO

--==============================================================================
-- PARTE 4: CRIAÇÃO DE USUÁRIOS E ASSOCIAÇÃO COM LOGINS E ROLES
--==============================================================================
PRINT 'Criando Usuários e associando aos Logins e Roles...';

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'usuario_analista')
    CREATE USER usuario_analista FOR LOGIN login_analista;
ALTER ROLE role_analista ADD MEMBER usuario_analista;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'usuario_engenheiro_etl')
    CREATE USER usuario_engenheiro_etl FOR LOGIN login_engenheiro_etl;
ALTER ROLE role_engenheiro_etl ADD MEMBER usuario_engenheiro_etl;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'usuario_leitor_bi')
    CREATE USER usuario_leitor_bi FOR LOGIN login_leitor_bi;
ALTER ROLE role_leitor_bi ADD MEMBER usuario_leitor_bi;
GO

PRINT 'Configuração de segurança concluída com sucesso!';
GO