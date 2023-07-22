/*Create LinkedServer on itself with:
 name  - @LinkedServername 
and remout user with name @ruserName and @ruserPassword
*/
DECLARE @servername VARCHAR(190), @ruserName VARCHAR(90), @ruserPassword VARCHAR(90),  @LinkedServername VARCHAR(190)

SET @LinkedServername = 'EtServer' ---!!!
SELECT @ruserName = '', @ruserPassword  = '' --- !!!

SELECT @servername = CONVERT(VARCHAR(190), SERVERPROPERTY('servername'))
SELECT @servername

USE [master]

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = @LinkedServername)
EXEC master.dbo.sp_dropserver @server=@LinkedServername, @droplogins='droplogins'


EXEC master.dbo.sp_addlinkedserver @server = @LinkedServername, @srvproduct=N'Equipment', @provider=N'SQLOLEDB', @datasrc=@servername

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = @LinkedServername, @locallogin = N'sa', @useself = N'False', @rmtuser =  @ruserName, @rmtpassword = @ruserPassword

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'collation compatible', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'data access', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'dist', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'pub', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'rpc', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'rpc out', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'sub', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'connect timeout', @optvalue=N'0'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'collation name', @optvalue=null

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'lazy schema validation', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'query timeout', @optvalue=N'0'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'use remote collation', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=@LinkedServername, @optname=N'remote proc transaction promotion', @optvalue=N'true'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = @LinkedServername, @locallogin = NULL , @useself = N'False'
GO
