/* Listing 7-1: Alter statement for the scalar-valued function dbo.increment */
ALTER FUNCTION dbo.increment (@someint int)
RETURNS int
AS
BEGIN
RETURN(@someint + 1); 
END;
GO

/* Listing 7-2: Simple query to list posts with a score of 320 */
SELECT p.ID
	, p.score
--	, dbo.increment(p.score) AS oneAdded
FROM dbo.posts p
WHERE p.score = 320;

/* Listing 7-3: Create script for an Event Session IO  Patterns */ 
CREATE EVENT SESSION [IO Patterns] ON SERVER
ADD EVENT sqlserver.sp_statement_completed(
ACTION(sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.sql_statement_completed(
ACTION(sqlserver.sql_text,sqlserver.tsql_stack))
ADD TARGET package0.event_file(SET filename=N'C:\SSdata\IOPatterns.xel');

/* Listing 7-4: Start the Event Session */
ALTER EVENT SESSION [IO Patterns] ON SERVER  
STATE = START;  
GO 

/* Listing 7-5: Stop the Event Session */
ALTER EVENT SESSION [IO Patterns] ON SERVER  
STATE = STOP;  
GO 

/* Listing 7-6: Code to review the Extended Event Session data */
SELECT
  event_data_XML.value ('(/event/data  [@name=''duration''      ]/value)[1]', 'BIGINT'        ) AS duration,
  event_data_XML.value ('(/event/data  [@name=''cpu time''      ]/value)[1]', 'BIGINT'        ) AS cpu time,
  event_data_XML.value ('(/event/data  [@name=''physical reads'']/value)[1]', 'BIGINT'        ) AS physical reads,
  event_data_XML.value ('(/event/data  [@name=''logical reads'' ]/value)[1]', 'BIGINT'        ) AS logical reads,
  event_data_XML.value ('(/event/data  [@name=''writes''        ]/value)[1]', 'BIGINT'        ) AS writes,
  event_data_XML.value ('(/event/data  [@name=''row count''     ]/value)[1]', 'BIGINT'        ) AS row count,
  event_data_XML.value ('(/event/data  [@name=''statement''     ]/value)[1]', 'NVARCHAR(4000)') AS [statement]
FROM (SELECT CAST(event_data AS XML) AS event_data_XML
	FROM sys.fn_xe_file_target_read_file('c:\SSdata\IOPatterns*.xel', null, null, null) AS F
				) AS E;

/* Listing 7-7: Query with a function in the WHERE clause */
SELECT p.ID
	, p.score
FROM dbo.posts p
WHERE p.score > 315
	AND p.score < 325
	AND dbo.increment(p.score) = 321;

/* Listing 7-8: Sample query with a date function in the WHERE clause */
DECLARE @date date;
SET @date='20120801';

SELECT p.ID
	, p.score
FROM dbo.posts p
WHERE DATEADD(dd,1,CAST(p.creationdate AS date)) = @date;

/* Listing 7-9: Number of posts expected in the result set of the query in Listing 7-8 */
SELECT COUNT(1) AS numPosts
	, CAST(p.creationdate AS date) AS theDay
FROM dbo.posts p
WHERE p.creationdate > '20120731'
AND p.creationdate < '20120801'
GROUP BY CAST(p.creationdate AS date)
ORDER BY theDay;

/* Listing 7-10: Moving DATEADD() function to the parameter and out of the query */
DECLARE @date date
, @startdate date;
SET @date='20120801';
SET @startdate = DATEADD(dd,-1,@date);

SELECT p.ID
, p.score
FROM dbo.posts p
WHERE p.creationdate >= @startdate
AND p.creationdate < @date;

/* Listing 7-11: Alter statement for the andTheKitchenSink function */
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

/* Listing 7-12: Sample query using the andTheKitchenSink function */
SELECT p.id AS postID
	, p.Score
	, dbo.andTheKitchenSink(649789,'COMMENT') AS numComments
	, dbo.andTheKitchenSink(649789,'RESPONS') AS numResponses
	, dbo.andTheKitchenSink(649789,'RESPDR') AS numResponders
	, dbo.andTheKitchenSink(649789,'VOTE') AS numVotes
	, p.ViewCount
FROM dbo.Posts p
WHERE p.id = 649789;

/* Listing 7-13: Viewing totals metrics for Extended Event session data */
SELECT SUM(duration)/1000 AS totDurationms
, SUM(cpu time)/1000 AS totCPUms
, SUM(logical reads) AS totLogReads
FROM(
SELECT
  event_data_XML.value ('(/event/data  [@name=''duration''      ]/value)[1]', 'BIGINT'        ) AS duration,
  event_data_XML.value ('(/event/data  [@name=''cpu time''      ]/value)[1]', 'BIGINT'        ) AS cpu time,
  event_data_XML.value ('(/event/data  [@name=''physical reads'']/value)[1]', 'BIGINT'        ) AS physical reads,
  event_data_XML.value ('(/event/data  [@name=''logical reads'' ]/value)[1]', 'BIGINT'        ) AS logical reads,
  event_data_XML.value ('(/event/data  [@name=''writes''        ]/value)[1]', 'BIGINT'        ) AS writes,
  event_data_XML.value ('(/event/data  [@name=''row count''     ]/value)[1]', 'BIGINT'        ) AS row count,
  event_data_XML.value ('(/event/data  [@name=''statement''     ]/value)[1]', 'NVARCHAR(4000)') AS [statement]
FROM (SELECT CAST(event_data AS XML) AS event_data_XML
				FROM sys.fn_xe_file_target_read_file('c:\SSdata\IOPatterns*.xel', null, null, null) AS F
				) AS E) q;

/* Listing 7-14: Rewrite of andTheKitchenSink to only get the desired value */
ALTER FUNCTION dbo.andTheKitchenSink (@postID int, @value varchar(8))
RETURNS varchar(30)
AS
BEGIN
DECLARE @returnValue varchar(30);
SET @returnValue = CASE @value
			WHEN 'COMMENT' THEN COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
					FROM dbo.Comments
					WHERE postID = @postID),'0')
			WHEN 'RESPDR' THEN COALESCE((SELECT CAST(COUNT(DISTINCT OwnerUserID) AS varchar(30))
					FROM dbo.posts
					WHERE parentID = @postID
						AND postTypeID = 2),'0')
			WHEN 'LINK' THEN COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
					FROM dbo.PostLinks
					WHERE postID = @postID),'0')
			WHEN 'VOTE' THEN COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
					FROM dbo.Votes
					WHERE postID = @postID),'0')
			ELSE COALESCE((SELECT CAST(COUNT(1) AS varchar(30))
					FROM dbo.posts
					WHERE parentID = @postID
						AND postTypeID = 2),'0')
			END;

