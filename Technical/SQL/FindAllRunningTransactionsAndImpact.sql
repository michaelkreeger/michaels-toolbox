-- Do not lock anything, and do not get held up by any locks.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT [Spid] = sp.session_Id
	,[Blocking ID] = er.blocking_session_id
	,[Start Time] = ec.connect_time
	,[Last Batch Start] = start_time
	,[Command] = er.command
	,[Database] = DB_NAME(er.database_id)
	,[User] = login_name
	,[Percent Complete] = er.percent_complete
	,[Completion Time] = er.estimated_completion_time/60000
	,[Status] = er.STATUS
	,[Wait Type] = wait_type
	,[CPU Time] = er.cpu_time
	,[Reads] = er.reads
	,[Writes] = er.writes
	,[Logical Reads] = er.Logical_reads
	,[Row Count] = er.row_count
	,[Program] = program_name
	,[Host Name] = host_name
	,[Parent Query] = qt.text
	,SUBSTRING(qt.TEXT, (er.statement_start_offset / 2) + 1, ((
		CASE er.statement_end_offset WHEN - 1 
			THEN DATALENGTH(qt.TEXT) 
			ELSE er.statement_end_offset 
			END - er.statement_start_offset ) / 2) + 1) AS [SQL Statement]
	,[Query Plan] = p.query_plan
FROM sys.dm_exec_requests er
INNER JOIN sys.dm_exec_sessions sp ON er.session_id = sp.session_id
INNER JOIN sys.dm_exec_connections ec ON ec.session_id = sp.session_id
OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
OUTER APPLY sys.dm_exec_query_plan(er.plan_handle) p
WHERE sp.is_user_process = 1
	AND sp.session_Id NOT IN (@@SPID)
	AND qt.text != 'sp_server_diagnostics'
ORDER BY 1,2
