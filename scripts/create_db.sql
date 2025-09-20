IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'mortalidade')
BEGIN
    PRINT 'Banco de dados "mortalidade" não encontrado. Criando...';
    CREATE DATABASE mortalidade;
    PRINT 'Banco de dados "mortalidade" criado com sucesso.';
END
ELSE
BEGIN
    PRINT 'Banco de dados "mortalidade" já existe.';
END
GO

USE mortalidade;
GO

CREATE TABLE tipobito (
	id_tipobito TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE obito (
	id_obito INT PRIMARY KEY IDENTITY,
	id_tipobito TINYINT NOT NULL,

	dtobito DATE NOT NULL,
	horaobito TIME,

	CONSTRAINT FK_obito_tipobito FOREIGN KEY(id_tipobito)
	REFERENCES tipobito (id_tipobito)
);


CREATE TABLE tipo_linha (
	id_tipo_linha TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);


CREATE TABLE cid_causa (
	id_causa INT PRIMARY KEY IDENTITY,
	id_obito INT NOT NULL,
	id_tipo_linha TINYINT NOT NULL,

	cid_cod VARCHAR(45),
	causabas CHAR(4),
	causabas_original CHAR(4),
	cb_alt VARCHAR(10),

	CONSTRAINT FK_causa_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_causa_tipo_linha FOREIGN KEY(id_tipo_linha)
	REFERENCES tipo_linha (id_tipo_linha)
);

CREATE TABLE lococor (
	id_lococor TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE local_ocorrencia(
	id_obito INT PRIMARY KEY,
	id_lococor TINYINT NOT NULL,

	codestab CHAR(8),
	codmunocor CHAR(7) NOT NULL,

	CONSTRAINT FK_local_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_local_lococor FOREIGN KEY(id_lococor)
	REFERENCES lococor (id_lococor),

	CONSTRAINT CHK_local_EstabelecimentoObrigatorio CHECK (
        (id_lococor <> 1 AND id_lococor <> 2) OR codestab IS NOT NULL
    )

);

CREATE TABLE circobito (
	id_circobito TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE acidtrab (
	id_acidtrab TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE fonte (
	id_fonte TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE tpobitocor (
	id_tpobitocor TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE circunstancia_obito (
	id_obito INT PRIMARY KEY,
	id_circobito TINYINT,
	id_acidtrab TINYINT,
	id_fonte TINYINT,
	id_tpobitocor TINYINT,

	CONSTRAINT FK_circunstancia_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_circunstancia_circobito FOREIGN KEY(id_circobito)
	REFERENCES circobito (id_circobito),

	CONSTRAINT FK_circunstancia_acidtrab FOREIGN KEY(id_acidtrab)
	REFERENCES acidtrab (id_acidtrab),

	CONSTRAINT FK_circunstancia_fonte FOREIGN KEY(id_fonte)
	REFERENCES fonte (id_fonte),

	CONSTRAINT FK_circunstancia_tpobitocor FOREIGN KEY(id_tpobitocor)
	REFERENCES tpobitocor (id_tpobitocor)
);

CREATE TABLE esc2010 (
	id_esc2010 TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE esc (
	id_esc TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE escfalagr1 (
	id_escfalagr1 TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE escolaridade_falecido (
	id_escol INT PRIMARY KEY IDENTITY,
	id_esc2010 TINYINT,
	id_esc TINYINT,
	id_escfalagr1 TINYINT,
	seriescfal TINYINT,

	CONSTRAINT FK_escolaridade_esc2010 FOREIGN KEY(id_esc2010)
	REFERENCES esc2010 (id_esc2010),

	CONSTRAINT FK_escolaridade_esc FOREIGN KEY(id_esc)
	REFERENCES esc (id_esc),

	CONSTRAINT FK_escolaridade_escfalagr1 FOREIGN KEY(id_escfalagr1)
	REFERENCES escfalagr1 (id_escfalagr1)

);

CREATE TABLE municipio (
	cod_municipio CHAR(7) PRIMARY KEY,
	nome_municipio VARCHAR(60),
	uf CHAR(2)
);

CREATE TABLE idade_unidade (
    id_idade_unidade TINYINT PRIMARY KEY,
    descricao VARCHAR(20)
);

CREATE TABLE idade (
    id_idade INT PRIMARY KEY IDENTITY,
    id_idade_unidade TINYINT,
    quantidade INT,

    CONSTRAINT FK_idade_unidade FOREIGN KEY(id_idade_unidade) 
	REFERENCES idade_unidade(id_idade_unidade)
);

CREATE TABLE estado_civil (
	id_estciv TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE sexo (
	id_sexo TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE raca_cor (
	id_racacor TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE pessoa_falecida (
	id_obito INT PRIMARY KEY,
	codmunnatu CHAR(7),
	codmunres CHAR(7),
	id_escol INT,
	id_racacor TINYINT,
	id_estciv TINYINT,
	id_sexo TINYINT NOT NULL,
	id_idade INT,
	dtnasc DATE,
	ocup CHAR(6),
	natural VARCHAR(4),

	CONSTRAINT FK_pessoa_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_pessoa_municipio_natu FOREIGN KEY(codmunnatu)
	REFERENCES municipio (cod_municipio),

	CONSTRAINT FK_pessoa_municipio_res FOREIGN KEY(codmunres)
	REFERENCES municipio (cod_municipio),

	CONSTRAINT FK_pessoa_escol FOREIGN KEY(id_escol)
	REFERENCES escolaridade_falecido (id_escol),

	CONSTRAINT FK_pessoa_racacor FOREIGN KEY(id_racacor)
	REFERENCES raca_cor (id_racacor),

	CONSTRAINT FK_pessoa_estciv FOREIGN KEY(id_estciv)
	REFERENCES estado_civil (id_estciv),

	CONSTRAINT FK_pessoa_sexo FOREIGN KEY(id_sexo)
	REFERENCES sexo (id_sexo),

	CONSTRAINT FK_pessoa_idade FOREIGN KEY(id_idade)
	REFERENCES idade (id_idade)
);

CREATE TABLE escmae2010 (
	id_escmae2010 TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE escmae (
	id_escmae TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE escmaeagr1 (
	id_escmaeagr1 TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE escolaridade_mae (
	id_escol_mae INT PRIMARY KEY IDENTITY,
	id_escmae2010 TINYINT,
	id_escmae TINYINT,
	id_escmaeagr1 TINYINT,
	seriescmae TINYINT,

	CONSTRAINT FK_escolaridadeMae_escmae2010 FOREIGN KEY(id_escmae2010)
	REFERENCES escmae2010 (id_escmae2010),

	CONSTRAINT FK_escolaridadeMae_escmae FOREIGN KEY(id_escmae)
	REFERENCES escmae (id_escmae),

	CONSTRAINT FK_escolaridadeMae_escmaeagr1 FOREIGN KEY(id_escmaeagr1)
	REFERENCES escmaeagr1 (id_escmaeagr1),

	CONSTRAINT CHK_escolaridadeMae_SerieObrigatoria CHECK (
        NOT (id_escmae2010 IN (1, 2, 3) AND seriescmae IS NULL)
    )

);

CREATE TABLE gestacao (
	id_gestacao TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE gravidez (
	id_gravidez TINYINT PRIMARY KEY,
	tipo VARCHAR(50)
);

CREATE TABLE parto (
	id_parto TINYINT PRIMARY KEY,
	tipo VARCHAR(50)
);

CREATE TABLE obitoparto (
	id_obitoparto TINYINT PRIMARY KEY,
	momento VARCHAR(50)
);

CREATE TABLE tpmorteoco (
	id_tpmorteoco TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE obitograv (
	id_obitograv TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE obitopuerp (
	id_obitopuerp TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE morteparto (
	id_morteparto TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE mae (
	id_obito INT PRIMARY KEY,
	id_gestacao TINYINT,
	id_gravidez TINYINT,
	id_parto TINYINT,
	id_obitoparto TINYINT,
	id_tpmorteoco TINYINT,
	id_obitograv TINYINT,
	id_obitopuerp TINYINT,
	id_morteparto TINYINT,
	id_escol_mae INT,
	idademae TINYINT,
	ocupmae CHAR(6),
	qtdfilvivo TINYINT,
	qtdfilmorto TINYINT,
	semagestac TINYINT,
	peso SMALLINT,
	causamat VARCHAR(4),

	CONSTRAINT FK_mae_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_mae_gestacao FOREIGN KEY(id_gestacao)
	REFERENCES gestacao (id_gestacao),

	CONSTRAINT FK_mae_gravidez FOREIGN KEY(id_gravidez)
	REFERENCES gravidez (id_gravidez),

	CONSTRAINT FK_mae_parto FOREIGN KEY(id_parto)
	REFERENCES parto (id_parto),

	CONSTRAINT FK_mae_obitoparto FOREIGN KEY(id_obitoparto)
	REFERENCES obitoparto (id_obitoparto),

	CONSTRAINT FK_mae_tpmorteoco FOREIGN KEY(id_tpmorteoco)
	REFERENCES tpmorteoco (id_tpmorteoco),

	CONSTRAINT FK_mae_obitograv FOREIGN KEY(id_obitograv)
	REFERENCES obitograv (id_obitograv),

	CONSTRAINT FK_mae_obitopuerp FOREIGN KEY(id_obitopuerp)
	REFERENCES obitopuerp (id_obitopuerp),

	CONSTRAINT FK_mae_morteparto FOREIGN KEY(id_morteparto)
	REFERENCES morteparto (id_morteparto),

	CONSTRAINT FK_mae_escolaridadeMae FOREIGN KEY(id_escol_mae)
	REFERENCES escolaridade_mae (id_escol_mae)
);

CREATE TABLE necropsia (
	id_necropsia TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE exame (
	id_exame TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE cirurgia (
	id_cirurgia TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE atestante (
	id_atestante TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE assistmed (
	id_assistmed TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE atestado (
	id_obito INT PRIMARY KEY,
	id_necropsia TINYINT,
	id_exame TINYINT,
	id_cirurgia TINYINT,
	id_atestante TINYINT,
	id_assistmed TINYINT,

	dtatestado DATE,
	atestado VARCHAR(70),
	comunsvoim  CHAR(7),

	CONSTRAINT FK_atestado_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_atestado_necropsia FOREIGN KEY(id_necropsia)
	REFERENCES necropsia (id_necropsia),

	CONSTRAINT FK_atestado_exame FOREIGN KEY(id_exame)
	REFERENCES exame (id_exame),

	CONSTRAINT FK_atestado_cirurgia FOREIGN KEY(id_cirurgia)
	REFERENCES cirurgia (id_cirurgia),

	CONSTRAINT FK_atestado_atestante FOREIGN KEY(id_atestante)
	REFERENCES atestante (id_atestante),

	CONSTRAINT FK_atestado_assistmed FOREIGN KEY(id_assistmed)
	REFERENCES assistmed (id_assistmed),

);

CREATE TABLE fonteinv (
	id_fonteinv TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE tpresginfo (
	id_tpresginfo TINYINT PRIMARY KEY,
	descricao VARCHAR(75)
);

CREATE TABLE tpnivelinv (
	id_tpnivelinv CHAR(1) PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE altcausa (
	id_altcausa TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE stdoepidem (
	id_stdoepidem TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE stdonova (
	id_stdonova TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE tppos (
	id_tppos CHAR(1) PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE origem (
	id_origem TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE tp_altera (
	id_tp_altera TINYINT PRIMARY KEY,
	descricao VARCHAR(50)
);

CREATE TABLE info_sistema (
	id_obito INT PRIMARY KEY,
	id_fonteinv TINYINT,
	id_tpresginfo TINYINT,
	id_tpnivelinv CHAR(1),
	id_altcausa TINYINT,
	id_stdoepidem TINYINT,
	id_stdonova TINYINT,
	id_tppos CHAR(1),
	id_origem TINYINT,
	id_tp_altera TINYINT,

	numerolote VARCHAR(8),
	dtinvestig DATE,
	dtcadastro DATE,
	stcodifica CHAR(1),
	codificado CHAR(1),
	versaosist CHAR(7),
	versaoscb CHAR(7),
	dtrecebim DATE,
	dtrecoriga DATE,
	opor_do INT,
	difdata INT,
	nudiasobco INT,
	dtcadinv DATE,
	dtconinv DATE,
	fontentrev CHAR(1),
	fonteambul CHAR(1),
	fontepront CHAR(1),
	fontesvo CHAR(1),
	fonteiml CHAR(1),
	fonteprof CHAR(1),
	dtcadinf DATE,
	dtconcaso DATE,

	CONSTRAINT FK_info_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_info_fonteinv FOREIGN KEY(id_fonteinv)
	REFERENCES fonteinv (id_fonteinv),

	CONSTRAINT FK_info_tpresginfo FOREIGN KEY(id_tpresginfo)
	REFERENCES tpresginfo (id_tpresginfo),

	CONSTRAINT FK_info_tpnivelinv FOREIGN KEY(id_tpnivelinv)
	REFERENCES tpnivelinv (id_tpnivelinv),

	CONSTRAINT FK_info_altcausa FOREIGN KEY(id_altcausa)
	REFERENCES altcausa (id_altcausa),

	CONSTRAINT FK_info_stdoepidem FOREIGN KEY(id_stdoepidem)
	REFERENCES stdoepidem (id_stdoepidem),

	CONSTRAINT FK_info_tppos FOREIGN KEY(id_tppos)
	REFERENCES tppos (id_tppos),

	CONSTRAINT FK_info_origem FOREIGN KEY(id_origem)
	REFERENCES origem (id_origem),

	CONSTRAINT FK_info_tp_altera FOREIGN KEY(id_tp_altera)
	REFERENCES tp_altera (id_tp_altera)

);

INSERT INTO tipobito (id_tipobito, descricao)
VALUES
	(1, 'Fetal'),
	(2, 'Não Fetal');

INSERT INTO lococor (id_lococor, descricao)
VALUES
	(1, 'Hospital'),
	(2, 'Outros estabelecimentos de saúde'),
	(3, 'Domicilio'),
	(4, 'Via publica'),
	(5, 'Outros'),
	(6, 'Aldeia indigena'),
	(9, 'Ignorado');

INSERT INTO circobito (id_circobito, descricao)
VALUES
	(1, 'Acidente'),
	(2, 'Suicidio'),
	(3, 'Homicidio'),
	(4, 'Outros'),
	(9, 'Ignorado');

INSERT INTO acidtrab (id_acidtrab, descricao)
VALUES
	(1, 'Sim'),
	(2, 'Não'),
	(9, 'Ignorado');

INSERT INTO fonte (id_fonte, descricao)
VALUES
	(1, 'Ocorrencia Policial'),
	(2, 'Hospital'),
	(3, 'Familia'),
	(4, 'Outra'),
	(9, 'Ignorado');

INSERT INTO tpobitocor (id_tpobitocor, descricao)
VALUES
	(1, 'Via Publica'),
	(2, 'Endereço de residencia'),
	(3, 'Outro domicilio'),
	(4, 'Estabelecimento comercial'),
	(5, 'Outros'),
	(9, 'Ignorada');

INSERT INTO estado_civil (id_estciv, descricao) 
VALUES 
	(1, 'Solteiro'), 
	(2, 'Casado'), 
	(3, 'Viúvo'), 
	(4, 'Separado judicialmente/divorciado'),
	(5, 'União estável'), 
	(9, 'Ignorado'); 

INSERT INTO sexo ( id_sexo, descricao)
VALUES 
	(1, 'Masculino'),
	(2, 'Feminino'), 
	(0, 'Ignorado'),
	(9, 'Ignorado');


INSERT INTO raca_cor ( id_racacor, descricao)
VALUES 
	(1, 'Branca'),
    (2, 'Preta'), 
    (3, 'Amarela'),
    (4, 'Parda'), 
    (5, 'Indígena'), 
    (9, 'Ignorado');

INSERT INTO esc2010 (id_esc2010, descricao)
VALUES
	(0, 'Sem escolaridade'),
	(1, 'Fundamental I (1ª a 4ª série)'),
	(2, 'Fundamental II (5ª a 8ª série)'),
	(3, 'Médio (antigo 2º Grau)'),
	(4, 'Superior incompleto'),
	(5, 'Superior completo'),
	(9, 'Ignorado');


INSERT INTO esc (id_esc, descricao)
VALUES
	(1, 'Nenhuma'),
	(2, 'de 1 a 3 anos'),
	(3, 'de 4 a 7 anos'),
	(4, 'de 8 a 11 anos'),
	(5, '12 anos e mais'),
	(9, 'Ignorado');
	
INSERT INTO escfalagr1 (id_escfalagr1, descricao)
VALUES
	(00, 'Sem Escolaridade'),
	(01, 'Fundamental I Incompleto'),
	(02, 'Fundamental I Completo'),
	(03, 'Fundamental II Incompleto'),
	(04, 'Fundamental II Completo'), 
	(05, 'Ensino Médio Incompleto'),
	(06, 'Ensino Médio Completo'),
	(07, 'Superior Incompleto'),
	(08, 'Superior Completo'),
	(09, 'Ignorado'),
	(10, 'Fundamental I Incompleto ou Inespecífico'),
	(11, 'Fundamental II Incompleto ou Inespecífico'),
	(12, 'Ensino Médio Incompleto ou Inespecífico');

INSERT INTO gestacao (id_gestacao, descricao)
VALUES
	(1, 'Menos de 22 semanas'),
	(2, '22 a 27 semanas'),
	(3, '28 a 31 semanas'),
	(4, '32 a 36 semana'),
	(5, '37 a 41 semanas'),
	(6, '42 e + semanas'),
	(9, 'Ignorado');

INSERT INTO gravidez (id_gravidez, tipo)
VALUES
	(1, 'única'),
	(2, 'dupla'),
	(3, 'tripla e mais'),
	(9, 'ignorada');

INSERT INTO parto (id_parto, tipo)
VALUES
	(1, 'vaginal'),
	(2, 'cesáreo'),
	(9, 'ignorado');

INSERT INTO obitoparto (id_obitoparto, momento)
VALUES
	(1, 'antes'),
	(2, 'durante'),
	(3, 'depois'),
	(9, 'ignorado');

INSERT INTO tpmorteoco (id_tpmorteoco, descricao)
VALUES
	(1, 'na gravidez'),
	(2, 'no parto'), 
	(3, 'no abortamento'),
	(4, 'até 42 dias após o término do parto'),
	(5, 'de 43 dias a 1 ano após o término da gestação'),
	(8, 'não ocorreu nestes períodos'),
	(9, 'ignorado');

INSERT INTO obitograv (id_obitograv, descricao)
VALUES 
	(1, 'sim'),
	(2, 'não'),
	(9, 'ignorado');


INSERT INTO obitopuerp (id_obitopuerp, descricao)
VALUES
	(1, 'Sim, até 42 dias após o parto'),
	(2, 'Sim, de 43 dias a 1 ano'),
	(3, 'Não'),
	(9, 'Ignorado');

INSERT INTO morteparto (id_morteparto, descricao)
VALUES
	(1, 'antes'),
	(2, 'durante'),
	(3, 'após'), 
	(9, 'Ignorado');

INSERT INTO escmae2010 (id_escmae2010, descricao)
VALUES
	(0, 'Sem escolaridade'),
	(1, 'Fundamental I (1ª a 4ª série)'),
	(2, 'Fundamental II (5ª a 8ª série)'),
	(3, 'Médio (antigo 2º Grau)'),
	(4, 'Superior incompleto'),
	(5, 'Superior completo'),
	(9, 'Ignorado');


INSERT INTO escmae (id_escmae, descricao)
VALUES
	(1, 'Nenhuma'),
	(2, 'de 1 a 3 anos'),
	(3, 'de 4 a 7 anos'),
	(4, 'de 8 a 11 anos'),
	(5, '12 anos e mais'),
	(9, 'Ignorado');
	
INSERT INTO escmaeagr1 (id_escmaeagr1, descricao)
VALUES
	(00, 'Sem Escolaridade'),
	(01, 'Fundamental I Incompleto'),
	(02, 'Fundamental I Completo'),
	(03, 'Fundamental II Incompleto'),
	(04, 'Fundamental II Completo'), 
	(05, 'Ensino Médio Incompleto'),
	(06, 'Ensino Médio Completo'),
	(07, 'Superior Incompleto'),
	(08, 'Superior Completo'),
	(09, 'Ignorado'),
	(10, 'Fundamental I Incompleto ou Inespecífico'),
	(11, 'Fundamental II Incompleto ou Inespecífico'),
	(12, 'Ensino Médio Incompleto ou Inespecífico');

INSERT INTO assistmed (id_assistmed, descricao)
VALUES 
	(1, 'Sim'), 
	(2, 'Não'), 
	(9, 'Ignorado');

INSERT INTO necropsia ( id_necropsia, descricao) 
VALUES 
	(1, 'Sim'), 
	(2, 'Não'), 
	(9, 'Ignorado');

INSERT INTO exame (id_exame, descricao ) 
VALUES 
	(1, 'Sim'), 
	(2, 'Não'),
	(9, 'Ignorado'); 

INSERT INTO cirurgia (id_cirurgia, descricao) 
VALUES 
	(1, 'Sim'), 
	(2, 'Não'), 
	(9, 'Ignorado');


INSERT INTO atestante (id_atestante, descricao) 
VALUES 
	(1, 'Assistente'), 
	(2, 'Substituto'),
	(3, 'IML'), 
	(4, 'SVO'), 
	(5, 'Outro');

INSERT INTO altcausa (id_altcausa, descricao)
VALUES
	(1, 'Sim'), 
	(2, 'Não');

INSERT INTO stdoepidem (id_stdoepidem, descricao) 
VALUES 
	(1, 'Sim'),
	(0, 'Não');

INSERT INTO stdonova (id_stdonova, descricao)
VALUES 
	(1, 'Sim'), 
	(0, 'Não');

INSERT INTO fonteinv (id_fonteinv, descricao)
VALUES 
	(1, ' Comitê de Morte Materna e/ou Infantil'), 
	(2, 'Visita domiciliar / Entrevista família'), 
	(3, 'Estabelecimento de Saúde / Prontuário'), 
	(4, 'Relacionado com outros bancos de dados'), 
	(5, 'SVO'), 
	(6, 'IML'), 
	(7, 'Outra fonte'), 
	(8, 'Múltiplas fontes'), 
	(9, 'ignorado');

INSERT INTO tpresginfo (id_tpresginfo, descricao)
VALUES 
	(1, 'Não acrescentou nem corrigiu informação'), 
	(2, 'Sim, permitiu o resgate de novas informações'),
	(3, 'Sim, permitiu a correção de alguma das causas informadas originalmente');

INSERT INTO tpnivelinv (id_tpnivelinv, descricao)
VALUES 
	('E', 'Estadual'), 
	('R', 'Regional'), 
	('M', 'Municipal');

INSERT INTO tppos (id_tppos, descricao)
VALUES 
	('S', 'Sim'), 
	('N', 'Não');

INSERT INTO origem (id_origem, descricao)
VALUES 
	(1, 'Oracle'), 
	(2, 'Banco estadual diponibilizado via FTP'), 
	(3, 'Banco SEADE'), 
	(9, 'Ignorado');

INSERT INTO tp_altera (id_tp_altera, descricao)
VALUES 
	(02, 'CausaBas em branco'), 
	(03, 'CausaBas com ausência do 4 caractere'), 
	(04, 'Causas Asterisco'), 
	(05, 'CID não pode ser CausaBas'), 
	(06, 'CausaBas inválida para o Sexo Feminino'), 
	(07, 'CausaBas inválida para o Sexo Masculino'), 
	(08, 'CID Implausíveis'), 
	(09, 'Causas Erradicadas ou Causa U'), 
	(10, 'Causas Triviais'), 
	(11, 'Causas Improváveis'), 
	(12, 'Óbito Não Fetal com causa Fetal'), 
	(13, 'Óbito Fetal com causa Não Fetal'), 
	(14, 'Óbito Materno duvidoso'), 
	(15, 'Óbito possível de ser materno'), 
	(16, 'Óbito com restrição de idade (TP_MSG_5)'), 
	(17, 'Óbito com restrição de idade (TP_MSG_6)');

INSERT INTO tipo_linha (id_tipo_linha, descricao)
VALUES
	(1, 'LINHAA'),
	(2, 'LINHAB'),
	(3, 'LINHAC'),
	(4, 'LINHAD'),
	(5, 'LINHAII');

INSERT INTO idade_unidade (id_idade_unidade, descricao) VALUES
(1, 'Minutos'),
(2, 'Horas'),
(3, 'Dias'),
(4, 'Anos'),
(5, 'Anos (mais de 100)'),
(0, 'Indefinido'),
(9, 'Ignorado');