RETURN(@returnValue); 
END;
GO

/* Listing 7-15: Using OUTER APPLY to find additional aggregate data */
SELECT p.id AS postID
	, p.Score
	, com.numComments
	, resp.numResponses
	, resp.numResponders
	, vote.numVotes
	, p.ViewCount
FROM dbo.Posts p
OUTER APPLY (SELECT COUNT(1) AS numComments
		FROM dbo.Comments c
		WHERE c.postID = p.ID) com
OUTER APPLY (SELECT COUNT(DISTINCT OwnerUserID) AS numResponders
			, COUNT(id) AS numResponses
		FROM dbo.Posts resp
		WHERE resp.postTypeID = 2
			AND p.id = resp.parentID) resp
OUTER APPLY (SELECT COUNT(1) AS numVotes
		FROM dbo.Votes v
		WHERE v.postID = p.id) vote
WHERE p.id = 649789;

/* Listing 7-16: Query calling the andTheKitchenSink function, returning several rows */
SELECT p.id AS postID
	, p.Score
	, dbo.andTheKitchenSink(649789,'COMMENT') AS numComments
	, dbo.andTheKitchenSink(649789,'RESPONS') AS numResponses
	, dbo.andTheKitchenSink(649789,'RESPDR') AS numResponders
	, dbo.andTheKitchenSink(649789,'VOTE') AS numVotes
	, p.ViewCount
FROM dbo.Posts p
WHERE p.score = 320;

/* Listing 7-17: Using OUTER APPLY to find additional aggregate data, against multiple rows */
SELECT p.id AS postID
		, p.Score
		, com.numComments
		, respInfo.numResponses
		, respInfo.numResponders
		, vote.numVotes
		, p.ViewCount
FROM dbo.Posts p
OUTER APPLY (SELECT COUNT(1) AS numComments
			FROM dbo.Comments c
			WHERE c.postID = p.ID) com
OUTER APPLY (SELECT COUNT(DISTINCT resp.OwnerUserID) AS numResponders
			, COUNT(resp.id) AS numResponses
		FROM dbo.Posts resp
		WHERE resp.postTypeID = 2
			AND p.id = resp.parentID) respInfo
OUTER APPLY (SELECT COUNT(1) AS numVotes
			FROM dbo.Votes v
			WHERE v.postID = p.id) vote
WHERE p.score = 320;


/* Listing 7-18: Alter statement from responderInfoMultiValue */
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

/* Listing 7-19: Query calling the responderInfoMultiValue function */
SELECT DisplayName
	, Reputation
FROM dbo.responderInfoMultiValue(649789); --the number is a post ID

/* Listing 7-20: Alter statement for the responderInfoInline function */
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
