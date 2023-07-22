SELECT DISTINCT
p.ProductID
	,Name
   ,MIN(ListPrice) OVER (PARTITION BY p.Color) AS MinCost
   ,MAX(ListPrice) OVER (PARTITION BY p.Color) AS MaxCost
   ,AVG(ListPrice) OVER (PARTITION BY p.Color) AS AvgCost
   
FROM SalesLT.Product AS p
WHERE p.Color IN ('Black', 'Red', 'Silver')
