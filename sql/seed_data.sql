-- Seed data for DataQuest database
-- This script populates the database with sample investigative data
-- Data Dictionary compliant

USE DataQuest;
GO

-- ============================================================
-- Seed Persons table
-- ============================================================

INSERT INTO [dbo].[Persons] ([FirstName], [LastName], [Role], [IsSuspect])
VALUES
    ('Alice', 'Johnson', 'Suspect', 1),
    ('Bob', 'Smith', 'Witness', 0),
    ('Carol', 'Williams', 'Investigator', 0),
    ('David', 'Brown', 'Witness', 0),
    ('Emma', 'Davis', 'Victim', 0),
    ('Frank', 'Miller', 'Suspect', 1),
    ('Grace', 'Wilson', 'Witness', 0),
    ('Henry', 'Moore', 'Investigator', 0);
GO

-- ============================================================
-- Seed Locations table
-- ============================================================

INSERT INTO [dbo].[Locations] ([Name], [Address])
VALUES
    ('Main Office', '123 Business Ave, New York, NY 10001'),
    ('Conference Room A', '123 Business Ave, Room 501, New York, NY 10001'),
    ('Coffee Shop Downtown', '456 Coffee St, New York, NY 10002'),
    ('Alice Residence', '789 Oak St, New York, NY 10003'),
    ('Server Room', '123 Business Ave, Basement, New York, NY 10001');
GO

-- ============================================================
-- Seed Relationships table
-- ============================================================

INSERT INTO [dbo].[Relationships] ([PersonID_A], [PersonID_B], [Type])
VALUES
    (1, 2, 'Coworker'),         -- Alice and Bob
    (1, 3, 'Acquaintance'),     -- Alice and Carol
    (2, 4, 'Coworker'),         -- Bob and David
    (1, 5, 'Employer'),     -- Alice and Emma (supervisor)
    (3, 5, 'Coworker'),         -- Carol and Emma
    (6, 4, 'Friend'),       -- Frank and David
    (6, 7, 'Acquaintance'),     -- Frank and Grace
    (1, 6, 'Rival'),  -- Alice and Frank (competitive)
    (2, 8, 'Supervisor'), -- Bob and Henry
    (3, 8, 'Colleague'),    -- Carol and Henry
    (7, 5, 'Friend'),   -- Grace and Emma
    (4, 8, 'Acquaintance');     -- David and Henry
GO

-- ============================================================
-- Seed Cases table
-- ============================================================

INSERT INTO [dbo].[Cases] ([CaseTitle], [InitialPrompt], [Conclusion])
VALUES
    (
  'The Mystery of the Missing Code',
        'A valuable proprietary code repository has gone missing from the main office. Your job is to investigate by examining communications, access logs, and witness statements to determine who took it and why. Timeline is critical - trace when the theft occurred.',
        NULL  -- Conclusion will be filled after student completes case
    ),
    (
     'Timeline Contradiction',
        'Multiple witnesses provide conflicting accounts of their activities on the day of the incident. Use SQL to construct a timeline from transaction logs and communications. Identify which accounts are inconsistent and determine what really happened.',
        NULL
    ),
    (
        'The Data Breach',
   'Unusual database access has been detected outside normal business hours. Someone unauthorized accessed customer data. Examine server logs, access records, and communications to identify the culprit and determine what data was accessed.',
        NULL
    ),
    (
        'The Red Herring',
      'A suspicious transaction was flagged by security. Multiple people had access. Use SQL to analyze who was present when, who benefited, and who might be framing someone else. Look for patterns in the data that don''t match the obvious narrative.',
 NULL
    );
GO

-- ============================================================
-- Seed Evidence table
-- ============================================================

INSERT INTO [dbo].[Evidence] ([CaseID], [LocationID], [Type], [TimestampFound])
VALUES
    -- Case 1: The Missing Code
    (1, 1, 'CCTV_Log', '2024-01-15 09:30:00'),
    (1, NULL, 'Email', '2024-01-15 10:00:00'),
    (1, 4, 'Physical', '2024-01-15 14:20:00'),
    (1, 2, 'CCTV_Log', '2024-01-15 08:00:00'),
    
    -- Case 2: Timeline Contradiction
    (2, NULL, 'Financial_Record', '2024-01-15 15:00:00'),
    (2, 3, 'CCTV_Log', '2024-01-15 15:30:00'),
    (2, 1, 'Access_Log', '2024-01-15 15:45:00'),
    
    -- Case 3: Data Breach
    (3, 5, 'CCTV_Log', '2024-01-16 02:15:00'),
    (3, NULL, 'Access_Log', '2024-01-16 02:30:00'),
    (3, 5, 'System_Log', '2024-01-16 02:45:00'),
    (3, NULL, 'Email', '2024-01-16 06:00:00'),
    
    -- Case 4: Red Herring
    (4, 1, 'Financial_Record', '2024-01-15 16:00:00'),
    (4, NULL, 'Access_Log', '2024-01-16 02:00:00'),
    (4, 5, 'CCTV_Log', '2024-01-14 19:00:00'),
    (4, 1, 'Email', '2024-01-16 08:00:00');
