
GO

INSERT INTO sport.Clubs
           (
		   [AwayTeamID]
           ,[AwayTeam]
		   )
	
  SELECT  dcml.AwayTeamID, 
	 dcml.AwayTeam
 FROM dbo.dbCamp_MatchesList AS dcml
GO


