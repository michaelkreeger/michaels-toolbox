-- use when exec sp_UpdateStats isn't available


DECLARE @sql NVARCHAR(max) = '';

SELECT @sql = @sql+'UPDATE STATISTICS ' + '[' + table_name + ']' + ' WITH FULLSCAN; PRINT ''UPDATING STATISTICS ON ' + table_name +'...'';' FROM information_schema.tables where TABLE_TYPE = 'BASE TABLE';

--SELECT @SQL
EXEC sp_executesql @statement=@sql;

