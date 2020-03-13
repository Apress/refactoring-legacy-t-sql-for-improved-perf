/* Listing 3-1: Query to find max data value length in several columns of the WidePosts table */
SELECT MAX(len(AboutMe)) AS AbtMe
		, MAX(len(Body)) AS body	
		, MAX(len(CommentText1)) AS CT1	
		, MAX(len(CommentText2)) AS CT2	
		, MAX(len(CommentText3)) AS CT3	
		, MAX(len(CommentText4)) AS CT4	
		, MAX(len(CommentText5)) AS CT5	
		, MAX(len(Title)) AS Title	
		, MAX(len(Tags)) AS Tags	
		, MAX(len(WebsiteURL)) AS WebURL	
FROM dbo.WidePosts;

/* Listing 3-2: Example call to sp_spaceused to find the amount of data in the WidePosts table */
EXEC sp_spaceused N'dbo.WidePosts';  
GO  

/* Listing 3-3: Query to find cardinality of some columns in the WidePosts table */
SELECT COUNT(DISTINCT parentID) as numParentIDs
		, COUNT(DISTINCT [Views]) AS numViews
		, COUNT(DISTINCT PostID) AS numPostIDs
		, COUNT(DISTINCT AnswerCount) AS numAnswerCounts
FROM dbo.WidePosts;

/* Listing 3-4: Example call to sp_help for information on the table WidePosts */
sp_help wideposts

/* Listing 3-5: View create statement for theWidePostsView view */
IF (NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsView'))
BEGIN
    EXECUTE('CREATE VIEW WidePostsView as SELECT 1 as t');
END;
GO

ALTER VIEW WidePostsView AS 
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

/* Listing 3-6: Selecting top 100 records from the WidePostsView */
SELECT TOP 100 postID
, AcceptedAnswerId
, AnswerCount
, Body
, ClosedDate
, CommentCount
, CommunityOwnedDate
, CreationDate
, FavoriteCount
, LastActivityDate
, LastEditDate
, LastEditorDisplayName
, LastEditorUserId
, OwnerUserId
, ParentId
, PostTypeId
, Score
, Tags
, Title
, ViewCount
, AboutMe
, Age
, UserCreationDate
, DisplayName
, DownVotes
, EmailHash
, LastAccessDate
, Location
, Reputation
, UpVotes
, Views
, WebsiteUrl
, AccountId
, CommentId1
, CommentCreationDate1
, CommentScore1
, CommentText1
, CommentUserId1
, CommentId2
, CommentCreationDate2
, CommentScore2
, CommentText2
, CommentUserId2
, CommentId3
, CommentCreationDate3
, CommentScore3
, CommentText3
, CommentUserId3
, CommentId4
, CommentCreationDate4
, CommentScore4
, CommentText4
, CommentUserId4
, CommentId5
, CommentCreationDate5
, CommentScore5
, CommentText5
, CommentUserId5

FROM WidePostsView
ORDER BY postID;

/* Listing 3-7: Selecting top 100 records from the table WidePosts */
SELECT TOP 100 postID
, AcceptedAnswerId
, AnswerCount
, Body
, ClosedDate
, CommentCount
, CommunityOwnedDate
, CreationDate
, FavoriteCount
, LastActivityDate
, LastEditDate
, LastEditorDisplayName
, LastEditorUserId
, OwnerUserId
, ParentId
, PostTypeId
, Score
, Tags
, Title
, ViewCount
, AboutMe
, Age
, UserCreationDate
, DisplayName
, DownVotes
, EmailHash
, LastAccessDate
, Location
, Reputation
, UpVotes
, Views
, WebsiteUrl
, AccountId
, CommentId1
, CommentCreationDate1
, CommentScore1
, CommentText1
, CommentUserId1
, CommentId2
, CommentCreationDate2
, CommentScore2
, CommentText2
, CommentUserId2
, CommentId3
, CommentCreationDate3
, CommentScore3
, CommentText3
, CommentUserId3
, CommentId4
, CommentCreationDate4
, CommentScore4
, CommentText4
, CommentUserId4
, CommentId5
, CommentCreationDate5
, CommentScore5
, CommentText5
, CommentUserId5

FROM WidePosts
ORDER BY PostID;

/* Listing 3-8: Clean up code for WidePosts table and associated objects */
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'WidePosts')
BEGIN
DROP TABLE WidePosts;
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

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePostsView')
BEGIN
    DROP VIEW WidePostsView;
END;
GO

/* Listing 3-9: WidePosts view create statement */
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'WidePosts')
BEGIN
    EXECUTE('CREATE VIEW WidePosts as SELECT 1 as t');
END;
GO

ALTER VIEW WidePosts AS 
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
