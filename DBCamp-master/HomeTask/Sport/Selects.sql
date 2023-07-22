DECLARE @DateStart as datetime,
		@DateEnd as datetime,
		@TournamentName as varchar(max)
SET @DateStart = '20180909';
SET	@DateEnd = '20180912';
SET @TournamentName = 'Woman'

SELECT Distinct t.HomeTeam, t.AwayTeam
FROM   dbo.Teams as t

SELECT  *
FROM  dbo.Matches as m 
where m.DateMatch BEtWEEN @DateStart and @DateEnd

SELECT t.TournamentName, s.Sport,
		c.HomeClub,
		tm.HomeTeam,
		try_convert(varchar,m.DateMatch) as MatchDate,
		c.Clubs,
		tm.AwayTeam  
FROM dbo.Matches as m
	join Tournaments as t on t.TournamentId = m.TournamentId
	join dbo.Sports as s on s.SportID = m.SportID
	join dbo.Clubs as c on m.MatchId = c.MatchId
	join dbo.Teams as tm on m.MatchId = tm.MatchId


SELECT top 50 *
FROM dbo.Matches as m
	where m.DateMatch BEtWEEN @DateStart and @DateEnd   
SELECT @@error --???????? ??? ???????


select * from dbo.Matches as m
	join Tournaments as t on m.TournamentId = t.TournamentId
	where t.TournamentName like '%'+ @TournamentName + '%'
/*last*/
SELECT distinct 
		tm.HomeTeam,
		c.HomeClub
FROM dbo.Matches as m
	join Tournaments as t on t.TournamentId = m.TournamentId
	join dbo.Sports as s on s.SportID = m.SportID
	join dbo.Clubs as c on m.MatchId = c.MatchId
	join dbo.Teams as tm on m.MatchId = tm.MatchId
/*select from thew view*/
select * from MatchList 