GO

-- ============================================================
-- Seed WitnessStatements table
-- ============================================================

INSERT INTO [dbo].[WitnessStatements] ([CaseID], [PersonID], [StatementText])
VALUES
    (1, 2, 'I saw Alice Johnson leaving the office around 5:15 PM with a USB drive. She looked nervous and hurried out quickly.'),
    (1, 4, 'I was in the conference room working late. I did not see anyone suspicious. Alice was at her desk most of the day.'),
    (1, 5, 'Alice asked me about accessing the code repository backup yesterday. She said she needed it for a project, but I thought that was strange since we have version control.'),
    (2, 2, 'I left the office at 3 PM on that day. I saw David at the coffee shop around 3:30 PM.'),
    (2, 4, 'I was at the office the entire day. I did not leave until 6 PM. I never went to the coffee shop.'),
    (3, 3, 'System detected unauthorized access to the database server at 2:15 AM. Access was from an internal IP, suggesting someone with physical access to the building.'),
    (1, 7, 'I noticed Frank accessing the data room without proper authorization. He seemed in a hurry.'),
    (3, 8, 'System logs indicate multiple failed login attempts before successful breach. Access pattern suggests insider knowledge of security protocols.');
GO

-- ============================================================
-- Seed TransactionLogs table
-- ============================================================

INSERT INTO [dbo].[TransactionLogs] ([PersonID], [Timestamp], [Amount])
VALUES
    -- Case 1: The Missing Code
    (1, '2024-01-15 08:00:00', NULL),     -- Alice arrives at office
    (1, '2024-01-15 09:15:00', NULL),   -- Alice at workstation
    (2, '2024-01-15 08:30:00', NULL),     -- Bob arrives
    (2, '2024-01-15 15:00:00', NULL),     -- Bob leaves office
    (2, '2024-01-15 15:30:00', 5.50),     -- Bob's coffee purchase (Timeline Contradiction case)
    (4, '2024-01-15 08:45:00', NULL),     -- David arrives
    (4, '2024-01-15 18:00:00', NULL),     -- David leaves office (contradicts statement)
    (1, '2024-01-15 17:15:00', NULL),     -- Alice leaves office
    (1, '2024-01-15 17:20:00', NULL),     -- Alice badge swipe at exit
    (1, '2024-01-16 00:00:00', NULL),     -- Alice badge access attempt at night (suspicious)
    (1, '2024-01-16 00:15:00', NULL),     -- Alice at data center (after hours)
    
    -- Case 2: Timeline Contradiction (more logs)
    (2, '2024-01-15 08:00:00', NULL),     -- Bob office entry
    (2, '2024-01-15 12:00:00', 8.75),-- Bob lunch purchase
    (4, '2024-01-15 08:15:00', NULL),     -- David office entry
    (4, '2024-01-15 15:45:00', 3.25),     -- David coffee shop (contradicts his statement)
    (5, '2024-01-15 08:30:00', NULL),     -- Emma office entry
    (5, '2024-01-15 17:00:00', NULL),     -- Emma office exit
    
    -- Case 3: Data Breach
    (3, '2024-01-16 02:15:00', NULL),     -- Carol at server room (authorized maintenance)
    (6, '2024-01-16 02:10:00', NULL),  -- Frank badge access (unauthorized)
    (NULL, '2024-01-16 02:30:00', NULL),  -- Unauthorized access (person unknown)
    (6, '2024-01-16 02:45:00', NULL),     -- Frank exits building
    (3, '2024-01-16 06:00:00', NULL),     -- Carol exits after completing maintenance
    
    -- Additional activity logs for pattern analysis
    (1, '2024-01-14 18:00:00', NULL),     -- Alice after hours (day before)
    (6, '2024-01-14 19:30:00', NULL),     -- Frank after hours (day before)
    (7, '2024-01-15 09:00:00', NULL),     -- Grace office entry
    (8, '2024-01-16 01:00:00', NULL);     -- Henry on duty (night shift)
GO

-- ============================================================
-- Seed StorySteps table
-- ============================================================

