/* Listing 5-1: The iu_Users_DownVotes trigger definition */
IF NOT EXISTS (SELECT 1 FROM  sys.triggers
 WHERE name = 'iu_Users_DownVotes'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.30   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/

CREATE TRIGGER dbo.iu_Users_DownVotes ON dbo.Users
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

ALTER TRIGGER [dbo].[iu_Users_DownVotes] ON [dbo].[Users]
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

INSERT INTO dbo.Triggerlog (id, thisDate, thisAction, descript)
SELECT u.id, getdate(), 'Update', 'Update reputation User table'
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0;

END;
END;
GO

/*Listing 5-2: Adding a downvote to user 763725 */
DECLARE @userID int = 763725;

SELECT id, reputation, downvotes
FROM dbo.Users
WHERE id = @userID;

UPDATE dbo.users
SET downvotes = downvotes + 1
WHERE id = @userID;

SELECT id, reputation, downvotes
FROM dbo.Users
WHERE id = @userID;

/* Listing 5-3: Adding  a downvote to user 1010297 */
DECLARE @userID int = 1010297;

SELECT id, reputation, downvotes
FROM dbo.Users
WHERE id = @userID;

UPDATE dbo.users
SET downvotes = downvotes + 1
WHERE id = @userID;

SELECT id, reputation, downvotes
FROM dbo.Users
WHERE id = @userID;

/* Listing 5-4: Trigger logic for iu_Users_Downvotes */
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0)
BEGIN
UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0;
END;

/* Listing 5-5: Querying the Triggerlog table */
SELECT id, thisdate, thisaction, descript
FROM Triggerlog;

/* Listing 5-6: Code to check if recursive triggers are allowed */
SELECT database_id, name, is_recursive_triggers_on 
FROM sys.databases;

/* Listing 5-7: Adding TRIGGER_NESTLEVEL() to prevent recursion */
IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('iu_Users_Downvotes'),'AFTER','DML')) > 1)
BEGIN
RETURN;
END;

/* full query definition after change in Listing 5-7 made */
ALTER TRIGGER [dbo].[iu_Users_DownVotes] ON [dbo].[Users]
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON;

IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('iu_Users_Downvotes'),'AFTER','DML')) > 1)
BEGIN
RETURN;
END;

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

INSERT INTO dbo.Triggerlog (id, thisDate, thisAction, descript)
SELECT u.id, getdate(), 'Update', 'Update reputation User table'
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0;

END;
END;
GO

/* Listing 5-8: Restoring User 1010297’s reputation */
DECLARE @userID int = 1010297;

UPDATE u
SET reputation = 25
		, downvotes = 14
FROM dbo.users u
WHERE id = @userID;

/* Listing 5-9: Looking at downvotes and reputation for multiple users */
DECLARE @theTable TABLE (id int);
INSERT INTO @theTable (id)
VALUES (1010297)
		, (1639596)
		, (2179513)
		, (2491405)
		, (2549795);

SELECT tb.id
		, u.reputation
		, u.downvotes
FROM @theTable tb
INNER JOIN dbo.users u ON tb.id = u.id;

/* Listing 5-10: Update downvotes for multiple users */
DECLARE @theTable TABLE (id int);
INSERT INTO @theTable (id)
VALUES (1010297)
		, (1639596)
		, (2179513)
		, (2491405)
		, (2549795);

SELECT tb.id
		, u.reputation
		, u.downvotes
FROM @theTable tb
INNER JOIN dbo.users u ON tb.id = u.id;

UPDATE u
SET downvotes = u.downvotes + 1
FROM dbo.users u
INNER JOIN @theTable tb ON u.id = tb.id;

SELECT tb.id
		, u.reputation
		, u.downvotes
FROM @theTable tb
INNER JOIN dbo.users u ON tb.id = u.id;

/* Listing 5-11: New update statement testing if downvotes is divisible by 5 */
UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
		AND i.DownVotes % 5 = 0;

/* full query definition after change in Listing 5-7 made */
ALTER TRIGGER [dbo].[iu_Users_DownVotes] ON [dbo].[Users]
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON;

IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('iu_Users_Downvotes'),'AFTER','DML')) > 1)
BEGIN
RETURN;
END;

-- if the downvote count divided by 5 has no remainder, subtract 1 from the reputation
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0)
BEGIN

UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
		AND i.DownVotes % 5 = 0;

INSERT INTO dbo.Triggerlog (id, thisDate, thisAction, descript)
SELECT u.id, getdate(), 'Update', 'Update reputation User table'
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
		AND i.DownVotes % 5 = 0;
END;
END;
GO
		
/* 5-12: Restore multiple users’ reputation points */
DECLARE @theTable TABLE (id int, reputation int, downvotes int);
INSERT INTO @theTable (id, reputation, downvotes)
VALUES (1010297, 25, 14)
		, (1639596, 1, 3)
		, (2179513, 5, 3)
		, (2491405, 1, 3)
		, (2549795, 31, 3);

