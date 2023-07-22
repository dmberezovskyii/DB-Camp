USE [DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











ALTER PROCEDURE [SmartIms].[sp_UpdDevData]
AS 
BEGIN





IF EXISTS ( SELECT  *
            FROM    TempDB..sysobjects
            WHERE   id = OBJECT_ID(N'TempDB..#Device') ) 
    BEGIN
        DROP TABLE #Device
    END

CREATE TABLE [#Device](
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
) 

INSERT INTO [#Device]
EXEC [SIServer].[ADD_SERVER].[dbo].sp_GetEquipmentDataJuridical @type = 1  

INSERT INTO [SmartIms].[DeviceJur]
SELECT * FROM [#Device] AS D WHERE NOT EXISTS (SELECT * FROM [SmartIms].[DeviceJur] AS D2 WHERE [D].[Id] = [D2].[Id])

PRINT 'ë³÷èëüíèê³â ³ìïîðòîâàíî'



IF EXISTS ( SELECT  *
            FROM    TempDB..sysobjects
            WHERE   id = OBJECT_ID(N'TempDB..#DeviceData') ) 
    BEGIN
        DROP TABLE #DeviceData
    END

CREATE TABLE [#DeviceData](
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

) 


-- ³ìïîðò äàíèõ ïðî ë³÷èëüíèêè ñìàðò íà îñíîâ³ êëàñèô³êàòîðà ç ô³ë³é
DECLARE   @CounterId INT, @date SMALLDATETIME
SET @date= CONVERT(SMALLDATETIME,DATEADD(DAY, DATEDIFF(day, 0, GETDATE()), -1))
declare SmartCounter cursor scroll for 
--SELECT Id FROM [dbo].[sfParseArrayToStringTable](@ArrayFilialId) AS SPATST
SELECT 
	DJ.Id
FROM SmartIms.ReportDay AS RD
	JOIN SmartIms.FilialDeviceJur AS FDJ ON RD.FilialId = FDJ.FilialId
	JOIN SmartIms.DeviceJur AS DJ ON CONVERT(NUMERIC,FDJ.CounterNumber)=DJ.SN
WHERE FDJ.CounterNumber=RD.CounterNumber
	AND DATEPART(DAY,GETDATE())=RD.ReportDay
GROUP BY DJ.Id
HAVING COUNT(dj.Id)>=1
	open SmartCounter;
fetch next from SmartCounter into @CounterId
	while(@@fetch_status=0)
BEGIN

BEGIN TRY
INSERT INTO [#DeviceData]
EXEC [SmartImsServer].[ADDAXDB_APPSERVER].[dbo].sp_GetEquipmentDataJuridical 4,  @CounterId,@date


END TRY




BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber
    ,ERROR_MESSAGE() as ErrorMessage
END CATCH;
--SELECT @Query
	FETCH NEXT FROM SmartCounter INTO @CounterId
END

CLOSE SmartCounter
DEALLOCATE SmartCounter

--DECLARE @DateFrom SMALLDATETIME
--   ,@DateTo SMALLDATETIME 

--SET @DateFrom = DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0)
--SET @DateTo = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)

--SELECT @datefrom = '20141101', @DateTo = '20141201'

--INSERT INTO [#DeviceData]
--EXEC [SmartImsServer].[ADDAXDB_APPSERVER].[dbo].sp_GetEquipmentDataJuridical 4, @DateFrom, @DateTo

DELETE FROM [SmartIms].[DeviceDataJur] --WHERE [Time] > @DateFrom AND [Time] <= @DateTo

INSERT INTO [SmartIms].[DeviceDataJur]
SELECT * 
FROM [#DeviceData] AS DD


--òàðèô³êàö³ÿ ³ìïîðòîâàíèõ ïîêàç³â

UPDATE ddj  set ddj.tariffid=1
 FROM SmartIms.DeviceDataJur AS DDJ
WHERE DeviceId IN (SELECT DeviceId FROM SmartIms.DeviceDataJur AS ddj2 GROUP BY DeviceId HAVING COUNT(DeviceId)<=3)
PRINT 'Òàðèô³êîâàíî áåç ÷àñîâèõ çîí'



UPDATE ddj  set ddj.tariffid=3
 FROM SmartIms.DeviceDataJur AS DDJ
WHERE DeviceId IN  (SELECT DeviceId FROM SmartIms.DeviceDataJur AS ddj2 
JOIN SmartIms.DeviceScaleJur dsj ON DDJ2.LogicalName=dsj.DeviceScale
WHERE DirectionType NOT IN (2,3)
 GROUP BY DeviceId HAVING COUNT(DeviceId)>=3)

		PRINT 'Òàðèô³êîâàíî àòèâ 2 çîíè'


	
	


	
PRINT 'Òàðèô³êîâàíî Àòèâ 2 çîíè'

UPDATE ddj  set ddj.tariffid=7 
FROM SmartIms.DeviceDataJur AS DDJ
WHERE DeviceId IN (SELECT DeviceId FROM SmartIms.DeviceDataJur AS ddj2 GROUP BY DeviceId HAVING COUNT(DeviceId)=4)

PRINT 'Òàðèô³êîâàíî Àêòèâ 2 çîíè ðåàòèâ òà ãåíåðàö³ÿ áåç çîí'

UPDATE ddj  set ddj.tariffid=2 
FROM SmartIms.DeviceDataJur AS DDJ
WHERE DeviceId IN (SELECT DeviceId FROM SmartIms.DeviceDataJur AS ddj2 GROUP BY DeviceId HAVING COUNT(DeviceId)=5)
PRINT 'Òàðèô³êîâàíî Àêòèâ 3 çîíè'
-- âèäàëåííÿ íåâ³ðíî çàïðîãðàìîâàíèõ ë³÷èëüíèê (äàí³ ïî øêàëàõ â Áä Åêâ³ïìåíòà íå ñï³âïàäàþòü ç äàíèìè ïî ÑÌÀÐÒÓ)
DELETE FROM SmartIms.DeviceDataJur WHERE DeviceId IN 
									(SELECT DeviceId 
									FROM SmartIms.DeviceDataJur AS DDJ 
									WHERE TariffId=7 AND LogicalName=0x0100640800FF)
PRINT 'Âèäàëåíî íåñï³ïàä³ííÿ ïî øêàëàõ'



                

IF EXISTS ( SELECT  *
            FROM    TempDB..sysobjects
            WHERE   id = OBJECT_ID(N'TempDB..[#FilialDeviceJur]') ) 
    BEGIN
        DROP TABLE [#FilialDeviceJur]
    END



CREATE TABLE [#FDJur](
	[FilialId] [int] NULL,
	[CoreEquipmentGuid] [uniqueidentifier] NOT NULL,
	[CounterNumber] [varchar](50) NOT NULL,
	[CounterTypeId] [int] NOT NULL,
	[EquipmentTypeName] [varchar](200) NOT NULL,
	[ContractNumber] [varchar](1000) NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[CounterMeasuringid] [int] NOT NULL,
	[DirectionType] [int] NOT NULL,
	[Number] [smallint]  NULL,



)

CREATE NONCLUSTERED INDEX [Index1] ON [#FDJur] 
(
	[CounterNumber] ASC,
	[CoreEquipmentGuid] ASC,
	[FilialId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 


DELETE FROM FDJur
-- ³ìïîðò äàíèõ ïðî ë³÷èëüíèêè ñìàðò íà îñíîâ³ êëàñèô³êàòîðà ç ô³ë³é
DECLARE @Query NVARCHAR(MAX), @ArrayFilialId NVARCHAR(max), @FilialId VARCHAR(3)
--SET @ArrayFilialId = '190,210,220,230,240,250,260,280,290,300,320,350'
declare SmartCounterFromFilial cursor scroll for 
--SELECT Id FROM [dbo].[sfParseArrayToStringTable](@ArrayFilialId) AS SPATST
SELECT CONVERT(VARCHAR(3),[OrganizationUnitId]) FROM [SmartIms].[FilialGroup] AS FG
	open SmartCounterFromFilial;
fetch next from SmartCounterFromFilial into @FilialId
	while(@@fetch_status=0)
BEGIN

	SET @Query = 


'

declare @s INT

SELECT @s = Q FROM OPENQUERY([PR' + @FilialId + '],''select [PR' + @FilialId + '_Equipment].[SupportDefined].[FN_getOrganizationUnitId]() as Q'')

INSERT INTO [#FDJur]
        ( [FilialId]
        ,[CoreEquipmentGuid]
        ,[CounterNumber]
        ,[CounterTypeId]
        ,[EquipmentTypeName]
        ,[ContractNumber]
        ,[DateFrom]
        ,[CounterMeasuringid]
        ,[DirectionType]
        ,[Number]

       
        )
SELECT @s as FilialId,
		[ce].[guid] AS CoreEquipmentGuid, 
		[ch].CounterNumber, 
		[ch].[CounterTypeId], 
		[CE].[EquipmentTypeName],
		[ppl].[Contractnumber], 
		[BC].[DateFrom],
		[cm].CounterMeasuringid,
		[cm].[DirectionType],
		[S].[Number]
		 
  FROM   
		PR' + @FilialId + '.PR' + @FilialId + '_Equipment.PlacementLocation.EsjPoint AS ppl
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.[EquipmentMain].[BelongCurrent] AS BC ON [ppl].[PlacementLocationId] = [BC].[PlacementLocationId]
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.EquipmentMain.PlacementLocation AS PL ON BC.PlacementLocationId = PL.PlacementLocationId 
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.Organization.OrganizationUnit AS OU ON PL.OrganizationUnitId = OU.OrganizationUnitId AND ContractorId IS NOT NULL
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.[EquipmentMain].[CoreEquipment] AS CE ON [BC].[CoreEquipmentId] = [CE].[CoreEquipmentId] AND [EquipmentKindId] = 1
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.[Counter].[Counter] AS C ON [BC].[CoreEquipmentId] = [C].[CoreEquipmentId]
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.[Counter].[CounterHistory] AS CH ON [C].[CounterId] = [CH].[CounterId] AND [CH].[DateTo] = ''20790606''
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.Counter.CounterMeasuring AS CM ON CH.CounterHistoryId = CM.CounterHistoryId
		--JOIN Counter.GroupIndex AS GI ON CM.CounterMeasuringId = GI.CounterMeasuringId
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.Counter.Scale AS S ON CM.CounterMeasuringId = S.CounterMeasuringId
		JOIN PR' + @FilialId + '.PR' + @FilialId + '_Equipment.EquipmentDictionary.CounterType AS CT ON CT.CounterTypeId = CH.CounterTypeId

WHERE NOT EXISTS (SELECT * FROM [SmartIms].[FilialDeviceJur] AS FD WHERE [CoreEquipmentGuid] = CE.Guid)
			and ct.Code in (10233,
							   10234,10235,10236,
							   10237,10238,10239,
							   10240,10241 )
		   and ch.CounterNumber NOT LIKE ''%ô%'' 
		   and CounterNumber NOT LIKE ''%òðàí%''
		   and ppl.dateto=''20790606''
		   and   CH.ReactiveScaleCount<>2
		   and pl.PlacementLocationTypeId=5
'

BEGIN TRY
	EXEC(@Query)
	PRINT @FilialId
	
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber
    ,ERROR_MESSAGE() as ErrorMessage
END CATCH;
--SELECT @Query
	FETCH NEXT FROM SmartCounterFromFilial INTO @FilialId
END

CLOSE SmartCounterFromFilial
DEALLOCATE SmartCounterFromFilial


INSERT INTO [SmartIms].[FDJur]
        ( [FilialId]
        ,[CoreEquipmentGuid]
        ,[CounterNumber]
        ,[CounterTypeId]
        ,[EquipmentTypeName]
        ,[ContractNumber]
        ,[DateFrom]
        ,[CounterMeasuringid]
        ,[DirectionType]
        ,[Number] )
 SELECT [FilialId]
        ,[CoreEquipmentGuid]
        ,[CounterNumber]
        ,[CounterTypeId]
        ,[EquipmentTypeName]
        ,[ContractNumber]
        ,[DateFrom]
        ,[CounterMeasuringid]
        ,[DirectionType]
        ,[Number]
       
     
        FROM #FDJur FD2
WHERE NOT EXISTS (SELECT * FROM [SmartIms].[FDJur] AS FD WHERE [FD].[CoreEquipmentGuid] = [FD2].[CoreEquipmentGuid] AND [FD].[IsDeleted] = 0)

PRINT 'Ë³÷èëüíèê³â ³ìïîðòîâàíî'
--INSERT INTO [SmartIms].[DeviceLinkJur]
--        ( [DeviceId]
--        ,[CoreEquipmentGuid])
--SELECT D.[Id], [FD].[CoreEquipmentGuid] 
--FROM    [SmartIms].[DeviceJur] AS D 
--JOIN [SmartIms].[DeviceLocation] AS DL ON [D].[Id] = [DL].[DeviceId]
--JOIN [SmartIms].[FilialGroup] AS FG ON [FG].[FilialGroupId] = [DL].[GroupId]
--        JOIN [SmartIms].[FilialDeviceJur] AS FD ON [D].[SN] = CONVERT(NUMERIC, [FD].counternumber)
--AND [FG].[OrganizationUnitId] = FD.FilialId AND IsDeleted=0
--WHERE NOT EXISTS (
--SELECT CONVERT(NUMERIC, [FD2].counternumber) FROM [SmartIms].[FilialDeviceJur] AS FD2 WHERE [IsDeleted] = 0 GROUP BY CONVERT(NUMERIC, [FD2].counternumber) HAVING COUNT(*)>1 AND CONVERT(NUMERIC, [FD].counternumber) = CONVERT(NUMERIC, [FD2].counternumber))
--AND NOT EXISTS (SELECT * FROM [SmartIms].[DeviceLinkJur] AS DL2 WHERE [FD].[CoreEquipmentGuid] = [DL2].[CoreEquipmentGuid] AND [FD].[IsDeleted] = 0)
--AND NOT EXISTS (SELECT * FROM [SmartIms].[DeviceLinkJur] AS DL2 WHERE [DL2].[DeviceId] = [D].[Id])
END








GO


