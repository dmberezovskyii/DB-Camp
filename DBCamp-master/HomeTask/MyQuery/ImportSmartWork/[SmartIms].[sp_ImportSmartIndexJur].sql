USE [DB]
GO

/****** Object:  StoredProcedure [SmartIms].[sp_ImportSmartIndexJur]    Script Date: 09/15/2015 16:47:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














ALTER PROCEDURE  [SmartIms].[sp_ImportSmartIndexJur]  

AS
BEGIN

BEGIN TRANSACTION  ImportedGroupIndex

INSERT INTO Counter.GroupIndex
        ( Guid ,
          CounterMeasuringId ,
          StaffId ,
          OrderId ,
          Date ,
          EventType ,
          IsForCalculate ,
          IsTechCheck ,
          Note ,
          CachedIndexes ,
          GroupIndexSourceId ,
          PlacementLocationId ,
          CreateDate ,
          UpdateDate
        )
SELECT	NEWID(),
		CounterMeasuringId,
		375 AS staffid,
		NULL AS orderid,
		IndexDate,
		0 AS EVENTType,
		0 AS IsForCalculate,
		0 AS IsTechCheck,
		'SmartImsJuridical' AS Note ,
		STUFF((  SELECT   '/' + CAST(CAST(IndexValue AS DECIMAL) AS VARCHAR)
					from DirectorateServer.PRDIR_Equipment.SmartIms.v_CounterDataJur AS DDJ
                       WHERE DDJ.CounterMeasuringId=vc.CounterMeasuringId
                        FOR XML PATH('') ), 1, 1, '') as IndexValue,
        112 AS GroupIndexSourceId,
		BC.PlacementLocationId,
		GETDATE() AS CreateDate,
		GETDATE() AS UpdateDate
FROM DirectorateServer.PRDIR_Equipment.SmartIms.v_CounterDataJur as vc
        JOIN EquipmentMain.CoreEquipment AS CE ON CE.Guid=vc.CoreEquipmentGuid AND EquipmentKindId=1
        JOIN EquipmentMain.BelongCurrent AS BC ON BC.CoreEquipmentId=ce.CoreEquipmentId
        JOIN EquipmentMain.PlacementLocation AS PL ON bc.PlacementLocationId=PL.PlacementLocationId
WHERE PL.PlacementLocationTypeId=5
		AND pl.OrganizationUnitId = [SupportDefined].[FN_getOrganizationUnitId]()
AND NOT EXISTS (SELECT * FROM [Counter].[GroupIndex] AS [GI] 
		JOIN [EquipmentDictionary].[GroupIndexSource] [GIS] ON [GI].[GroupIndexSourceId] = [GIS].[GroupIndexSourceId]
		JOIN [Counter].[CounterMeasuring] CM ON [GI].[CounterMeasuringId] = [CM].[CounterMeasuringId]
		JOIN [Counter].[CounterHistory] CH ON [CM].[CounterHistoryId] = [CH].[CounterHistoryId]
		JOIN [Counter].[Counter] C ON [CH].[CounterId] = [C].[CounterId] 
		JOIN [Organization].[Staff] S ON [GI].[StaffId] = [S].[StaffId]
WHERE [GI].[PlacementLocationId]=[PL].[PlacementLocationId] AND [GI].[Date]=[VC].[IndexDate] AND [C].[CoreEquipmentId]=[CE].[CoreEquipmentId]  )
			
	GROUP BY CounterMeasuringId,
			vc.IndexDate,
			BC.PlacementLocationId
	
	HAVING COUNT(CounterMeasuringId)>=1



INSERT INTO Counter.[Index]
        ( ScaleId, GroupIndexId, Guid, Value )
--VALUES  ( 0, -- ScaleId - int
--          0, -- GroupIndexId - int
--          NULL, -- Guid - uniqueidentifier
--          NULL  -- Value - decimal
--          )
--        ( [ImportedGroupIndexId]
--        ,[ScaleNumber]
--        ,[Value] )
SELECT ScaleId,
		GroupIndexId,
		NEWID(),
		IndexValue

FROM Server.DIR_Equipment.SmartIms.v_CounterDataJur AS VCDJ
		JOIN Counter.GroupIndex AS GI ON VCDJ.CounterMeasuringId = GI.CounterMeasuringId AND VCDJ.IndexDate=GI.Date
		JOIN Counter.Scale AS S ON GI.CounterMeasuringId = S.CounterMeasuringId
		
WHERE GI.IsForCalculate=0
	AND VCDJ.EquipmentScaleId=S.Number
	AND VCDJ.FilialId=[SupportDefined].[FN_getOrganizationUnitId]()
	AND NOT EXISTS
	(SELECT * FROM Server.DIR_Equipment.SmartIms.v_CounterDataJur AS VCDJ2
		JOIN Counter.GroupIndex AS GI2 ON VCDJ2.CounterMeasuringId = GI2.CounterMeasuringId AND VCDJ2.IndexDate=GI.Date
		JOIN Counter.Scale AS S2 ON GI2.CounterMeasuringId = S2.CounterMeasuringId
		JOIN Counter.[Index] AS [i] ON S2.ScaleId = i.ScaleId
WHERE GI2.IsForCalculate=0
	AND i.GroupIndexId=GI.GroupIndexId )
	
DECLARE @sql VARCHAR(max)

SET @sql = '
INSERT INTO [JuridicalDB].dbo.CounterMeterage
        ( CounterId ,
          RaportObjectId ,
          MeterageValue ,
          MeterageTypeId ,
          MeterageDate ,
          EnergyKindId ,
          TimeZoneId ,
          Quadrant ,
          IsForCalculate ,
          IsTechCheck ,
          StaffId ,
          EquipmentGroupIndexGuid
        )
SELECT c.CounterId,
		NUll,
		VCDJ.IndexValue,
			2,
		VCDJ.IndexDate,
		TZ2.EnergyKindId,
		VCDJ.JuridicalScaleId,
		NULL,
		gi.IsForCalculate,
		0,
		375,
		GI.[Guid]	
	
 FROM  Server.DIR_Equipment.SmartIms.v_CounterDataJur AS VCDJ
			JOIN Counter.GroupIndex AS GI ON VCDJ.CounterMeasuringId = GI.CounterMeasuringId
			JOIN Counter.CounterMeasuring AS CM ON GI.CounterMeasuringId = CM.CounterMeasuringId
			JOIN Counter.CounterHistory AS CH ON CM.CounterHistoryId = CH.CounterHistoryId
			JOIN Counter.Counter AS Cc ON CH.CounterId = Cc.CounterId
			JOIN EquipmentMain.BelongCurrent AS BC ON Cc.CoreEquipmentId = BC.CoreEquipmentId
			--JOIN EquipmentMain.[Order] AS O ON bc.InstallOrderId=o.OrderId
			join [JuridicalDB].dbo.TimeZone AS TZ on vcdj.JuridicalScaleId=tz.timezoneid
			JOIN [JuridicalDB].dbo.TimeZonal AS TZ2 ON TZ.TimeZonalId = TZ2.TimeZonalId
			join [JuridicalDB].dbo.counter as c on c.EquipmentCounterId=ch.CounterId
		
WHERE GI.Date=VCDJ.IndexDate
		and ch.dateto =''20790606''
		--and ch.DigitCapacity=c.CapacityActive
		and ch.CheckQuarter=c.CheckQuarter
			 and c.ActiveTimeZonalId =ch.ActiveScaleCount
		and tz.TimeZoneId = vcdj.JuridicalScaleId
		AND VCDJ.FilialId=[SupportDefined].[FN_getOrganizationUnitId]()
		and NOT EXISTS
		(select * from Server.DIR_Equipment.SmartIms.v_CounterDataJur AS VCDJ2
			JOIN Counter.GroupIndex AS GI2 ON VCDJ.CounterMeasuringId = GI2.CounterMeasuringId
			JOIN Counter.CounterMeasuring AS CM2 ON GI2.CounterMeasuringId = CM2.CounterMeasuringId
			JOIN Counter.CounterHistory AS CH2 ON CM2.CounterHistoryId = CH2.CounterHistoryId
			JOIN Counter.Counter AS Cc2 ON CH2.CounterId = Cc2.CounterId
			join [JuridicalDB].dbo.counter as c on c.EquipmentCounterId=ch.CounterId
			join [JuridicalDB].dbo.counterMeterage as CMJ on CMJ.CounterId=c.CounterId
			 where  CMJ.EquipmentGroupIndexGuid=GI.guid
			 
			 )


                                                        '
SET @sql = [Services].[ReplaceDatabasePath]('JDB', @sql)
EXEC (@sql) --AT UtilityServer






 IF @@ERROR <> 0 
                        ROLLBACK TRAN ImportedGroupIndex 
                ELSE 
                        COMMIT TRAN ImportedGroupIndex


END



















GO


