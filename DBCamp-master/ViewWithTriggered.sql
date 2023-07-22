ALTER  VIEW zOrderEmployee
WITH SCHEMABINDING /*Triggered view*/
	AS
	SELECT   e.[Valid From],e.Employee,e.[Preferred Name],e.[Lineage Key]
	  FROM Dimension.Employee AS e
		 LEFT JOIN  Integration.Lineage AS l ON l.[Lineage Key] = e.[Lineage Key]
	WHERE l.[Lineage Key] > 1
	

	
