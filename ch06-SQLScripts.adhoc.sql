/* Listing 6-1: Response posts for a single day. Run time 256ms */
SELECT CAST(p.creationdate AS DATE) AS createDate
	, p.id
FROM dbo.posts p
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
AND posttypeID = 1;  

/* listing 6-2: Expanded data for response posts in a single day. Run time 11ms */
SELECT CAST(p.creationdate AS DATE) AS createDate
	, p.ID
	, p.AnswerCount
	, pUser.OwnerUserID
	, CASE WHEN pUser.ID = p.AcceptedAnswerID THEN 1 ELSE 0 END AS isAccepted
	, pUser.Score AS upvotes
	, pUser.postTypeID
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND pUser.postTypeID = 2
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
	AND p.posttypeID = 1
ORDER BY p.id, pUser.ownerUserID;

/* Listing 6-3: Adding aggregates to our response posts for a single day query. Run time 9ms */
SELECT CAST(p.creationdate AS DATE) AS createDate
	, COUNT(p.ID) as numPosts
	, SUM(p.AnswerCount) AS numResponses
	, MAX(p.AnswerCount) AS maxNumAnswers
	, pUser.OwnerUserID
	, SUM(CASE WHEN pUser.ID = p.AcceptedAnswerID THEN 1 ELSE 0 END) AS isAccepted
	, MAX(pUser.Score) AS upvotes
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND pUser.postTypeID = 2
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
	AND p.posttypeID = 1
GROUP BY CAST(p.creationdate AS DATE), pUser.OwnerUserID
ORDER BY pUser.OwnerUserID;

/* Listing 6-4: Check existence of a user */
SELECT * FROM users
WHERE id = 0;

