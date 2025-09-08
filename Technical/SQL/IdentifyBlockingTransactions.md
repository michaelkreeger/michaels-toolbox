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
WHERE LTRIM(RTRIM(BlkBy)) = '.'

select * from #spWho2

SELECT * FROM sys.dm_exec_requests 
WHERE blocking_session_id <> 0 or 
      session_id in (select BlkBy from #spWho2)

SELECT
    l.request_session_id AS SPID,
    l.resource_type,
    l.resource_database_id,
    l.resource_associated_entity_id AS ResourceID,
    l.request_mode AS LockMode,
    l.request_status,
    OBJECT_NAME(l.resource_associated_entity_id) AS LockedObjectName,
	l.*
FROM sys.dm_tran_locks l
WHERE l.request_session_id IN (SELECT SPID FROM #spWho2);


-- Clean up
DROP TABLE #spWho2
