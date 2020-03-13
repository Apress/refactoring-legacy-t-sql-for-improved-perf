DECLARE @dbname sysname;
SET @dbname = (SELECT db_name());


IF EXISTS (SELECT 1
		FROM sys.databases
		WHERE name = @dbname
		 AND is_recursive_triggers_on = '0')
BEGIN
DECLARE @theSQL nvarchar(200);

SET @theSQL = 'ALTER DATABASE ' + @dbname + '
SET RECURSIVE_TRIGGERS ON;'

EXECUTE (@theSQL);
END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.tables
	WHERE name = 'WidePosts'
)
BEGIN
	CREATE TABLE [dbo].[WidePosts]
	( [WideId]                [INT] IDENTITY(-2147483648, 1) NOT NULL
	, [PostID]                INT NULL
	, [AcceptedAnswerId]      [INT] NULL
	, [AnswerCount]           [INT] NULL
	, [Body]                  [NVARCHAR](MAX) NOT NULL
	, [ClosedDate]            [DATETIME] NULL
	, [CommentCount]          [INT] NULL
	, [CommunityOwnedDate]    [DATETIME] NULL
	, [CreationDate]          [DATETIME] NOT NULL
	, [FavoriteCount]         [INT] NULL
	, [LastActivityDate]      [DATETIME] NOT NULL
	, [LastEditDate]          [DATETIME] NULL
	, [LastEditorDisplayName] [NVARCHAR](40) NULL
	, [LastEditorUserId]      [INT] NULL
	, [OwnerUserId]           [INT] NULL
	, [ParentId]              [INT] NULL
	, [PostTypeId]            [INT] NOT NULL
	, [Score]                 [INT] NOT NULL
	, [Tags]                  [NVARCHAR](150) NULL
	, [Title]                 [NVARCHAR](250) NULL
	, [ViewCount]             [INT] NOT NULL
		-- owner user ID user ID table data	
	, [AboutMe]               [NVARCHAR](2000) NULL
	, [Age]                   [INT] NULL
	, [UserCreationDate]      [DATETIME] NOT NULL
	, [DisplayName]           [NVARCHAR](40) NOT NULL
	, [DownVotes]             [INT] NOT NULL
	, [EmailHash]             [NVARCHAR](40) NULL
	, [LastAccessDate]        [DATETIME] NOT NULL
	, [Location]              [NVARCHAR](100) NULL
	, [Reputation]            [INT] NOT NULL
	, [UpVotes]               [INT] NOT NULL
	, [Views]                 [INT] NOT NULL
	, [WebsiteUrl]            [NVARCHAR](200) NULL
	, [AccountId]             [INT] NULL	
		-- Comments table data	
	, [CommentId1]            [INT] NULL
	, [CommentCreationDate1]  [DATETIME] NULL
	, [CommentScore1]         [INT] NULL
	, [CommentText1]          [NVARCHAR](700) NULL
	, [CommentUserId1]        [INT] NULL
	, [CommentId2]            [INT] NULL
	, [CommentCreationDate2]  [DATETIME] NULL
	, [CommentScore2]         [INT] NULL
	, [CommentText2]          [NVARCHAR](700) NULL
	, [CommentUserId2]        [INT] NULL
	, [CommentId3]            [INT] NULL
	, [CommentCreationDate3]  [DATETIME] NULL
	, [CommentScore3]         [INT] NULL
	, [CommentText3]          [NVARCHAR](700) NULL
	, [CommentUserId3]        [INT] NULL
	, [CommentId4]            [INT] NULL
	, [CommentCreationDate4]  [DATETIME] NULL
	, [CommentScore4]         [INT] NULL
	, [CommentText4]          [NVARCHAR](700) NULL
	, [CommentUserId4]        [INT] NULL
	, [CommentId5]            [INT] NULL
	, [CommentCreationDate5]  [DATETIME] NULL
	, [CommentScore5]         [INT] NULL
	, [CommentText5]          [NVARCHAR](700) NULL
	, [CommentUserId5]        [INT] NULL
	, CONSTRAINT [PK_WidePosts_WideId] PRIMARY KEY CLUSTERED([WideId] ASC)
		)
	;

ALTER TABLE [dbo].[WidePosts]  WITH CHECK ADD  CONSTRAINT [fk_WidePosts_PostID] FOREIGN KEY([postID])
REFERENCES [dbo].[Posts] ([ID]);

CREATE NONCLUSTERED INDEX ix_WidePosts_postID ON dbo.WidePosts(postID);

	PRINT N'Added Table WidePosts';

END;
GO

CREATE NONCLUSTERED INDEX ix_Posts_parentID ON dbo.posts (parentID);
	PRINT N'Added index parentID on Posts';
GO

PRINT N'Start Add data to Table WidePosts';
IF NOT EXISTS
(
	SELECT 1
	FROM WidePosts
)
BEGIN

-- loop through for 1,200,000 IDs...
DECLARE @minID int = 0
	, @maxID int = 100000;

WHILE @maxID <= 1200000
BEGIN
	INSERT INTO [dbo].[WidePosts]
	( [PostID]
	, [AcceptedAnswerId]
	, [AnswerCount]
	, [Body]
	, [ClosedDate]
	, [CommentCount]
	, [CommunityOwnedDate]
	, [CreationDate]
	, [FavoriteCount]
	, [LastActivityDate]
	, [LastEditDate]
	, [LastEditorDisplayName]
	, [LastEditorUserId]
	, [OwnerUserId]
	, [ParentId]
	, [PostTypeId]
	, [Score]
	, [Tags]
	, [Title]
	, [ViewCount]
		-- owner user ID user ID table data	
	, [AboutMe]
	, [Age]
	, [UserCreationDate]
	, [DisplayName]
	, [DownVotes]
	, [EmailHash]
	, [LastAccessDate]
	, [Location]
	, [Reputation]
	, [UpVotes]
	, [Views]
	, [WebsiteUrl]
	, [AccountId]	
		-- Comments table data	
	, [CommentId1]
	, [CommentCreationDate1]
	, [CommentScore1]
	, [CommentText1]
	, [CommentUserId1]
	, [CommentId2]
	, [CommentCreationDate2]
	, [CommentScore2]
	, [CommentText2]
	, [CommentUserId2]
	, [CommentId3]
	, [CommentCreationDate3]
	, [CommentScore3]
	, [CommentText3]
	, [CommentUserId3]
	, [CommentId4]
	, [CommentCreationDate4]
	, [CommentScore4]
	, [CommentText4]
	, [CommentUserId4]
	, [CommentId5]
	, [CommentCreationDate5]
	, [CommentScore5]
	, [CommentText5]
	, [CommentUserId5]
	)
	 SELECT p.[ID]
		, p.[AcceptedAnswerId]
		, p.[AnswerCount]
		, p.[Body]
		, p.[ClosedDate]
		, p.[CommentCount]
		, p.[CommunityOwnedDate]
		, p.[CreationDate]
		, p.[FavoriteCount]
		, p.[LastActivityDate]
		, p.[LastEditDate]
		, p.[LastEditorDisplayName]
		, p.[LastEditorUserId]
		, p.[OwnerUserId]
		, p.[ParentId]
		, p.[PostTypeId]
		, p.[Score]
		, p.[Tags]
		, p.[Title]
		, p.[ViewCount]
		-- owner user ID user ID table data	
	, LEFT(u.[AboutMe], 2000)
		, u.[Age]
		, u.[CreationDate]
		, u.[DisplayName]
		, u.[DownVotes]
		, u.[EmailHash]
		, u.[LastAccessDate]
		, u.[Location]
		, u.[Reputation]
		, u.[UpVotes]
		, u.[Views]
		, u.[WebsiteUrl]
		, u.[AccountId]	
		-- Comments table data	
		, commentInfo.[CommentId1]
		, commentInfo.[CommentCreationDate1]
		, commentInfo.[CommentScore1]
		, commentInfo.[CommentText1]
		, commentInfo.[CommentUserId1]
		, commentInfo.[CommentId2]
		, commentInfo.[CommentCreationDate2]
		, commentInfo.[CommentScore2]
		, commentInfo.[CommentText2]
		, commentInfo.[CommentUserId2]
		, commentInfo.[CommentId3]
		, commentInfo.[CommentCreationDate3]
		, commentInfo.[CommentScore3]
		, commentInfo.[CommentText3]
		, commentInfo.[CommentUserId3]
		, commentInfo.[CommentId4]
		, commentInfo.[CommentCreationDate4]
		, commentInfo.[CommentScore4]
		, commentInfo.[CommentText4]
		, commentInfo.[CommentUserId4]
		, commentInfo.[CommentId5]
		, commentInfo.[CommentCreationDate5]
		, commentInfo.[CommentScore5]
		, commentInfo.[CommentText5]
		, commentInfo.[CommentUserId5]
	 FROM dbo.posts p
	 INNER JOIN dbo.Users u ON p.OwnerUserId = u.Id
		 OUTER APPLY
				 (
					 SELECT MAX(CASE
								WHEN cInfo.theRowNum = 1
								THEN cInfo.Id
								ELSE NULL
								END) AS [CommentId1]
						, MAX(CASE
								WHEN cInfo.theRowNum = 1
								THEN cInfo.CreationDate
								ELSE NULL
								END) AS [CommentCreationDate1]
						, MAX(CASE
								WHEN cInfo.theRowNum = 1
								THEN cInfo.Score
								ELSE NULL
								END) AS [CommentScore1]
						, MAX(CASE
								WHEN cInfo.theRowNum = 1
								THEN cInfo.[Text]
								ELSE NULL
								END) AS [CommentText1]
						, MAX(CASE
								WHEN cInfo.theRowNum = 1
								THEN cInfo.UserId
								ELSE NULL
								END) AS [CommentUserId1]
						, MAX(CASE
								WHEN cInfo.theRowNum = 2
								THEN cInfo.Id
								ELSE NULL
								END) AS [CommentId2]
						, MAX(CASE
								WHEN cInfo.theRowNum = 2
								THEN cInfo.CreationDate
								ELSE NULL
								END) AS [CommentCreationDate2]
						, MAX(CASE
								WHEN cInfo.theRowNum = 2
								THEN cInfo.Score
								ELSE NULL
								END) AS [CommentScore2]
						, MAX(CASE
								WHEN cInfo.theRowNum = 2
								THEN cInfo.[Text]
								ELSE NULL
								END) AS [CommentText2]
						, MAX(CASE
								WHEN cInfo.theRowNum = 2
								THEN cInfo.UserId
								ELSE NULL
								END) AS [CommentUserId2]
						, MAX(CASE
								WHEN cInfo.theRowNum = 3
								THEN cInfo.Id
								ELSE NULL
								END) AS [CommentId3]
						, MAX(CASE
								WHEN cInfo.theRowNum = 3
								THEN cInfo.CreationDate
								ELSE NULL
								END) AS [CommentCreationDate3]
						, MAX(CASE
								WHEN cInfo.theRowNum = 3
								THEN cInfo.Score
								ELSE NULL
								END) AS [CommentScore3]
						, MAX(CASE
								WHEN cInfo.theRowNum = 3
								THEN cInfo.[Text]
								ELSE NULL
								END) AS [CommentText3]
						, MAX(CASE
								WHEN cInfo.theRowNum = 3
								THEN cInfo.UserId
								ELSE NULL
								END) AS [CommentUserId3]
						, MAX(CASE
								WHEN cInfo.theRowNum = 4
								THEN cInfo.Id
								ELSE NULL
								END) AS [CommentId4]
						, MAX(CASE
								WHEN cInfo.theRowNum = 4
								THEN cInfo.CreationDate
								ELSE NULL
								END) AS [CommentCreationDate4]
						, MAX(CASE
								WHEN cInfo.theRowNum = 4
								THEN cInfo.Score
								ELSE NULL
								END) AS [CommentScore4]
						, MAX(CASE
								WHEN cInfo.theRowNum = 4
								THEN cInfo.[Text]
								ELSE NULL
								END) AS [CommentText4]
						, MAX(CASE
								WHEN cInfo.theRowNum = 4
								THEN cInfo.UserId
								ELSE NULL
								END) AS [CommentUserId4]
						, MAX(CASE
								WHEN cInfo.theRowNum = 5
								THEN cInfo.Id
								ELSE NULL
								END) AS [CommentId5]
						, MAX(CASE
								WHEN cInfo.theRowNum = 5
								THEN cInfo.CreationDate
								ELSE NULL
								END) AS [CommentCreationDate5]
						, MAX(CASE
								WHEN cInfo.theRowNum = 5
								THEN cInfo.Score
								ELSE NULL
								END) AS [CommentScore5]
						, MAX(CASE
								WHEN cInfo.theRowNum = 5
								THEN cInfo.[Text]
								ELSE NULL
								END) AS [CommentText5]
						, MAX(CASE
								WHEN cInfo.theRowNum = 5
								THEN cInfo.UserId
								ELSE NULL
								END) AS [CommentUserId5]
					 FROM
					 (
						 SELECT c.[Id]
							, c.[CreationDate]
							, c.[PostId]
							, c.[Score]
							, c.[Text]
							, c.[UserId]
							, ROW_NUMBER() OVER(PARTITION BY c.PostID
										ORDER BY CreationDate) AS theRowNum
						 FROM dbo.Comments c
						 WHERE c.PostID = p.ID
					 ) cInfo
					 WHERE cinfo.theRowNum <= 5
					 GROUP BY cInfo.PostID
				 ) commentInfo
				 -- batches of 100k to avoid blowing out tempdb totally
				 WHERE p.ID > @minID
					 AND p.ID <= @maxID;

