DROP TABLE IF EXISTS dbo.FTable;
DROP TABLE IF EXISTS dbo.STable;
CREATE Table FTable (
	Range1  int not null)
CREATE Table STable (
	RandomRange int not null
	)

DECLARE @range1 as int = 0;
WHILE @range1 <= 50
Begin
SET @range1 += 10;
INSERT INTO [dbo].[FTable] ([Range1])
	VALUES (@range1);
END
DECLARE @randomRange as smallint = 0;
WHILE @randomRange <= 30
Begin
SET @randomRange += 1;
INSERT INTO [dbo].STable (RandomRange, rangeid)
	VALUES (FLOOR(RAND() * (30 - 1 + 1)));
end


select f.Range1, Sum(s.RandomRange) as rangeSum from FTable as f, STable as s
group by f.Range1 WITH ROLLUP


SELECT
	f.Range1
   ,SUM(s.RandomRange) AS rangeSum
FROM FTable AS f
	,STable AS s
GROUP BY grouping SETS (rollup(f.Range1))


