/*
================================================================================
SCRIPT DE SEGURAN�A (DCL) - SEMANA 10
================================================================================
Este script implementa a estrat�gia de seguran�a exigida.
Ele cria:
1. LOGINS: (N�vel de Servidor) Para autentica��o.
2. ROLES: (N�vel de Banco) Para agrupar permiss�es (os "perfis").
3. USERS: (N�vel de Banco) Para mapear os logins ao banco de dados.

Os perfis s�o baseados nos pap�is da apresenta��o final:
- Arquiteto de Dados 
- Engenheiro de Dados 
- Analista de Dados 
================================================================================
*/

--==============================================================================
-- ETAPA 1: CRIA��O DOS LOGINS (N�VEL DE SERVIDOR)
--==============================================================================
-- Deve ser executado no banco de dados 'master'
USE master;
GO

PRINT 'Etapa 1: Criando Logins no Servidor...';

-- Cria o login para o Arquiteto de Dados
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_arquiteto')
BEGIN
    CREATE LOGIN login_arquiteto WITH PASSWORD = 'SenhaComplexa123!';
    PRINT 'Login "login_arquiteto" criado.';
END
ELSE
    PRINT 'Login "login_arquiteto" j� existe.';

-- Cria o login para o Engenheiro de Dados
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_engenheiro')
BEGIN
    CREATE LOGIN login_engenheiro WITH PASSWORD = 'SenhaComplexa123!';
    PRINT 'Login "login_engenheiro" criado.';
END
ELSE
    PRINT 'Login "login_engenheiro" j� existe.';

-- Cria o login para o Analista de Dados
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_analista')
BEGIN
    CREATE LOGIN login_analista WITH PASSWORD = 'SenhaComplexa123!';
    PRINT 'Login "login_analista" criado.';
END
ELSE
    PRINT 'Login "login_analista" j� existe.';
GO


--==============================================================================
-- ETAPA 2: CRIA��O DAS ROLES E PERMISS�ES (N�VEL DE BANCO)
--==============================================================================
-- Mudar para o contexto do banco de dados do projeto
USE mortalidade;
GO

PRINT 'Etapa 2: Criando Roles e definindo permiss�es no banco "mortalidade"...';

-- --- 2.1: Role 'role_arquiteto_dados' ---
-- O Arquiteto valida a estrutura e o modelo. 
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_arquiteto_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_arquiteto_dados;
    PRINT 'Role "role_arquiteto_dados" criada.';
END

-- Conforme solicitado: Permiss�o de SELECT em todas as tabelas (e views)
-- Isso permite que ele valide os dados e a estrutura sem poder modificar.
GRANT SELECT ON SCHEMA::dbo TO role_arquiteto_dados;
PRINT 'Permiss�o "SELECT" concedida para "role_arquiteto_dados".';
GO

-- --- 2.2: Role 'role_engenheiro_dados' ---
-- O Engenheiro executa o ETL (Extra��o, Transforma��o e Carga). [cite: 146, 148]
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_engenheiro_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_engenheiro_dados;
    PRINT 'Role "role_engenheiro_dados" criada.';
END

-- Permiss�o para LER, INSERIR, ATUALIZAR e APAGAR dados nas tabelas.
-- Necess�rio para que as Stored Procedures de ETL (que ele executar�)
-- possam carregar os dados. 
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO role_engenheiro_dados;

-- Permiss�o para EXECUTAR as Stored Procedures de ETL. 
GRANT EXECUTE ON OBJECT::sp_ETL_obitos TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_cid10 TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_municipios TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_cbo2002 TO role_engenheiro_dados;
PRINT 'Permiss�es de DML e EXECUTE (ETL) concedidas para "role_engenheiro_dados".';
GO

-- --- 2.3: Role 'role_analista_dados' ---
-- O Analista consome os dados e executa as an�lises. 
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_analista_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_analista_dados;
    PRINT 'Role "role_analista_dados" criada.';
END

-- Implementa��o do "Princ�pio do Menor Privil�gio" 
-- 1. Nega explicitamente qualquer permiss�o de escrita (DML).
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO role_analista_dados;

-- 2. Concede permiss�o de LEITURA (SELECT) nas Views e Tabelas.
GRANT SELECT ON SCHEMA::dbo TO role_analista_dados;

-- 3. Concede permiss�o para EXECUTAR apenas as Stored Procedures anal�ticas. 
GRANT EXECUTE ON OBJECT::sp_1_1_distribuicao_obitos_perfil_demografico TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_1_2_correlacao_escolaridade_idade_morrer TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_1_3_top3_causas_morte_estado_civil TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_1_4_ocupacoes_obitos_acidente_trabalho TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_2_1_ranking_municipios_causas_violentas TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_2_2_percentual_obitos_fora_estab_saude TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_2_3_fluxo_obitos_residencia_ocorrencia TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_3_1_top10_causas_morte_faixa_etaria_sexo TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_3_2_relacao_assistencia_medica_causa_morte TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_3_3_fonte_informacao_causas_violentas TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_4_1_relacao_escolaridade_mae_obito_fetal TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_4_2_correlacao_parto_momento_obito TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_4_3_distribuicao_peso_obitos_primeiro_ano TO role_analista_dados;
GRANT EXECUTE ON OBJECT::sp_4_4_perfil_maes_obitos_maternos TO role_analista_dados;
PRINT 'Permiss�es de Analista (DENY DML, GRANT SELECT, GRANT EXECUTE Anal�ticas) concedidas.';
GO


--==============================================================================
-- ETAPA 3: CRIA��O DOS USERS E ASSOCIA��O �S ROLES
--==============================================================================
PRINT 'Etapa 3: Mapeando Logins para Users e adicionando-os �s Roles...';

-- Cria o USU�RIO 'user_arquiteto' no banco 'mortalidade' e o liga ao 'login_arquiteto'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_arquiteto')
BEGIN
    CREATE USER user_arquiteto FOR LOGIN login_arquiteto;
    PRINT 'User "user_arquiteto" criado.';
END
-- Adiciona o usu�rio � sua respectiva role
ALTER ROLE role_arquiteto_dados ADD MEMBER user_arquiteto;
PRINT '"user_arquiteto" adicionado � "role_arquiteto_dados".';


-- Cria o USU�RIO 'user_engenheiro' no banco 'mortalidade' e o liga ao 'login_engenheiro'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_engenheiro')
BEGIN
    CREATE USER user_engenheiro FOR LOGIN login_engenheiro;
    PRINT 'User "user_engenheiro" criado.';
END
-- Adiciona o usu�rio � sua respectiva role
ALTER ROLE role_engenheiro_dados ADD MEMBER user_engenheiro;
PRINT '"user_engenheiro" adicionado � "role_engenheiro_dados".';


-- Cria o USU�RIO 'user_analista' no banco 'mortalidade' e o liga ao 'login_analista'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_analista')
BEGIN
    CREATE USER user_analista FOR LOGIN login_analista;
    PRINT 'User "user_analista" criado.';
END
-- Adiciona o usu�rio � sua respectiva role
ALTER ROLE role_analista_dados ADD MEMBER user_analista;
PRINT '"user_analista" adicionado � "role_analista_dados".';
GO

PRINT '================================================================================';
PRINT 'Estrat�gia de seguran�a (DCL) conclu�da com sucesso!';
PRINT '================================================================================';