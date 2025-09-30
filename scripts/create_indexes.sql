USE mortalidade
GO

-- �ndices para acelerar os JOINs com a tabela pessoa_falecida
CREATE INDEX IX_pessoa_falecida_id_sexo ON pessoa_falecida(id_sexo);
CREATE INDEX IX_pessoa_falecida_id_racacor ON pessoa_falecida(id_racacor);
CREATE INDEX IX_pessoa_falecida_id_idade ON pessoa_falecida(id_idade);
CREATE INDEX IX_pessoa_falecida_codmunres ON pessoa_falecida(codmunres);
CREATE INDEX IX_pessoa_falecida_ocup ON pessoa_falecida(ocup);

-- �ndices para acelerar os JOINs com a tabela local_ocorrencia
CREATE INDEX IX_local_ocorrencia_codmunocor ON local_ocorrencia(codmunocor);
CREATE INDEX IX_local_ocorrencia_id_lococor ON local_ocorrencia(id_lococor);

-- �ndices para a tabela de circunst�ncia do �bito (muito usada em filtros)
CREATE INDEX IX_circunstancia_obito_id_circobito ON circunstancia_obito(id_circobito);
CREATE INDEX IX_circunstancia_obito_id_acidtrab ON circunstancia_obito(id_acidtrab);

-- �ndice para a tabela de causas (essencial para agrupar por causa b�sica)
CREATE INDEX IX_cid_causa_causabas ON cid_causa(causabas);

-- �ndices para a tabela mae (usada nas an�lises materno-infantil)
CREATE INDEX IX_mae_id_escol_mae ON mae(id_escol_mae);
CREATE INDEX IX_mae_id_tpmorteoco ON mae(id_tpmorteoco);

CREATE INDEX IX_idade_id_idade_unidade ON idade(id_idade_unidade);
GO