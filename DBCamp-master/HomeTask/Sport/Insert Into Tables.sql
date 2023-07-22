USE [Sport]
GO
/*Insert Tournament*/
SET NOCOUNT ON --?? ???????? ????????? ??????
set XACT_ABORT ON --?? ???? ???????????? ??????? ?????????? ??? ???????, ???? SEVERITY ??? 0 ?? 10 ???? ???????, ??? 10 ?? 16 ?? ????

BEGIN try
	begin tran -- ??????????? ??????????
	INSERT INTO [dbo].[Tournaments]
			   ([TournamentId]
			   ,[TournamentName]
			   ,[ExternalIdPrefix])
	SELECT DISTINCT  dcml.TournamentId, 
					 dcml.TournamentName,
					 dcml.ExternalIdPrefix
	 FROM dbo.dbCamp_MatchesList AS dcml 
	 COMMIT
 end TRY
BEGIN CATCH
	PRINT ''
		IF XACT_STATE() <> 0 -- 1 ???? ???? ?????, 0 - ???? ???????? ??????????, -1 -?? ???? ???? ??????????
		ROLLBACK TRAN
	throw
END CATCH

GO
/*Insert Spoerts*/
BEGIN try
INSERT INTO [dbo].[Sports]
           ([SportID]
           ,[Sport])
SELECT DISTINCT  dcml.SportID, 
 dcml.Sport
 FROM dbo.dbCamp_MatchesList AS dcml 
 Print 'Insert into Sports';
END TRY
BEGIN CATCH
	PRINT 'XACT_STATE' 
	IF XACT_STATE() <> 0
	ROLLBACK TRAN
	THROW
END CATCH
/*Insert Clubs*/
BEGIN try
	INSERT INTO [dbo].[Clubs]
			   ([MatchId]
			   ,[AwayClubId]
			   ,[Clubs]
			   ,[HomeClubId]
			   ,[HomeClub])
	 SELECT DISTINCT  dcml.MatchId, 
					 dcml.AwayClubID,
					 dcml.AwayClub,
					 dcml.HomeClubID,
					 dcml.HomeClub
	 FROM dbo.dbCamp_MatchesList AS dcml 
END TRY
BEGIN CATCH
PRINT ''
 IF XACT_STATE() <> 0
	ROLLBACK TRAN
	THROW
END CATCH

/*Insert Teams*/
BEGIN try
INSERT INTO [dbo].[Teams]
           ([MatchId]
           ,[HomeTeamID]
           ,[HomeTeam]
           ,[AwayTeamId]
           ,[AwayTeam])
 SELECT DISTINCT  dcml.MatchId, 
				 dcml.HomeTeamID,
				 dcml.HomeTeam,
				 dcml.AwayTeamID,
				 dcml.AwayTeam
 FROM dbo.dbCamp_MatchesList AS dcml 
 

INSERT INTO [dbo].[Matches]
           ([MatchId]
           ,[DateMatch]
           ,[TournamentId]
           ,[SportID])
SELECT DISTINCT  dcml.MatchId, 
 dcml.DateMatch,
 dcml.TournamentId,
 dcml.SportID
 FROM dbo.dbCamp_MatchesList AS dcml 
END TRY

BEGIN CATCH
PRINT ''
 IF XACT_STATE() <> 0
	ROLLBACK TRAN
	THROW
END CATCH





