USE mortalidade;

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
	id_causa INT PRIMARY KEY,
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
	codmunocor CHAR(8) NOT NULL,

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
	id_escol TINYINT PRIMARY KEY,
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

CREATE TABLE naturalidade(
	codmunnatu CHAR(7) PRIMARY KEY,
	nome_municipio VARCHAR(60),
	uf CHAR(2),
	natural VARCHAR(4)
);

CREATE TABLE municipio_res (
	codmunres CHAR(7) PRIMARY KEY,
	nome_municipio VARCHAR(60),
	uf CHAR(2)
);

CREATE TABLE idade (
	id_idade TINYINT PRIMARY KEY,
	quantidade INT
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
	codmunres CHAR(7) NOT NULL,
	id_escol TINYINT,
	id_racacor TINYINT,
	id_estciv TINYINT,
	id_sexo TINYINT NOT NULL,
	id_idade TINYINT,

	dtnasc DATE,
	ocup CHAR(6),

	CONSTRAINT FK_pessoa_obito FOREIGN KEY(id_obito)
	REFERENCES obito (id_obito),

	CONSTRAINT FK_pessoa_codmunnatu FOREIGN KEY(codmunnatu)
	REFERENCES naturalidade (codmunnatu),

	CONSTRAINT FK_pessoa_codmunres FOREIGN KEY(codmunres)
	REFERENCES municipio_res (codmunres),

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
	id_escol_mae TINYINT PRIMARY KEY,
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
	id_escol_mae TINYINT,
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

	dtatestado DATE NOT NULL,
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

	CONSTRAINT CHK_Comunsvoim_Obrigatorio CHECK (
        (id_atestante NOT IN (3, 4)) OR comunsvoim IS NOT NULL
    )
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