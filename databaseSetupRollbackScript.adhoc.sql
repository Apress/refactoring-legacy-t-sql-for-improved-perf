ALTER DATABASE StackOverflowForBook
SET RECURSIVE_TRIGGERS OFF;
GO

IF EXISTS
(
	SELECT 1
	FROM sys.tables
	WHERE name = 'WidePosts'
)
BEGIN
DROP TABLE dbo.WidePosts;
END;
GO

IF EXISTS
(
	SELECT 1
	FROM sys.triggers
	WHERE name = 'ut_Users_WidePosts'
)
DROP TRIGGER ut_Users_WidePosts;
GO

                IF EXISTS
(SELECT
   1
 FROM
   sys.procedures
 WHERE
   name = 'sp_jobOverlap'
)
BEGIN
DROP PROCEDURE sp_jobOverlap;
END;
GO

                IF EXISTS
(SELECT
   1
 FROM
   sys.procedures
 WHERE
   name = 'sp_codeCallsCascade'
)
BEGIN
DROP PROCEDURE sp_codeCallsCascade;
END;
GO

               IF EXISTS
(SELECT
   1
 FROM
   sys.procedures
 WHERE
   name = 'sp_codeCalledCascade'
)
BEGIN
DROP PROCEDURE sp_codeCalledCascade;
END;
GO
        
IF EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'DailySummaryReportPerMonth'
)
BEGIN
DROP PROCEDURE DailySummaryReportPerMonth;
END;
GO

IF EXISTS
(
	SELECT 1
	FROM sys.tables
	WHERE name = 'Triggerlog'
)
BEGIN
DROP TABLE Triggerlog;
END;
GO

 IF EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'iu_Users_DownVotes')
BEGIN
DROP TRIGGER iu_Users_DownVotes;
END;
GO

IF EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'i_LinkTypes_doNothing'

)
BEGIN
DROP TRIGGER i_LinkTypes_doNothing;
END;
GO

               IF EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'u_LinkTypes_doNothing'

)
BEGIN
DROP TRIGGER u_LinkTypes_doNothing;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Posts')
    AND name='ix_Posts_ownerUserID')
BEGIN
DROP INDEX [ix_Posts_ownerUserID] ON [dbo].[Posts];
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Users')
    AND name='ix_Users_displayName')
BEGIN
DROP INDEX [ix_Users_displayName] ON [dbo].[Users];
END;
GO

             IF EXISTS
(SELECT
   1
 FROM
   sys.objects
 WHERE
   name = 'getLastBadgeUser'
   AND type = 'FN'
)
BEGIN
DROP FUNCTION dbo.getLastBadgeUser;
END;
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'Numbers')
BEGIN
DROP TABLE Numbers;
END;
GO

IF EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'getUserInfoByName'
)
BEGIN
DROP PROCEDURE dbo.getUserInfoByName;
END;
GO

 

IF EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Posts')
    AND name=' ix_Posts_score')
BEGIN
DROP INDEX ix_Posts_score ON Posts;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Votes')
    AND name='ix_Votes_postID')
BEGIN
DROP INDEX ix_Votes_postID ON Votes;
END;
GO

IF EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'increment'
   AND type = 'FN')
BEGIN
DROP FUNCTION increment;
END;
GO

IF EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'andTheKitchenSink'
   AND type = 'FN')
BEGIN
DROP FUNCTION andTheKitchenSink;
END;
GO

IF EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'responderInfoInline'
   AND type = 'IF')
BEGIN
DROP FUNCTION responderInfoInline;
END;
GO

IF EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'responderInfoMultiValue'
   AND type = 'TF')
BEGIN
DROP FUNCTION responderInfoMultiValue;
END;
GO

IF EXISTS(SELECT 1 FROM sys.server_event_sessions 
WHERE name='IO_Patterns')
BEGIN
DROP EVENT SESSION [IO_Patterns] ON SERVER;
END;
GO

/* chapter 4 views */
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusFour')
BEGIN
DROP VIEW dbo.WidePostsPlusFour;
END;
GO


IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusThree')
BEGIN
DROP VIEW dbo.WidePostsPlusThree;
END;
GO


IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusTwo')
BEGIN
DROP VIEW dbo.WidePostsPlusTwo;
END;
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusOne')
BEGIN
DROP VIEW dbo.WidePostsPlusOne;
END;
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePosts')
BEGIN
DROP VIEW dbo.WidePosts;
END;
GO


              IF EXISTS
(SELECT
   1
 FROM
   sys.objects
 WHERE
   name = 'getNumLinkedPosts'
   AND type = 'FN'
)
BEGIN
DROP FUNCTION dbo.getNumLinkedPosts;
END;
GO
