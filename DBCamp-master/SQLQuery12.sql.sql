
GO
INSERT INTO [dbo].[Clubs]
           (  [AwayClubId]
           ,[AwayClub])
		  
 SELECT DISTINCT  dcml.AwayClubID, 
 dcml.AwayClub
 FROM dbo.dbCamp_MatchesList AS dcml 

 
GO

INSERT INTO [dbo].[Matches]
           ([MatchId]
           ,[DateMatch])
  SELECT DISTINCT dcml.MatchId, 
	 dcml.DateMatch
 FROM dbo.dbCamp_MatchesList  AS dcml

GO

INSERT INTO [dbo].[Teams]
           ([AwayTeamID]
           ,[AwayTeam])
  SELECT DISTINCT dcml.AwayTeamID, 
	 dcml.AwayTeam
 FROM dbo.dbCamp_MatchesList AS dcml
GO

INSERT INTO [dbo].[Tournaments]
           ([TournamentId]
           ,[TournamentName]
           ,[ExternalIdPrefix])
   SELECT DISTINCT [TournamentId]
           ,[TournamentName]
           ,[ExternalIdPrefix] FROM dbo.dbCamp_MatchesList
GO








