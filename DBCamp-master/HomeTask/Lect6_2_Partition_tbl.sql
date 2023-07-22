/*ALTER TABLE dbo.StockChanges ADD CONSTRAINT PK_TABLE1 PRIMARY KEY NONCLUSTERED  (DocID)
   WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
         ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO*/

if exists(SELECT
	name
		FROM sys.indexes
			WHERE name = N'IX_Date')
				DROP INDEX IX_Date ON dbo.StockChanges;

CREATE NONCLUSTERED INDEX IX_Date ON dbo.StockChanges (ChangeDate)
include (MedicineId, DocID, DocType, Quantity);
GO

DBCC show_statistics ('dbo.StockChanges', IX_Date) with histogram;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @dates as datetime = '';
DECLARE @datee as datetime = ''; 

SELECT * FROM StockChanges as sc
	JOIN Medicines as m on m.MedicineId = sc.MedicineId
	WHERE ChangeDate BETWEEN @dates AND @datee