WITH allProducts
AS
(SELECT DISTINCT 
	MIN(p.ListPrice - p.StandardCost) OVER (PARTITION BY p.Color) AS MinSalary,
	MAx(p.ListPrice - p.StandardCost) OVER (PARTITION BY p.Color) AS MAxSalary
	FROM SalesLT.Product AS p
	WHERE p.Color IN ('Black', 'Red', 'Silver')
		)
	
SELECT
	ap.*
FROM allProducts ap
	
