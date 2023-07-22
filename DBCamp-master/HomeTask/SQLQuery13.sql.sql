
USE Sport

CREATE TABLE Clubs (
	AwayClubId UNIQUEIDENTIFIER not null primary key ,
	AwayClub VARCHAR (255) 
);


CREATE TABLE Teams(
	[AwayTeamID] [uniqueidentifier] NOT NULL primary key,
	[AwayTeam] [nvarchar](450) NULL);
	GO

CREATE TABLE Sports(
	[SportID] [int] NOT NULL PRIMARY KEY,
	[Sport] [nvarchar](max) NULL
);
GO

CREATE TABLE Matches(
	[MatchId] [uniqueidentifier] NOT NULL primary key,
		[DateMatch] [datetime] NOT NULL	)
GO

CREATE TABLE Tournaments(	
	[TournamentId] [uniqueidentifier] not NULL primary key ,
	[TournamentName] [nvarchar](max) NULL,
	[ExternalIdPrefix] [nvarchar](50) NULL);
GO

