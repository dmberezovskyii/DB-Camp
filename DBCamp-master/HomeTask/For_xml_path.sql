IF object_id(N'TempDB..#temp ') is not null
begin
	DROP TABLE #temp;
END
GO

SELECT TOP 10
	c.CustomerName
   ,c.CustomerId INTO #temp
FROM Customers AS c;
GO

SELECT
	STUFF((SELECT
			T2.CustomerName
		FROM #temp AS T2
		WHERE t.CustomerId = t2.CustomerId

		FOR
		XML PATH (''))
	, 1, 0, '') AS CustomerXML
FROM #temp AS T;

GO
