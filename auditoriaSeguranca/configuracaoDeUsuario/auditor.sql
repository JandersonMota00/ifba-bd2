/* ===========================================================================
   1) Auditor (db_auditor)
   – Leitura exclusiva da audit.ChangeLog
   – Sem acesso às tabelas operacionais
   =========================================================================== */
-- 3.1 Criar login de servidor
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'aud123')
  CREATE LOGIN aud123 WITH PASSWORD = 'Aud!t0r#2025';
GO

-- 3.2 Criar usuário de banco
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AuditorUser')
  CREATE USER AuditorUser FOR LOGIN aud123;
GO

-- 3.3 Criar role de auditor
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_auditor' AND type = 'R')
  CREATE ROLE db_auditor;
GO

-- 3.4 Associar usuário à role
ALTER ROLE db_auditor ADD MEMBER AuditorUser;
GO

-- 3.5 Permissão de leitura apenas no log de auditoria
GRANT SELECT ON audit.ChangeLog TO db_auditor;
GO

-- 3.6 Negar acesso total às tabelas operacionais
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_consumo                     TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.geolocalizacao                    TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.ordemItem                         TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.ordens                            TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.ordensDePagamento                 TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.olist_order_reviews_dataset       TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.product_category_name_translation TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.produtos                          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.vendas                            TO db_auditor;
GO