INSERT INTO [dbo].[StorySteps] ([CaseID], [StepNumber], [StepPrompt], [CanonicalQuery])
VALUES
    (
    1,
    1,
    'Who left the office latest and might have had opportunity to steal the code?',
        'SELECT TOP 1 p.FirstName, p.LastName, MAX(t.Timestamp) as LastSeen FROM Persons p JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE p.IsSuspect = 1 GROUP BY p.PersonID, p.FirstName, p.LastName ORDER BY MAX(t.Timestamp) DESC'
    ),
    (
  1,
     2,
        'What relationships exist between the suspect and other people?',
        'SELECT r.Type, CASE WHEN r.PersonID_A = 1 THEN CONCAT(p.FirstName, '' '', p.LastName) ELSE CONCAT(p2.FirstName, '' '', p2.LastName) END as RelatedPerson FROM Relationships r JOIN Persons p ON r.PersonID_B = p.PersonID JOIN Persons p2 ON r.PersonID_A = p2.PersonID WHERE r.PersonID_A = 1 OR r.PersonID_B = 1'
    ),
    (
     1,
    3,
  'What did witnesses say about the suspect''s behavior?',
        'SELECT w.StatementText FROM WitnessStatements w WHERE w.PersonID = 1 OR w.StatementText LIKE ''%Alice%'''
    ),
    (
        2,
   1,
        'Build a timeline of everyone''s activities on that day.',
      'SELECT p.FirstName, p.LastName, t.Timestamp, DATEPART(HOUR, t.Timestamp) as Hour FROM Persons p LEFT JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE CAST(t.Timestamp AS DATE) = ''2024-01-15'' ORDER BY t.Timestamp'
    ),
    (
        2,
2,
        'Which witness statement contradicts the transaction logs?',
        'SELECT p.FirstName, p.LastName, w.StatementText FROM Persons p JOIN WitnessStatements w ON p.PersonID = w.PersonID WHERE w.CaseID = 2 AND (p.PersonID = 2 OR p.PersonID = 4)'
 ),
    (
        3,
    1,
        'Who had physical access to the server room at the time of the breach?',
        'SELECT p.FirstName, p.LastName, t.Timestamp FROM Persons p JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE t.Timestamp BETWEEN ''2024-01-16 02:00:00'' AND ''2024-01-16 03:00:00'' ORDER BY t.Timestamp'
    ),
    (
   4,
     1,
        'Who had access to both the transaction data AND the physical location?',
        'SELECT p.FirstName, p.LastName FROM Persons p WHERE p.Role IN (''Investigator'', ''Suspect'') ORDER BY p.FirstName'
    ),
    (
        4,
        2,
        'Which two suspects had suspicious after-hours activity on consecutive days?',
        'SELECT DISTINCT p.FirstName, p.LastName, t.Timestamp FROM Persons p JOIN TransactionLogs t ON p.PersonID = t.PersonID WHERE DATEPART(HOUR, t.Timestamp) > 18 OR DATEPART(HOUR, t.Timestamp) < 6 ORDER BY t.Timestamp'
    );
GO

-- ============================================================
-- Seed AnswerKeys table
-- ============================================================

INSERT INTO [dbo].[AnswerKeys] ([StepID], [ExpectedResultHash], [ExpectedClueValue])
VALUES
    (1, 'HASH_1_LATEST_PERSON', 'Alice Johnson left at 17:15:00 - latest departure among suspects'),
    (2, 'HASH_1_RELATIONSHIPS', 'Alice has relationships with: Coworker (Bob), Acquaintance (Carol), Employer relationship to Emma'),
    (3, 'HASH_1_WITNESS_STATEMENTS', 'Bob saw Alice leaving with a USB drive looking nervous; Emma found her request for backup access suspicious'),
    (4, 'HASH_2_TIMELINE', 'David''s log shows 18:00 departure but his statement claims he was at office all day and left at 6 PM - times match exactly'),
    (5, 'HASH_2_CONTRADICTION', 'David''s transaction logs show coffee shop visit at 15:45 on 2024-01-15, but he stated he never went to coffee shop'),
    (6, 'HASH_3_ACCESS', 'Carol (PersonID 3) had authorized access 02:15:00; Frank (PersonID 6) had unauthorized access 02:10:00'),
    (7, 'HASH_4_DUAL_ACCESS', 'Persons with Investigator OR Suspect roles: Carol Williams (Investigator), Alice Johnson (Suspect), Frank Miller (Suspect)'),
    (8, 'HASH_4_SUSPICIOUS_ACTIVITY', 'Alice (2024-01-16 00:00-00:15) and Frank (2024-01-16 02:10 and 2024-01-14 19:30) show pattern of after-hours access');
GO

-- ============================================================
-- Data seeding complete - Schema and data are Data Dictionary compliant
-- ============================================================
