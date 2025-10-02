USE mortalidade
GO

IF OBJECT_ID('trg_Valida_vw_ObitoCompleto', 'TR') IS NOT NULL
    DROP TRIGGER trg_Valida_vw_ObitoCompleto;
GO

CREATE TRIGGER trg_Valida_vw_ObitoCompleto
ON vw_ObitoCompleto
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Validação (Aplica-se apenas para INSERT e UPDATE)
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Validação de idade: SÓ aplica a regra de 0-130 se a unidade for ANOS (4).
        IF EXISTS (SELECT 1 FROM inserted WHERE id_idade_unidade = 4 AND (idade_quantidade < 0 OR idade_quantidade > 130))
        BEGIN
            RAISERROR ('Para idade em anos (unidade 4), o valor deve estar entre 0 e 130.', 16, 1);
            RETURN;
        END

        -- Validação de data
        IF EXISTS (SELECT 1 FROM inserted WHERE dtobito < dtnasc)
        BEGIN
            RAISERROR ('Data do óbito não pode ser anterior à data de nascimento.', 16, 1);
            RETURN;
        END
    END

    -- CASO 1: UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Atualiza obito e pessoa_falecida
        UPDATE o SET o.id_tipobito = i.id_tipobito, o.dtobito = i.dtobito, o.horaobito = i.horaobito FROM obito o JOIN inserted i ON o.id_obito = i.id_obito;
        UPDATE pf SET pf.dtnasc = i.dtnasc, pf.id_sexo = i.id_sexo, pf.id_estciv = i.id_estciv, pf.id_racacor = i.id_racacor, pf.codmunres = i.codmunres, pf.ocup = i.ocup, pf.id_escol = i.id_escol FROM pessoa_falecida pf JOIN inserted i ON pf.id_obito = i.id_obito;

        UPDATE id
        SET
            id.quantidade = i.idade_quantidade,
            id.id_idade_unidade = i.id_idade_unidade
        FROM idade id
        JOIN pessoa_falecida pf ON id.id_idade = pf.id_idade
        JOIN inserted i ON pf.id_obito = i.id_obito;
    END

    -- CASO 2: DELETE
    ELSE IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT DISTINCT pf.id_idade, pf.id_escol INTO #IdsParaVerificar FROM pessoa_falecida pf JOIN deleted d ON pf.id_obito = d.id_obito;
        DELETE cid FROM cid_causa cid JOIN deleted d ON cid.id_obito = d.id_obito;
        DELETE mae FROM mae mae JOIN deleted d ON mae.id_obito = d.id_obito;
        DELETE pf FROM pessoa_falecida pf JOIN deleted d ON pf.id_obito = d.id_obito;
        DELETE loc FROM local_ocorrencia loc JOIN deleted d ON loc.id_obito = d.id_obito;
        DELETE cir FROM circunstancia_obito cir JOIN deleted d ON cir.id_obito = d.id_obito;
        DELETE ate FROM atestado ate JOIN deleted d ON ate.id_obito = d.id_obito;
        DELETE inf FROM info_sistema inf JOIN deleted d ON inf.id_obito = d.id_obito;
        DELETE o FROM obito o JOIN deleted d ON o.id_obito = d.id_obito;

        DELETE i FROM idade i 
        JOIN #IdsParaVerificar temp ON i.id_idade = temp.id_idade 
        WHERE NOT EXISTS 
            (SELECT 1 FROM pessoa_falecida pf WHERE pf.id_idade = i.id_idade);

        DELETE ef FROM escolaridade_falecido ef 
        JOIN #IdsParaVerificar temp ON ef.id_escol = temp.id_escol 
        WHERE NOT EXISTS 
            (SELECT 1 FROM pessoa_falecida pf WHERE pf.id_escol = ef.id_escol);
    END

    -- CASO 3: INSERT
    ELSE IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 from deleted)
    BEGIN
        DECLARE @IdMap TABLE (temp_id INT IDENTITY PRIMARY KEY, new_obito_id INT, new_idade_id INT, new_escol_id INT);
        SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as temp_id INTO #inserted_temp FROM inserted;
        
        INSERT INTO idade (id_idade_unidade, quantidade)
        OUTPUT inserted.id_idade, t.temp_id INTO @IdMap (new_idade_id, temp_id)
        SELECT t.id_idade_unidade, t.idade_quantidade
        FROM #inserted_temp t;
        
        INSERT INTO escolaridade_falecido (id_esc2010, id_esc, id_escfalagr1, seriescfal) 
        OUTPUT inserted.id_escol, t.temp_id INTO @IdMap (new_escol_id, temp_id) 
        SELECT NULL, NULL, NULL, NULL FROM #inserted_temp t;
        MERGE INTO obito USING (SELECT * FROM #inserted_temp) AS source ON 1=0
        WHEN NOT MATCHED THEN INSERT (id_tipobito, dtobito, horaobito) 
        VALUES (source.id_tipobito, source.dtobito, source.horaobito)
        OUTPUT inserted.id_obito, source.temp_id INTO @IdMap (new_obito_id, temp_id);

        INSERT INTO pessoa_falecida (id_obito, dtnasc, id_sexo, id_estciv, id_racacor, codmunres, ocup, id_idade, id_escol)
        SELECT m.new_obito_id, i.dtnasc, i.id_sexo, i.id_estciv, i.id_racacor, i.codmunres, i.ocup, m.new_idade_id, m.new_escol_id
        FROM #inserted_temp AS i INNER JOIN @IdMap AS m ON i.temp_id = m.temp_id;
    END
END;
GO