/* Listing 6-5: Adding windowing functions. Run time 56s  */
SELECT p.ID
	, CAST(p.creationdate AS DATE) AS createDate
	, p.AnswerCount
	, pUser.score
	, COUNT(pUser.parentID) OVER (PARTITION BY pUser.ownerUserID) AS numPostsUser
	, COUNT(pUser.ownerUserID) OVER (PARTITION BY pUser.parentID) AS numUsersPost
	, pUser.parentid
	, pUser.ownerUserID
	, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY pUser.ownerUserID) AS numAccepted
	, u.DisplayName
	, ROW_NUMBER() OVER (PARTITION BY pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
	AND p.posttypeID = 1;

/* Listing 6-6: Adding an outer query with some additional ROW_NUMBERs. Run time 55s */
SELECT theInfo.ID -- level two
		, theInfo.createDate
		, theInfo.answerCount
		, MAX(theInfo.score) OVER () AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER () AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER () AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER () AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (SELECT p.ID -- level one - innermost
		, CAST(p.creationdate AS DATE) AS createDate
		, p.AnswerCount
		, pUser.score
		, COUNT(pUser.parentID) OVER (PARTITION BY pUser.ownerUserID) AS numPostsUser
		, COUNT(pUser.ownerUserID) OVER (PARTITION BY pUser.parentID) AS numUsersPost
		, pUser.parentid
		, pUser.ownerUserID
		, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY pUser.ownerUserID) AS numAccepted
		, u.DisplayName
		, ROW_NUMBER() OVER (PARTITION BY pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
	AND p.posttypeID = 1) theInfo;

/* Listing 6-7: Query with filtering using aggregates and ROW_NUMBER(). Run time 55s. */
SELECT COUNT(secInfo.ID) AS numPosts  -- level three - outermost
		, secInfo.createDate
		, SUM(secInfo.answerCount) AS numResponses
		, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
		, MAX(secInfo.maxPostsUser) AS maxPostsuser
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostPosts 
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 
		, MAX(secInfo.numDistinctUsers) AS numUsersResponded

FROM (
SELECT theInfo.ID -- level two
		, theInfo.createDate
		, theInfo.answerCount
		, MAX(theInfo.score) OVER () AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER () AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER () AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER () AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (
SELECT p.ID -- level one - innermost
		, CAST(p.creationdate AS DATE) AS createDate
		, p.AnswerCount
		, pUser.score
		, COUNT(pUser.parentID) OVER (PARTITION BY pUser.ownerUserID) AS numPostsUser
		, COUNT(pUser.ownerUserID) OVER (PARTITION BY pUser.parentID) AS numUsersPost
		, pUser.parentid
		, pUser.ownerUserID
		, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY pUser.ownerUserID) AS numAccepted
		, u.DisplayName
		, ROW_NUMBER() OVER (PARTITION BY pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120802'
	AND p.posttypeID = 1) theInfo

) secInfo
WHERE secInfo.theIDRow = 1
GROUP BY secInfo.createDate; 
 
/* Listing 6-8: Adjusting query in Listing 6-6 to get data for each day for a month. Run time: 1:06 (min) */
SELECT COUNT(secInfo.ID) AS numPosts  -- level three - outermost
		, secInfo.createDate
		, SUM(secInfo.answerCount) AS numResponses
		, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
		, MAX(secInfo.maxPostsUser) AS maxPostsuser
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostPosts 
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 
		, MAX(secInfo.numDistinctUsers) AS numUsersResponded
FROM (
SELECT theInfo.ID -- level two
		, theInfo.createDate
		, theInfo.answerCount
		, MAX(theInfo.score) OVER () AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER () AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER () AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER () AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (
SELECT p.ID -- level one - innermost
		, CAST(p.creationdate AS DATE) AS createDate
		, p.AnswerCount
		, pUser.score
		, COUNT(pUser.parentID) OVER (PARTITION BY pUser.ownerUserID) AS numPostsUser
		, COUNT(pUser.ownerUserID) OVER (PARTITION BY pUser.parentID) AS numUsersPost
		, pUser.parentid
		, pUser.ownerUserID
		, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY pUser.ownerUserID) AS numAccepted
		, u.DisplayName
		, ROW_NUMBER() OVER (PARTITION BY pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120901'
	AND p.posttypeID = 1) theInfo

) secInfo
WHERE secInfo.theIDRow = 1
GROUP BY secInfo.createDate
ORDER BY secInfo.createDate;

/* Listing 6-9: Revising the first level or innermost query to include date partitioning. Run time: 1:34 (min) */
SELECT COUNT(secInfo.ID) AS numPosts  -- level three - outermost
		, secInfo.createDate
		, SUM(secInfo.answerCount) AS numResponses
		, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
		, MAX(secInfo.maxPostsUser) AS maxPostsuser
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostPosts 
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 
		, MAX(secInfo.numDistinctUsers) AS numUsersResponded
FROM (
SELECT theInfo.ID -- level two
		, theInfo.createDate
		, theInfo.answerCount
		, MAX(theInfo.score) OVER () AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER () AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER () AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER () AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (SELECT p.ID -- level one - innermost
	, CAST(p.creationdate AS DATE) AS createDate
	, p.AnswerCount
	, pUser.score
	, COUNT(pUser.parentID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numPostsUser
	, COUNT(pUser.ownerUserID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.parentID) AS numUsersPost
	, pUser.parentid
	, pUser.ownerUserID
	, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numAccepted
	, u.DisplayName
	, ROW_NUMBER() OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120901'
	AND p.posttypeID = 1) theInfo
) secInfo
WHERE secInfo.theIDRow = 1
GROUP BY secInfo.createDate
ORDER BY secInfo.createDate;

/* Listing 6-10: The code in Listing 6-9 with createDate partitioning added to the second level. Run time: 1:14 (min) */
SELECT COUNT(secInfo.ID) AS numPosts  -- level three - outermost
		, secInfo.createDate
		, SUM(secInfo.answerCount) AS numResponses
		, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
		, MAX(secInfo.maxPostsUser) AS maxPostsuser
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostPosts 
		, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 
		, MAX(secInfo.numDistinctUsers) AS numUsersResponded
FROM (SELECT theInfo.ID -- level two
		, theInfo.createDate
		, MAX(theInfo.answerCount) OVER (PARTITION BY theInfo.ID) AS answerCount
		, MAX(theInfo.score) OVER (PARTITION BY theInfo.createDate) AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER (PARTITION BY theInfo.createDate) AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER (PARTITION BY theInfo.createDate) AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY theInfo.createDate) AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (
SELECT p.ID
		, CAST(p.creationdate AS DATE) AS createDate
		, p.AnswerCount
		, pUser.score
		, COUNT(pUser.parentID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numPostsUser
		, COUNT(pUser.ownerUserID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.parentID) AS numUsersPost
		, pUser.parentid
		, pUser.ownerUserID
		, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numAccepted
		, u.DisplayName
		, ROW_NUMBER() OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120901'
	AND p.posttypeID = 1
) theInfo
) secInfo
WHERE secInfo.theIDRow = 1
GROUP BY secInfo.createDate
ORDER BY secInfo.createDate;

/* Listing 6-11: Final code to replace original dailySummaryReportByMonth stored procedure code. Run time: 1:08 (min) */
SELECT secInfo.createDate AS monthYear
	, DATEPART(dd, secInfo.CreateDate) AS [dayOfMonth]
	, DATEPART(dw, secInfo.createDate) AS [dayOfWeek]
	, COUNT(secInfo.ID) AS numPosts
	, SUM(secInfo.answerCount) AS numResponses 
	, MAX(secInfo.numDistinctUsers) AS numUsersResponded
	, MAX(secInfo.maxPostsUser) AS highNumUsersSinglePost
	, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostResponses 
	, CAST(MAX(secInfo.maxPostsUser)/COUNT(secInfo.ID) * 100 AS DECIMAL(8,7)) AS percentagePosts
	, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
	, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 

FROM (
SELECT theInfo.ID 
	, theInfo.createDate
	, theInfo.answerCount
	, MAX(theInfo.score) OVER (PARTITION BY theInfo.createDate) AS maxUpvotes
	, MAX(theInfo.numPostsUser) OVER (PARTITION BY theInfo.createDate) AS maxPostsUser
	, theInfo.numPostsUser
	, theInfo.DisplayName
	, MAX(theInfo.numUsersPost) OVER (PARTITION BY theInfo.createDate) AS maxNumUsersPost
	, theInfo.numAccepted
	, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY theInfo.createDate) AS numDistinctUsers
	, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (
SELECT p.ID
		, CAST(p.creationdate AS DATE) AS createDate
		, p.AnswerCount
		, pUser.score
		, COUNT(pUser.parentID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numPostsUser
		, COUNT(pUser.ownerUserID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.parentID) AS numUsersPost
		, pUser.parentid
		, pUser.ownerUserID
		, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numAccepted
		, u.DisplayName
		, ROW_NUMBER() OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
	LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
		AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
		AND pUser.postTypeID = 2
	LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= '20120801'
	AND p.creationDate < '20120901'
	AND p.posttypeID = 1
) theInfo

) secInfo
WHERE secInfo.theIDRow = 1
GROUP BY secInfo.createDate
ORDER BY secInfo.createDate; 

/* Listing 6-12: Code over dates without posts */
SELECT COUNT(1) as numPosts
, CAST(creationdate AS date) AS theDate
FROM dbo.posts
WHERE creationdate >= '20080715'
   AND creationDate < '20080816'
GROUP BY CAST(creationdate AS date)
ORDER BY CAST(creationdate AS date);

/* Listing 6-13: Showing dates without posts using the Numbers table */
DECLARE @numDays tinyint = DATEDIFF(dd, '20080715', '20080816');
SELECT COALESCE(numPosts,0) AS numPosts
		, DATEADD(dd, n-1, '20080715') AS theDate
		, num.n
FROM dbo.numbers num
LEFT OUTER JOIN (SELECT COUNT(1) as numPosts
, CAST(creationdate AS date) AS theDate
FROM dbo.posts
WHERE creationdate >= '20080715'
   AND creationDate < '20080816'
GROUP BY CAST(creationdate AS date)
) postInfo ON DATEADD(dd, n-1, '20080715') = postInfo.theDate
WHERE num.n <= @numdays
ORDER BY postInfo.theDate;

/* Listing 6-14: Final version, replacement code for DailySummaryReportPerMonth */
ALTER PROCEDURE [dbo].[DailySummaryReportPerMonth] @monthyear DATETIME2
AS
	/* in case the first day of the month not passed in */

	SET @monthyear = DATEADD(month, DATEDIFF(month, 0, @monthYear), 0);
DECLARE @enddate datetime2 = DATEADD(month, 1, @monthYear);
DECLARE @numDays tinyint = DATEDIFF(dd, @monthYear, @enddate);

SELECT  DATEADD(dd,num.n-1,@monthYear) AS monthYear
	, DATEPART(dd, DATEADD(dd,num.n-1,@monthYear)) AS [dayOfMonth]
	, DATEPART(dw, DATEADD(dd, num.n-1,@monthYear)) AS [dayOfWeek]
	, COUNT(secInfo.ID) AS numPosts
	, SUM(secInfo.answerCount) AS numResponses 
	, MAX(secInfo.numDistinctUsers) AS numUsersResponded
	, MAX(secInfo.maxPostsUser) AS highNumUsersSinglePost
	, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.DisplayName ELSE NULL END) AS userMostResponses 
	, CAST(MAX(secInfo.maxPostsUser)/COUNT(secInfo.ID) * 100 AS DECIMAL(8,7)) AS percentagePosts
	, MAX(secInfo.maxUpvotes) AS numHighestUpvotesOneAnswer
	, MAX(CASE WHEN secInfo.maxPostsUser = secInfo.numPostsUser THEN secInfo.numAccepted ELSE 0 END) AS numAccepted 
FROM dbo.Numbers num
LEFT OUTER JOIN (
SELECT theInfo.ID 
		, theInfo.createDate
		, MAX(theInfo.answerCount) OVER (PARTITION BY theInfo.ID) AS answerCount
		, MAX(theInfo.score) OVER (PARTITION BY theInfo.createDate) AS maxUpvotes
		, MAX(theInfo.numPostsUser) OVER (PARTITION BY theInfo.createDate) AS maxPostsUser
		, theInfo.numPostsUser
		, theInfo.DisplayName
		, MAX(theInfo.numUsersPost) OVER (PARTITION BY theInfo.createDate) AS maxNumUsersPost
		, theInfo.numAccepted
		, SUM(CASE WHEN theInfo.theUserRowNum = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY theInfo.createDate) AS numDistinctUsers
		, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY numPostsUser DESC) AS theIDRow
FROM (
SELECT p.ID
			, CAST(p.creationdate AS DATE) AS createDate
			, p.AnswerCount
			, pUser.score
			, COUNT(pUser.parentID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numPostsUser
			, COUNT(pUser.ownerUserID) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.parentID) AS numUsersPost
			, pUser.parentid
			, pUser.ownerUserID
			, SUM(CASE WHEN pUser.id = p.AcceptedAnswerId THEN 1 ELSE 0 END) OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID) AS numAccepted
			, u.DisplayName
			, ROW_NUMBER() OVER (PARTITION BY CAST(p.creationdate AS DATE), pUser.ownerUserID ORDER BY pUser.parentID DESC) AS theUserRowNum
FROM dbo.posts p
		LEFT OUTER JOIN dbo.posts pUser ON p.id = pUser.parentID
			AND EXISTS (SELECT pUser.ownerUserID EXCEPT (SELECT NULL UNION SELECT 0))
			AND pUser.postTypeID = 2
		LEFT OUTER JOIN dbo.users u ON pUser.OwnerUserId = u.id
WHERE p.creationDate >= @monthYear
			AND p.creationDate < @endDate
			AND p.posttypeID = 1
) theInfo

) secInfo ON secInfo.createDate = DATEADD(dd, num.n-1,@monthYear) -- n starts at 1 so you want to subtract one to start with the “normal” first day
	AND secInfo.theIDRow = 1