PRINT N'Added data to Table WidePosts, through ' + CAST(@maxID AS varchar(12));

SET @minID = @minID + 100000;
SET @maxID = @maxID + 100000;

END;

	PRINT N'Done Add data to Table WidePosts';

END;
GO



IF NOT EXISTS
(
	SELECT 1
	FROM sys.triggers
	WHERE name = 'ut_Users_WidePosts'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/*******************************************************************************  
    2019.05.12   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/

CREATE TRIGGER dbo.ut_Users_WidePosts ON dbo.Users
FOR UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS (SELECT 1 FROM INSERTED)
    RETURN;
 
 END;';
	EXECUTE SP_EXECUTESQL 
		@sQL;
END;
GO

/**************************************************************
  Object Description: Pushes user changes to the WidePosts table.
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  --------------   ----------   -------------------
  2019.05.12   LBohm                  		Initial Release
*******************************************************************/

ALTER TRIGGER [dbo].[ut_Users_WidePosts] ON [dbo].[Users]
FOR UPDATE
AS
	SET NOCOUNT ON;
	IF EXISTS
	(
		SELECT 1
		FROM INSERTED i
			INNER JOIN dbo.WidePosts wp ON i.id = wp.OwnerUserId
	)
	BEGIN
		IF EXISTS
		(
			SELECT 1
			FROM INSERTED i
				INNER JOIN dbo.WidePosts wp ON i.id = wp.OwnerUserId
			WHERE i.Age <> wp.Age
						OR i.CreationDate <> wp.UserCreationDate
						OR i.DisplayName <> wp.DisplayName
						OR i.DownVotes <> wp.DownVotes
						OR i.EmailHash <> wp.EmailHash
						OR i.[Location] <> wp.[location]
						OR i.Reputation <> wp.Reputation
						OR i.UpVotes <> wp.UpVotes
						OR i.[Views] <> wp.[Views]
						OR i.WebsiteUrl <> wp.WebsiteUrl
		)
		BEGIN
			UPDATE wp
				SET 
				wp.[AboutMe] = LEFT(i.AboutMe, 2000)
			, wp.[Age] = i.Age
			, wp.[UserCreationDate] = i.CreationDate
			, wp.[DisplayName] = i.DisplayName
			, wp.[DownVotes] = i.DownVotes
			, wp.[EmailHash] = i.EmailHash
			, wp.[LastAccessDate] = i.LastAccessDate
			, wp.[Location] = i.[Location]
			, wp.[Reputation] = i.Reputation
			, wp.[UpVotes] = i.UpVotes
			, wp.[Views] = i.[Views]
			, wp.[WebsiteUrl] = i.WebsiteUrl
			, wp.AccountID = i.AccountID
			FROM dbo.WidePosts wp
				INNER JOIN INSERTED i ON wp.OwnerUserId = i.id
			WHERE i.Age <> wp.Age
						OR i.CreationDate <> wp.UserCreationDate
						OR i.DisplayName <> wp.DisplayName
						OR i.DownVotes <> wp.DownVotes
						OR i.EmailHash <> wp.EmailHash
						OR i.[Location] <> wp.[location]
						OR i.Reputation <> wp.Reputation
						OR i.UpVotes <> wp.UpVotes
						OR i.[Views] <> wp.[Views]
						OR i.WebsiteUrl <> wp.WebsiteUrl;
		END;
	END;
GO
	PRINT N'Added WidePosts trigger to Users';


 IF NOT EXISTS
(SELECT
   1
 FROM
   sys.procedures
 WHERE
   name = 'sp_codeCallsCascade'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    TodaysDate   AuthorName                     INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE dbo.sp_codeCallsCascade 
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO

/*******************************************************************************************************************  
  Object Description: Finds all cascaded code that this piece of code calls
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.17   Lisa Bohm                  Initial Release
********************************************************************************************************************/

ALTER PROCEDURE dbo.sp_codeCallsCascade @codeName nvarchar(128)
		, @rootSchema sysname
AS
     SET NOCOUNT ON;
BEGIN
                
IF @rootSchema IS NULL
BEGIN
SET @rootSchema = 'dbo';
END;
 

DECLARE  @root nvarchar(128) = 'root'
		, @rootType nvarchar(60) = 'root';

WITH CallChain AS (
SELECT @root AS callingCode 
		,  o.type_desc AS callObjType
		, 0 as theLevel
		, OBJECT_ID(@rootSchema + '.' + @codeName) AS thisobjID
		,  @rootSchema AS schemaName
		, @codeName AS thisobjName
		, o.type_desc as thisObjType
		, CAST(OBJECT_ID(@codeName)  AS varchar(4000)) AS orderBy
FROM  sys.objects AS o 
		WHERE o.object_id = OBJECT_ID(@codeName) 

UNION ALL 

SELECT	b.thisObjName
		,  o.type_desc 
		, b.theLevel + 1
		, CASE WHEN b.thisObjName = sed.referenced_entity_name THEN 0 ELSE OBJECT_ID(@rootSchema + '.' + referenced_entity_name)  END
		, CASE WHEN b.thisObjName = sed.referenced_entity_name THEN 'LOOP REF'
						WHEN b.orderBy LIKE '%' + CAST(OBJECT_ID(sed.referenced_entity_name) AS varchar(12)) + '%' THEN 'LOOP REF' 
						ELSE COALESCE(sed.referenced_schema_name,'') END 
		, sed.referenced_entity_name 
		, r.type_desc 
		, CAST(CONCAT(b.OrderBy,'-',CAST(OBJECT_ID(referenced_entity_name) AS varchar(12))) AS varchar(4000))
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id 
INNER JOIN sys.objects AS r ON OBJECT_ID(@rootSchema + '.' + referenced_entity_name)  = r.object_id 
INNER JOIN CallChain b ON sed.referencing_id = b.thisObjID
AND (r.type_desc = 'SQL_STORED_PROCEDURE' 
		OR r.type_desc LIKE 'SQL_%' + '%FUNCTION'
		OR r.type_desc = 'VIEW')
AND b.schemaName <> 'LOOP REF'
		)

		SELECT thisObjName
			, thisobjid
			, thisObjType
			, callingCode
			, theLevel
			, orderBy
			, schemaName
		INTO #callList
		FROM CallChain
		ORDER BY orderby
		OPTION (maxrecursion 200)

		;
SELECT thisObjName
		, thisObjType
		, callingCode
		, theLevel
		, schemaName
FROM #callList
ORDER BY orderby;

DROP TABLE #callList;


END;
GO
	PRINT N'Added sp_codeCallsCascade';


                IF NOT EXISTS
(SELECT
   1
 FROM
   sys.procedures
 WHERE
   name = 'sp_codeCalledCascade'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    TodaysDate   AuthorName                     INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE dbo.sp_codeCalledCascade 
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO

/*******************************************************************************************************************  
  Object Description: finds cascaded code that calls this code
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.17   Lisa Bohm                  Initial Release
********************************************************************************************************************/

ALTER PROCEDURE dbo.sp_codeCalledCascade @codeName nvarchar(128)
		, @rootSchema sysname = 'dbo'
AS
     SET NOCOUNT ON;
BEGIN
                
DECLARE  @root nvarchar(128) = 'root'
		, @rootType nvarchar(60) = 'root';

WITH CallChain AS (
SELECT @root AS calledCode 
		, o.type_desc AS thisObjType
		, 0 as theLevel
		, OBJECT_ID(@rootSchema + '.' + @codeName) AS thisobjID
		, @rootSchema AS schemaName
		, @codeName AS thisobjName
		, CAST(OBJECT_ID(@codeName)  AS varchar(4000)) AS orderBy
FROM  sys.objects AS o 
		WHERE o.object_id = OBJECT_ID(@codeName) 

UNION ALL 

SELECT b.thisobjName
		,  r.type_desc 
		, b.theLevel + 1
		, sed.referencing_id
		, CASE WHEN b.thisobjID = sed.referencing_id THEN 'LOOP REF'
						WHEN b.orderBy LIKE '%' + CAST(sed.referencing_id AS varchar(12)) + '%' THEN 'LOOP REF' 
						ELSE COALESCE(sed.referenced_schema_name,'') END 
		, r.name 
		, CAST(CONCAT(b.OrderBy,'-',CAST(referencing_id AS varchar(12))) AS varchar(4000))
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS r ON sed.referencing_id  = r.object_id 
INNER JOIN CallChain b ON OBJECT_ID(sed.referenced_entity_name) = b.thisObjID
AND (r.type_desc = 'SQL_STORED_PROCEDURE' 
		OR r.type_desc LIKE 'SQL_%' + '%FUNCTION'
		OR r.type_desc = 'VIEW')
AND b.schemaName <> 'LOOP REF'
		)

		SELECT thisObjName
			, thisobjid
			, thisObjType
			, calledCode
			, theLevel
			, orderBy
			, schemaName
		INTO #callList
		FROM CallChain
		ORDER BY orderby
		OPTION (maxrecursion 200)

		;
SELECT thisObjName
		, thisObjType
		, calledCode
		, theLevel
		, schemaName
FROM #callList
ORDER BY orderby;

DROP TABLE #callList;

END;
GO
	PRINT N'Added sp_codeCalledCascade';

	              IF NOT EXISTS
(SELECT
   1
 FROM
   sys.objects
 WHERE
   name = 'getNumLinkedPosts'
   AND type = 'FN'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.08   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.getNumLinkedPosts (@postID int)
RETURNS int
AS
BEGIN
 RETURN 1;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO

/*******************************************************************************************************************  
  Object Description: Get number of linked posts for a postID
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.08   LBohm                  Initial Release
********************************************************************************************************************/

ALTER FUNCTION dbo.getNumLinkedPosts (@postID int)
RETURNS int
AS
BEGIN
DECLARE @numPosts int;

SET @numPosts = COALESCE((SELECT COUNT(1)
					FROM dbo.postLinks
					WHERE postID = @postID),0);

RETURN @numPosts;

END;
GO
	PRINT N'Added function getNumLinkedPosts';
        
IF NOT EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'DailySummaryReportPerMonth'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/*******************************************************************************  
    2019.05.26  	 LBohm                   INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE dbo.DailySummaryReportPerMonth 
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';
	EXECUTE SP_EXECUTESQL 
		@sQL;
END;
GO

/*******************************************************************************    
Description: Data for daily report for a month   
--Test call:
-- EXECUTE dbo.DailySummaryReportPerMonth @monthYear = '20180801';
  
  
   2019.05.26  	 LBohm          INITIAL RELEASE  
***************************************************************************************/

ALTER PROCEDURE [dbo].[DailySummaryReportPerMonth] @monthyear DATETIME
AS
BEGIN
	/* in case the first day of the month not passed in */

	SET @monthyear = DATEADD(month, DATEDIFF(month, 0, @monthYear), 0);
	DECLARE @postID           INT
				, @dayOfMonth       TINYINT
				, @numAnswers       INT
				, @numUsers         INT
				, @acceptedAnswerID INT
				, @userID           INT
				, @displayName      NVARCHAR(40)
				, @isAccepted       BIT
				, @userCtThisPost   SMALLINT
				, @numUpvotes       SMALLINT;
	CREATE TABLE #finalOutput
	( monthyear                  DATETIME
	, dayOfMonth                 TINYINT
	, dayOfWeek                  TINYINT
	, numPosts                   SMALLINT
	, numResponses               SMALLINT
	, numUsersResponded          SMALLINT
	, highNumUsersSinglePost     SMALLINT
	, userMostResponses          NVARCHAR(40) -- DisplayName
	, percentagePosts            DECIMAL(8,7)
	, numHighestUpvotesOneAnswer SMALLINT
	);
	DECLARE @usersDay TABLE
	( dayOfMonth          TINYINT
	, userID              INT
	, displayName         NVARCHAR(40)
	, numPostsAnswered    SMALLINT
	, numAcceptedAnsPosts SMALLINT
	);

	/* get first post in the time period that isn't a comment or answer */

	SET @postID = COALESCE(
	(
		SELECT MIN(id)
		FROM dbo.posts
		WHERE DATEADD(month, DATEDIFF(month, 0, creationDate), 0) = @monthYear
					AND posttypeID = 1
	), 0);

	/* get all posts in the time period that aren't comments or answers */

	WHILE @postID > 0
	BEGIN
		SELECT @numAnswers = p.AnswerCount
				 , @acceptedAnswerid = p.AcceptedAnswerID
				 , @dayofmonth = DATEPART(dd, p.CreationDate)
		FROM dbo.posts p
		WHERE p.id = @postID;
		IF EXISTS
		(
			SELECT 1
			FROM #finalOutput
			WHERE dayOfmonth = @dayOfmonth
		)
		BEGIN
			-- update
			UPDATE fo
				SET 
				fo.numPosts = fo.numPosts + 1
			, fo.numResponses =
													fo.numResponses + @numAnswers
			FROM #finalOutput fo
			WHERE fo.dayOfmonth = @dayOfmonth;
		END;
		ELSE
		BEGIN
			-- insert
			INSERT INTO #finalOutput
			( monthyear
			, dayOfMonth
			, dayofWeek
			, numPosts
			, numResponses
			, numUsersResponded
			, highNumUsersSinglePost
			, userMostResponses
			, numHighestUpvotesOneAnswer
			)
			VALUES
				( @monthYear
				, @dayofmonth
				, DATEPART(dw, DATEADD(dd, @dayofmonth - 1, @monthYear))
				, 1
				, @numAnswers
				, 0
				, 0
				, ''
				, 0
				);
		END;

		/*  now the user stuff */

		SET @userCtThisPost = 0;
		SET @userID = COALESCE(
		(
			SELECT MIN(p.ownerUserID)
			FROM dbo.posts p
			WHERE p.ParentID = @postID
						AND p.postTypeID = 2
		), 0);
		WHILE @userID > 0
		BEGIN
			SET @isAccepted = COALESCE(
			(
				SELECT 1
				FROM dbo.posts p
				WHERE p.OwnerUserID = @userID
							AND p.ParentID = @postID
							AND p.id = @acceptedAnswerID
			), 0);
			SET @userCtThisPost =
														@userCtThisPost + 1;
			SET @numUpvotes = COALESCE(
			(
				SELECT MAX(p.Score)
				FROM dbo.posts p
				WHERE p.OwnerUserID = @userID
							AND p.ParentID = @postID
			), 0);
			UPDATE fo
				SET 
				fo.numUsersResponded =
															 fo.numUsersResponded + 1
			, fo.numHighestUpvotesOneAnswer = CASE
																					WHEN @numUpvotes > fo.numHighestUpvotesOneAnswer
																						THEN @numUpvotes
																				ELSE fo.numHighestUpvotesOneAnswer
																				END
			FROM #finalOutput fo
			WHERE fo.dayOfmonth = @dayOfmonth;

			/* add records to user table for later calculations */

			IF EXISTS
			(
				SELECT 1
				FROM @usersDay
				WHERE dayOfmonth = @dayOfmonth
							AND userID = @userID
			)
			BEGIN
				UPDATE ud
					SET 
					ud.numPostsAnswered =
																ud.numPostsAnswered + 1
				, ud.numAcceptedAnsPosts =
																	 ud.numAcceptedAnsPosts + @isAccepted
				FROM @usersDay ud
				WHERE dayOfmonth = @dayOfmonth
							AND userID = @userID;
			END;
			ELSE
			BEGIN
				INSERT INTO @usersDay
				( dayOfMonth
				, userID
				, displayName
				, numPostsAnswered
				, numAcceptedAnsPosts
				)
							 SELECT @dayOfMonth
										, @userID
										, u.displayName
										, 1
										, @isAccepted
							 FROM dbo.Users u
							 WHERE u.id = @userID;
			END;
			SET @userID = COALESCE(
			(
				SELECT MIN(p.ownerUserID)
				FROM dbo.posts p
				WHERE p.ParentID = @postID
							AND posttypeID = 2
							AND p.ownerUserID > @userID
			), 0);
		END;
		UPDATE fo
			SET 
			fo.highNumUsersSinglePost = CASE
																		WHEN @userCtThisPost > fo.highNumUsersSinglePost
																			THEN @userCtThisPost
																	ELSE fo.highNumUsersSinglePost
																	END
		FROM #finalOutput fo
		WHERE fo.dayOfmonth = @dayOfmonth;

		/* get next post ID */

		SET @postID = COALESCE(
		(
			SELECT MIN(id)
			FROM dbo.posts
			WHERE DATEADD(month, DATEDIFF(month, 0, creationDate), 0) = @monthYear
						AND posttypeID = 1
						AND id > @postID
		), 0);
	END;

	/* final day user calculations */

	UPDATE fo
		SET 
		fo.userMostResponses =
	(
		SELECT ud.displayName
		FROM @usersDay ud
		WHERE ud.dayOfMonth = fo.dayOfMonth
					AND ud.numPostsAnswered =
		(
			SELECT MAX(udm.numPostsAnswered)
			FROM @usersDay udm
			WHERE ud.dayOfMonth = fo.dayOfMonth
		)
	)
	, fo.percentagePosts = CASE
													 WHEN fo.numPosts = 0
														 THEN 0
												 ELSE CAST(
	(
		SELECT MAX(ud.numPostsAnswered)
		FROM @usersDay ud
		WHERE ud.dayOfMonth = fo.dayOfMonth
	) / fo.numPosts AS DECIMAL(8, 7))
												 END
	FROM #finalOutput fo;

SELECT *
FROM #finalOutput;
END;
GO

	PRINT N'Added daily summary report proc';

	
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsCh4')
BEGIN
    EXECUTE('CREATE VIEW WidePostsCh4 as SELECT 1 as t');
END;
GO

ALTER VIEW WidePostsCh4 AS 
SELECT
 p.ID AS postID
, p.AcceptedAnswerId
, p.AnswerCount
, p.Body
, p.ClosedDate
, p.CommentCount
, p.CommunityOwnedDate
, p.CreationDate
, p.FavoriteCount
, p.LastActivityDate
, p.LastEditDate
, p.LastEditorDisplayName
, p.LastEditorUserId
, p.OwnerUserId
, p.ParentId
, p.PostTypeId
, p.Score
, p.Tags
, p.Title
, p.ViewCount
, u.AboutMe
, u.Age
, u.CreationDate AS UserCreationDate
, u.DisplayName
, u.DownVotes
, u.EmailHash
, u.LastAccessDate
, u.Location
, u.Reputation
, u.UpVotes
, u.Views
, u.WebsiteUrl
, u.AccountId
, c.CommentId1
, c.CommentCreationDate1
, c.CommentScore1
, c.CommentText1
, c.CommentUserId1
, c.CommentId2
, c.CommentCreationDate2
, c.CommentScore2
, c.CommentText2
, c.CommentUserId2
, c.CommentId3
, c.CommentCreationDate3
, c.CommentScore3
, c.CommentText3
, c.CommentUserId3
, c.CommentId4
, c.CommentCreationDate4
, c.CommentScore4
, c.CommentText4
, c.CommentUserId4
, c.CommentId5
, c.CommentCreationDate5
, c.CommentScore5
, c.CommentText5
, c.CommentUserId5
FROM dbo.Posts p
INNER JOIN dbo.Users u ON p.ownerUserID = u.id
OUTER APPLY (SELECT coms.postID
		, MAX(CASE WHEN theRowNum = 1 THEN coms.id ELSE NULL END) AS commentId1
		, MAX(CASE WHEN theRowNum = 1 THEN coms.CreationDate ELSE NULL END) AS commentCreationDate1
		, MAX(CASE WHEN theRowNum = 1 THEN coms.score ELSE NULL END) AS commentScore1
		, MAX(CASE WHEN theRowNum = 1 THEN coms.[text] ELSE NULL END) AS commentText1
		, MAX(CASE WHEN theRowNum = 1 THEN coms.UserID ELSE NULL END) AS commentUserID1
		, MAX(CASE WHEN theRowNum = 2 THEN coms.id ELSE NULL END) AS commentId2						 
		, MAX(CASE WHEN theRowNum = 2 THEN coms.CreationDate ELSE NULL END) AS commentCreationDate2
		, MAX(CASE WHEN theRowNum = 2 THEN coms.score ELSE NULL END) AS commentScore2			 
		, MAX(CASE WHEN theRowNum = 2 THEN coms.[text] ELSE NULL END) AS commentText2			 
		, MAX(CASE WHEN theRowNum = 2 THEN coms.UserID ELSE NULL END) AS commentUserID2
		, MAX(CASE WHEN theRowNum = 3 THEN coms.id ELSE NULL END) AS commentId3
		, MAX(CASE WHEN theRowNum = 3 THEN coms.CreationDate ELSE NULL END) AS commentCreationDate3
		, MAX(CASE WHEN theRowNum = 3 THEN coms.score ELSE NULL END) AS commentScore3
		, MAX(CASE WHEN theRowNum = 3 THEN coms.[text] ELSE NULL END) AS commentText3
		, MAX(CASE WHEN theRowNum = 3 THEN coms.UserID ELSE NULL END) AS commentUserID3
		, MAX(CASE WHEN theRowNum = 4 THEN coms.id ELSE NULL END) AS commentId4
		, MAX(CASE WHEN theRowNum = 4 THEN coms.CreationDate ELSE NULL END) AS commentCreationDate4
		, MAX(CASE WHEN theRowNum = 4 THEN coms.score ELSE NULL END) AS commentScore4
		, MAX(CASE WHEN theRowNum = 4 THEN coms.[text] ELSE NULL END) AS commentText4
		, MAX(CASE WHEN theRowNum = 4 THEN coms.UserID ELSE NULL END) AS commentUserID4
		, MAX(CASE WHEN theRowNum = 5 THEN coms.id ELSE NULL END) AS commentId5
		, MAX(CASE WHEN theRowNum = 5 THEN coms.CreationDate ELSE NULL END) AS commentCreationDate5
		, MAX(CASE WHEN theRowNum = 5 THEN coms.score ELSE NULL END) AS commentScore5
		, MAX(CASE WHEN theRowNum = 5 THEN coms.[text] ELSE NULL END) AS commentText5
		, MAX(CASE WHEN theRowNum = 5 THEN coms.UserID ELSE NULL END) AS commentUserID5

	FROM (SELECT ID
			, CreationDate
			, score
			, [text]
			, userID
			, postID
			, ROW_NUMBER() OVER (PARTITION BY postID ORDER BY CreationDate) AS theRowNum
		FROM dbo.comments com
		WHERE com.postID = p.id) coms
	WHERE coms.theRowNum <= 5
	GROUP BY coms.PostID) c;
GO

PRINT N'Added WidePostsCh4 view';
  
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusOne')
BEGIN
    EXECUTE('CREATE VIEW WidePostsPlusOne as SELECT 1 as t');
END;

GO

ALTER VIEW WidePostsPlusOne AS 
SELECT wp.*
	, pt.Type AS PostType
	, vt.Userid AS voteUser
FROM dbo.WidePostsCh4 wp
	INNER JOIN dbo.PostTypes pt ON wp.PostTypeID = pt.id
INNER JOIN dbo.Votes vt ON vt.PostID = wp.PostID;

GO

PRINT N'Added WidePostsPlusOne view';


IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusTwo')
BEGIN
    EXECUTE('CREATE VIEW WidePostsPlusTwo as SELECT 1 as t');
END;

GO

ALTER VIEW WidePostsPlusTwo AS 

SELECT wp1.postID
, wp1.AcceptedAnswerId
, wp1.AnswerCount
, wp1.Body
, wp1.ClosedDate
, wp1.CommentCount
, wp1.CommunityOwnedDate
, wp1.CreationDate
, wp1.FavoriteCount
, wp1.LastActivityDate
, wp1.LastEditDate
, wp1.LastEditorDisplayName
, wp1.LastEditorUserId
, wp1.OwnerUserId
, wp1.ParentId
, wp1.PostTypeId
, wp1.Score
, wp1.Tags
, wp1.Title
, wp1.ViewCount
, wp1.AboutMe
, wp1.Age
, wp1.UserCreationDate
, wp1.DisplayName
, wp1.DownVotes
, wp1.EmailHash
, wp1.LastAccessDate
, wp1.[Location]
, wp1.Reputation
, wp1.UpVotes
, wp1.[Views]
, wp1.WebsiteUrl
, wp1.AccountId
, wp1.CommentId1
, wp1.CommentCreationDate1
, wp1.CommentScore1
, wp1.CommentText1
, wp1.CommentUserId1
, wp1.CommentId2
, wp1.CommentCreationDate2
, wp1.CommentScore2
, wp1.CommentText2
, wp1.CommentUserId2
, wp1.CommentId3
, wp1.CommentCreationDate3
, wp1.CommentScore3
, wp1.CommentText3
, wp1.CommentUserId3
, wp1.CommentId4
, wp1.CommentCreationDate4
, wp1.CommentScore4
, wp1.CommentText4
, wp1.CommentUserId4
, wp1.CommentId5
, wp1.CommentCreationDate5
, wp1.CommentScore5
, wp1.CommentText5
, wp1.CommentUserId5
, wp1.PostType
, vty.[name] AS VoteType
, COUNT(wp1.voteUser) AS numVotes
FROM dbo.WidePostsPlusOne wp1
INNER JOIN dbo.Votes vt ON vt.PostID = wp1.PostID
INNER JOIN dbo.VoteTypes vty ON vt.VoteTypeID = vty.id
WHERE wp1.voteUser = vt.userID
GROUP BY  wp1.postID
, wp1.AcceptedAnswerId
, wp1.AnswerCount
, wp1.Body
, wp1.ClosedDate
, wp1.CommentCount
, wp1.CommunityOwnedDate
, wp1.CreationDate
, wp1.FavoriteCount
, wp1.LastActivityDate
, wp1.LastEditDate
, wp1.LastEditorDisplayName
, wp1.LastEditorUserId
, wp1.OwnerUserId
, wp1.ParentId
, wp1.PostTypeId
, wp1.Score
, wp1.Tags
, wp1.Title
, wp1.ViewCount
, wp1.AboutMe
, wp1.Age
, wp1.UserCreationDate
, wp1.DisplayName
, wp1.DownVotes
, wp1.EmailHash
, wp1.LastAccessDate
, wp1.[Location]
, wp1.Reputation
, wp1.UpVotes
, wp1.[Views]
, wp1.WebsiteUrl
, wp1.AccountId
, wp1.CommentId1
, wp1.CommentCreationDate1
, wp1.CommentScore1
, wp1.CommentText1
, wp1.CommentUserId1
, wp1.CommentId2
, wp1.CommentCreationDate2
, wp1.CommentScore2
, wp1.CommentText2
, wp1.CommentUserId2
, wp1.CommentId3
, wp1.CommentCreationDate3
, wp1.CommentScore3
, wp1.CommentText3
, wp1.CommentUserId3
, wp1.CommentId4
, wp1.CommentCreationDate4
, wp1.CommentScore4
, wp1.CommentText4
, wp1.CommentUserId4
, wp1.CommentId5
, wp1.CommentCreationDate5
, wp1.CommentScore5
, wp1.CommentText5
, wp1.CommentUserId5
, wp1.PostType
, vt.VoteTypeID
, vty.[Name];

GO

PRINT N'Added WidePostsPlusTwo view';


IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusThree')
BEGIN
    EXECUTE('CREATE VIEW WidePostsPlusThree as SELECT 1 as t');
END;

GO

ALTER VIEW WidePostsPlusThree AS 
SELECT wp2.postID
, wp2.AcceptedAnswerId
, wp2.AnswerCount
, wp2.Body
, wp2.ClosedDate
, wp2.CommentCount
, wp2.CommunityOwnedDate
, wp2.CreationDate
, wp2.FavoriteCount
, wp2.LastActivityDate
, wp2.LastEditDate
, wp2.LastEditorDisplayName
, wp2.LastEditorUserId
, wp2.OwnerUserId
, wp2.ParentId
, wp2.PostTypeId
, wp2.Score
, wp2.Tags
, wp2.Title
, wp2.ViewCount
, wp2.AboutMe
, wp2.Age
, wp2.UserCreationDate
, wp2.DisplayName
, wp2.DownVotes
, wp2.EmailHash
, wp2.LastAccessDate
, wp2.[Location]
, wp2.Reputation
, wp2.UpVotes
, wp2.[Views]
, wp2.WebsiteUrl
, wp2.AccountId
, wp2.PostType
, wp2.voteType
, wp2.numVotes
, commentUnpivot.commentID
, commentUnpivot.commentCreationDate
, commentUnpivot.commentScore
, commentUnpivot.commentText
, commentUnpivot.commentUserID

FROM dbo.WidePostsPlusTwo wp2
INNER JOIN (SELECT CommentID1 AS commentID
										, CommentCreationDate1 AS commentCreationDate
										, CommentScore1 AS commentScore
										, CommentText1 AS commentText
										, CommentUserID1 AS commentUserID
										, PostID
						FROM dbo.WidePostsPlusTwo
						UNION ALL
						SELECT CommentID2
										, CommentCreationDate2
										, CommentScore2
										, CommentText2
										, CommentUserID2
										, PostID
						FROM dbo.WidePostsPlusTwo
						UNION ALL
						SELECT CommentID3
										, CommentCreationDate3
										, CommentScore3
										, CommentText3
										, CommentUserID3
										, PostID
						FROM dbo.WidePostsPlusTwo
						UNION ALL
						SELECT CommentID4 
										, CommentCreationDate4 
										, CommentScore4
										, CommentText4 
										, CommentUserID4
										, PostID
						FROM dbo.WidePostsPlusTwo
						UNION ALL
						SELECT CommentID5
										, CommentCreationDate5
										, CommentScore5
										, CommentText5
										, CommentUserID5
										, PostID
						FROM dbo.WidePostsPlusTwo) commentUnpivot ON wp2.postID = commentUnpivot.postID
;

GO

PRINT N'Added WidePostsPlusThree view';

IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsPlusFour')
BEGIN
    EXECUTE('CREATE VIEW WidePostsPlusFour as SELECT 1 as t');
END;

GO

ALTER VIEW WidePostsPlusFour AS 
SELECT wp3.*
		, dbo.getnumLinkedPosts(wp3.postID) AS numLinkedPosts
FROM dbo.WidePostsPlusThree wp3
WHERE wp3.commentID IS NOT NULL;
GO

PRINT N'Added WidePostsPlusFour view';


IF NOT EXISTS
(
	SELECT 1
	FROM sys.tables
	WHERE name = 'Triggerlog'
)
BEGIN

CREATE TABLE dbo.Triggerlog (logID int identity (-2147483648,1)
   , id int
	 , thisdate datetime2
	 , thisaction nvarchar(50)
	 , descript nvarchar(50)
	 );
 END;
 GO
 
	PRINT N'Added triggerlog table';

 IF NOT EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'iu_Users_DownVotes'

)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.30   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/
CREATE TRIGGER iu_Users_DownVotes ON dbo.Users
FOR INSERT,UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS (SELECT 1 FROM INSERTED)
    RETURN;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO
/*******************************************************************************************************************  
  Object Description: Reduces User Reputation after 5 downvotes.
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.30   LBohm                  		Initial Release
********************************************************************************************************************/

ALTER TRIGGER [iu_Users_DownVotes] ON [dbo].[Users]
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON;
-- if the downvote count divided by 5 has no remainder, subtract 1 from the reputation
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0)
BEGIN
UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0;

INSERT INTO dbo.triggerlog (id, thisdate, thisaction, descript)
SELECT i.id
, getdate()
, 'User downvote trigger ran'
, 'downvotes: ' + CAST(downvotes as nvarchar(12)) + '; reputation: ' + CAST(reputation as nvarchar(12))
FROM INSERTED i
WHERE i.reputation > 0;


END;

END;
GO

	PRINT N'Added downvotes trigger on Users';
	

               IF NOT EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'i_LinkTypes_doNothing'

)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.30   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/

CREATE TRIGGER dbo.i_LinkTypes_doNothing ON dbo.LinkTypes
FOR INSERT
AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS (SELECT 1 FROM INSERTED)
    RETURN;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO
/*******************************************************************************************************************  
  Object Description: Doesn't do a thing.
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.30   LBohm                  		Initial Release
********************************************************************************************************************/

ALTER TRIGGER [dbo].[i_LinkTypes_doNothing] ON [dbo].[LinkTypes]
FOR INSERT
AS
BEGIN
SET NOCOUNT ON;

UPDATE lt
SET lt.[type] = lt.[Type]
FROM dbo.linkTypes lt
INNER JOIN INSERTED i ON lt.id = i.id
WHERE 1 = 0;

INSERT INTO dbo.triggerlog (id, thisdate, thisaction, descript)
VALUES (0
, getdate()
, 'LT Insert Do Nothing Trigger Ran'
, ''
)


END;
GO
	PRINT N'Added insert trigger to LinkTypes';

               IF NOT EXISTS
(SELECT
   1
 FROM
   sys.triggers
 WHERE
   name = 'u_LinkTypes_doNothing'

)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.30   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/

CREATE TRIGGER dbo.u_LinkTypes_doNothing ON dbo.LinkTypes
FOR UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS (SELECT 1 FROM INSERTED)
    RETURN;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO
/*******************************************************************************************************************  
  Object Description: Doesn't do a thing.
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.06.30   LBohm                  		Initial Release
********************************************************************************************************************/

ALTER TRIGGER [dbo].[u_LinkTypes_doNothing] ON [dbo].[LinkTypes]
FOR UPDATE
AS
BEGIN
SET NOCOUNT ON;


INSERT INTO dbo.triggerlog (id, thisdate, thisaction, descript)
VALUES (0
, getdate()
, 'LT Update do-nothing Trigger Ran'
, ''
)
END;
GO
	PRINT N'Added update trigger to LinkTypes';


IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Posts')
    AND name='ix_Posts_ownerUserID')
