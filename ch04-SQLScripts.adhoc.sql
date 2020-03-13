/* Listing 4-1: Find number of linked posts query */
SELECT wp4.postID
	, wp4.creationDate
	, wp4.numLinkedPosts
FROM WidePostsPlusFour wp4
WHERE wp4.creationDate >='20120801'
	AND wp4.creationDate < '20120901';

/* Listing 4-2: View definition for WidePostsPlusFour */
ALTER VIEW WidePostsPlusFour AS 
SELECT wp3.*
		, dbo.getnumLinkedPosts(wp3.postID) AS numLinkedPosts
FROM dbo.WidePostsPlusThree wp3
WHERE wp3.commentID IS NOT NULL;

/* Listing 4-3: Sample call for sp_codeCalledCascade */
 EXECUTE sp_codeCallsCascade @codename = 'WidePostsPlusFour', @rootSchema='dbo';

/* Listing 4-4: Expanded code for WidePostsPlusFour, containing nested view code */
SELECT wp4.postID
, wp4.creationDate
, wp4.numLinkedPosts
FROM (SELECT wp3.*
		, dbo.getnumLinkedPosts(wp3.postID) AS numLinkedPosts
FROM (SELECT wp2.postID
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

FROM (SELECT wp1.postID
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
FROM (SELECT wp.*
	, pt.Type AS PostType
	, vt.Userid AS voteUser
FROM (SELECT
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
		GROUP BY coms.PostID) c
) wp  --WidePostsCh4
	INNER JOIN dbo.PostTypes pt ON wp.PostTypeID = pt.id
INNER JOIN dbo.Votes vt ON vt.PostID = wp.PostID) wp1
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
, vty.[Name]
) wp2 --WidePostsPlusTwo
OUTER APPLY (SELECT CommentID1 AS commentID  
          , CommentCreationDate1 AS commentCreationDate  
          , CommentScore1 AS commentScore  
          , CommentText1 AS commentText  
          , CommentUserID1 AS commentUserID  
          , PostID  
      FROM dbo.WidePostsPlusTwo wpp2a  
        WHERE wpp2a.postID = wp2.postID  
      UNION ALL  
      SELECT CommentID2  
          , CommentCreationDate2  
          , CommentScore2  
          , CommentText2  
          , CommentUserID2  
          , PostID  
      FROM dbo.WidePostsPlusTwo wpp2b  
        WHERE wpp2b.postID = wp2.postID  
      UNION ALL  
      SELECT CommentID3  
          , CommentCreationDate3  
          , CommentScore3  
          , CommentText3  
          , CommentUserID3  
          , PostID  
      FROM dbo.WidePostsPlusTwo wpp2c  
        WHERE wpp2c.postID = wp2.postID  
      UNION ALL  
      SELECT CommentID4   
          , CommentCreationDate4   
          , CommentScore4  
          , CommentText4   
          , CommentUserID4  
          , PostID  
      FROM dbo.WidePostsPlusTwo wpp2d  
        WHERE wpp2d.postID = wp2.postID  
      UNION ALL  
      SELECT CommentID5  
          , CommentCreationDate5  
          , CommentScore5  
          , CommentText5  
          , CommentUserID5  
          , PostID  
      FROM dbo.WidePostsPlusTwo wpp2e  
        WHERE wpp2e.postID = wp2.postID) commentUnpivot 
) wp3 --WidePostsPlusThree
WHERE wp3.commentID IS NOT NULL   
)  wp4 --WidePostsPlusFour
WHERE wp4.creationDate >='20120801'
	AND wp4.creationDate < '20180901';
	
/* Listing 4-5: Queries to find number of rows called by the nested views*/
SELECT COUNT(1) FROM WidePostsCh4
WHERE postID < 1000000;

SELECT COUNT(1) FROM WidePostsPlusOne
WHERE postID < 1000000;

SELECT COUNT(1) FROM WidePostsPlusTwo
WHERE postID < 1000000;

SELECT COUNT(1) FROM WidePostsPlusThree
WHERE postID < 1000000;

SELECT COUNT(1) FROM WidePostsPlusFour
WHERE postID < 1000000;


/* Listing 4-6: Adding a function to data pulled from the Posts table */
SELECT p.ID
, p.creationDate
, dbo.getnumLinkedPosts(p.ID) AS numLinkedPosts
FROM dbo.Posts p
WHERE p.creationDate >= '20120801'
AND p.creationDate < '20120901';

/* Listing 4-7: Definition for the getNumLinkedPosts function */
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

/* Listing 4-8: Replacing the getNumLinkedPosts function with an OUTER APPLY */
 SELECT p.ID
, p.creationDate
, nlp.numLinkedPosts
FROM dbo.Posts p
OUTER APPLY (SELECT COUNT(1) AS numLinkedPosts
FROM dbo.postLinks pl
WHERE pl.postID = p.ID) nlp
WHERE p.creationDate >= '20120801'
AND p.creationDate < '20120901';

/* Listing 4-9: Creating an index on the PostID column in the PostLinks table */
CREATE NONCLUSTERED INDEX ix_PostLinks_PostID ON dbo.PostLinks (PostID);


