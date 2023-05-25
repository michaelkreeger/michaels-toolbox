/* Statistics Health */
/* This only looks at statistics on tables with >= to 1000 records */
CREATE TABLE #results
    (
	  [Server Name] VARCHAR(255),
      [Database Name] VARCHAR(255),
	  [Table Name] VARCHAR(255),
	  [Index Name] VARCHAR(255),
	  [Statistics Date] DATETIME,
	  [Days Old] BIGINT,
	  [Auto Created] INT,
	  [No Recompute] INT,
	  [User Created] INT,
	  [Row Count] BIGINT
    ) ;
INSERT INTO #results
EXEC sp_MSforeachdb @command1 = 'USE [?];
SELECT @@servername AS [Server Name], DB_NAME() AS [Database Name], o.name AS [Table Name], i.name AS [Index Name],  
      STATS_DATE(i.[object_id], i.index_id) AS [Statistics Date],
      DATEDIFF(d, STATS_DATE(i.object_id, i.index_id), GETDATE()) DaysOld, 
      s.auto_created AS [Auto Created], s.no_recompute AS [No Recompute], s.user_created AS [User Created], st.row_count AS [Row Count]
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.stats AS s WITH (NOLOCK)
ON i.[object_id] = s.[object_id] 
AND i.index_id = s.stats_id
INNER JOIN sys.dm_db_partition_stats AS st WITH (NOLOCK)
ON o.[object_id] = st.[object_id]
AND i.[index_id] = st.[index_id]
WHERE o.[type] = ''U'' AND st.row_count >= 1000
ORDER BY STATS_DATE(i.[object_id], i.index_id) ASC OPTION (RECOMPILE);';  
SELECT * FROM #results ORDER BY [Days Old] DESC
DROP TABLE #results
