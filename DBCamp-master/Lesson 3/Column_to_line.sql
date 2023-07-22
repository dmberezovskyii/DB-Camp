DROP TABLE IF EXISTS dbo.InRow;
 
CREATE Table dbo.InRow (
[ProductTypeId] smallint not null ,
)

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @loop as int = 0;

WHILE @loop <= 15.
Begin try
SET @loop += 1
INSERT INTO [dbo].InRow ([ProductTypeId])
	VALUES (@loop);
END TRY

BEGIN CATCH
PRINT ''
	IF XACT_STATE() <> 0
	ROLLBACK TRAN
	THROW
END CATCH
GO

DECLARE  @IntoLine varchar(max)
DECLARE  @Result varchar(max)='1'
DECLARE Cur CURSOR fast_forward FOR
        SELECT ir.ProductTypeId  FROM InRow as ir
OPEN Cur
FETCH NEXT FROM Cur into @IntoLine
WHILE (@@FETCH_STATUS = 0)
 BEGIN

SET @Result = @Result + ',' + @IntoLine
    FETCH NEXT FROM Cur  into  @IntoLine
 
END
CLOSE Cur
DEALLOCATE Cur

SET @Result = RIGHT(@Result, LEN(@Result) - 2)
print @Result