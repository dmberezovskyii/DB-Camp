 DECLARE @sql VARCHAR(max)

SET @sql = '




SELECT 

Acc,
CG.ShortName
 
FROM ACommon.Account AS A 
left join AccountingCommon.Contract AS contr on contr.AccountID=a.AccountId
JOIN ACommon.Address AS A3 ON A.AddressId = A3.AddressId
  JOIN ACommon.UsageObject AS UO ON A.AccountId = UO.AccountId
  JOIN ACommon.Address AS A2 ON UO.AddressId = A2.AddressId
  JOIN ACommon.Point AS P ON UO.UsageObjectId = P.UsageObjectId
  JOIN Measuring.Counter AS C ON p.PointId=C.PointId
  JOIN Measuring.CounterType AS CT ON c.CounterTypeId=CT.CounterTypeId
  OUTER APPLY (SELECT TOP 1 cg2.* FROM AccountingCommon.ClassifierGroupAccount AS CGA 
  JOIN Dictionary.ClassifierGroup AS CG2 ON CGA.ClassifierGroupId = CG2.ClassifierGroupId AND CG2.ClassifierGroupId IN (2,3,6,20)
  WHERE a.AccountId=CGA.AccountId) CG  
  LEFT JOIN ACommon.PhysicalPerson AS PP ON a.PhysicalPersonId=PP.PhysicalPersonId
  LEFT JOIN AD.oElement AS O ON p.oElementId=O.oElementId
 join  [EquipmentDB].Billing.[CounterTimeZonal] tz on tz.CounterTimeZonalId=c.counterId            
         JOIN  [EDB].Count.[CMeasuring] fcm ON tz.CounterMeasuringId = fcm.CounterMeasuringId
         JOIN  [EDB].Count.[CHistory] fch ON fcm.CounterHistoryId = fch.CounterHistoryId
         JOIN  [EDB].ED.[CType] fct ON fch.CounterTypeId = fct.CounterTypeId
 
WHERE C.DateTo=''20790606''
--AND fCH.IsActiveScaleCountProgrammable=1
AND contr.DateTo=''20790606''

--AND CT.Code NOT IN (10242,10243,10244)-- Smart 3
and contr.ContractRegularTypeId in (1,10)-- Äîãîâ³ð òà äîãîâ³ð íà áóä ìàéäàí÷èê (òèï äîãîâîðó)
and cg.shortname IS NOT NUll
'
SET @sql = [Services].[ReplaceDatabasePath]('EquipmentDB', @sql)
EXEC (@sql) --AT Server"