GROUP BY num.n
ORDER BY num.n;

/* Listing 6-15: Executing the stored procedure with STATISTICS IO and TIME on */
SET STATISTICS IO,TIME ON;
GO
EXECUTE getUserInfoByName @theName = 'Joel';

/* Listing 6-16: getUserInfoByName query with subqueries removed */
DECLARE @theName NVARCHAR  (40) = 'Joel';
SELECT u.ID
	, u.displayname
	, u.aboutme
	, SUM(CASE WHEN p.postTypeID = 1 THEN 1 ELSE 0 END) AS numPosts
	, SUM(CASE WHEN v.id IS NOT NULL THEN 1 ELSE 0 END) AS numFavVotes
	, SUM(CASE WHEN p.postTypeID = 2 THEN 1 ELSE 0 END) AS numComments
	, MAX(CASE WHEN p.postTypeID = 2 THEN p.creationDate ELSE '20000101' END) AS dateLastComment
	, u.upvotes
	, u.downvotes
	, dbo.getlastBadgeUser(u.id) AS latestBadge
FROM dbo.users u
INNER JOIN dbo.posts p ON u.id = p.ownerUserID
	LEFT OUTER JOIN dbo.votes v ON p.ID = v.postID
		AND v.VoteTypeId = 5
WHERE p.postTypeID IN (1,2)
 AND u.[DisplayName] LIKE '%' + @theName + '%'
