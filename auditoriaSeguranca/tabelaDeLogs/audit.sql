-- Criar o schema 'audit' se ainda não existir
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'audit'
)
    EXEC('CREATE SCHEMA audit');
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'audit_views'
)
    EXEC('CREATE SCHEMA audit_views');
GO

-- Criar a tabela de logs de alterações
CREATE TABLE audit.ChangeLog (
    ChangeLogID       INT IDENTITY(1,1) PRIMARY KEY,  -- Identificador único do log
    TableName         NVARCHAR(128)   NOT NULL,       -- Nome da tabela alterada
    Operation         CHAR(1)         NOT NULL,       -- Tipo de operação: I, U ou D
    PrimaryKeyValue   NVARCHAR(256)   NOT NULL,       -- Valor da chave primária (ou composta)
    ColumnName        NVARCHAR(128)   NOT NULL,       -- Nome da coluna alterada ou 'ALL'
    OldValue          NVARCHAR(MAX)       NULL,       -- Valor antes da alteração
    NewValue          NVARCHAR(MAX)       NULL,       -- Valor após a alteração
    ChangedBy         NVARCHAR(128)   NOT NULL,       -- Usuário que executou a operação
    ChangedAt         DATETIME2(3)    NOT NULL        -- Data/hora da alteração (UTC)
);
GO

-- (Opcional) Índices para acelerar consultas frequentes
CREATE INDEX IX_ChangeLog_TableName_ChangedAt
    ON audit.ChangeLog (TableName, ChangedAt DESC);

CREATE INDEX IX_ChangeLog_PrimaryKeyValue
    ON audit.ChangeLog (PrimaryKeyValue);
GO
