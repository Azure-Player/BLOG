CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification]
    FOR SERVER AUDIT [LocalServerAudit]
    ADD (INSERT, UPDATE, DELETE ON SCHEMA::dbo BY public)
WITH (State = ON);
