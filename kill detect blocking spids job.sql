--TODO: Change @server_name
--TODO: Create DBALogging.dbo.ExecRequestsLog if it doesn't already exist.

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Kill Blocking Sessions', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'Custom Long-Running Script to terminate long-running queries
Running on a job with parameters planned and configured. Limited logging of the script’s session-killing activities will be written to the dbalogging.dbo.ExecRequestsLog table on the server.
', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Kill Blocking Sessions', @server_name = N'99-SQL2012'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Kill Blocking Sessions', @step_name=N'kill long running sessions', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.killblockingsessions', 
		@database_name=N'DBALogging', 
		@flags=4
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Kill Blocking Sessions', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'Custom Long-Running Script to terminate long-running queries
Running on a job with parameters planned and configured jointly by Sparkhound and D’Addario IT and Business decision makers. Limited logging of the script’s session-killing activities will be written to the dbalogging.dbo.ExecRequestsLog table on the server.
', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Kill Blocking Sessions', @name=N'five minutes', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150129, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