BEGIN
CREATE NONCLUSTERED INDEX [ix_Posts_ownerUserID] ON [dbo].[Posts]
(
	[ownerUserID] ASC,
	[PostTypeId] ASC
);

END;
GO
	PRINT N'Added index to posts';


IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Posts')
    AND name='ix_Posts_creationDate')
BEGIN
CREATE NONCLUSTERED INDEX [ix_Posts_creationDate] ON [dbo].[Posts]
(
	[creationDate] ASC
);

END;
GO
	PRINT N'Added index to posts';


IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Users')
    AND name='ix_Users_displayName')
BEGIN
CREATE NONCLUSTERED INDEX [ix_Users_displayName] ON [dbo].[Users]
(
	[displayName] ASC
	);

END;
GO
	PRINT N'Added index to users';

             IF NOT EXISTS
(SELECT
   1
 FROM
   sys.objects
 WHERE
   name = 'getLastBadgeUser'
   AND type = 'FN'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.07.07  LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.getLastBadgeUser (@userID int)
RETURNS int
AS
BEGIN
 RETURN 1;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO



/*******************************************************************************************************************  
  Object Description: Get latest badge for a userid
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.07.07  LBohm                  Initial Release
********************************************************************************************************************/

ALTER FUNCTION dbo.getLastBadgeUser (@userID int)
RETURNS nvarchar(40)
AS
BEGIN
DECLARE @badgename nvarchar(40);

SET @badgename = COALESCE((SELECT TOP 1 [Name]
		FROM dbo.Badges
		WHERE userID = @userID
ORDER BY [Date] DESC),'');

RETURN @badgename;

END;
GO
	PRINT N'Added function getLastBadgeUser';

--Numbers table:
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'Numbers')
BEGIN
  DECLARE @UpperLimit INT;
  SET @UpperLimit = 5000000;

  WITH
     n5   (x) AS (SELECT 1 UNION SELECT 0),  
     n4   (x) AS (SELECT 1 FROM n5 CROSS JOIN n5 AS x),
     n3   (x) AS (SELECT 1 FROM n4 CROSS JOIN n4 AS x),
     n2   (x) AS (SELECT 1 FROM n3 CROSS JOIN n3 AS x),
     n1   (x) AS (SELECT 1 FROM n2 CROSS JOIN n2 AS x),
     n0   (x) AS (SELECT 1 FROM n1 CROSS JOIN n1 AS x),
     Nbrs (x) AS 
     (
         SELECT
             ROW_NUMBER() OVER
             (ORDER BY x)
         FROM n0
     )
  SELECT [n] = x
    INTO dbo.Numbers
    FROM Nbrs
    WHERE x BETWEEN 1 AND @UpperLimit;

  CREATE UNIQUE CLUSTERED INDEX n ON dbo.Numbers ([n]);
