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
	(6, '42 e + semanas');

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
