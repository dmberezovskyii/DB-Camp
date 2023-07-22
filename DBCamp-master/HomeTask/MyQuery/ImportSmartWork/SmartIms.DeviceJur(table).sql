USE [PRDIR_Equipment]
GO

/****** Object:  Table [SmartIms].[DeviceJur]    Script Date: 09/03/2015 16:58:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SmartIms].[DeviceJur](
	[Id] [int] NOT NULL,
	[Producer] [varchar](3) NULL,
	[SerialNo] [varchar](32) NULL,
	[Ident] [int] NULL,
	[DevTypeId] [int] NULL,
	[SubType1] [int] NULL,
	[SubType2] [int] NULL,
	[LogId] [varchar](32) NULL,
	[DateInstall] [datetime] NULL,
	[DateCheck] [datetime] NULL,
	[DateProduct] [datetime] NULL,
	[Status] [int] NULL,
	[StatusDate] [datetime] NULL,
	[ResourceID] [int] NULL,
	[EANCode] [varchar](30) NULL,
	[SN] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


