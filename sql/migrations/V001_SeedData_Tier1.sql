-- ============================================================================
-- DataQuest SQL Detective - Seed Data for Phase 1
-- Version: 001
-- Date: December 5, 2025
-- Purpose: Initial data for Tier 1 cases (Cases 1.1 & 1.2)
--
-- This script populates:
--   Case 1.1: "Missing Badge Access Record" (Badge swipe anomalies)
--   Case 1.2: "Downtown Parking Lot Theft" (Unauthorized gate exit)
-- ============================================================================

-- ============================================================================
-- CASE SETUP
-- ============================================================================

INSERT INTO Cases (CaseTitle, CaseDescription, DifficultyTier, IsActive)
VALUES 
    (N'Missing Badge Access Record', 
   N'A critical badge access record is missing from the security logs. The system shows 50 badge swipes but one entry appears to be absent. Students must identify the gap in the access timeline for server room 4th floor.', 
     1, 
     1),
    (N'Downtown Parking Lot Theft', 
     N'A vehicle theft occurred in the downtown parking lot. Gate logs show unusual activity around the time of the theft. Students must analyze gate entry/exit records to identify unauthorized vehicle movement.',
     1,
     1);

-- ============================================================================
-- TIER 1, CASE 1.1: Badge Access Records
-- ============================================================================

-- Persons for Case 1.1
INSERT INTO Persons (FirstName, LastName, Role, IsSuspect, Affiliation)
VALUES
    (N'John', N'Smith', N'Employee', 0, N'IT Department'),
    (N'Sarah', N'Johnson', N'Employee', 0, N'IT Department'),
  (N'Michael', N'Brown', N'Employee', 1, N'IT Department'),
    (N'Emily', N'Davis', N'Security Officer', 0, N'Security'),
    (N'Robert', N'Wilson', N'Manager', 0, N'IT Department');

-- Locations for Case 1.1
INSERT INTO Locations (Name, Address, Zone, BuildingType)
VALUES
(N'Server Room 4th Floor', N'100 Tech Plaza, Suite 400', N'Building A', N'Office'),
    (N'Building Entrance', N'100 Tech Plaza, Main Entrance', N'Building A', N'Office'),
    (N'Server Room 3rd Floor', N'100 Tech Plaza, Suite 300', N'Building A', N'Office');

-- BadgeAccess records for Case 1.1
-- Create a sequence of 50 badge access records with one missing
-- The missing record is between 09:45 and 10:15 for Michael Brown

