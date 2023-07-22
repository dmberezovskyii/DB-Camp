
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [SupportDefined].[FN_getOrganizationUnitId] ()
RETURNS INT
AS
/*
110602 Dima
*/
BEGIN
RETURN
(
	SELECT OU.OrganizationUnitId FROM dbo.OrganizationUnit AS OU
WHERE ContractorId IS NOT NULL
)
END
GO


