SELECT TOP 5 * FROM Dimension.City AS c
	WHERE c.[City Key] IN (SELECT o.[City Key] 
							FROM Fact.[Order] AS o 
								WHERE o.[City Key] IS NOT NULL)

SELECT TOP 100 * FROM Dimension.Customer AS c
	JOIN Fact.Movement AS m
	    ON m.[Customer Key] = c.[Customer Key]
WHERE m.Quantity >= 0
	ORDER BY m.Quantity
	


