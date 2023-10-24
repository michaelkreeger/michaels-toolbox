--Stored procedure execution times

SELECT 
   DB_NAME(database_id) [database],
   OBJECT_NAME(object_id) [stored_procedure],
   cached_time, 
   last_execution_time, 
   execution_count,
   (total_elapsed_time/execution_count) / 1000 [avg_elapsed_time_Milliseconds],
   [type_desc]
FROM sys.dm_exec_procedure_stats T
--WHERE OBJECT_NAME(object_id) IN ('StoredProc1', 'StoredProc2', 'StoredProc3')
ORDER BY [avg_elapsed_time_Milliseconds] desc;
