SELECT  CONVERT(char(10),CURRENT_TIMESTAMP,102) as MatchDate,
		CAST(m.MatchId as nvarchar(max)) as MatchId
FROM dbo.Matches as m

SELECT  CAST(m.DateMatch as varchar(20)) +'|'+ ConverT(varchar(max), m.MatchId) as MatchId
FROM  dbo.Matches as m  

SELECT  TRY_CAST(s.SportID as varchar(1))/*якщо менше ніж значення поверне *** */
FROM    dbo.Sports as  s


SELECT TournamentName, Sport, MatchYear + '.' + MaachMonth as dateMatch,  
					[1],[2],[3],[4],[5],[6],[7] ,[8],[9],[10],[11],[12],
					[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],
					[25],[26],[27],[29],[30],[31]
FROM
	(
		select t.TournamentName,
		 s.Sport,
		 Cast(YEAR(DateMatch ) as varchar(4)) as MatchYear,
		  Cast(MONTH(DateMatch ) as varchar(2)) as MaachMonth, 
		  DAY(DateMatch ) as md,  
		count(DateMatch) as CountDays
				from dbo.Matches as m
					join Tournaments as t on t.TournamentId = m.TournamentId
					join Sports as s on s.SportID = m.SportID
				WHERE t.TournamentName like '%AFL%'
		group by tournamentName,Sport, YEAR(m.DateMatch ), MONTH(m.DateMatch ), DAY(m.DateMatch )    
	) P
	PIVOT (
		SUM(CountDays)
		FOR md IN([1],[2],[3],[4],[5],[6],[7] ,[8],[9],[10],[11],[12],
					[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],
					[25],[26],[27],[29],[30],[31]
					)
	) AS PVT    

order by 1, 2

SELECT  *
	FROM   dbo.Matches as m
	Cross apply 
	(select * from dbo.Sports as s
		where m.SportID = s.SportID) as sport

SELECT  *
FROM    dbo.Matches as  m
	outer apply
		(select * from Tournaments as t
			where t.TournamentId = m.TournamentId) as tour


SELECT  t.TournamentId, LEN(t.TournamentName)
FROM  Tournaments as t  