GROUP BY u.id
	, u.displayname
	, u.aboutme
	, u.upvotes
	, u.downvotes
	, dbo.getlastBadgeUser(u.id);



/* Listing 6-17: Create statement for dbo.getLastBadgeUser */
/*************************************************************  Object Description: Get latest badge for a userid  
    
  Revision History:  
  Date         Name             Label/PTS    Description  
  -----------  ---------------  ----------  ----------------------------------------  
  2019.07.07  LBohm                  Initial Release  
***************************************************/  
  
CREATE FUNCTION dbo.getLastBadgeUser (@userID int)  
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

/* Listing 6-18: The OUTER APPLY to replace the getLastBadgeUser function */
	OUTER APPLY (SELECT TOP 1 [Name] AS latestBadge
		FROM dbo.Badges
		WHERE userID = u.id
		ORDER BY [Date] DESC) AS bInfo

/* Listing 6-19: Rewrite of getUserInfoByName stored procedure */
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
-- EXECUTE dbo.getUserInfoByName @theName = 'Joel';
  
    2019.07.07  	 LBohm          INITIAL RELEASE  
***************************************************************************************/

ALTER PROCEDURE [dbo].[getUserInfoByName] @theName varchar(20)
AS

SELECT u.ID
	, u.displayname
	, u.aboutme
	, SUM(CASE WHEN p.postTypeID = 1 THEN 1 ELSE 0 END) AS numPosts
	, SUM(CASE WHEN v.id IS NOT NULL THEN 1 ELSE 0 END) AS numFavVotes
	, SUM(CASE WHEN p.postTypeID = 2 THEN 1 ELSE 0 END) AS numComments
	, MAX(CASE WHEN p.postTypeID = 2 THEN p.creationDate ELSE '20000101' END) AS dateLastComment
	, u.upvotes
	, u.downvotes
	, binfo.latestBadge
FROM dbo.users u
INNER JOIN dbo.posts p ON u.id = p.ownerUserID
	LEFT OUTER JOIN dbo.votes v ON p.ID = v.postID
				AND v.VoteTypeId = 5
	OUTER APPLY (SELECT TOP 1 [Name] AS latestBadge
		FROM dbo.Badges
		WHERE userID = u.id
		ORDER BY [Date] DESC) AS bInfo
WHERE p.postTypeID IN (1,2)
 AND u.[DisplayName] LIKE @theName + '%'
GROUP BY u.id
		, u.displayname
		, u.aboutme
		, u.upvotes
		, u.downvotes
		, binfo.latestBadge;
