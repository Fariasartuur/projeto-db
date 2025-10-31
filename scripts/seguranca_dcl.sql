/*
================================================================================
SCRIPT DE SEGURANÇA (DCL) - SEMANA 10
================================================================================
Este script implementa a estratégia de segurança exigida.
Ele cria:
1. LOGINS: (Nível de Servidor) Para autenticação.
2. ROLES: (Nível de Banco) Para agrupar permissões (os "perfis").
3. USERS: (Nível de Banco) Para mapear os logins ao banco de dados.

Os perfis são baseados nos papéis da apresentação final:
- Arquiteto de Dados 
- Engenheiro de Dados 
- Analista de Dados 
================================================================================
*/

--==============================================================================
-- ETAPA 1: CRIAÇÃO DOS LOGINS (NÍVEL DE SERVIDOR)
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
    PRINT 'Login "login_arquiteto" já existe.';

-- Cria o login para o Engenheiro de Dados
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_engenheiro')
BEGIN
    CREATE LOGIN login_engenheiro WITH PASSWORD = 'SenhaComplexa123!';
    PRINT 'Login "login_engenheiro" criado.';
END
ELSE
    PRINT 'Login "login_engenheiro" já existe.';

-- Cria o login para o Analista de Dados
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'login_analista')
BEGIN
    CREATE LOGIN login_analista WITH PASSWORD = 'SenhaComplexa123!';
    PRINT 'Login "login_analista" criado.';
END
ELSE
    PRINT 'Login "login_analista" já existe.';
GO


--==============================================================================
-- ETAPA 2: CRIAÇÃO DAS ROLES E PERMISSÕES (NÍVEL DE BANCO)
--==============================================================================
-- Mudar para o contexto do banco de dados do projeto
USE mortalidade;
GO

PRINT 'Etapa 2: Criando Roles e definindo permissões no banco "mortalidade"...';

-- --- 2.1: Role 'role_arquiteto_dados' ---
-- O Arquiteto valida a estrutura e o modelo. 
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_arquiteto_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_arquiteto_dados;
    PRINT 'Role "role_arquiteto_dados" criada.';
END

-- Conforme solicitado: Permissão de SELECT em todas as tabelas (e views)
-- Isso permite que ele valide os dados e a estrutura sem poder modificar.
GRANT SELECT ON SCHEMA::dbo TO role_arquiteto_dados;
PRINT 'Permissão "SELECT" concedida para "role_arquiteto_dados".';
GO

-- --- 2.2: Role 'role_engenheiro_dados' ---
-- O Engenheiro executa o ETL (Extração, Transformação e Carga). [cite: 146, 148]
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_engenheiro_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_engenheiro_dados;
    PRINT 'Role "role_engenheiro_dados" criada.';
END

-- Permissão para LER, INSERIR, ATUALIZAR e APAGAR dados nas tabelas.
-- Necessário para que as Stored Procedures de ETL (que ele executará)
-- possam carregar os dados. 
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO role_engenheiro_dados;

-- Permissão para EXECUTAR as Stored Procedures de ETL. 
GRANT EXECUTE ON OBJECT::sp_ETL_obitos TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_cid10 TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_municipios TO role_engenheiro_dados;
GRANT EXECUTE ON OBJECT::sp_ETL_cbo2002 TO role_engenheiro_dados;
PRINT 'Permissões de DML e EXECUTE (ETL) concedidas para "role_engenheiro_dados".';
GO

-- --- 2.3: Role 'role_analista_dados' ---
-- O Analista consome os dados e executa as análises. 
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'role_analista_dados' AND type = 'R')
BEGIN
    CREATE ROLE role_analista_dados;
    PRINT 'Role "role_analista_dados" criada.';
END

-- Implementação do "Princípio do Menor Privilégio" 
-- 1. Nega explicitamente qualquer permissão de escrita (DML).
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO role_analista_dados;

-- 2. Concede permissão de LEITURA (SELECT) nas Views e Tabelas.
GRANT SELECT ON SCHEMA::dbo TO role_analista_dados;

-- 3. Concede permissão para EXECUTAR apenas as Stored Procedures analíticas. 
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
PRINT 'Permissões de Analista (DENY DML, GRANT SELECT, GRANT EXECUTE Analíticas) concedidas.';
GO


--==============================================================================
-- ETAPA 3: CRIAÇÃO DOS USERS E ASSOCIAÇÃO ÀS ROLES
--==============================================================================
PRINT 'Etapa 3: Mapeando Logins para Users e adicionando-os às Roles...';

-- Cria o USUÁRIO 'user_arquiteto' no banco 'mortalidade' e o liga ao 'login_arquiteto'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_arquiteto')
BEGIN
    CREATE USER user_arquiteto FOR LOGIN login_arquiteto;
    PRINT 'User "user_arquiteto" criado.';
END
-- Adiciona o usuário à sua respectiva role
ALTER ROLE role_arquiteto_dados ADD MEMBER user_arquiteto;
PRINT '"user_arquiteto" adicionado à "role_arquiteto_dados".';


-- Cria o USUÁRIO 'user_engenheiro' no banco 'mortalidade' e o liga ao 'login_engenheiro'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_engenheiro')
BEGIN
    CREATE USER user_engenheiro FOR LOGIN login_engenheiro;
    PRINT 'User "user_engenheiro" criado.';
END
-- Adiciona o usuário à sua respectiva role
ALTER ROLE role_engenheiro_dados ADD MEMBER user_engenheiro;
PRINT '"user_engenheiro" adicionado à "role_engenheiro_dados".';


-- Cria o USUÁRIO 'user_analista' no banco 'mortalidade' e o liga ao 'login_analista'
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'user_analista')
BEGIN
    CREATE USER user_analista FOR LOGIN login_analista;
    PRINT 'User "user_analista" criado.';
END
-- Adiciona o usuário à sua respectiva role
ALTER ROLE role_analista_dados ADD MEMBER user_analista;
PRINT '"user_analista" adicionado à "role_analista_dados".';
GO

PRINT '================================================================================';
PRINT 'Estratégia de segurança (DCL) concluída com sucesso!';
PRINT '================================================================================';