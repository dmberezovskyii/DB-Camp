
DROP TABLE IF EXISTS sport.Teams ;
GO
DROP TABLe IF EXISTS sport.Clubs;
GO
DROP TABLE IF EXISTS sport.Teams;
GO
DROP TABLE IF EXISTS sport.Tournaments;
GO
DROP TABLE IF EXISTS sport.Matches;
GO
CREATE Schema sport;
GO

CREATE TABLE sport.Clubs(
	Id int not null Primary key,
	AwayClubId UNIQUEIDENTIFIER NOT NULL,
	AwayClub VARCHAR (255));
	
CREATE TABLE Teams(
	[AwayTeamID] [uniqueidentifier] NOT NULL PRIMARY KEY,
	[AwayTeam] [nvarchar](450) NULL);
	GO
CREATE TABLE Sports(
	[SportID] [int] NOT NULL PRIMARY KEY,
	[Sport] [nvarchar](max) NULL
);
GO

CREATE TABLE Matches(
	[MatchId] [uniqueidentifier] NOT NULL PRIMARY KEY,
		[DateMatch] [datetime] NOT NULL	)
GO

CREATE TABLE Tournaments(	
	[TournamentId] [uniqueidentifier] not NULL PRIMARY KEY,
	[TournamentName] [nvarchar](max) NULL,
	[ExternalIdPrefix] [nvarchar](50) NULL);
GO

