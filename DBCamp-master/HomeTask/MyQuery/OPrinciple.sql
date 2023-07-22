
IF object_id(N'TempDB..#tmp ') > 0 
begin
       drop table #tmp
       drop table #tmp2
end

SELECT  A.AccountId,
	A.AccountNumber,
	rtrim(ltrim(PP.LastName + ' ' + PP.FirstName+ ' ' + PP.SecondName)) as family,
	LTrim(RTrim(IsNull(AD.CityTypeShortName,AD.CityTypeName))) + ' ' + LTrim(RTrim(AD.[CityName]))  +
+ CASE WHEN len(AD.[CityRegionName]) > 0 THEN  IsNull(', ' + LTrim(RTrim(AD.[CityRegionName])) + ' ðàéîí ','') 
ELSE ''END 
+ IsNull(', ' + LTrim(RTrim(IsNull(AD.StreetTypeShortName,AD.[StreetTypeName]))) + ' ' + LTrim(RTrim(AD.[StreetName])),'') +
          (Case Len(isnull(adr.Building, '')) When 0 Then '' Else ', áóä.'+LTRIM(RTRIM(Adr.Building)) End)+
          (Case Len(isnull(Adr.BuildingPart, '')) When 0 Then '' Else ', êîðï.'+LTRIM(RTRIM(Adr.BuildingPart)) End)+
          (Case Len(isnull(Adr.Apartment, '')) When 0 Then '' Else ', êâ.'+LTRIM(RTRIM(Adr.Apartment)) End)  as AddressPerson,
	oe.FullPathName,
	c.CounterNumber,
	(CASE 
		WHEN c.Phase= 0	THEN 3
				WHEN c.phase=1	THEN 1
				END) AS Phase,
				(CASE WHEN C.OperatingPrinciple=0 	THEN '²íäóêö³éíèé'
							WHEN c.OperatingPrinciple=1 THEN 'Åëåêòðîííèé'
							END) AS OperatingPrinciple,
								c.DateFrom AS dateAddInplace,
								C.DigitCapacity,
							ManufacturingYear,
							CheckQuarter,
							CT.NAME,
							p.PointId,
							C.DateFrom
INTO #tmp 

FROM Measuring.CounterType AS CT
		JOIN Measuring.Counter AS C ON CT.CounterTypeId = C.CounterTypeId
		JOIN ACommon.Point AS P ON C.PointId = P.PointId
		JOIN ADictionary.OblElement AS OE ON P.OblElementId = OE.OblElementId
		JOIN ACommon.UsageObject AS UO ON P.UsageObjectId = UO.UsageObjectId
		join ACommon.Address Adr ON uo.AddressId = Adr.AddressId
		JOIN ACommon.Account AS A ON UO.AccountId = A.AccountId 
		JOIN ACommon.PhysicalPerson AS PP ON  A.PhysicalPersonId = PP.PhysicalPersonId
		LEFT JOIN Dictionary.AddressDictionary AD ON IsNull(Adr.StreetId,Adr.CityId) = CASE WHEN Adr.StreetId is null THEN AD.CityId ELSE AD.StreetId END
		LEFT JOIN 
		(SELECT uo.AccountId, d.[DisconnectionId] ,dp.[Name] AS [DisconnectionPlaceName] ,d.[DisconnectionStatus] AS [DisconnectionPlaceStatus] , d.DateFrom AS [DateFrom] 
		,d.[Note] FROM [AccountingCommon].[Disconnection] AS d 
		JOIN ( SELECT d2.[DisconnectionId], ROW_NUMBER() OVER (PARTITION BY d2.PointId ORDER BY d2.DateFrom DESC) AS RowNumber 
		FROM [AccountingCommon].[Disconnection] as d2) AS dtemp ON dtemp.[DisconnectionId] = d.[DisconnectionId] 
		AND dtemp.RowNumber = 1 JOIN [AccountingCommon].[Point] p ON p.PointId = d.PointId 
		JOIN [AccountingCommon].[UsageObject] uo ON uo.UsageObjectId = p.UsageObjectId 
		LEFT JOIN [AccountingDictionary].[DisconnectionPlace] dp ON dp.DisconnectionPlaceId = d.DisconnectionPlaceId 
		) as ofs on ofs.AccountId = UO.AccountId 
 WHERE 
 C.DateTo='20790606'
AND ct.Code IN (
)
ORDER BY c.DateFrom




SELECT *   	INTO #tmp2             
		 FROM(SELECT PeriodFrom,
	t.family,
		SUM(Quantity) AS Quantity,
		OperatingPrinciple,
		Phase,
		DigitCapacity,
		CounterNumber,
		AccountNumber,
		FullPathName,
		t.AccountId


	
	
	

FROM FinanceMain.Operation AS o
		JOIN #tmp AS t ON o.AccountId = t.AccountId
		JOIN FinanceMain.OperationRow AS or2 ON o.OperationId=or2.OperationId
		WHERE DocumentTypeId=1    
		AND ConsumptionFrom BETWEEN DATEADD(MONTH,-3,GETDATE()) AND GETDATE()
		 
				 GROUP BY t.AccountId,t.family,
				 OperatingPrinciple,Phase,
				 t.AccountNumber,
				 FullPathName,
				 CounterNumber,
				 DigitCapacity,
				 PeriodFrom,
				 t.AccountId
			
				
				 
				 
				 
) AS qw




--SELECT TOP 50 AccountNumber,t.AccountId , 
--STUFF((  SELECT  '/' + CAST(CAST(T2.Quantity AS DECIMAL) AS VARCHAR)
--                     from #tmp2 AS T2
--where t.AccountId=t2.AccountId 

--                                                  FOR
--                                                    XML PATH('')
--                                                  ), 1, 1, '') as lcount

--FROM #tmp AS T

SELECT DATEADD(MONTH,-3,CONVERT (date, GETDATE())) AS StartDate,
CONVERT (date, GETDATE()) AS EndDate,

AccountNumber,
AddressPerson,
family,
FullPathName,
CounterNumber,
DateFrom AS InstallDate,
OperatingPrinciple,
Phase,
LEFT(CheckQuarter,4)+'.'+RIGHT(CheckQuarter,1) AS CheckQuarter,
ManufacturingYear,
REPLACE(DigitCapacity,'.',',') AS DigitCapacity,
STUFF((  SELECT  '/' + CAST(CAST(T2.Quantity AS DECIMAL) AS VARCHAR)
                  from #tmp2 AS T2
                  where t.AccountId=t2.AccountId 

                                                  FOR
                                                    XML PATH('')
                                                  ), 1, 1, '') as CountQuant
 FROM #tmp AS T
