/*
================================================================================
SCRIPT PARA CONSULTA DAS TABELAS DE DOMÍNIO
================================================================================
Este script executa um SELECT em todas as tabelas de domínio (lookup tables)
para exibir os valores de referência (ID vs. Descrição).

Para tabelas grandes, é exibida uma amostra das primeiras 100 linhas.
*/

USE mortalidade;
GO

--------------------------------------------------------------------------------
-- TABELAS DE DOMÍNIO PRINCIPAIS (GRANDES - AMOSTRA)
--------------------------------------------------------------------------------

-- Tabela: municipio (Amostra das primeiras 100 linhas)
PRINT 'Consultando: municipio (amostra)';
SELECT TOP 100 * FROM municipio;
GO

-- Tabela: cbo2002 (Amostra das primeiras 100 linhas)
PRINT 'Consultando: cbo2002 (amostra)';
SELECT TOP 100 * FROM cbo2002;
GO

-- Tabela: cid10_subcategorias (Amostra das primeiras 100 linhas)
PRINT 'Consultando: cid10_subcategorias (amostra)';
SELECT TOP 100 * FROM cid10_subcategorias;
GO

--------------------------------------------------------------------------------
-- DEMAIS TABELAS DE DOMÍNIO (PEQUENAS)
--------------------------------------------------------------------------------

PRINT 'Consultando demais tabelas de domínio...';
GO

-- Tabela: tipobito
SELECT * FROM tipobito;
GO

-- Tabela: lococor
SELECT * FROM lococor;
GO

-- Tabela: circobito
SELECT * FROM circobito;
GO

-- Tabela: acidtrab
SELECT * FROM acidtrab;
GO

-- Tabela: fonte
SELECT * FROM fonte;
GO

-- Tabela: tpobitocor
SELECT * FROM tpobitocor;
GO

-- Tabela: estado_civil
SELECT * FROM estado_civil;
GO

-- Tabela: sexo
SELECT * FROM sexo;
GO

-- Tabela: raca_cor
SELECT * FROM raca_cor;
GO

-- Tabela: esc2010
SELECT * FROM esc2010;
GO

-- Tabela: esc
SELECT * FROM esc;
GO

-- Tabela: escfalagr1
SELECT * FROM escfalagr1;
GO

-- Tabela: idade_unidade
SELECT * FROM idade_unidade;
GO

-- Tabela: escmae2010
SELECT * FROM escmae2010;
GO

-- Tabela: escmae
SELECT * FROM escmae;
GO

-- Tabela: escmaeagr1
SELECT * FROM escmaeagr1;
GO

-- Tabela: gestacao
SELECT * FROM gestacao;
GO

-- Tabela: gravidez
SELECT * FROM gravidez;
GO

-- Tabela: parto
SELECT * FROM parto;
GO

-- Tabela: obitoparto
SELECT * FROM obitoparto;
GO

-- Tabela: tpmorteoco
SELECT * FROM tpmorteoco;
GO

-- Tabela: obitograv
SELECT * FROM obitograv;
GO

-- Tabela: obitopuerp
SELECT * FROM obitopuerp;
GO

-- Tabela: morteparto
SELECT * FROM morteparto;
GO

-- Tabela: necropsia
SELECT * FROM necropsia;
GO

-- Tabela: exame
SELECT * FROM exame;
GO

-- Tabela: cirurgia
SELECT * FROM cirurgia;
GO

-- Tabela: atestante
SELECT * FROM atestante;
GO

-- Tabela: assistmed
SELECT * FROM assistmed;
GO

-- Tabela: fonteinv
SELECT * FROM fonteinv;
GO

-- Tabela: tpresginfo
SELECT * FROM tpresginfo;
GO

-- Tabela: tpnivelinv
SELECT * FROM tpnivelinv;
GO

-- Tabela: altcausa
SELECT * FROM altcausa;
GO

-- Tabela: stdoepidem
SELECT * FROM stdoepidem;
GO

-- Tabela: stdonova
SELECT * FROM stdonova;
GO

-- Tabela: tppos
SELECT * FROM tppos;
GO

-- Tabela: origem
SELECT * FROM origem;
GO

-- Tabela: tp_altera
SELECT * FROM tp_altera;
GO

-- Tabela: tipo_linha
SELECT * FROM tipo_linha;
GO