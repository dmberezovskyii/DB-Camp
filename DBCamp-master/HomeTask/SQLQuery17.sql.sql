USE [Sport]
GO

/****** Object:  Table [dbo].[Clubs]    Script Date: 11.10.2018 20:18:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Clubs](
	
	[AwayClubId] [uniqueidentifier] NOT NULL ,
	[AwayClub] [varchar](255) NULL
) ON [PRIMARY]
GO


CREATE CLUSTERED INDEX CL_Clubs_AwayClubId ON [dbo].[Clubs]([AwayClubId])
