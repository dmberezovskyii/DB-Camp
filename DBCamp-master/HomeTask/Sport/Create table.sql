USE Sport

IF OBJECT_ID ( N'dbo.Matches', N'U' ) IS NOT NULL
	Begin
	DROP TABLE dbo.Matches;
	END
ELSE IF OBJECT_ID(N'dbo.Matches', N'U') IS NULL
	BEGIN
	DROP TABLE dbo.Matches;
	END
GO 

IF OBJECT_ID ( N'dbo.Teams', N'U' ) IS NOT NULL
	Begin
	DROP TABLE dbo.Teams;
	END
ELSE IF OBJECT_ID(N'dbo.Teams', N'U') IS NULL
	BEGIN
	DROP TABLE dbo.Teams;
	END
GO
IF OBJECT_ID ( N'dbo.Sports', N'U' ) IS NOT NULL
	Begin
	DROP TABLE dbo.Sports;
	END
ELSE IF OBJECT_ID(N'dbo.Sports', N'U') IS NULL
	BEGIN
	DROP TABLE dbo.Sports;
	END
GO  
IF OBJECT_ID ( N'dbo.Tournaments', N'U' ) IS NOT NULL
	Begin
	DROP TABLE dbo.Tournaments;
	END
ELSE IF OBJECT_ID(N'dbo.Tournaments', N'U') IS NULL
	BEGIN
	DROP TABLE dbo.Tournaments;
	END
GO 

  
BEGIN try
	IF OBJECT_ID ( N'dbo.Clubs', N'U' ) IS NOT NULL
		Begin
			DROP TABLE dbo.Clubs;
		END
end TRY
BEGIN CATCH
	PRINT 'Table doesn"t exist or empty'
END CATCH

DROP TABLE IF EXISTS dbo.Clubs; 
GO





