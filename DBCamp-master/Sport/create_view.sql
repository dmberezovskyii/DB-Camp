CREATE VIEW MatchList  
AS  
SELECT  *
	FROM dbo.Clubs
	union all
SELECT  *
	FROM    dbo.Teams  