END
GO
	PRINT N'Added numbers table';

IF NOT EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'getUserInfoByName'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/*******************************************************************************  
    2019.07.07  	 LBohm                   INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE dbo.getUserInfoByName 
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';
	EXECUTE SP_EXECUTESQL 
		@sQL;
END;
GO

/*******************************************************************************    
Description: Data for users by name
--Test call:
-- EXECUTE dbo.getUserInfoByName @theName = 'Joel’;
  
    2019.07.07  	 LBohm          INITIAL RELEASE  
***************************************************************************************/

ALTER PROCEDURE [dbo].[getUserInfoByName] @theName varchar(20)
AS
BEGIN
SELECT u.ID
		, u.displayname
		, u.aboutme
		, count(p.id) AS numPosts
		, (SELECT COUNT(v.id) FROM votes v 
						where EXISTS (SELECT 1 FROM posts vp
																WHERE vp.id = v.PostId 
																 AND vp.OwnerUserId = u.id)
																AND v.votetypeID = 5) AS numfavVotes
		, (SELECT COUNT(pc.id)
						FROM dbo.Posts pc
						WHERE pc.ownerUserID = u.id
						 AND pc.postTypeID = 2) AS numComments
		, (SELECT MAX(creationDate)
						FROM dbo.posts plastcom
						WHERE plastcom.ownerUserID = u.id
						AND plastcom.postTypeID = 2) AS dateLastComment
		, u.upvotes
		, u.downvotes
		, dbo.getlastBadgeUser(u.id) AS latestBadge
