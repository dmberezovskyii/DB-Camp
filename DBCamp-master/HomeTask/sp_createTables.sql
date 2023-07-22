IF OBJECT_ID ( N'sp_getCreateTables', N'P' ) IS NOT NULL
Begin 
	DROP PROCEDURE sp_getCreateTables;
END
ELSE IF OBJECT_ID ( N'sp_getCreateTables', N'P' ) IS  NULL
	BEGIN
		DROP PROCEDURE sp_getCreateTables;
	END
GO 

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure sp_getCreateTables

	as
 begin
CREATE TABLE Clubs (
	[MatchId] [uniqueidentifier] NOT NULL primary key,
	AwayClubId UNIQUEIDENTIFIER not null,
	[Clubs] [nvarchar](450) NULL,
	HomeClubId UNIQUEIDENTIFIER not null ,
	HomeClub [nvarchar](450) NULL);

CREATE TABLE Teams(
	[MatchId] [uniqueidentifier] NOT NULL primary key,
	[HomeTeamID] [uniqueidentifier] NOT NULL,
	[HomeTeam] [nvarchar](450) NULL,
	AwayTeamId UNIQUEIDENTIFIER not null,
	AwayTeam nvarchar(450) null);

	
CREATE TABLE Sports(
	[SportID] [int] NOT NULL PRIMARY KEY,
	[Sport] [nvarchar](max) NULL
);

CREATE TABLE Tournaments(	
	[TournamentId] [uniqueidentifier] not NULL primary key ,
	[TournamentName] [nvarchar](max) NULL,
	[ExternalIdPrefix] [nvarchar](50) NULL	)

CREATE TABLE Matches(
	[MatchId] [uniqueidentifier] NOT NULL primary key,
	[DateMatch] [datetime] NOT NULL,
	[TournamentId] [uniqueidentifier] not NULL,
	[SportID] [int] NOT NULL,
	CONSTRAINT [ClubMatchId] FOREIGN KEY (MatchId) REFERENCES Clubs ([MatchId]),
	CONSTRAINT [TeamsMatchId] FOREIGN KEY (MatchID) REFERENCES Teams ([MatchId]),
	CONSTRAINT SportID FOREIGN KEY (SportID) REFERENCES Sports (SportID),
	CONSTRAINT TournamentRefId FOREIGN KEY (TournamentId) REFERENCES Tournaments (TournamentId) )
 END

 GO

 BEGIN try
 EXEC sp_getCreateTables
 END TRY

 BEGIN CATCH
 SELECT
	ERROR_NUMBER() AS ErrorNumber
   ,ERROR_MESSAGE() AS ErrorMessage;
 END CATCH