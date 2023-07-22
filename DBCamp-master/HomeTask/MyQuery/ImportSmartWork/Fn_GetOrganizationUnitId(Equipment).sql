
GO

/****** Object:  UserDefinedFunction [SupportDefined].[FN_getOrganizationUnitId]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [SupportDefined].[FN_getOrganizationUnitId] ()
RETURNS INT
AS
/*ïîâåðòàº ³äåíòèô³êàòîð äëÿ ô³ë³àëó
110602 Dima
*/
BEGIN
RETURN
(
	SELECT TOP 1 [OU].[OrganizationUnitId] 
FROM [Services].[Setting] SS
JOIN [Organization].[OrganizationUnit] OU ON [SS].[Value] = CONVERT(CHAR(36),[OU].[Guid])
WHERE SS.[SettingId] = 5
)
END
GO


