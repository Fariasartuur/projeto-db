USE mortalidade
GO

CREATE TABLE Auditoria_Obito (
    id_auditoria INT IDENTITY PRIMARY KEY,
    id_obito INT,
    operacao VARCHAR(10),
    usuario_bd SYSNAME,
    data_hora DATETIME DEFAULT GETDATE(),
    valores_antigos NVARCHAR(MAX),
    valores_novos NVARCHAR(MAX)
);
GO

IF OBJECT_ID('trg_Auditoria_obito', 'TR') IS NOT NULL
    DROP TRIGGER trg_Auditoria_obito;
GO

CREATE TRIGGER trg_Auditoria_obito
ON obito
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @usuario_bd SYSNAME = SUSER_SNAME();

    -- UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Obito (id_obito, operacao, usuario_bd, valores_antigos, valores_novos)
        SELECT 
            i.id_obito, 
            'UPDATE', 
            @usuario_bd,
            (SELECT * FROM deleted d_inner WHERE d_inner.id_obito = d.id_obito FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT * FROM inserted i_inner WHERE i_inner.id_obito = i.id_obito FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM 
            inserted i
        JOIN 
            deleted d ON i.id_obito = d.id_obito;
    END
    -- INSERT
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria_Obito (id_obito, operacao, usuario_bd, valores_novos)
        SELECT 
            i.id_obito, 
            'INSERT', 
            @usuario_bd,
            (SELECT * FROM inserted i_inner WHERE i_inner.id_obito = i.id_obito FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM 
            inserted i;
    END
    -- DELETE
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Obito (id_obito, operacao, usuario_bd, valores_antigos)
        SELECT 
            d.id_obito, 
            'DELETE', 
            @usuario_bd,
            (SELECT * FROM deleted d_inner WHERE d_inner.id_obito = d.id_obito FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM 
            deleted d;
    END
END;
GO