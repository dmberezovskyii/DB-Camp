USE [DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













ALTER PROCEDURE [dbo].[sp_GetEqpData] (@Type TINYINT,
 @CounterId INT = NULL,
  @date SMALLDATETIME = NULL)
AS BEGIN

-- Ë³÷èëüíèêè Device
IF @Type = 1
BEGIN
SELECT * FROM [dbo].[dm_Devices] AS DD
END




-- ²íôîðìàö³ÿ ïðî ïîêàçíèêè ë³÷èëüíèêà çà ïåð³îä DeviceData
IF @Type = 4
BEGIN

IF @CounterId IS NULL OR @date Is NULL  RETURN

SELECT  TOP 1  RT.[Ident]
       ,RRD.[DeviceId]
       ,RRD.ClassId
       ,RRD.LogicalName
       ,RRD.AttId
       ,RRD.[Time]
       ,[ReceivedTime]
       ,[Value]
       ,[Event]
       ,RTP.[Unit]
       ,RTP.[Scaler]
       ,[NormValue]
       , (CASE WHEN RTP.Number IN (7) THEN 6
			WHEN RTP.Number IN (8) THEN 5 
			WHEN RTP.Number IN (9) THEN 7 
			WHEN RTP.Number IN (15) THEN 3
			WHEN RTP.Number IN (16) THEN 2
			WHEN RTP.Number IN (5) THEN 1
       END) AS Number
       ,     NULL AS TariffId
       
FROM dbo.RW_TemplateParameter AS RTP
			LEFT JOIN dbo.RW_Template AS RT ON RTP.TemplateId = RT.Ident
			LEFT JOIN dbo.RW_ReceivedData AS RRD ON RRD.LogicalName=RTP.LogicalName
			LEFT JOIN dbo.v_Devices AS VD ON VD.Id=RRD.DeviceId
	WHERE  RRD.Time=@date
                      AND TemplateId=10 AND [Option]=0
                       AND RTP.ClassId=4
                       AND RRD.LogicalName NOT IN (0x01034B0800FF,0x0101230800FF,0x0102370800FF)
                       AND VD.Id=@CounterId
                     
          

END
END














GO


