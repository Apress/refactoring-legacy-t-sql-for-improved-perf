/* Listing 2-1: DailySummaryReportPerMonth stored procedure code */
IF NOT EXISTS
(
	SELECT 1
	FROM sys.procedures
	WHERE name = 'DailySummaryReportPerMonth'
)
BEGIN
	DECLARE @sQL NVARCHAR(1200);
	SET @sQL = N'/********************************************************************    2019.05.26  	 LBohm              INITIAL STORED PROC STUB CREATE RELEASE
************************************************************************/

CREATE PROCEDURE dbo.DailySummaryReportPerMonth 
AS
     SET NOCOUNT ON;
BEGIN
 SELECT 1;
 END;';
	EXECUTE SP_EXECUTESQL @sQL;
END;
GO

/**********************************************************************
Description: Data for daily report for a month   
--Test call:
-- EXECUTE dbo.DailySummaryReportPerMonth @monthYear = ‘20180801’;  
   2019.05.26  	 LBohm          INITIAL RELEASE  
***********************************************************************/

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
	, percentagePosts            DECIMAL(8, 7)
	, numHighestUpvotesOneAnswer SMALLINT
	);
DECLARE @usersDay TABLE
	( dayOfMonth          TINYINT
	, userID              INT
	, displayName         NVARCHAR(40)
	, numPostsAnswered    SMALLINT
	, numAcceptedAnsPosts SMALLINT
	);

/* get first post in the time period that isn’t a comment or answer */
SET @postID = COALESCE(
	(
		SELECT MIN(id)
		FROM dbo.posts
		WHERE DATEADD(month, DATEDIFF(month, 0, creationDate), 0) = @monthYear
			AND posttypeID = 1
	), 0);

	/* get all posts in the time period that aren’t comments or answers */

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
		SET fo.numPosts = fo.numPosts + 1
			, fo.numResponses = fo.numResponses + @numAnswers
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
		SET @userCtThisPost = @userCtThisPost + 1;
		SET @numUpvotes = COALESCE(
			(
				SELECT MAX(p.Score)
				FROM dbo.posts p
				WHERE p.OwnerUserID = @userID
					AND p.ParentID = @postID
			), 0);
		UPDATE fo
		SET fo.numUsersResponded = fo.numUsersResponded + 1
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
			SET ud.numPostsAnswered = ud.numPostsAnswered + 1
					, ud.numAcceptedAnsPosts = ud.numAcceptedAnsPosts + @isAccepted
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
	SET fo.highNumUsersSinglePost = CASE
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
SET fo.userMostResponses =
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

/* Listing 2-2: Data truncation example Part 1 */

DECLARE @sometable TABLE (somecol varchar(40));
DECLARE @othertable TABLE (othercol Varchar(50));

INSERT INTO @othertable(othercol)
VALUES ('blah')
		, ('foo')
		, ('short')
		, ('uhhuh');

INSERT INTO @sometable (somecol)
SELECT othercol
FROM @othertable;

SELECT *
FROM @sometable;

/* Listing 2-3: Data Truncation example Part 2 */
DECLARE @sometable TABLE (somecol varchar(40));
DECLARE @othertable TABLE (othercol Varchar(100));

INSERT INTO @othertable(othercol)
VALUES ('blah')
		, ('foo')
		, ('short')
		, ('uhhuh')
		, ('nuhuh Im going to be over 40 characters ha');

INSERT INTO @sometable (somecol)
SELECT othercol
FROM @othertable;

SELECT *
FROM @sometable;

/* Listing 2-5: Implicit Conversion example Part 1 */
DECLARE @sometable TABLE (int01 INT);
DECLARE @othertable TABLE (varchar01 varchar(8));

INSERT INTO @sometable (int01)
VALUES (1)
		, (10)
		, (23)
		, (47)
		, (56);

INSERT INTO @othertable(varchar01)
VALUES ('23')
		, ('a89')
		, ('56o')
		, ('e1')
		, ('47');

SELECT ot.varchar01
FROM @othertable ot
WHERE EXISTS (SELECT 1
			FROM @sometable st
			WHERE st.int01 = ot.varchar01);

/* Listing 2-7: Implicit Conversion example Part 2 */
DECLARE @sometable TABLE (int01 INT);
DECLARE @othertable TABLE (varchar01 varchar(8));

INSERT INTO @sometable (int01)
VALUES (1)
		, (10)
		, (23)
		, (47)
		, (56);


INSERT INTO @othertable(varchar01)
VALUES ('23')
		, ('89')
		, ('56')
		, ('1')
		, ('47');

SELECT ot.varchar01
FROM @othertable ot
WHERE EXISTS (SELECT 1
			FROM @sometable st
			WHERE st.int01 = ot.varchar01);

/* Listing 2-8: percentage posts calculation from Listing 2-1 */
CASE
	WHEN fo.numPosts = 0
THEN 0
	ELSE CAST(
			(
			  SELECT MAX(ud.numPostsAnswered)
				FROM @usersDay ud
				WHERE ud.dayOfMonth = fo.dayOfMonth
			) / fo.numPosts AS DECIMAL(8, 7))
		 END

/* Listing 2-10: Code to determine number of posts entered per month */
SELECT COUNT(1) as NumPosts
, DATEPART(year,creationdate)
, DATEPART(m, creationdate)
FROM dbo.Posts
WHERE posttypeid = 1
GROUP BY DATEPART(year,creationdate),DATEPART(m,creationdate)
ORDER BY DATEPART(year,creationdate),DATEPART(m,creationdate);

/* Listing 2-11: Sample call for sp_codeCallsCascade */
EXECUTE sp_codeCallsCascade @codeName='DailySummaryReportPerMonth', @rootSchema = 'dbo'; 

/* Listing 2-12: Native SQL Server Function in the WHERE clause from Listing 2-1 */
SET @postID = COALESCE((SELECT MIN(id)
				FROM dbo.posts
				WHERE  DATEADD(m, DATEDIFF(m, 0, creationDate),0) = @monthYear
					AND posttypeID = 1)
				,0);

/* Listing 2-13: Mocked up test example of native SQL Server function in the WHERE clause */
DECLARE @monthYear datetime = '20120801'
	, @postID int;

SET @postID = COALESCE((SELECT MIN(id)
				FROM dbo.posts
				WHERE  DATEADD(m, DATEDIFF(m, 0, creationDate),0) = @monthYear
					AND posttypeID = 1)
			,0);
SET @postID = COALESCE((SELECT MIN(id)
				FROM dbo.posts
				WHERE  DATEADD(m, DATEDIFF(m, 0, creationDate),0) = @monthYear
					AND posttypeID = 1
					AND id > @postID),0);
