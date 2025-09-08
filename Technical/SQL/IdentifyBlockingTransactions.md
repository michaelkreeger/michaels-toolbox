-- Create a temporary table to hold sp_who2 results
CREATE TABLE #spWho2 (
    SPID INT,
    Status VARCHAR(50),
    Login VARCHAR(max),
    HostName VARCHAR(max),
    BlkBy VARCHAR(5),
    DBName VARCHAR(max),
    Command VARCHAR(50),
    CPUTime INT,
    DiskIO INT,
    LastBatch VARCHAR(50),
    ProgramName VARCHAR(100),
    SPID2 INT,
    RequestID INT
)

-- Insert results from sp_who2 into the temp table
INSERT INTO #spWho2
EXEC sp_who2

-- Query only blocking sessions
delete from #spWho2
WHERE LTRIM(RTRIM(BlkBy)) = '.' AND 
      SPID NOT IN (
		select CONVERT(INT, LTRIM(RTRIM(BlkBy)))
		from #spWho2
		WHERE LTRIM(RTRIM(BlkBy)) <> '.'
		)

select * from #spWho2


SELECT 
    r.session_id,
    r.status,
    r.command,
    r.start_time,
    r.database_id,
    r.cpu_time,
    r.total_elapsed_time,
    t.text AS sql_text,
    OBJECT_NAME(t.objectid, r.database_id) AS stored_procedure_name, 
	r.*
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.session_id in (select SPID from #spWho2)

SELECT
    l.request_session_id AS SPID,
    l.resource_type,
    l.resource_database_id,
    l.resource_associated_entity_id AS ResourceID,
    l.request_mode AS LockMode,
    l.request_status,
	CASE 
		WHEN l.resource_associated_entity_id <= 2147483647 THEN 
			OBJECT_NAME(CAST(l.resource_associated_entity_id AS INT))
		ELSE 
			NULL
	END AS LockedObjectName,
	l.*
FROM sys.dm_tran_locks l
WHERE l.request_session_id IN (SELECT SPID FROM #spWho2);


-- Clean up
DROP TABLE #spWho2
