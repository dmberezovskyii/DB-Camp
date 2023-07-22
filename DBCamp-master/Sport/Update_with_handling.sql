SET XACT_ABORT ON
BEGIN Try
	Update dbo.Tournaments
	set TournamentName = 'National Football League'
	where TournamentName = 'NFL'
END TRY

BEGIN CATCH
	PRINT ''
	IF XACT_STATE() <> 0
	ROLLBACK TRAN
	THROW
END CATCH