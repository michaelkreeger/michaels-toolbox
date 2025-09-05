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

-- Clean up
DROP TABLE #spWho2
