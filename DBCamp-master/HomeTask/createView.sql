CREATE VIEW InnerJoinPersons
AS
SELECT  CONCAT(p.FirstName,' ',p.MiddleName,'.',p.LastName) AS person, p.Title,e.LoginID
FROM  Person.Person AS p
	JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.MiddleName IS NOT NULL
GO

CREATE VIEW LeftJoinPersons
AS
SELECT  CONCAT(p.FirstName,' ',p.MiddleName,'.',p.LastName) AS person ,p.Title, e.LoginID
FROM  Person.Person AS p
	LEFT JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.MiddleName IS NOT NULL
GO

