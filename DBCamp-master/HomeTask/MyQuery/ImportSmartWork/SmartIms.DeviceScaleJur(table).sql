USE [DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SmartIms].[DeviceScale](
	[DayTypesId] [int] NOT NULL,
	[TariffId] [smallint] NOT NULL,
	[DirectionType] [smallint] NULL,
	[DeviceScale] [varbinary](6) NULL,
	[EquipmentScaleId] [int] NULL,
	[DeviceScaleId] [int] NOT NULL,
	[JuridicalScaleId] [int] NULL,
	[Name] [varchar](15) NOT NULL,
	[TimeZonal] [smallint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


