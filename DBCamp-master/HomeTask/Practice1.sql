DROP TABLE IF EXISTS dbo.Goods; 
CREATE Table dbo.Goods (
[ProductTypeId] smallint not null ,
[ProductName] varchar(150) null,
[GroupToUseId] smallint not null,
	[SubGroupeId] smallint null,
	ColorId smallint not null,
	increases smallint not null
)
SET NOCOUNT ON

set XACT_ABORT ON

DECLARE @cicle as int = 1;
DECLARE @colorId as smallint = 1;

WHILE @cicle <= 100.
Begin try
	set @cicle += 1
	set @colorId += 1
INSERT INTO [dbo].[Goods] ([ProductTypeId]
, [ProductName]
, [GroupToUseId]
, [SubGroupeid]
, [ColorId]
,[increases])
	VALUES (@cicle, 'Pensil' + try_CONVERT(VARCHAR, @colorId), 1, 1, @colorId, 1);
END	TRY	   

BEGIN CATCH
	Print ''
	IF XACT_STATE() <> 0
	ROLLBACK TRAN
	Throw
END Catch			  
GO

BEGIN Try
	UPDATE [dbo].[Goods]
   SET 
      [GroupToUseId] = 2

 WHERE ProductTypeId < = 15

	 UPDATE [dbo].[Goods]
	 SET [GroupToUseId] = 3

	 WHERE ProductTypeId BETWEEN 15 AND 45
	

UPDATE [dbo].[Goods]
SET [GroupToUseId] = 3

WHERE ProductTypeId BETWEEN 45 AND 75
end try
BEGIN CATCH
	IF XACT_STATE() <> 0
		ROLLBACK TRAN
		THROW
	ELSE
		PRINT 'Updated'
END CATCH

DECLARE @Increases1 as smallint = 5,
		@Increases2 as smallint = 10,
		@IncreasesElse as smallint = 2.
DECLARE @Group1 as smallint = 2,
		@Group2 as smallint = 3,
		@ElseGroup as smallint = 1.

IF @Group1 = 2
	UPDATE Goods
		SET increases = @Increases1
			where GroupToUseId = @Group1
 IF @Group2 = 3
				UPDATE Goods
					SET increases = @Increases2
						WHERE GroupToUseId = @Group2
 IF @ElseGroup NOT in (2,3)
					UPDATE Goods
						SET increases = @IncreasesElse
						where GroupToUseId not IN(1,2)