FROM dbo.users u
		INNER JOIN dbo.posts p on u.id = p.ownerUserID
WHERE u.[DisplayName] LIKE '%' + @theName + '%'
		and p.PostTypeId = 1
GROUP BY u.ID, u.displayname, u.aboutme, u.upvotes, u.downvotes;
END;
GO
	PRINT N'Added getUserInfoByname';




IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Posts')
    AND name='ix_Posts_score')
BEGIN
CREATE INDEX ix_Posts_score ON dbo.Posts (Score);
END;
GO
	PRINT N'Added index to Posts on Score';

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.Votes')
    AND name='ix_Votes_postID')
BEGIN
CREATE INDEX ix_Votes_postID ON dbo.Votes (PostID);
END;
GO
	PRINT N'Added index to Votes';

IF NOT EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'increment'
   AND type = 'FN')
BEGIN
DECLARE @SQL nvarchar(1200);

SET @SQL = N'/*******************************************************************************  
    2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.increment (@someint int)
RETURNS int
AS
BEGIN
 RETURN 1;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO


/*******************************************************************************************************************  
  Object Description: Adds 1 to a number
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
********************************************************************************************************************/

ALTER FUNCTION dbo.increment (@someint int)
RETURNS int
AS
BEGIN
RETURN(@someint + 1); 
END;
GO
	PRINT N'Added function increment';

IF NOT EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'andTheKitchenSink'
   AND type = 'FN')
BEGIN
DECLARE @SQL nvarchar(1200);

SET @SQL = N'/*******************************************************************************  
    2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.andTheKitchenSink (@someint int)
RETURNS int
AS
BEGIN
 RETURN 1;
 
 END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO


/*******************************************************************************************************************  
  Object Description: Gets a bunch of different possible values
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
********************************************************************************************************************/

ALTER FUNCTION dbo.andTheKitchenSink (@postID int, @value varchar(8))
RETURNS varchar(30)
AS
BEGIN
DECLARE @returnValue varchar(30)
, @numComments varchar(30)
, @numResponses varchar(30)
, @numResponders varchar(30)
, @numLinks varchar(30)
, @numVotes varchar(30)
;

SET @numComments = COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
										FROM dbo.Comments
										WHERE postID = @postID),'0');

SET @numResponses = COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
										FROM dbo.posts
										WHERE parentID = @postID
												AND postTypeID = 2),'0');

SET @numResponders = COALESCE((SELECT CAST(COUNT(DISTINCT OwnerUserID) AS varchar(30))
										FROM dbo.posts
										WHERE parentID = @postID
												AND postTypeID = 2),'0');

SET @numLinks = COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
										FROM dbo.PostLinks
										WHERE postID = @postID),'0');

SET @numVotes = COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
										FROM dbo.Votes
										WHERE postID = @postID),'0');

SET @returnValue = CASE @value
												WHEN 'COMMENT' THEN @numComments
												WHEN 'RESPDR' THEN @numResponders
												WHEN 'LINK' THEN @numLinks
												WHEN 'VOTE' THEN @numVotes
												ELSE @numResponses
												END;
RETURN(@returnValue); 
END;
GO
	PRINT N'Added function andTheKitchenSink';

IF NOT EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'responderInfoInline'
   AND type = 'IF')
BEGIN
DECLARE @SQL nvarchar(1200);

SET @SQL = N'/*******************************************************************************  
    2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.responderInfoInline (@someint int)
RETURNS TABLE
AS
 RETURN SELECT 1 AS one;
';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO


/*******************************************************************************************************************  
  Object Description: Finds information for a responder to a post using an inline function.
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
********************************************************************************************************************/

ALTER FUNCTION dbo.responderInfoInline (@postID int)
RETURNS TABLE
AS
RETURN SELECT u.DisplayName
					, u.Reputation
					, u.WebsiteUrl
				FROM dbo.Users u
				WHERE EXISTS (SELECT 1 
							FROM dbo.posts p
							WHERE p.parentID = @postID
								  AND u.ID = p.OwnerUserId
 AND p.postTypeID = 2);
GO
	PRINT N'Added function responderInfoInline';


IF NOT EXISTS (SELECT 1 FROM sys.objects
		WHERE name = 'responderInfoMultiValue'
   AND type = 'TF')
BEGIN
DECLARE @SQL nvarchar(1200);

SET @SQL = N'/*******************************************************************************  
    2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
***************************************************************************************/

CREATE FUNCTION dbo.responderInfoMultiValue (@someint int)
RETURNS @userInfo TABLE
		(someint int)
AS
BEGIN
INSERT @userinfo(someint)
SELECT 1;
RETURN
END;';

EXECUTE SP_EXECUTESQL @SQL;
END;
GO


/*******************************************************************************************************************  
  Object Description: Finds information for a responder to a post using a multi-value function.
  
  Revision History:
  Date         Name             Label/PTS    Description
  -----------  ---------------  ----------  ----------------------------------------
  2019.07.20   LBohm                     INITIAL FUNCTION STUB CREATE RELEASE
********************************************************************************************************************/

ALTER FUNCTION dbo.responderInfoMultiValue (@postID int)
RETURNS @userInfo TABLE
		(DisplayName nvarchar(40)
				, Reputation int
				, WebsiteURL nvarchar(200)
				)
AS
BEGIN

DECLARE @userList TABLE (ownerUserID int);

INSERT INTO @userList (ownerUserID)
SELECT p.ownerUserID
FROM dbo.Posts p
WHERE p.parentID = @postID
 AND p.postTypeID = 2;

 INSERT INTO @userInfo (DisplayName, Reputation, WebsiteURL)
 SELECT u.DisplayName
					, u.Reputation
					, u.WebsiteUrl
				FROM dbo.Users u
				INNER JOIN @userlist ul ON ul.ownerUserID = u.id;

RETURN
END;
GO
	PRINT N'Added function responderInfoMultiValue';


