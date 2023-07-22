/*
 * nested loop
 */
 USE AdventureWorks2017

SELECT  CONCAT(p.FirstName,' ',p.MiddleName,'.',p.LastName) AS person ,p.Title, e.LoginID
FROM  Person.Person AS p
	JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.BirthDate BETWEEN '1969-01-29' AND '1980-01-29'

/*
 * merge loop - злиття сортованим списком (використвуються індекси)
 */
 
 SELECT  p.BusinessEntityID, p.PersonType
FROM  Person.Person AS p
	 inner merge JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID

	SELECT  COUNT(p.FirstName)
	FROM    Person.Person AS p
	