USE [PRDIR_Equipment]
GO

/****** Object:  Table [SmartIms].[ReportDay]    Script Date: 09/03/2015 16:57:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SmartIms].[ReportDay](
	[FilialId] [int] NULL,
	[ReportDay] [tinyint] NULL,
	[CounterNumber] [varchar](50) NULL,
	[EquipmentCounterId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