IF NOT EXISTS(SELECT 1 FROM sys.server_event_sessions 
WHERE name='IO_Patterns')
BEGIN
CREATE EVENT SESSION [IO_Patterns] ON SERVER
ADD EVENT sqlserver.sp_statement_completed(
ACTION(sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.sql_statement_completed(
ACTION(sqlserver.sql_text,sqlserver.tsql_stack))
ADD TARGET package0.event_file(SET filename=N'C:\IOPatterns.xel');
END;
GO


	PRINT N'Added event session';
	
	
IF NOT EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'waitForForJobs'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/*******************************************************************************  
    2019.08.04 	 LBohm                   INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE dbo.waitForForJobs 
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';
	EXECUTE SP_EXECUTESQL 
		@sQL;
END;
GO

/*******************************************************************************    
Description: Data for users by name
--Test call:
-- EXECUTE dbo.waitForForJobs @theTimeDelay = '00:02:00';
  
    2019.08.04  	 LBohm          INITIAL RELEASE  
***************************************************************************************/

ALTER PROCEDURE [dbo].[waitForForJobs] @theTimeDelay char(8) = '00:00:00'
AS


BEGIN  
    WAITFOR DELAY @theTimeDelay;
END;  
GO  	

	PRINT N'Added job waitfor proc';
	GO

/* set up “fake” jobs */
	
IF NOT EXISTS
(
	SELECT 1
	FROM msdb.dbo.sysjobs_view
	WHERE name = N'NightlyMaintenance'
)
BEGIN

DECLARE @thisDB sysname = DB_NAME();
	
EXECUTE msdb.dbo.sp_add_job @job_name = N'NightlyMaintenance';

EXECUTE msdb.dbo.sp_add_jobstep @job_name = N'NightlyMaintenance'
	, @step_name = N'Run nightly maintenance'
	, @subsystem = N'TSQL'
	, @command = N'EXECUTE dbo.waitForForJobs @theTimeDelay = ''02:00:00'''
	, @database_name = @thisDB;
	
EXECUTE msdb.dbo.sp_add_jobschedule @job_name =  N'NightlyMaintenance'
	, @name = 'Nightly maintenance'
	, @freq_type = 4
	, @freq_interval = 1
	, @active_start_date = 20190901
	, @active_start_time = '220000';
	
	EXECUTE msdb.dbo.sp_add_jobserver @job_name =  N'NightlyMaintenance'
		, @server_name = @@servername;
		
END;
GO

	PRINT N'Added nightly maintenance job';
	GO

IF NOT EXISTS
(
	SELECT 1
	FROM msdb.dbo.sysjobs_view
	WHERE name = N'ShortOne'
)
BEGIN

DECLARE @thisDB sysname = DB_NAME();
	
EXECUTE msdb.dbo.sp_add_job @job_name = N'ShortOne';

EXECUTE msdb.dbo.sp_add_jobstep @job_name = N'ShortOne'
	, @step_name = N'Run short job'
	, @subsystem = N'TSQL'
	, @command = N'EXECUTE dbo.waitForForJobs @theTimeDelay = ''00:01:00'''
	, @database_name = @thisDB;
	
EXECUTE msdb.dbo.sp_add_jobschedule @job_name =  N'ShortOne'
	, @name = 'Short sched'
	, @freq_type = 4
	, @freq_interval = 1
	, @freq_subday_type = 0x4  -- 0X8 hours….
	, @freq_subday_interval = 2
	, @active_start_date = 20190901
	, @active_start_time = '080000'
, @active_end_time = '200000';
	
	EXECUTE msdb.dbo.sp_add_jobserver @job_name =  N'ShortOne'
		, @server_name = @@servername;
		
END;
GO

	PRINT N'Added short job';
	GO

IF NOT EXISTS
(
	SELECT 1
	FROM msdb.dbo.sysjobs_view
	WHERE name = N'HourlyOne'
)
BEGIN

DECLARE @thisDB sysname = DB_NAME();
	
EXECUTE msdb.dbo.sp_add_job @job_name = N'HourlyOne';

EXECUTE msdb.dbo.sp_add_jobstep @job_name = N'HourlyOne'
	, @step_name = N'Run hourly job'
	, @subsystem = N'TSQL'
	, @command = N'EXECUTE dbo.waitForForJobs @theTimeDelay = ''00:32:00'''
	, @database_name = @thisDB;
	
EXECUTE msdb.dbo.sp_add_jobschedule @job_name =  N'HourlyOne'
	, @name = 'Hourly sched'
	, @freq_type = 4
	, @freq_interval = 1
	, @freq_subday_type = 0x8 
	, @freq_subday_interval = 1
	, @active_start_date = 20190901
	, @active_start_time = '060000'
, @active_end_time = '220000';
	
	EXECUTE msdb.dbo.sp_add_jobserver @job_name =  N'HourlyOne'
		, @server_name = @@servername;
		
END;
GO

	PRINT N'Added hourly job';
	GO

IF NOT EXISTS
(
	SELECT 1
	FROM msdb.dbo.sysjobs_view
	WHERE name = N'TooLong'
)
BEGIN

DECLARE @thisDB sysname = DB_NAME();
	
EXECUTE msdb.dbo.sp_add_job @job_name = N'TooLong';

EXECUTE msdb.dbo.sp_add_jobstep @job_name = N'TooLong'
	, @step_name = N'Run too long'
	, @subsystem = N'TSQL'
	, @command = N'EXECUTE dbo.waitForForJobs @theTimeDelay = ''00:45:00'''
	, @database_name = @thisDB;
	
EXECUTE msdb.dbo.sp_add_jobschedule @job_name =  N'TooLong'
	, @name = 'HalfHour Sched'
	, @freq_type = 4
	, @freq_interval = 1
	, @freq_subday_type = 0x4
	, @freq_subday_interval = 30
	, @active_start_date = 20190901
	, @active_start_time = '040000'
, @active_end_time = '220000';
	
	EXECUTE msdb.dbo.sp_add_jobserver @job_name =  N'TooLong'
		, @server_name = @@servername;
		
END;
GO

	PRINT N'Added too long job';
	GO
	
IF NOT EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'sp_jobOverlap'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/*******************************************************************************  
    2019.09.25		LBohm e           INITIAL STORED PROC STUB CREATE RELEASE
***************************************************************************************/

CREATE PROCEDURE [dbo].[sp_jobOverlap] @debug bit=0
AS
     SET NOCOUNT ON;
     
BEGIN
 SELECT 1;
 END;';
	EXECUTE SP_EXECUTESQL
		@sQL;
END;
GO


ALTER PROCEDURE [dbo].[sp_jobOverlap] @debug BIT=0
AS

DECLARE @dailyJobs TABLE (jobid smallint IDENTITY(1,1)  
  , jobName nvarchar(128)  
  ,schedtimeDelay time  
  , startTime time  
  , endTime time  
  , duration time);  


  
INSERT INTO @dailyJobs (jobName, schedTimeDelay, startTime, endTime, duration)  
SELECT sj.name  
--**
  , CASE WHEN freq_subday_type = 1 then '23:59:00'  
    WHEN freq_subday_type = 8 THEN CASE WHEN freq_subday_interval <= 9 THEN '0' END + CAST(freq_subday_interval AS varchar(2)) + ':00:00'  
    WHEN freq_subday_type = 4 THEN RIGHT('00' + CAST(freq_subday_interval/60 AS varchar(2)) ,2) + ':' + RIGHT('00' + CAST(freq_subday_interval % 60 AS varchar(2)),2)  + ':00'  
  END  
  , CAST(CAST((ssch.active_start_time/10000) AS varchar(2)) +':' + CAST((ssch.active_start_time) % 100 AS varchar(2))  +':' + CAST(ssch.active_start_time % 100 AS varchar(2)) AS time)  
  , CAST(CAST((ssch.active_end_time/10000) AS varchar(2)) +':' + CAST((ssch.active_end_time) % 100 AS varchar(2))  +':' + CAST(ssch.active_end_time % 100 AS varchar(2)) AS time)  
  , CAST(  
  CAST(LEFT(RIGHT('000000' + CAST(AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000'   
       + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))) AS varchar(6)),6),2) + (LEFT(RIGHT('000000' + CAST(AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000'   
       + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))) AS varchar(6)),4),2) / 60) AS varchar(2)) +':'   
    + CAST(((LEFT(RIGHT('000000' + CAST(AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000'   
       + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))) AS varchar(6)),4),2)) + (RIGHT(AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000'   
       + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))),2) / 60)) % 60 AS varchar(2))  +':'   
    + CAST(RIGHT(AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000'   
       + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))),2) % 60 AS varchar(2))  
    AS time)  
FROM msdb.dbo.sysjobs sj  
    INNER JOIN msdb.dbo.sysjobschedules AS sjs  
        ON sj.job_id = sjs.job_id  
    INNER JOIN msdb.dbo.sysschedules AS ssch  
        ON sjs.schedule_id = ssch.schedule_id  
  LEFT OUTER JOIN msdb.dbo.sysjobhistory sjh ON sj.job_id =  sjh.job_id  
WHERE ssch.freq_type = 4  
  AND sj.enabled = 1  
GROUP BY sj.job_id  
  , sj.name  
  , ssch.freq_subday_type  
  , ssch.freq_subday_interval  
  , ssch.active_start_time  
  , ssch.active_end_time;  
  
IF @debug >0  
BEGIN  
SELECT *  
FROM @dailyJobs;  
  
END;  
  
  
DECLARE @breakoutTimes TABLE (jobID int,  totschedminSet decimal(8,3), totdurationminSet decimal(8,3), numTimesDay int, endTimeSet decimal(8,3));   
  
  
INSERT INTO @breakoutTimes (jobID, totschedminSet, totdurationminSet, endTimeSet, numTimesDay)  
SELECT jobID  
  , (DATEPART(hour, schedTimeDelay) * 6.0)   
      + (CAST(DATEPART(minute, schedTimeDelay) AS decimal(8,2))/10.0)   
      + (CAST(DATEPART(second, schedTimeDelay) AS decimal(8,2))/600.0)  
  , (DATEPART(hour, duration) * 6.0)   
      + (CAST(DATEPART(minute, duration) AS decimal(8,2))/10.0)   
      + (CAST(DATEPART(second, duration) AS decimal(8,2))/600.0)  
  , CAST(DATEDIFF(minute, startTime, endTime) AS decimal(8,2))/10.0  
  , CEILING(CASE WHEN ((DATEPART(hour, schedTimeDelay) * 6.0)   
          + (CAST(DATEPART(minute, schedTimeDelay) AS decimal(8,2))/10.0)   
          + (CAST(DATEPART(second, schedTimeDelay) AS decimal(8,2))/600.0)) = 0   
     THEN 0   
     ELSE ((24.0 * 6)  
          -(CAST(DATEDIFF(minute, startTime, endTime) AS decimal(8,2))/10.0))  
          /(  
            (DATEPART(hour, schedTimeDelay) * 6.0)   
            + (CAST(DATEPART(minute, schedTimeDelay) AS decimal(8,2))/10.0)   
            + (CAST(DATEPART(second, schedTimeDelay) AS decimal(8,2))/600.0)  
          ) END)  
FROM @dailyJobs;  
  
IF @debug > 0  
BEGIN  
SELECT *  
FROM @breakoutTimes;  
END;  
/* how many times does each job run?  Calculate that */  
  
IF @debug > 0  
BEGIN  
SELECT jobSchedinf.jobID  
  , jobSchedInf.numTimesDay  
  , jobSchedInf.theStartTime  
  , jobSchedInf.theEndTime  
FROM (SELECT mj.jobID  
  , bt.numTimesDay  
  , ntInfo.N  
  , DATEADD(minute, (ntInfo.N * bt.totschedminSet * 10), mj.startTime) AS theStartTime  
  , DATEADD(minute, ((ntInfo.N * bt.totschedminSet * 10) + (bt.totdurationminSet * 10)), mj.startTime) AS theEndTime  
FROM @dailyJobs mj  
INNER JOIN @breakoutTimes bt ON mj.jobID = bt.jobID  
CROSS APPLY (SELECT N  
  FROM dbo.ident_Numbers nb  
  WHERE nb.n <= bt.numTimesDay) AS ntInfo) jobSchedInf  
  ;  
END;  
/* 144 */  
  
