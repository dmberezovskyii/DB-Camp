WITH Sales (SalesPersonID, SalesOrderID, SalesYear)  
AS  
-- Define the CTE query.  
(  
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
		 FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  AND SalesPersonID > 274 
    UNION ALL
		SELECT  soh.SalesPersonID, soh.SalesOrderID, YEAR(soh.OrderDate) AS SalesYear
		FROM  Sales.SalesOrderHeader AS soh
			WHERE  soh.SalesPersonID < 8
)  
-- Define the outer query referencing the CTE name.  
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  
FROM Sales 
GROUP BY SalesYear, SalesPersonID  
ORDER BY SalesPersonID, SalesYear;  
GO

DECLARE @sql VARCHAR(max)
SET @sql = 'select top 10 c.[Customer Key], c.Customer from   Dimension.Customer AS c '
EXEC (@sql) --AT UtilityServer