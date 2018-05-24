CREATE SERVER AUDIT [LocalServerAudit]
/*	TO APPLICATION_LOG
	WITH ( QUEUE_DELAY = 1000, ON_FAILURE = SHUTDOWN )
*/
    TO FILE ( 
        FILEPATH = '$(AuditDirectory)',
        MAXSIZE = 10 MB, MAX_ROLLOVER_FILES = 1000, RESERVE_DISK_SPACE = OFF
    )
    WITH ( 
        QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE,

        -- audit object will have known GUID in order to work with HA solutions
        AUDIT_GUID = '67408544-56AD-4A34-9582-192941B8CB13'
    );
