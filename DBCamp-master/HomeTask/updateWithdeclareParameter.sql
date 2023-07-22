DECLARE @organizationid INT
SET @organizationid='350'

BEGIN TRANSACTION;
INSERT INTO [EquipmentMain].[PlacementLocationRule]( Guid, [EquipmentKindId], [SourcePlacementLocationTypeId], [SourceOrganizationUnitId], [SourcePlacementLocationId], [CurrentPlacementLocationTypeId], [CurrentOrganizationUnitId], [CurrentPlacementLocationId], [TargetPlacementLocationTypeId], [TargetOrganizationUnitId], [TargetPlacementLocationId], [IsEnabled], [EmployeeOrganizationUnitId], [Name])
SELECT  N'858c9e0a-0f97-4f8b-8fcc-fc22576ee375', 1, NULL, NULL, NULL, 4, @organizationid, NULL, 7, @organizationid, NULL, 1, @organizationid, N'Âñò. ë³÷ ÎÂÔ' UNION ALL
SELECT  N'8a101eae-8200-4029-a0d0-b70bd8f9aac6', 2, NULL, NULL, NULL, 3, @organizationid, NULL, 7, @organizationid, NULL, 1, @organizationid, N'Âñò. ÒÑ. ÎÂÔ' UNION ALL
SELECT N'31a2051a-1cd1-4ff5-a32e-94838ad20d4b', 3, NULL, NULL, NULL, 3, @organizationid, NULL, 7, @organizationid, NULL, 1, @organizationid, N'Âñò. ÒÍ ÎÂÔ' UNION ALL
SELECT  N'5d1a40f8-0b09-42b5-aca8-b15d062c4d7b', 4, NULL, NULL, NULL, 4, @organizationid, NULL, 7, @organizationid, NULL, 1, @organizationid, N'Âñò. ïëá. ÎÂÔ' UNION ALL
SELECT  N'747977c9-00c4-405a-a358-39a00723141d', 1, NULL, NULL, NULL, 7, @organizationid, NULL, 3, @organizationid, NULL, 1, @organizationid, N'Çíÿòòÿ  ç ÒÎ ÎÂÔ'
COMMIT;
RAISERROR (N'[EquipmentMain].[PlacementLocationRule]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO


