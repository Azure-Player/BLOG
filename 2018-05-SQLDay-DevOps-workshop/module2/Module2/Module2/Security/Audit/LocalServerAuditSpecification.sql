CREATE SERVER AUDIT SPECIFICATION [LocalServerAuditSpecification]
FOR SERVER AUDIT [LocalServerAudit]
ADD (APPLICATION_ROLE_CHANGE_PASSWORD_GROUP),
    ADD (AUDIT_CHANGE_GROUP),
    ADD (BACKUP_RESTORE_GROUP),
    ADD (DATABASE_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (DATABASE_OWNERSHIP_CHANGE_GROUP),
    ADD (DATABASE_PERMISSION_CHANGE_GROUP),
    ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),
    ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
    ADD (DBCC_GROUP),
    ADD (LOGIN_CHANGE_PASSWORD_GROUP),
    ADD (SCHEMA_OBJECT_CHANGE_GROUP),
    ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_OBJECT_CHANGE_GROUP),
    ADD (SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
    ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
    ADD (SERVER_STATE_CHANGE_GROUP),
    ADD (TRACE_CHANGE_GROUP),
    ADD (USER_CHANGE_PASSWORD_GROUP),
    ADD (USER_DEFINED_AUDIT_GROUP)

    WITH (STATE = ON);

/* 
 Note: SSDT supports so-called management-scoped object, but only for initial
 creation. SERVER AUDIT, SERVER AUDIT SPECIFICATION and DATABASE AUDIT
 SPECIFICATION belong to this group of objects. During subsequent deployments
 SSDT will not attempt to alter them if their definition changes in the project.
 It will emit warning 72038 and will not generate code for the change.

 Please change the definition here as needed, so deployment on non-existing
 database succeeds, but if you want to change existing audit object, do it in
 pre- or post-deploy script, or by dropping it before deployment, or using
 another workaround.
*/
