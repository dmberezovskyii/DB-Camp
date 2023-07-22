USE [PRDIR_Equipment]
GO

/****** Object:  Table [SmartIms].[DeviceDataJur]    Script Date: 09/03/2015 16:58:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SmartIms].[DeviceDataJur](
	[Ident] [int] NOT NULL,
	[DeviceId] [int] NOT NULL,
	[ClassId] [smallint] NOT NULL,
	[LogicalName] [binary](6) NOT NULL,
	[AttId] [tinyint] NOT NULL,
	[Time] [datetime] NOT NULL,
	[ReceivedTime] [datetime] NOT NULL,
	[Value] [bigint] NULL,
	[Event] [tinyint] NULL,
	[Unit] [tinyint] NOT NULL,
	[Scaler] [tinyint] NOT NULL,
	[NormValue] [numeric](38, 19) NULL,
	[Number] [smallint] NULL,
	[TariffId] [smallint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


