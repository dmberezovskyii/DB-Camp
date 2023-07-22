USE Sport;
DECLARE @blocker int = 0;

WHILE @blocker < 1
begin
update Clubs 
	SET Clubs = 'test' 
	WHERE MatchId = 'FE0371DF-2D66-46C5-8DC5-0035BF4EBB7F'
end
DECLARE @SpID bigint;

SET NOCOUNT ON;
DECLARE @Kill nvarchar(50)
SET @SpID = (SELECT
		spid
	FROM sys.sysprocesses
	WHERE lastwaittype = 'LCK_M_X')
SET @Kill = 'KILL ' + CAST(@spid AS VARCHAR(3))

SELECT
	@Kill
EXEC sp_executesql @Kill