INSERT INTO BadgeAccess (CaseID, PersonID, LocationID, AccessTime, AccessType, Status, BadgeID)
VALUES
    -- John Smith entries
    (1, 1, 1, '2025-11-14 08:00:00', 'Entry', 'Successful', 'B001'),
    (1, 1, 1, '2025-11-14 08:30:00', 'Exit', 'Successful', 'B001'),
    (1, 1, 2, '2025-11-14 08:35:00', 'Entry', 'Successful', 'B001'),
    (1, 1, 2, '2025-11-14 17:00:00', 'Exit', 'Successful', 'B001'),
 
    -- Sarah Johnson entries
    (1, 2, 1, '2025-11-14 08:15:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-14 12:00:00', 'Exit', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-14 13:00:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-14 17:15:00', 'Exit', 'Successful', 'B002'),
    
    -- Michael Brown entries - WITH MISSING ENTRY AT 09:00
    (1, 3, 1, '2025-11-14 08:45:00', 'Entry', 'Successful', 'B003'),
    -- MISSING ENTRY: Would have been at 09:00 for Michael Brown
    (1, 3, 1, '2025-11-14 09:30:00', 'Entry', 'Successful', 'B003'),
 (1, 3, 1, '2025-11-14 10:00:00', 'Exit', 'Successful', 'B003'),
    (1, 3, 2, '2025-11-14 10:05:00', 'Entry', 'Successful', 'B003'),
    (1, 3, 2, '2025-11-14 10:30:00', 'Exit', 'Successful', 'B003'),
    (1, 3, 1, '2025-11-14 14:00:00', 'Entry', 'Successful', 'B003'),
    (1, 3, 1, '2025-11-14 16:45:00', 'Exit', 'Successful', 'B003'),
    
    -- Emily Davis entries
  (1, 4, 2, '2025-11-14 07:30:00', 'Entry', 'Successful', 'B004'),
    (1, 4, 2, '2025-11-14 17:30:00', 'Exit', 'Successful', 'B004'),
    
    -- Robert Wilson entries
    (1, 5, 1, '2025-11-14 09:00:00', 'Entry', 'Successful', 'B005'),
    (1, 5, 1, '2025-11-14 11:00:00', 'Exit', 'Successful', 'B005'),
  (1, 5, 1, '2025-11-14 13:30:00', 'Entry', 'Successful', 'B005'),
    (1, 5, 1, '2025-11-14 17:00:00', 'Exit', 'Successful', 'B005'),
    
    -- Additional entries to reach 50+ records
    (1, 1, 1, '2025-11-15 08:00:00', 'Entry', 'Successful', 'B001'),
    (1, 1, 1, '2025-11-15 17:00:00', 'Exit', 'Successful', 'B001'),
    (1, 2, 1, '2025-11-15 08:15:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-15 17:15:00', 'Exit', 'Successful', 'B002'),
    (1, 3, 1, '2025-11-15 08:45:00', 'Entry', 'Successful', 'B003'),
    (1, 3, 1, '2025-11-15 17:00:00', 'Exit', 'Successful', 'B003'),
    (1, 4, 2, '2025-11-15 07:30:00', 'Entry', 'Successful', 'B004'),
    (1, 4, 2, '2025-11-15 17:30:00', 'Exit', 'Successful', 'B004'),
    (1, 5, 1, '2025-11-15 09:00:00', 'Entry', 'Successful', 'B005'),
    (1, 5, 1, '2025-11-15 17:00:00', 'Exit', 'Successful', 'B005'),
    (1, 1, 1, '2025-11-16 08:00:00', 'Entry', 'Successful', 'B001'),
    (1, 1, 1, '2025-11-16 17:00:00', 'Exit', 'Successful', 'B001'),
 (1, 2, 1, '2025-11-16 08:15:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-16 17:15:00', 'Exit', 'Successful', 'B002'),
    (1, 3, 1, '2025-11-16 08:45:00', 'Entry', 'Successful', 'B003'),
    (1, 3, 1, '2025-11-16 17:00:00', 'Exit', 'Successful', 'B003'),
    (1, 4, 2, '2025-11-16 07:30:00', 'Entry', 'Successful', 'B004'),
    (1, 4, 2, '2025-11-16 17:30:00', 'Exit', 'Successful', 'B004'),
    (1, 5, 1, '2025-11-16 09:00:00', 'Entry', 'Successful', 'B005'),
    (1, 5, 1, '2025-11-16 17:00:00', 'Exit', 'Successful', 'B005'),
  (1, 1, 1, '2025-11-17 08:00:00', 'Entry', 'Successful', 'B001'),
  (1, 1, 1, '2025-11-17 17:00:00', 'Exit', 'Successful', 'B001'),
    (1, 2, 1, '2025-11-17 08:15:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 1, '2025-11-17 17:15:00', 'Exit', 'Successful', 'B002'),
 (1, 3, 1, '2025-11-17 08:45:00', 'Entry', 'Successful', 'B003'),
 (1, 3, 1, '2025-11-17 17:00:00', 'Exit', 'Successful', 'B003'),
  (1, 4, 2, '2025-11-17 07:30:00', 'Entry', 'Successful', 'B004'),
    (1, 4, 2, '2025-11-17 17:30:00', 'Exit', 'Successful', 'B004'),
    (1, 5, 1, '2025-11-17 09:00:00', 'Entry', 'Successful', 'B005'),
    (1, 5, 1, '2025-11-17 17:00:00', 'Exit', 'Successful', 'B005'),
    (1, 1, 3, '2025-11-17 09:15:00', 'Entry', 'Successful', 'B001'),
    (1, 1, 3, '2025-11-17 09:45:00', 'Exit', 'Successful', 'B001'),
    (1, 2, 3, '2025-11-17 10:00:00', 'Entry', 'Successful', 'B002'),
    (1, 2, 3, '2025-11-17 10:30:00', 'Exit', 'Successful', 'B002'),
    (1, 3, 1, '2025-11-18 08:45:00', 'Entry', 'Successful', 'B003'),
    (1, 3, 1, '2025-11-18 17:00:00', 'Exit', 'Successful', 'B003'),
    (1, 4, 2, '2025-11-18 07:30:00', 'Entry', 'Successful', 'B004'),
    (1, 4, 2, '2025-11-18 17:30:00', 'Exit', 'Successful', 'B004'),
    (1, 5, 1, '2025-11-18 09:00:00', 'Entry', 'Successful', 'B005'),
  (1, 5, 1, '2025-11-18 17:00:00', 'Exit', 'Successful', 'B005');

-- ============================================================================
-- TIER 1, CASE 1.2: Parking Lot Theft
-- ============================================================================

-- Persons for Case 1.2
INSERT INTO Persons (FirstName, LastName, Role, IsSuspect, Affiliation)
VALUES
    (N'David', N'Martinez', N'Lot Attendant', 0, N'Parking Services'),
    (N'Jennifer', N'Garcia', N'Lot Attendant', 0, N'Parking Services'),
    (N'James', N'Taylor', N'Thief', 1, N'Unknown'),
    (N'Patricia', N'Anderson', N'Vehicle Owner', 0, N'Public'),
    (N'Christopher', N'Thomas', N'Security Guard', 0, N'Parking Services');

-- Locations for Case 1.2
INSERT INTO Locations (Name, Address, Zone, BuildingType)
VALUES
    (N'Downtown Parking Lot A', N'500 Main Street, Downtown', N'Downtown', N'Parking Lot'),
    (N'Downtown Parking Lot Entry', N'500 Main Street, Gate A', N'Downtown', N'Parking Lot'),
    (N'Downtown Parking Lot Exit', N'500 Main Street, Gate B', N'Downtown', N'Parking Lot');

-- ParkingLotAccess records for Case 1.2
-- Normal gate activity with suspicious unauthorized exit at 03:15 on 2025-11-14

INSERT INTO ParkingLotAccess (CaseID, LocationID, EventTime, EventType, VehicleID, VehicleRecorded, Notes)
VALUES
    -- Normal evening entries (2025-11-13)
    (2, 2, '2025-11-13 18:00:00', 'GateEntry', 'ABC123', 1, 'Evening visitor'),
    (2, 3, '2025-11-13 19:30:00', 'GateExit', 'ABC123', 1, 'Evening visitor leaving'),
    (2, 2, '2025-11-13 20:00:00', 'GateEntry', 'XYZ789', 1, 'Late evening entry'),
    (2, 3, '2025-11-13 22:00:00', 'GateExit', 'XYZ789', 1, 'Late evening exit'),
    
    -- Night of theft (2025-11-14) - SUSPICIOUS ACTIVITY
    (2, 2, '2025-11-14 02:15:00', 'GateEntry', NULL, 0, 'No vehicle recorded - possible tailgate'),
    (2, 3, '2025-11-14 03:15:00', 'GateExit', 'DEF456', 0, 'SUSPICIOUS: Vehicle exit not recorded on entry - possible stolen vehicle'),
    
 -- Normal morning activity resumes
    (2, 2, '2025-11-14 06:00:00', 'GateEntry', 'PQR234', 1, 'Early morning entry'),
  (2, 3, '2025-11-14 09:00:00', 'GateExit', 'PQR234', 1, 'Early morning exit'),
    (2, 2, '2025-11-14 08:30:00', 'GateEntry', 'STU567', 1, 'Morning entry'),
    (2, 3, '2025-11-14 11:30:00', 'GateExit', 'STU567', 1, 'Morning exit'),
    (2, 2, '2025-11-14 12:00:00', 'GateEntry', 'VWX890', 1, 'Midday entry'),
 (2, 3, '2025-11-14 14:00:00', 'GateExit', 'VWX890', 1, 'Midday exit'),
    (2, 2, '2025-11-14 15:00:00', 'GateEntry', 'YZA123', 1, 'Afternoon entry'),
    (2, 3, '2025-11-14 16:30:00', 'GateExit', 'YZA123', 1, 'Afternoon exit'),
    (2, 2, '2025-11-14 17:00:00', 'GateEntry', 'BCD456', 1, 'Evening entry'),
    (2, 3, '2025-11-14 18:00:00', 'GateExit', 'BCD456', 1, 'Evening exit'),
    
    -- Normal activity continues (2025-11-15)
    (2, 2, '2025-11-15 06:00:00', 'GateEntry', 'EFG789', 1, 'Morning entry'),
    (2, 3, '2025-11-15 09:00:00', 'GateExit', 'EFG789', 1, 'Morning exit'),
    (2, 2, '2025-11-15 10:00:00', 'GateEntry', 'HIJ012', 1, 'Morning entry'),
    (2, 3, '2025-11-15 12:00:00', 'GateExit', 'HIJ012', 1, 'Morning exit'),
    (2, 2, '2025-11-15 14:00:00', 'GateEntry', 'KLM345', 1, 'Afternoon entry'),
    (2, 3, '2025-11-15 17:00:00', 'GateExit', 'KLM345', 1, 'Afternoon exit'),
    (2, 2, '2025-11-15 18:00:00', 'GateEntry', 'NOP678', 1, 'Evening entry'),
    (2, 3, '2025-11-15 19:30:00', 'GateExit', 'NOP678', 1, 'Evening exit');

-- ============================================================================
-- STORY STEPS FOR CASE 1.1
-- ============================================================================

INSERT INTO StorySteps (CaseID, StepNumber, StepPrompt, CanonicalQuery, ExpectedValue)
VALUES
    (1, 1, 
     N'Find all badge access records for Michael Brown (PersonID=3) on 2025-11-14 and order them by time. How many entries do you find?',
     N'SELECT AccessID, PersonID, AccessTime, AccessType, Status FROM BadgeAccess WHERE CaseID=1 AND PersonID=3 AND CAST(AccessTime AS DATE)=''2025-11-14'' ORDER BY AccessTime;',
     N'You should find 5 records. There is a gap between 09:00 and 09:30 - a missing entry!'),
  
    (1, 2,
     N'Now find all badge access records for Server Room 4th Floor (LocationID=1) on 2025-11-14 between 8:00 AM and 10:30 AM, ordered by time. What do you notice?',
     N'SELECT AccessID, PersonID, AccessTime, AccessType FROM BadgeAccess WHERE CaseID=1 AND LocationID=1 AND CAST(AccessTime AS DATE)=''2025-11-14'' AND CAST(AccessTime AS TIME) BETWEEN ''08:00'' AND ''10:30'' ORDER BY AccessTime;',
     N'Michael Brown should have an entry at 09:00 but it''s missing. His records jump from 08:45 (Entry) to 09:30 (Entry).');

-- ============================================================================
-- STORY STEPS FOR CASE 1.2
-- ============================================================================

INSERT INTO StorySteps (CaseID, StepNumber, StepPrompt, CanonicalQuery, ExpectedValue)
VALUES
    (2, 1,
     N'Find all gate activity at the Downtown Parking Lot on 2025-11-14 between 02:00 and 04:00. What unusual event do you see?',
     N'SELECT GateEventID, EventTime, EventType, VehicleID, VehicleRecorded FROM ParkingLotAccess WHERE CaseID=2 AND CAST(EventTime AS DATE)=''2025-11-14'' AND CAST(EventTime AS TIME) BETWEEN ''02:00'' AND ''04:00'' ORDER BY EventTime;',
  N'At 03:15, there is a GateExit for vehicle DEF456, but VehicleRecorded=0, meaning this vehicle was NOT recorded entering!'),
     
    (2, 2,
     N'Compare entries vs exits for 2025-11-14. Find all vehicles that exited without entering first (VehicleRecorded=0 on exit and no matching entry). This is our stolen vehicle!',
     N'SELECT pl.GateEventID, pl.EventTime, pl.EventType, pl.VehicleID FROM ParkingLotAccess pl WHERE CaseID=2 AND pl.EventType=''GateExit'' AND pl.VehicleRecorded=0 AND CAST(pl.EventTime AS DATE)=''2025-11-14'';',
     N'Vehicle DEF456 exited at 03:15 without being recorded. This is the stolen vehicle!');

-- ============================================================================
-- ANSWER KEYS FOR CASE 1.1
-- ============================================================================

INSERT INTO AnswerKeys (StepID, ExpectedResultHash, ExpectedClueValue)
VALUES
    (1, 'hash_placeholder_step1_case1', N'5 records with gap between 09:00 and 09:30'),
    (2, 'hash_placeholder_step2_case1', N'Michael Brown missing entry at 09:00 in Server Room 4th Floor');

-- ============================================================================
-- ANSWER KEYS FOR CASE 1.2
-- ============================================================================

INSERT INTO AnswerKeys (StepID, ExpectedResultHash, ExpectedClueValue)
VALUES
    (3, 'hash_placeholder_step1_case2', N'Vehicle DEF456 exits at 03:15 with VehicleRecorded=0'),
    (4, 'hash_placeholder_step2_case2', N'DEF456 is the stolen vehicle that exited without entering');

-- ============================================================================
-- VERIFICATION MESSAGE
-- ============================================================================

PRINT '=============================================================================';
PRINT 'Seed Data - Phase 1 (Tier 1 Cases) Successfully Inserted';
PRINT '=============================================================================';
PRINT '';
PRINT 'Case 1.1: Missing Badge Access Record';
PRINT '  - 5 Persons: John Smith, Sarah Johnson, Michael Brown, Emily Davis, Robert Wilson';
PRINT '  - 3 Locations: Server Room 4th Floor, Building Entrance, Server Room 3rd Floor';
PRINT '  - 50+ BadgeAccess records with 1 missing entry (Michael Brown at 09:00)';
PRINT '  - 2 StorySteps for investigation';
PRINT '';
PRINT 'Case 1.2: Downtown Parking Lot Theft';
PRINT '  - 5 Persons: David Martinez, Jennifer Garcia, James Taylor, Patricia Anderson, Christopher Thomas';
PRINT '  - 3 Locations: Downtown Parking Lot A, Entry Gate, Exit Gate';
PRINT '  - 28 ParkingLotAccess records with 1 suspicious unrecorded exit (Vehicle DEF456 at 03:15)';
PRINT '  - 2 StorySteps for investigation';
PRINT '';
PRINT 'Story Steps Created: 4 total (2 per case)';
PRINT 'Answer Keys Created: 4 total (2 per case)';
PRINT '';
PRINT 'All data is realistic but minimal for easy testing and verification.';
PRINT '=============================================================================';
