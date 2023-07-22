
BEGIN

	SET @Query = 


'

declare @s INT

SELECT @s = Q FROM OPENQUERY([PR' + @FId + '],''select [D' + @FId + 'Eqp].[SupportDefined].[FN_getOrganizationUnitId]() as Q'')

INSERT INTO [#FDJur]
        ( [FId]
        ,[CEGUID]
        ,[CN]
        ,[TypeId]
        ,[Name]
        ,[ContractNumber]
        [DateFrom]

       
        )
SELECT @s as FId,
		[ce].[guid] AS CEGUID, 
		[ch].CN, 
		[ch].[TypeId], 
		[CE].[Name],
		[ppl].[Contractnumber], 
		[BC].[DateFrom]
		 
  FROM   
		DB' + @FId + '.PR' + @FId + 'Eqp.PL.EsjPoint AS ppl
		JOIN DB' + @FId + '.PR' + @FId + 'Eqp.[EqpMain].[BelongCurrent] AS BC ON [ppl].[PlacementLocationId] = [BC].[PlacementLocationId]
		JOIN DB' + @FId + '.PR' + @FId + 'Eqp.EqpMain.PL AS PL ON BC.PlacementLocationId = PL.PlacementLocationId 
		JOIN DB' + @FId + '.PR' + @FId + 'Eqp.ORG.OrganizationUnit AS OU ON PL.OrganizationUnitId = OU.OrganizationUnitId AND ContractorId IS NOT NULL

WHERE NOT EXISTS (SELECT * FROM [SmartIms].[FilialDeviceJur] AS FD WHERE [Guid] = CE.Guid)
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
	PRINT @FId
	
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber
    ,ERROR_MESSAGE() as ErrorMessage
END CATCH;
--SELECT @Query
	FETCH NEXT FROM SmartCounterFrom INTO @FId
END

CLOSE SmartCounterFrom
DEALLOCATE SmartCounterFrom





GO