UPDATE u
SET reputation = tb.reputation
		, downvotes = tb.downvotes
FROM dbo.users u
INNER JOIN @theTable tb ON u.id = tb.id;

/* Listing 5-13: Increasing the upvotes of 4 users */
DECLARE @theTable TABLE (id int);
INSERT INTO @theTable (id)
VALUES (1010297)
	, (1639596)
	, (22)
	, (123);

SELECT tb.id
		, u.reputation
		, u.downvotes
		, u.upvotes
FROM @theTable tb
INNER JOIN dbo.users u ON tb.id = u.id;

UPDATE u
SET upvotes = u.upvotes + 1
	, downvotes = u.downvotes
FROM dbo.users u
INNER JOIN @theTable tb ON u.id = tb.id;

SELECT tb.id
		, u.reputation
		, u.downvotes
		, u.upvotes
FROM @theTable tb
INNER JOIN dbo.users u ON tb.id = u.id;

/* Listing 5-14: Restore user data for 4 users */
DECLARE @theTable TABLE (id int, downvotes int, upvotes int, reputation int);
INSERT INTO @theTable (id, downvotes, upvotes, reputation)
VALUES (1010297, 14, 161, 25)
		, (1639596, 3, 11,1)
		, (22,5, 203,12815)
		, (123,40,420,29211);

UPDATE u
  SET u.reputation = t.reputation
	, u.upvotes = t.upvotes
FROM dbo.users u
INNER JOIN @theTable t ON u.id = t.id;

/* Listing 5-15: UPDATE function check to add to our trigger in Listing 5-1 */
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0
	AND UPDATE(downvotes))
BEGIN

UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND UPDATE(downvotes);

/* full query definition after change in Listing 5-15 made */
ALTER TRIGGER [dbo].[iu_Users_DownVotes] ON [dbo].[Users]
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON;

IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('iu_Users_Downvotes'),'AFTER','DML')) > 1)
BEGIN
RETURN;
END;

-- if the downvote count divided by 5 has no remainder, subtract 1 from the reputation
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0
	AND UPDATE(downvotes))
BEGIN

UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND UPDATE(downvotes);

INSERT INTO dbo.Triggerlog (id, thisDate, thisAction, descript)
SELECT u.id, getdate(), 'Update', 'Update reputation User table'
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
		AND i.DownVotes % 5 = 0
		AND UPDATE(downvotes);
END;
END;
GO

/* Listing 5-16: Testing to see if the INSERTED and DELETED values are different */
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0
	AND EXISTS (SELECT i.downvotes EXCEPT SELECT d.downvotes FROM DELETED d WHERE i.id = d.id) )
BEGIN

UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND EXISTS (SELECT i.downvotes EXCEPT SELECT d.downvotes FROM DELETED d WHERE i.id = d.id) ;

/* Listing 5-17: Final revised iu_Users_DownVotes trigger */
 IF NOT EXISTS
(SELECT 1 FROM sys.triggers
 WHERE name = 'iu_Users_DownVotes'
)
BEGIN
DECLARE @SQL nvarchar(1200);
SET @SQL = N'/*******************************************************************************  
    2019.06.30   LBohm                     INITIAL TRIGGER STUB CREATE RELEASE
***************************************************************************************/

CREATE TRIGGER dbo.iu_Users_DownVotes ON dbo.Users
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

ALTER TRIGGER [dbo].[iu_Users_DownVotes] ON [dbo].[Users]
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON;

IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('iu_Users_Downvotes'),'AFTER','DML')) > 1)
BEGIN
RETURN;
END;

-- if the downvote count divided by 5 has no remainder, subtract 1 from the reputation
IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.DownVotes > 0
	AND i.DownVotes % 5 = 0
	AND i.reputation > 0
	AND EXISTS (SELECT i.downvotes EXCEPT SELECT d.downvotes FROM DELETED d WHERE i.id = d.id) )
BEGIN
	
UPDATE u
SET u.Reputation = u.Reputation - 1
FROM dbo.users u
INNER JOIN INSERTED i ON u.id = i.id
WHERE i.reputation > 0
		AND i.DownVotes > 0
		AND i.DownVotes % 5 = 0
		AND EXISTS (SELECT i.downvotes EXCEPT 
SELECT d.downvotes 
FROM DELETED d 
WHERE i.id = d.id) ;

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

/* Listing 5-18: Create statement for i_LinkTypes_doNothing */
 IF NOT EXISTS
(SELECT 1 FROM sys.triggers
 WHERE name = 'i_LinkTypes_doNothing'
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

/* Listing 5-19: The create statement for the u_LinkTypes_doNothing trigger */
IF NOT EXISTS (SELECT 1 FROM sys.triggers
 WHERE name = 'u_LinkTypes_doNothing'
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

/* Listing 5-20: Simple insert to the LinkTypes table */
INSERT INTO linkTypes (Type)
VALUES ('TTest');
