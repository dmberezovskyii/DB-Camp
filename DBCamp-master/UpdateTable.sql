UPDATE Person.Person
SET
	FirstName = 'Oleg',
	MiddleName = 'Vinnik'
WHERE FirstName NOT LIKE 'A%'
GO

SELECT  *
FROM   Person.Person AS p
GO

UPDATE p2
    SET FirstName = p.FirstName,
		MiddleName = p.MiddleName
FROM Person.Person AS p2 
	Inner Join AdventureWorks2017WorkData.Person.Person AS p on p2.BusinessEntityID = p.BusinessEntityID
WHERE p2.FirstName LIKE 'Oleg'
GO

SELECT  *
FROM    Person.Person AS p



