IF OBJECT_ID ( N'sp_getTournamentStat', N'P' ) IS NOT NULL
Begin 
	DROP PROCEDURE sp_getTournamentStat;
END
ELSE IF OBJECT_ID ( N'sp_getTournamentStat', N'P' ) IS  NULL
	BEGIN
		DROP PROCEDURE sp_getTournamentStat;
	END
GO 

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure sp_getTournamentStat
	@TournamentName as varchar(max) = Null,
	@DateStart as datetime = null,
	@DateEnd as datetime = null
	as
 begin

SELECT
	TournamentName
   ,Sport
   ,MatchYear + '.' + MaachMonth AS dateMatch
	,[1],[2],[3],[4],[5],[6],[7] ,[8],[9],[10],[11],[12],
					[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],
					[25],[26],[27],[29],[30],[31]
FROM (SELECT
		t.TournamentName
	   ,s.Sport
	   ,CAST(YEAR(DateMatch) AS VARCHAR(4)) AS MatchYear
	   ,CAST(MONTH(DateMatch) AS VARCHAR(2)) AS MaachMonth
	   ,DAY(DateMatch) AS md
	   ,COUNT(DateMatch) AS CountDays
	FROM dbo.Matches AS m
	JOIN Tournaments AS t
		ON t.TournamentId = m.TournamentId
	JOIN Sports AS s
		ON s.SportID = m.SportID
	WHERE t.TournamentName LIKE @TournamentName
		and m.DateMatch BETWEEN @DateStart AND @DateEnd
	GROUP BY tournamentName
			,Sport
			,YEAR(m.DateMatch)
			,MONTH(m.DateMatch)
			,DAY(m.DateMatch)) P
PIVOT (
SUM(CountDays)
			FOR md IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12],
			[13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24],
			[25], [26], [27], [29], [30], [31]
)
) AS PVT

ORDER BY 1, 2
 END

 GO


BEGIN TRY
 EXEC sp_getTournamentStat @TournamentName = '%Super%'
						  ,@DateStart = '20180901'
						  ,@DateEnd = '20180912'
END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber
   ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;  