SELECT jobInfo.jobname
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:00:00' AND jobinfo.theStartTime < '00:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:00:00' AND jobinfo.theEndTime < '00:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:00:00' AND jobinfo.theEndTime > '00:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:10:00' AND jobinfo.theStartTime < '00:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:10:00' AND jobinfo.theEndTime < '00:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:10:00' AND jobinfo.theEndTime > '00:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:20:00' AND jobinfo.theStartTime < '00:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:20:00' AND jobinfo.theEndTime < '00:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:20:00' AND jobinfo.theEndTime > '00:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:30:00' AND jobinfo.theStartTime < '00:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:30:00' AND jobinfo.theEndTime < '00:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:30:00' AND jobinfo.theEndTime > '00:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:40:00' AND jobinfo.theStartTime < '00:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:40:00' AND jobinfo.theEndTime < '00:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:40:00' AND jobinfo.theEndTime > '00:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '00:50:00' AND jobinfo.theStartTime < '01:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '00:50:00' AND jobinfo.theEndTime < '01:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '00:50:00' AND jobinfo.theEndTime > '01:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [00:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:00:00' AND jobinfo.theStartTime < '01:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:00:00' AND jobinfo.theEndTime < '01:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:00:00' AND jobinfo.theEndTime > '01:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:10:00' AND jobinfo.theStartTime < '01:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:10:00' AND jobinfo.theEndTime < '01:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:10:00' AND jobinfo.theEndTime > '01:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:20:00' AND jobinfo.theStartTime < '01:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:20:00' AND jobinfo.theEndTime < '01:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:20:00' AND jobinfo.theEndTime > '01:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:30:00' AND jobinfo.theStartTime < '01:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:30:00' AND jobinfo.theEndTime < '01:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:30:00' AND jobinfo.theEndTime > '01:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:40:00' AND jobinfo.theStartTime < '01:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:40:00' AND jobinfo.theEndTime < '01:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:40:00' AND jobinfo.theEndTime > '01:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '01:50:00' AND jobinfo.theStartTime < '02:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '01:50:00' AND jobinfo.theEndTime < '02:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '01:50:00' AND jobinfo.theEndTime > '02:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [01:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:00:00' AND jobinfo.theStartTime < '02:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:00:00' AND jobinfo.theEndTime < '02:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:00:00' AND jobinfo.theEndTime > '02:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:10:00' AND jobinfo.theStartTime < '02:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:10:00' AND jobinfo.theEndTime < '02:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:10:00' AND jobinfo.theEndTime > '02:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:20:00' AND jobinfo.theStartTime < '02:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:20:00' AND jobinfo.theEndTime < '02:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:20:00' AND jobinfo.theEndTime > '02:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:30:00' AND jobinfo.theStartTime < '02:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:30:00' AND jobinfo.theEndTime < '02:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:30:00' AND jobinfo.theEndTime > '02:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:40:00' AND jobinfo.theStartTime < '02:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:40:00' AND jobinfo.theEndTime < '02:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:40:00' AND jobinfo.theEndTime > '02:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '02:50:00' AND jobinfo.theStartTime < '03:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '02:50:00' AND jobinfo.theEndTime < '03:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '02:50:00' AND jobinfo.theEndTime > '03:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [02:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:00:00' AND jobinfo.theStartTime < '03:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:00:00' AND jobinfo.theEndTime < '03:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:00:00' AND jobinfo.theEndTime > '03:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:10:00' AND jobinfo.theStartTime < '03:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:10:00' AND jobinfo.theEndTime < '03:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:10:00' AND jobinfo.theEndTime > '03:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:20:00' AND jobinfo.theStartTime < '03:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:20:00' AND jobinfo.theEndTime < '03:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:20:00' AND jobinfo.theEndTime > '03:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:30:00' AND jobinfo.theStartTime < '03:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:30:00' AND jobinfo.theEndTime < '03:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:30:00' AND jobinfo.theEndTime > '03:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:40:00' AND jobinfo.theStartTime < '03:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:40:00' AND jobinfo.theEndTime < '03:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:40:00' AND jobinfo.theEndTime > '03:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '03:50:00' AND jobinfo.theStartTime < '04:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '03:50:00' AND jobinfo.theEndTime < '04:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '03:50:00' AND jobinfo.theEndTime > '04:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [03:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:00:00' AND jobinfo.theStartTime < '04:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:00:00' AND jobinfo.theEndTime < '04:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:00:00' AND jobinfo.theEndTime > '04:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:10:00' AND jobinfo.theStartTime < '04:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:10:00' AND jobinfo.theEndTime < '04:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:10:00' AND jobinfo.theEndTime > '04:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:20:00' AND jobinfo.theStartTime < '04:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:20:00' AND jobinfo.theEndTime < '04:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:20:00' AND jobinfo.theEndTime > '04:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:30:00' AND jobinfo.theStartTime < '04:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:30:00' AND jobinfo.theEndTime < '04:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:30:00' AND jobinfo.theEndTime > '04:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:40:00' AND jobinfo.theStartTime < '04:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:40:00' AND jobinfo.theEndTime < '04:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:40:00' AND jobinfo.theEndTime > '04:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '04:50:00' AND jobinfo.theStartTime < '05:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '04:50:00' AND jobinfo.theEndTime < '05:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '04:50:00' AND jobinfo.theEndTime > '05:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [04:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:00:00' AND jobinfo.theStartTime < '05:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:00:00' AND jobinfo.theEndTime < '05:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:00:00' AND jobinfo.theEndTime > '05:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:10:00' AND jobinfo.theStartTime < '05:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:10:00' AND jobinfo.theEndTime < '05:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:10:00' AND jobinfo.theEndTime > '05:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:20:00' AND jobinfo.theStartTime < '05:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:20:00' AND jobinfo.theEndTime < '05:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:20:00' AND jobinfo.theEndTime > '05:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:30:00' AND jobinfo.theStartTime < '05:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:30:00' AND jobinfo.theEndTime < '05:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:30:00' AND jobinfo.theEndTime > '05:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:40:00' AND jobinfo.theStartTime < '05:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:40:00' AND jobinfo.theEndTime < '05:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:40:00' AND jobinfo.theEndTime > '05:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '05:50:00' AND jobinfo.theStartTime < '06:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '05:50:00' AND jobinfo.theEndTime < '06:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '05:50:00' AND jobinfo.theEndTime > '06:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [05:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:00:00' AND jobinfo.theStartTime < '06:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:00:00' AND jobinfo.theEndTime < '06:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:00:00' AND jobinfo.theEndTime > '06:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:10:00' AND jobinfo.theStartTime < '06:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:10:00' AND jobinfo.theEndTime < '06:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:10:00' AND jobinfo.theEndTime > '06:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:20:00' AND jobinfo.theStartTime < '06:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:20:00' AND jobinfo.theEndTime < '06:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:20:00' AND jobinfo.theEndTime > '06:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:30:00' AND jobinfo.theStartTime < '06:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:30:00' AND jobinfo.theEndTime < '06:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:30:00' AND jobinfo.theEndTime > '06:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:40:00' AND jobinfo.theStartTime < '06:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:40:00' AND jobinfo.theEndTime < '06:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:40:00' AND jobinfo.theEndTime > '06:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '06:50:00' AND jobinfo.theStartTime < '07:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '06:50:00' AND jobinfo.theEndTime < '07:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '06:50:00' AND jobinfo.theEndTime > '07:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [06:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:00:00' AND jobinfo.theStartTime < '07:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:00:00' AND jobinfo.theEndTime < '07:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:00:00' AND jobinfo.theEndTime > '07:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:10:00' AND jobinfo.theStartTime < '07:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:10:00' AND jobinfo.theEndTime < '07:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:10:00' AND jobinfo.theEndTime > '07:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:20:00' AND jobinfo.theStartTime < '07:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:20:00' AND jobinfo.theEndTime < '07:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:20:00' AND jobinfo.theEndTime > '07:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:30:00' AND jobinfo.theStartTime < '07:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:30:00' AND jobinfo.theEndTime < '07:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:30:00' AND jobinfo.theEndTime > '07:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:40:00' AND jobinfo.theStartTime < '07:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:40:00' AND jobinfo.theEndTime < '07:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:40:00' AND jobinfo.theEndTime > '07:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '07:50:00' AND jobinfo.theStartTime < '08:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '07:50:00' AND jobinfo.theEndTime < '08:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '07:50:00' AND jobinfo.theEndTime > '08:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [07:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:00:00' AND jobinfo.theStartTime < '08:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:00:00' AND jobinfo.theEndTime < '08:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:00:00' AND jobinfo.theEndTime > '08:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:10:00' AND jobinfo.theStartTime < '08:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:10:00' AND jobinfo.theEndTime < '08:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:10:00' AND jobinfo.theEndTime > '08:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:20:00' AND jobinfo.theStartTime < '08:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:20:00' AND jobinfo.theEndTime < '08:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:20:00' AND jobinfo.theEndTime > '08:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:30:00' AND jobinfo.theStartTime < '08:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:30:00' AND jobinfo.theEndTime < '08:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:30:00' AND jobinfo.theEndTime > '08:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:40:00' AND jobinfo.theStartTime < '08:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:40:00' AND jobinfo.theEndTime < '08:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:40:00' AND jobinfo.theEndTime > '08:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '08:50:00' AND jobinfo.theStartTime < '09:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '08:50:00' AND jobinfo.theEndTime < '09:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '08:50:00' AND jobinfo.theEndTime > '09:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [08:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:00:00' AND jobinfo.theStartTime < '09:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:00:00' AND jobinfo.theEndTime < '09:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:00:00' AND jobinfo.theEndTime > '09:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:10:00' AND jobinfo.theStartTime < '09:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:10:00' AND jobinfo.theEndTime < '09:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:10:00' AND jobinfo.theEndTime > '09:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:20:00' AND jobinfo.theStartTime < '09:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:20:00' AND jobinfo.theEndTime < '09:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:20:00' AND jobinfo.theEndTime > '09:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:30:00' AND jobinfo.theStartTime < '09:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:30:00' AND jobinfo.theEndTime < '09:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:30:00' AND jobinfo.theEndTime > '09:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:40:00' AND jobinfo.theStartTime < '09:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:40:00' AND jobinfo.theEndTime < '09:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:40:00' AND jobinfo.theEndTime > '09:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '09:50:00' AND jobinfo.theStartTime < '10:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '09:50:00' AND jobinfo.theEndTime < '10:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '09:50:00' AND jobinfo.theEndTime > '10:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [09:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:00:00' AND jobinfo.theStartTime < '10:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:00:00' AND jobinfo.theEndTime < '10:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:00:00' AND jobinfo.theEndTime > '10:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:10:00' AND jobinfo.theStartTime < '10:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:10:00' AND jobinfo.theEndTime < '10:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:10:00' AND jobinfo.theEndTime > '10:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:20:00' AND jobinfo.theStartTime < '10:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:20:00' AND jobinfo.theEndTime < '10:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:20:00' AND jobinfo.theEndTime > '10:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:30:00' AND jobinfo.theStartTime < '10:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:30:00' AND jobinfo.theEndTime < '10:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:30:00' AND jobinfo.theEndTime > '10:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:40:00' AND jobinfo.theStartTime < '10:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:40:00' AND jobinfo.theEndTime < '10:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:40:00' AND jobinfo.theEndTime > '10:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '10:50:00' AND jobinfo.theStartTime < '11:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '10:50:00' AND jobinfo.theEndTime < '11:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '10:50:00' AND jobinfo.theEndTime > '11:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [10:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:00:00' AND jobinfo.theStartTime < '11:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:00:00' AND jobinfo.theEndTime < '11:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:00:00' AND jobinfo.theEndTime > '11:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:10:00' AND jobinfo.theStartTime < '11:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:10:00' AND jobinfo.theEndTime < '11:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:10:00' AND jobinfo.theEndTime > '11:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:20:00' AND jobinfo.theStartTime < '11:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:20:00' AND jobinfo.theEndTime < '11:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:20:00' AND jobinfo.theEndTime > '11:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:30:00' AND jobinfo.theStartTime < '11:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:30:00' AND jobinfo.theEndTime < '11:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:30:00' AND jobinfo.theEndTime > '11:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:40:00' AND jobinfo.theStartTime < '11:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:40:00' AND jobinfo.theEndTime < '11:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:40:00' AND jobinfo.theEndTime > '11:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '11:50:00' AND jobinfo.theStartTime < '12:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '11:50:00' AND jobinfo.theEndTime < '12:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '11:50:00' AND jobinfo.theEndTime > '12:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [11:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:00:00' AND jobinfo.theStartTime < '12:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:00:00' AND jobinfo.theEndTime < '12:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:00:00' AND jobinfo.theEndTime > '12:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:10:00' AND jobinfo.theStartTime < '12:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:10:00' AND jobinfo.theEndTime < '12:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:10:00' AND jobinfo.theEndTime > '12:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:20:00' AND jobinfo.theStartTime < '12:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:20:00' AND jobinfo.theEndTime < '12:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:20:00' AND jobinfo.theEndTime > '12:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:30:00' AND jobinfo.theStartTime < '12:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:30:00' AND jobinfo.theEndTime < '12:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:30:00' AND jobinfo.theEndTime > '12:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:40:00' AND jobinfo.theStartTime < '12:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:40:00' AND jobinfo.theEndTime < '12:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:40:00' AND jobinfo.theEndTime > '12:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '12:50:00' AND jobinfo.theStartTime < '13:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '12:50:00' AND jobinfo.theEndTime < '13:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '12:50:00' AND jobinfo.theEndTime > '13:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [12:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:00:00' AND jobinfo.theStartTime < '13:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:00:00' AND jobinfo.theEndTime < '13:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:00:00' AND jobinfo.theEndTime > '13:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:10:00' AND jobinfo.theStartTime < '13:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:10:00' AND jobinfo.theEndTime < '13:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:10:00' AND jobinfo.theEndTime > '13:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:20:00' AND jobinfo.theStartTime < '13:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:20:00' AND jobinfo.theEndTime < '13:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:20:00' AND jobinfo.theEndTime > '13:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:30:00' AND jobinfo.theStartTime < '13:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:30:00' AND jobinfo.theEndTime < '13:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:30:00' AND jobinfo.theEndTime > '13:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:40:00' AND jobinfo.theStartTime < '13:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:40:00' AND jobinfo.theEndTime < '13:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:40:00' AND jobinfo.theEndTime > '13:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '13:50:00' AND jobinfo.theStartTime < '14:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '13:50:00' AND jobinfo.theEndTime < '14:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '13:50:00' AND jobinfo.theEndTime > '14:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [13:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:00:00' AND jobinfo.theStartTime < '14:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:00:00' AND jobinfo.theEndTime < '14:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:00:00' AND jobinfo.theEndTime > '14:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:10:00' AND jobinfo.theStartTime < '14:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:10:00' AND jobinfo.theEndTime < '14:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:10:00' AND jobinfo.theEndTime > '14:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:20:00' AND jobinfo.theStartTime < '14:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:20:00' AND jobinfo.theEndTime < '14:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:20:00' AND jobinfo.theEndTime > '14:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:30:00' AND jobinfo.theStartTime < '14:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:30:00' AND jobinfo.theEndTime < '14:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:30:00' AND jobinfo.theEndTime > '14:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:40:00' AND jobinfo.theStartTime < '14:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:40:00' AND jobinfo.theEndTime < '14:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:40:00' AND jobinfo.theEndTime > '14:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '14:50:00' AND jobinfo.theStartTime < '15:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '14:50:00' AND jobinfo.theEndTime < '15:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '14:50:00' AND jobinfo.theEndTime > '15:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [14:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:00:00' AND jobinfo.theStartTime < '15:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:00:00' AND jobinfo.theEndTime < '15:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:00:00' AND jobinfo.theEndTime > '15:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:10:00' AND jobinfo.theStartTime < '15:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:10:00' AND jobinfo.theEndTime < '15:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:10:00' AND jobinfo.theEndTime > '15:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:20:00' AND jobinfo.theStartTime < '15:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:20:00' AND jobinfo.theEndTime < '15:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:20:00' AND jobinfo.theEndTime > '15:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:30:00' AND jobinfo.theStartTime < '15:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:30:00' AND jobinfo.theEndTime < '15:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:30:00' AND jobinfo.theEndTime > '15:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:40:00' AND jobinfo.theStartTime < '15:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:40:00' AND jobinfo.theEndTime < '15:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:40:00' AND jobinfo.theEndTime > '15:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '15:50:00' AND jobinfo.theStartTime < '16:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '15:50:00' AND jobinfo.theEndTime < '16:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '15:50:00' AND jobinfo.theEndTime > '16:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [15:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:00:00' AND jobinfo.theStartTime < '16:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:00:00' AND jobinfo.theEndTime < '16:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:00:00' AND jobinfo.theEndTime > '16:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:10:00' AND jobinfo.theStartTime < '16:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:10:00' AND jobinfo.theEndTime < '16:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:10:00' AND jobinfo.theEndTime > '16:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:20:00' AND jobinfo.theStartTime < '16:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:20:00' AND jobinfo.theEndTime < '16:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:20:00' AND jobinfo.theEndTime > '16:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:30:00' AND jobinfo.theStartTime < '16:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:30:00' AND jobinfo.theEndTime < '16:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:30:00' AND jobinfo.theEndTime > '16:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:40:00' AND jobinfo.theStartTime < '16:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:40:00' AND jobinfo.theEndTime < '16:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:40:00' AND jobinfo.theEndTime > '16:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '16:50:00' AND jobinfo.theStartTime < '17:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '16:50:00' AND jobinfo.theEndTime < '17:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '16:50:00' AND jobinfo.theEndTime > '17:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [16:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:00:00' AND jobinfo.theStartTime < '17:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:00:00' AND jobinfo.theEndTime < '17:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:00:00' AND jobinfo.theEndTime > '17:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:10:00' AND jobinfo.theStartTime < '17:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:10:00' AND jobinfo.theEndTime < '17:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:10:00' AND jobinfo.theEndTime > '17:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:20:00' AND jobinfo.theStartTime < '17:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:20:00' AND jobinfo.theEndTime < '17:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:20:00' AND jobinfo.theEndTime > '17:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:30:00' AND jobinfo.theStartTime < '17:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:30:00' AND jobinfo.theEndTime < '17:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:30:00' AND jobinfo.theEndTime > '17:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:40:00' AND jobinfo.theStartTime < '17:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:40:00' AND jobinfo.theEndTime < '17:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:40:00' AND jobinfo.theEndTime > '17:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '17:50:00' AND jobinfo.theStartTime < '18:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '17:50:00' AND jobinfo.theEndTime < '18:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '17:50:00' AND jobinfo.theEndTime > '18:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [17:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:00:00' AND jobinfo.theStartTime < '18:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:00:00' AND jobinfo.theEndTime < '18:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:00:00' AND jobinfo.theEndTime > '18:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:10:00' AND jobinfo.theStartTime < '18:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:10:00' AND jobinfo.theEndTime < '18:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:10:00' AND jobinfo.theEndTime > '18:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:20:00' AND jobinfo.theStartTime < '18:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:20:00' AND jobinfo.theEndTime < '18:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:20:00' AND jobinfo.theEndTime > '18:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:30:00' AND jobinfo.theStartTime < '18:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:30:00' AND jobinfo.theEndTime < '18:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:30:00' AND jobinfo.theEndTime > '18:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:40:00' AND jobinfo.theStartTime < '18:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:40:00' AND jobinfo.theEndTime < '18:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:40:00' AND jobinfo.theEndTime > '18:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '18:50:00' AND jobinfo.theStartTime < '19:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '18:50:00' AND jobinfo.theEndTime < '19:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '18:50:00' AND jobinfo.theEndTime > '19:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [18:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:00:00' AND jobinfo.theStartTime < '19:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:00:00' AND jobinfo.theEndTime < '19:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:00:00' AND jobinfo.theEndTime > '19:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:10:00' AND jobinfo.theStartTime < '19:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:10:00' AND jobinfo.theEndTime < '19:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:10:00' AND jobinfo.theEndTime > '19:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:20:00' AND jobinfo.theStartTime < '19:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:20:00' AND jobinfo.theEndTime < '19:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:20:00' AND jobinfo.theEndTime > '19:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:30:00' AND jobinfo.theStartTime < '19:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:30:00' AND jobinfo.theEndTime < '19:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:30:00' AND jobinfo.theEndTime > '19:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:40:00' AND jobinfo.theStartTime < '19:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:40:00' AND jobinfo.theEndTime < '19:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:40:00' AND jobinfo.theEndTime > '19:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '19:50:00' AND jobinfo.theStartTime < '20:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '19:50:00' AND jobinfo.theEndTime < '20:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '19:50:00' AND jobinfo.theEndTime > '20:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [19:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:00:00' AND jobinfo.theStartTime < '20:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:00:00' AND jobinfo.theEndTime < '20:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:00:00' AND jobinfo.theEndTime > '20:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:10:00' AND jobinfo.theStartTime < '20:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:10:00' AND jobinfo.theEndTime < '20:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:10:00' AND jobinfo.theEndTime > '20:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:20:00' AND jobinfo.theStartTime < '20:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:20:00' AND jobinfo.theEndTime < '20:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:20:00' AND jobinfo.theEndTime > '20:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:30:00' AND jobinfo.theStartTime < '20:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:30:00' AND jobinfo.theEndTime < '20:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:30:00' AND jobinfo.theEndTime > '20:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:40:00' AND jobinfo.theStartTime < '20:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:40:00' AND jobinfo.theEndTime < '20:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:40:00' AND jobinfo.theEndTime > '20:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '20:50:00' AND jobinfo.theStartTime < '21:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '20:50:00' AND jobinfo.theEndTime < '21:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '20:50:00' AND jobinfo.theEndTime > '21:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [20:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:00:00' AND jobinfo.theStartTime < '21:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:00:00' AND jobinfo.theEndTime < '21:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:00:00' AND jobinfo.theEndTime > '21:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:10:00' AND jobinfo.theStartTime < '21:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:10:00' AND jobinfo.theEndTime < '21:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:10:00' AND jobinfo.theEndTime > '21:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:20:00' AND jobinfo.theStartTime < '21:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:20:00' AND jobinfo.theEndTime < '21:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:20:00' AND jobinfo.theEndTime > '21:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:30:00' AND jobinfo.theStartTime < '21:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:30:00' AND jobinfo.theEndTime < '21:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:30:00' AND jobinfo.theEndTime > '21:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:40:00' AND jobinfo.theStartTime < '21:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:40:00' AND jobinfo.theEndTime < '21:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:40:00' AND jobinfo.theEndTime > '21:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '21:50:00' AND jobinfo.theStartTime < '22:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '21:50:00' AND jobinfo.theEndTime < '22:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '21:50:00' AND jobinfo.theEndTime > '22:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [21:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:00:00' AND jobinfo.theStartTime < '22:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:00:00' AND jobinfo.theEndTime < '22:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:00:00' AND jobinfo.theEndTime > '22:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:10:00' AND jobinfo.theStartTime < '22:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:10:00' AND jobinfo.theEndTime < '22:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:10:00' AND jobinfo.theEndTime > '22:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:20:00' AND jobinfo.theStartTime < '22:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:20:00' AND jobinfo.theEndTime < '22:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:20:00' AND jobinfo.theEndTime > '22:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:30:00' AND jobinfo.theStartTime < '22:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:30:00' AND jobinfo.theEndTime < '22:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:30:00' AND jobinfo.theEndTime > '22:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:40:00' AND jobinfo.theStartTime < '22:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:40:00' AND jobinfo.theEndTime < '22:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:40:00' AND jobinfo.theEndTime > '22:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '22:50:00' AND jobinfo.theStartTime < '23:00:00' THEN '|'  
      WHEN jobinfo.theEndTime > '22:50:00' AND jobinfo.theEndTime < '23:00:00' THEN '|'  
      WHEN jobinfo.theStartTime < '22:50:00' AND jobinfo.theEndTime > '23:00:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [22:50]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:00:00' AND jobinfo.theStartTime < '23:10:00' THEN '|'  
      WHEN jobinfo.theEndTime > '23:00:00' AND jobinfo.theEndTime < '23:10:00' THEN '|'  
      WHEN jobinfo.theStartTime < '23:00:00' AND jobinfo.theEndTime > '23:10:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:00]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:10:00' AND jobinfo.theStartTime < '23:20:00' THEN '|'  
      WHEN jobinfo.theEndTime > '23:10:00' AND jobinfo.theEndTime < '23:20:00' THEN '|'  
      WHEN jobinfo.theStartTime < '23:10:00' AND jobinfo.theEndTime > '23:20:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:10]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:20:00' AND jobinfo.theStartTime < '23:30:00' THEN '|'  
      WHEN jobinfo.theEndTime > '23:20:00' AND jobinfo.theEndTime < '23:30:00' THEN '|'  
      WHEN jobinfo.theStartTime < '23:20:00' AND jobinfo.theEndTime > '23:30:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:20]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:30:00' AND jobinfo.theStartTime < '23:40:00' THEN '|'  
      WHEN jobinfo.theEndTime > '23:30:00' AND jobinfo.theEndTime < '23:40:00' THEN '|'  
      WHEN jobinfo.theStartTime < '23:30:00' AND jobinfo.theEndTime > '23:40:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:30]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:40:00' AND jobinfo.theStartTime < '23:50:00' THEN '|'  
      WHEN jobinfo.theEndTime > '23:40:00' AND jobinfo.theEndTime < '23:50:00' THEN '|'  
      WHEN jobinfo.theStartTime < '23:40:00' AND jobinfo.theEndTime > '23:50:00' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:40]  
  , MAX(CASE WHEN jobinfo.theStartTime >= '23:50:00' AND jobinfo.theStartTime < '23:59:59' THEN '|'  
      WHEN jobinfo.theEndTime > '23:50:00' AND jobinfo.theEndTime < '23:59:59' THEN '|'  
      WHEN jobinfo.theStartTime < '23:50:00' AND jobinfo.theEndTime > '23:59:59' THEN '-'  
      ELSE ''  
      END  
      ) AS [23:50]  
  
  
FROM (SELECT jobSchedinf.jobname  
  , jobSchedInf.numTimesDay  
  , jobSchedInf.theStartTime  
  , jobSchedInf.theEndTime  
FROM (SELECT mj.jobname 
  , bt.numTimesDay  
  , ntInfo.N  
  , DATEADD(minute, (ntInfo.N * bt.totschedminSet * 10), mj.startTime) AS theStartTime  
  , DATEADD(minute, ((ntInfo.N * bt.totschedminSet * 10) + (bt.totdurationminSet * 10)), mj.startTime) AS theEndTime  
  , LAG(DATEADD(minute, ((ntInfo.N * bt.totschedminSet * 10) + (bt.totdurationminSet * 10)), mj.startTime),1,'00:00:00') OVER (PARTITION BY mj.jobID ORDER BY ntInfo.N) AS prevEndTime  
FROM @dailyJobs mj  
INNER JOIN @breakoutTimes bt ON mj.jobID = bt.jobID  
CROSS APPLY (SELECT N  
  FROM dbo.ident_Numbers nb  
  WHERE nb.n <= bt.numTimesDay) AS ntInfo) jobSchedInf  
) jobInfo  
GROUP BY jobInfo.jobname ; 

GO

	PRINT N'Added sp_joboverlap';
	GO 