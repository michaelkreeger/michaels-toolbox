SELECT 
	object_name, 
	instance_name, 
	cntr_value as cntr_value_InSeconds
FROM sys.dm_os_performance_counters
WHERE [counter_name] = 'Page life expectancy'
