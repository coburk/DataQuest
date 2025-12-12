# 🔍 DataQuest Case Design Examples - Downtown SLC Computer Science University

**Date:** December 4, 2025  
**Status:** REVISED CASE DESIGNS FOR ALL TIERS  
**Audience:** Computer Science Students  
**Setting:** Small CS University, Historical Downtown SLC Building  
**Dataset:** Crime Database (Realistic, Relevant, Educational)

---

## 📋 CONTEXT & SETTING

### The University
- **Name:** University of Computer Science (fictional)
- **Location:** Historic downtown Salt Lake City building (circa 1910s)
- **Size:** ~800 CS students total
- **Character:** Old building with modern tech infrastructure
- **Neighborhood:** Downtown SLC with mixed commercial, residential, arts district

### Local Context
- Historic district with local businesses, galleries, restaurants
- Public transit (UTA) hub nearby
- Street-level building access with foot traffic
- Nearby entertainment venues (bars, clubs, theaters)
- Urban crime patterns differ from suburban campus

### Student Context
- CS majors understand databases, systems, logic
- Familiar with tech-related crimes (theft of laptops, hacking, etc.)
- Downtown location means more urban crime exposure
- Practical, systems-thinking mindset

---

## 🎯 TIER SYSTEM CASES - REVISED EXAMPLES

### TIER 1: Junior Data Analyst - "Building Security Basics"

#### Case 1.1: "Missing Badge Access Records"

**Scenario:**
You work for the university's Facilities & Security office. The building uses badge access for the server room on the 4th floor (where expensive equipment is stored). A server outage occurred yesterday afternoon, and you need to verify who had physical access to the server room during the critical time window.

**Story:**
```
Incident: Server Room Cooling System Failed (Yesterday 2 PM - 4 PM)
Question: Who had badge access to server room during outage?
Task: Pull access logs to verify legitimate maintenance visits
```

**SQL Skills Required:**
- Simple SELECT query
- WHERE clause with time range filter
- COUNT aggregation

**Canonical Query:**
```sql
SELECT person_name, badge_time, access_location
FROM BadgeAccess
WHERE access_location = 'Server Room 4th Floor'
  AND badge_time >= '2025-11-14 14:00:00'
  AND badge_time <= '2025-11-14 16:00:00'
ORDER BY badge_time
```

**Investigation:**
- Question 1: "How many people accessed the server room yesterday afternoon?"
  → Find: 3 people (2 expected maintenance, 1 unexpected)
- Question 2: "Who is the unexpected person?"
  → Find: Badge shows "System Admin - Dr. Chen" at 2:15 PM
- Question 3: "Was this legitimate maintenance?"
  → Find: Yes, emergency cooling system check (confirmed with facilities log)

**Learning Outcome:**
- Basic date/time filtering
- Understanding access log structure
- Verifying security events
- Simple data validation

**Difficulty:** ⭐ (5-7 minutes)

---

#### Case 1.2: "Downtown Parking Lot Theft"

**Scenario:**
The university operates a small parking lot in the historic district for staff and student parking. A car was broken into overnight. The lot has a gate with a time-stamped access log. You need to find the time window when the vehicle was likely accessed.

**Story:**
```
Vehicle: 2022 Honda Civic
Incident: Break-in overnight (parked 6 PM, discovered 7 AM)
Damage: Driver window broken, laptop stolen
Question: When did the parking lot gate open/close?
Task: Find access patterns during incident window
```

**SQL Skills Required:**
- SELECT specific columns
- WHERE with time range
- ORDER BY for sequence

**Canonical Query:**
```sql
SELECT gate_event, event_time, vehicle_id
FROM ParkingLotAccess
WHERE event_date = '2025-11-14'
  AND event_time >= '18:00'
  AND event_time <= '07:00' -- Next day morning
ORDER BY event_time
```

**Investigation:**
- Question 1: "When were the gate openings during the incident window?"
  → Find: Multiple openings (normal staff/student departures 6-9 PM)
- Question 2: "Any unusual late-night activity?"
  → Find: Gate opened at 2:34 AM (no vehicle recorded entering)
- Question 3: "What does that mean?"
  → Find: Someone exited without proper vehicle record (possible theft suspect leaving)

**Learning Outcome:**
- Time-range filtering
- Understanding parking lot operations
- Identifying anomalies in normal patterns
- Basic investigative thinking

**Difficulty:** ⭐ (5-10 minutes)

---

### TIER 2: Senior Data Analyst - "Who's Stealing from Downtown?"

#### Case 2.1: "Laptop Theft Pattern in Downtown SLC"

**Scenario:**
Several laptops have been stolen from businesses and the university in downtown SLC over the past month. Police are trying to determine if these are random opportunistic thefts or part of a pattern. You need to analyze the theft reports to find common characteristics.

**Story:**
```
Incidents: 7 laptop thefts in downtown SLC (past 30 days)
Locations: Mix of university, coffee shops, businesses
Question: Is there a pattern to these thefts?
Context: Downtown SLC has high foot traffic and visibility
```

**Data Tables Involved:**
- Incidents (incident_id, description, type, date, time, location_id)
- Stolen_Items (item_id, incident_id, item_type, value, brand)
- Locations (location_id, name, building_type, address_zip)
- Reporters (reporter_id, incident_id, affiliation)

**SQL Skills Required:**
- JOIN 3 tables
- GROUP BY and COUNT
- HAVING clause
- ORDER BY aggregated results
- WHERE with multiple conditions

**Canonical Query:**
```sql
SELECT 
    l.location_name,
    COUNT(i.incident_id) as theft_count,
    AVG(si.item_value) as avg_laptop_value,
    STRING_AGG(si.brand, ', ') as brands_stolen
FROM Incidents i
JOIN Locations l ON i.location_id = l.location_id
JOIN Stolen_Items si ON i.incident_id = si.incident_id
WHERE i.incident_type = 'Theft'
  AND i.incident_date >= DATEADD(DAY, -30, GETDATE())
  AND si.item_type = 'Laptop'
  AND l.zip_code = '84101' -- Downtown SLC
GROUP BY l.location_id, l.location_name
HAVING COUNT(i.incident_id) > 1
ORDER BY theft_count DESC
```

**Investigation:**
- Question 1: "How many laptop thefts in downtown SLC this month?"
  → Find: 7 total
- Question 2: "Which locations had multiple thefts?"
  → Find: Coffee shop = 3 thefts, University = 2, Business district = 2
- Question 3: "What time of day do these happen?"
  → Find: Coffee shop thefts mostly morning (7-9 AM), University afternoon (2-4 PM)
- Question 4: "What brands of laptops?"
  → Find: Mix of MacBooks and Dell XPS (mid-range, not gaming rigs)
- Question 5: "What's the pattern?"
  → Find: High-value but portable laptops, in public places with heavy foot traffic

**Red Herring:**
The coffee shop seems to be a hotspot (3 thefts), making it look like an inside job or that place is specifically targeted. But actually, it's just where most students and professionals work with laptops in public.

**Learning Outcome:**
- Joining multiple data sources
- Grouping and aggregating
- Finding patterns in theft behavior
- Understanding context (location + time + item type)

**Difficulty:** ⭐⭐ (10-15 minutes)

---

#### Case 2.2: "Break-In Locations Over Time"

**Scenario:**
The downtown SLC area has experienced a string of vehicle break-ins in parking lots and on-street parking. Police want to identify the hot spots and times to increase patrols. You need to analyze break-in locations to recommend where to focus resources.

**Story:**
```
Incidents: 12 vehicle break-ins in past 2 months
Area: Downtown SLC (6-block radius)
Goal: Identify specific block locations and times
Action: Police resource allocation for prevention
```

**SQL Skills Required:**
- GROUP BY location
- COUNT incidents
- WHERE with date ranges
- JOINs with location data
- ORDER BY for ranking

**Canonical Query:**
```sql
SELECT TOP 5
l.block_address,
    l.zone_name,
    COUNT(i.incident_id) as break_in_count,
    AVG(DATEPART(HOUR, i.incident_time)) as avg_incident_hour,
    MIN(i.incident_date) as earliest_incident,
    MAX(i.incident_date) as latest_incident
FROM Incidents i
JOIN Locations l ON i.location_id = l.location_id
WHERE i.incident_type = 'Vehicle Break-In'
  AND i.incident_date >= DATEADD(MONTH, -2, GETDATE())
  AND l.zip_code IN ('84101', '84102') -- Downtown SLC zones
GROUP BY l.location_id, l.block_address, l.zone_name
ORDER BY break_in_count DESC
```

**Investigation:**
- Question 1: "Which blocks have the most break-ins?"
  → Find: Main Street (3), West Temple (3), South Temple (2), etc.
- Question 2: "What time of day do they occur?"
  → Find: Evening (6-10 PM) and overnight (midnight-4 AM)
- Question 3: "Are certain blocks worse at certain times?"
  → Find: West Temple area has overnight break-ins; Main Street has evening
- Question 4: "Why the difference?"
  → Find: West Temple = residential area, Main Street = entertainment district
- Question 5: "What time should patrols be increased?"
  → Find: Evening patrols Main Street, overnight patrols West Temple

**Learning Outcome:**
- Spatial pattern analysis (by location)
- Temporal pattern analysis (by time)
- Resource allocation decisions
- Understanding urban crime patterns

**Difficulty:** ⭐⭐ (10-15 minutes)

---

### TIER 3: Data Inspector - "Data Quality in Police Records"

#### Case 3.1: "Downtown SLC Police Report Consistency"

**Scenario:**
The university is partnering with downtown SLC police on a crime analysis project. You're reviewing incoming police reports to ensure data quality before analysis. A new police officer has been filing reports, and some of them have inconsistencies or missing information.

**Story:**
```
New Officer: Officer Rodriguez (started 2 weeks ago)
Quality Issue: Some reports seem incomplete or inconsistent
Task: Identify all data quality problems in their reports
Goal: Ensure accurate data for analysis and legal proceedings
```

**Data Tables:**
- Police_Reports (report_id, officer_id, incident_date, incident_type, location_id)
- Report_Details (report_id, description, witness_count, items_involved)
- Officers (officer_id, name, badge_number, start_date)
- Locations (location_id, block_address, zone, precinct)

**SQL Skills Required:**
- Multiple JOINs (4 tables)
- NULL handling
- CASE statements for conditional logic
- WHERE with AND/OR conditions
- Data type checking (length, format)

**Canonical Query:**
```sql
SELECT 
    pr.report_id,
    o.name as officer_name,
    pr.incident_date,
 pr.incident_type,
    CASE 
        WHEN pr.location_id IS NULL THEN 'Missing Location'
        WHEN rd.description IS NULL THEN 'Missing Description'
        WHEN rd.description = '' THEN 'Empty Description'
        WHEN LEN(rd.description) < 20 THEN 'Description Too Brief'
        WHEN rd.witness_count IS NULL THEN 'Witness Count Missing'
     WHEN rd.witness_count = 0 AND pr.incident_type NOT IN ('Vandalism', 'Theft') THEN 'Unusual: No Witnesses'
        WHEN pr.incident_type NOT IN (SELECT DISTINCT incident_type FROM Police_Reports WHERE officer_id != o.officer_id) THEN 'Unusual Incident Type'
        ELSE 'OK'
    END as data_quality_issue
FROM Police_Reports pr
JOIN Officers o ON pr.officer_id = o.officer_id
LEFT JOIN Report_Details rd ON pr.report_id = rd.report_id
LEFT JOIN Locations l ON pr.location_id = l.location_id
WHERE o.name = 'Officer Rodriguez'
    AND (pr.location_id IS NULL 
        OR rd.description IS NULL 
        OR rd.description = ''
        OR LEN(rd.description) < 20
        OR rd.witness_count IS NULL)
ORDER BY pr.incident_date DESC
```

**Investigation:**
- Question 1: "How many reports did Officer Rodriguez file?"
  → Find: 14 reports in 2 weeks
- Question 2: "Do any reports have missing location data?"
  → Find: 2 reports missing location_id
- Question 3: "Are descriptions complete?"
  → Find: 3 reports with descriptions under 20 characters ("Theft at store", etc.)
- Question 4: "Are witness counts always recorded?"
  → Find: 1 report missing witness count, 2 with witness_count = 0
- Question 5: "What's the pattern?"
  → Find: All issues are on evening shift (5 PM - 1 AM)
- Question 6: "Why evening shift specifically?"
  → Discover: Officer Rodriguez is still training; senior officers haven't been paired with him during evening shifts
- Question 7: "What should happen?"
  → Recommend: Pair with senior officer during evening shift training; review and correct those 14 reports

**Contradictions:**
- Seems like Officer Rodriguez is doing poor work
- But actually, he's under-supervised and lacks training on evening shift procedures
- His senior officer (Officer Thompson) works day shift and hasn't trained him on evening shift requirements
- Resolution: Structured training program during evening hours

**Learning Outcome:**
- Complex data quality verification
- Multiple JOIN patterns
- NULL handling and edge case detection
- Using CASE for conditional analysis
- Finding root causes, not just surface problems
- Understanding that data quality issues indicate training/process needs

**Difficulty:** ⭐⭐⭐ (20-30 minutes)

---

#### Case 3.2: "Theft Report Timeline Verification"

**Scenario:**
Several theft reports have been filed from downtown SLC businesses. You notice something odd: some reports have incident times that don't match store hours or business operations. You need to investigate whether data entry errors are occurring or if there's something else going on.

**Story:**
```
Observation: Thefts reported from downtown businesses at odd times
Examples: 
- Coffee shop theft at 3 AM (closed at midnight)
- Bookstore theft at 5 AM (opens at 10 AM)
- Restaurant theft at 2 AM (closed at 11 PM)
Question: Are these data entry errors? Or actual crimes?
Context: Several businesses in same area, similar time pattern
```

**Data Tables:**
- Incidents (incident_id, incident_type, incident_date, incident_time, location_id)
- Incident_Details (incident_id, description, discovery_time, discovery_date)
- Businesses (location_id, business_name, hours_open, hours_close)
- Police_Reports (incident_id, report_date, report_time, officer_notes)

**SQL Skills Required:**
- Multiple JOINs with temporal logic
- CASE statements for business hour analysis
- WHERE with complex conditions
- Time comparison logic
- Pattern recognition across dates

**Canonical Query:**
```sql
SELECT 
    i.incident_id,
    b.business_name,
    i.incident_type,
    i.incident_date,
    i.incident_time,
    id.discovery_time,
    id.discovery_date,
    b.hours_open,
    b.hours_close,
    CASE
WHEN CAST(i.incident_time AS TIME) < CAST(b.hours_open AS TIME) 
   OR CAST(i.incident_time AS TIME) > CAST(b.hours_close AS TIME)
      THEN 'Outside Business Hours'
        WHEN id.discovery_date > i.incident_date
        THEN 'Discovered Next Day'
 WHEN id.discovery_time IS NOT NULL 
          AND DATEDIFF(HOUR, i.incident_time, id.discovery_time) > 12
       THEN 'Large Time Gap'
      ELSE 'Within Business Hours'
    END as temporal_issue
FROM Incidents i
JOIN Incident_Details id ON i.incident_id = id.incident_id
JOIN Businesses b ON i.location_id = b.location_id
WHERE i.incident_type = 'Theft'
  AND i.incident_date >= DATEADD(DAY, -30, GETDATE())
  AND i.location_id IN (SELECT location_id FROM Businesses WHERE zip_code = '84101')
ORDER BY i.incident_date DESC
```

**Investigation:**
- Question 1: "How many theft reports from downtown businesses?"
  → Find: 8 reports in past month
- Question 2: "Which ones have odd incident times?"
  → Find: 5 reports outside business hours
- Question 3: "When were these thefts actually discovered?"
  → Find: Most discovered morning after (employee opens next day)
- Question 4: "So when did the actual theft occur?"
  → Find: Police recorded discovery time as incident time (data entry error!)
- Question 5: "What should the incident times really be?"
  → Find: Overnight (likely during closed hours, not specifically at 3 AM)
- Question 6: "Is this a real pattern or just reporting practice?"
  → Realize: These are overnight break-ins during closed business hours (normal)

**Contradiction:**
- Looks like police are recording impossible incident times
- But actually, the thefts occurred overnight during closed hours
- The issue: Police recorded when theft was discovered (morning), not when it occurred (overnight)
- Shows need for better reporting protocol: "Estimated incident window" vs. "Discovery time"

**Red Herring:**
The specific times (3 AM, 5 AM, 2 AM) make it look suspicious, but it's just that business was closed and theft discovered in morning.

**Learning Outcome:**
- Temporal pattern analysis
- Understanding business context
- Detecting data entry errors through logic verification
- Distinguishing between actual events and reporting practices
- Recognizing that data issues often indicate process problems

**Difficulty:** ⭐⭐⭐ (20-30 minutes)

---

### TIER 4: Data Detective - "Downtown SLC Break-In Ring"

#### Case 4.1: "Organized Downtown Business Break-Ins"

**Scenario:**
Over the past 6 weeks, downtown SLC businesses have experienced multiple break-ins. Police suspect an organized group based on similar methods and timing. You need to analyze all break-ins to determine if there's evidence of coordination, identify patterns, and find actionable intelligence.

**Story:**
```
Crime Pattern: 15 business break-ins in downtown SLC (6 weeks)
Locations: Mix of retail, restaurants, small offices
Methods: Similar pattern observed (forced entry, targeted items)
Suspicion: Organized group, not random opportunistic crime

Detective's Question:
"If this is organized, we'd expect:
- Similar method of operation (forced entry type)
- Targeting specific high-value items (electronics, cash registers)
- Sequential timing pattern
- Possibly same entry/exit methods
- Multiple repeat locations vs. spread across area"
```

**Data Tables:**
- Incidents (incident_id, incident_type, incident_date, incident_time, location_id, status)
- Break_In_Details (incident_id, entry_method, damage_description, items_taken)
- Suspects (suspect_id, name, known_aliases, criminal_history)
- Suspect_Involvement (incident_id, suspect_id, involvement_type, confidence_level)
- Business_Details (location_id, business_type, hours, security_type, repeat_victim)
- Evidence (evidence_id, incident_id, description, location_found)

**SQL Skills Required:**
- Multiple complex JOINs (6+ tables)
- CASE statements for pattern classification
- GROUP BY with multiple columns
- Pattern matching with WHERE conditions
- Temporal analysis (date/time clustering)
- String matching for method analysis

**Canonical Query:**
```sql
SELECT 
    i.incident_id,
    CAST(i.incident_date AS DATE) as incident_date,
    DATEPART(HOUR, i.incident_time) as hour_of_day,
    l.block_address,
    bd.entry_method,
    STRING_AGG(bd.items_taken, '; ') as items_taken,
    COUNT(DISTINCT si.suspect_id) as suspect_count,
  STRING_AGG(DISTINCT s.name, ', ') as suspect_names,
    bd.repeat_victim,
    CASE
        WHEN bd.entry_method IN ('Force Entry - Glass', 'Pry Lock')
     AND DATEDIFF(DAY, i.incident_date, LAG(i.incident_date) OVER (ORDER BY i.incident_date)) BETWEEN 1 AND 7
  AND bd.repeat_victim = 1
      THEN 'High Confidence - Coordinated'
    WHEN bd.entry_method IN ('Force Entry - Glass', 'Pry Lock')
    AND DATEDIFF(DAY, i.incident_date, LAG(i.incident_date) OVER (ORDER BY i.incident_date)) BETWEEN 1 AND 7
     THEN 'Medium Confidence - Possible Coordination'
     ELSE 'Low Confidence - Likely Isolated'
    END as coordination_assessment
FROM Incidents i
JOIN Locations l ON i.location_id = l.location_id
JOIN Break_In_Details bd ON i.incident_id = bd.incident_id
LEFT JOIN Suspect_Involvement si ON i.incident_id = si.incident_id
LEFT JOIN Suspects s ON si.suspect_id = s.suspect_id
WHERE i.incident_type = 'Break-In'
    AND i.incident_date >= DATEADD(DAY, -42, GETDATE())
    AND l.zip_code IN ('84101', '84102')
GROUP BY i.incident_id, i.incident_date, i.incident_time, l.block_address, bd.entry_method, bd.items_taken, bd.repeat_victim
ORDER BY i.incident_date DESC
```

**Investigation Flow:**

**Phase 1: Establish Overall Pattern**
- Question 1: "How many break-ins in downtown SLC past 6 weeks?"
  → Find: 15 break-ins (extremely high for small area)
- Question 2: "What's being targeted?"
  → Find: Electronics (7), cash registers (5), high-end bikes (2), jewelry (1)
- Question 3: "What's the entry method?"
  → Find: Force entry to glass door (9), pried locks (4), broken window (2)

**Phase 2: Temporal Pattern Analysis**
- Question 4: "When are these happening?"
  → Find:
    - Mostly nighttime (10 PM - 4 AM) = 11 of 15
    - Weekend concentration (Fri/Sat night) = 10 of 15
  - Pattern: Planned activity, not opportunistic
- Question 5: "Any clustering pattern?"
  → Find: Clusters of 2-3 break-ins within 3-day windows, then 5-7 day gaps
  - Could indicate: Group needed to lay low after each cluster

**Phase 3: Geographic Pattern Analysis**
- Question 6: "Which areas are hit?"
  → Find:
    - South Temple corridor = 7 break-ins
    - Main Street district = 5 break-ins
- West Temple = 3 break-ins
  - Pattern: Linear progression along downtown strips
- Question 7: "Any repeat locations?"
  → Find: One restaurant hit twice (10 days apart), one office building twice (8 days apart)
  - Indicator: Either gang knows good targets OR group is learning the layout

**Phase 4: Suspect Analysis**
- Question 8: "Any named suspects?"
  → Find:
    - Marcus "Dice" Williams appears in 3 incidents (confidence level 0.8)
    - Jason Torres appears in 2 incidents (confidence level 0.6)
    - Different suspects for other incidents
  - Pattern: Could be same group with different roles, or different groups
- Question 9: "Known associates of these suspects?"
  → Check: Criminal history shows Marcus and Jason have known association
  - Indicator: Likely working together
- Question 10: "Any alibis or contradictions?"
  → Find: Marcus arrested for unrelated offense on Oct 12 - during that break-in he couldn't have been there
  - But data shows him as suspect in Oct 12 incident
  - Implication: Either misidentified suspect OR different gang member mistaken for Marcus

**Phase 5: Method Consistency**
- Question 11: "Is entry method consistent?"
  → Find:
    - 9 of 15 use "force entry to glass" (very consistent)
    - 4 of 15 use "pry lock" (alternate method)
    - 2 of 15 use "broken window" (might be copy-cat or different group)
  - Pattern: 13 of 15 use forced entry (professional approach, not smash-and-grab)
- Question 12: "What items are selected?"
  → Find:
    - Electronics targeted 7 times (high resale value)
    - Cash registers 5 times (need cash for immediate needs)
    - Luxury items 2 times (might be one-offs or different member)
  - Pattern: Appears to be professional theft ring focusing on resalable goods

**Phase 6: The Twist & Resolution**

**Red Herring 1: "Marcus Williams is the ringleader"**
- He appears in 3 incidents as primary suspect
- BUT: One incident on Oct 12, he was arrested 50 miles away at same time
- Implication: Either misidentified or copycat group
- Resolution: Interview Marcus; verify timeline; check if someone impersonating him

**Red Herring 2: "They're hitting repeat locations for reconnaissance"**
- Two businesses hit twice
- BUT: These are 8-10 days apart, with different items taken
- Might indicate: Different group members testing same location, OR gang genuinely forgot what they already took
- More likely: Gang learned first location was vulnerable, returned to maximize theft

**Contradiction: "Organized group but inconsistent methods"**
- Mostly forced entry to glass (professional)
- But 2 incidents use "broken window" (seems less sophisticated)
- Could mean: Leadership group + lower-level members, OR copycats mimicking real gang

**True Pattern Emerges:**

After careful analysis:
- **15 break-ins over 6 weeks = definitely organized** (not random)
- **Consistent method + item selection** = professional operation
- **Temporal clustering** = group pattern (active period, lay low, repeat)
- **Geographic progression** = might be expanding territory
- **Suspect identification issues** = need better witness collection/photo verification
- **Alibis disproving some suspects** = need to clear verified alibis before focus

**Actionable Intelligence:**
1. Marcus Williams is NOT primary suspect (cleared by alibi)
2. Jason Torres needs detailed interview (confidence 0.6 in multiple incidents)
3. Pattern suggests team of 3-5 people (different suspects, coordinated timing)
4. Next likely target: North Temple area (logical geographic progression)
5. High probability of activity Fri/Sat night next window (5-7 days after Oct 20)
6. Increased glass/storefront security recommended on South Temple + Main Street

**Final Query (Predictive - Where Will They Strike Next?):**
```sql
SELECT TOP 3
    l.block_address,
    l.business_type,
    COUNT(i.incident_id) as historical_incidents,
    DATEDIFF(BLOCK_AWAY_FROM_RECENT_HITS) as distance_from_recent_activity,
 b.security_level,
    b.high_value_items
FROM Locations l
LEFT JOIN Incidents i ON l.location_id = i.location_id
LEFT JOIN Businesses b ON l.location_id = b.location_id
WHERE l.zip_code IN ('84101', '84102')
  AND NOT EXISTS (SELECT 1 FROM Incidents WHERE location_id = l.location_id AND incident_date >= DATEADD(DAY, -14, GETDATE()))
  AND l.block_address LIKE 'North Temple%' -- Geographic progression
  AND b.security_level IN ('Low', 'Moderate')
GROUP BY l.block_address, l.business_type, b.security_level, b.high_value_items
ORDER BY historical_incidents DESC, distance_from_recent_activity ASC
```

**Learning Outcome:**
- Complex multi-table JOIN patterns
- Temporal and geographic pattern analysis
- Suspect correlation while respecting alibis
- Distinguishing coordinated patterns from copycat activity
- Critical thinking about data quality and misidentification
- Following data to actionable intelligence
- Understanding real-world complexity of investigations
- Professional reasoning with incomplete information

**Difficulty:** ⭐⭐⭐⭐ (35-50 minutes)

---

### TIER 5: Director of Data Integrity - "Downtown SLC Crime Ecosystem Analysis"

#### Case 5.1: "Downtown Revitalization Impact on Crime"

**Scenario:**
Downtown SLC is undergoing revitalization: new businesses opening, more foot traffic, increased evening activities. City leadership wants data-driven answers: Will crime increase, decrease, or stay the same as downtown becomes more active? What's the relationship between economic activity and crime?

**Story:**
```
Context: Downtown revitalization project (3 months in, 9 months planned)
Question: Is revitalization helping or hurting crime situation?
Available Data: 
  - Crime reports (past 2 years)
  - Business opening/closing dates
  - Foot traffic counts
  - Police staffing levels
  - Economic activity metrics

Executive Leadership Question:
"Should we continue investing in downtown revitalization,
or is it creating crime problems? Give me the data-driven answer."
```

**Data Tables:**
- Incidents (incident_id, type, date, time, location_id, severity, status)
- Incident_Details (incident_id, description, property_value, victim_count)
- Locations (location_id, block_address, latitude, longitude, zone)
- Business_Operations (business_id, location_id, business_type, opening_date, closing_date)
- Foot_Traffic (traffic_id, location_id, date, hour, pedestrian_count)
- Police_Staffing (staff_date, officers_on_duty, zones_covered, reported_patrols)
- Economic_Activity (activity_date, zone, new_businesses, foot_traffic_avg, event_count)

**SQL Skills Required:**
- 8+ complex table JOINs
- Window functions (LAG, LEAD, ROW_NUMBER) for temporal analysis
- CTEs for multi-stage analysis
- CASE statements with business logic
- Statistical aggregation (averages, correlations, trends)
- Subqueries for comparative analysis
- Date arithmetic for phase comparisons

**Complex Analytical Query (Executive Analysis):**
```sql
WITH pre_revitalization AS (
    -- Baseline: 3 months before revitalization started
    SELECT 
     COUNT(DISTINCT i.incident_id) as incident_count,
        SUM(CASE WHEN i.incident_type = 'Theft' THEN 1 ELSE 0 END) as theft_count,
        SUM(CASE WHEN i.incident_type = 'Break-In' THEN 1 ELSE 0 END) as breakin_count,
        SUM(CASE WHEN i.incident_type = 'Vandalism' THEN 1 ELSE 0 END) as vandalism_count,
     AVG(CAST(id.property_value AS FLOAT)) as avg_property_loss,
        COUNT(DISTINCT z.zone) as zones_affected,
        'Pre-Revitalization' as period
    FROM Incidents i
    JOIN Incident_Details id ON i.incident_id = id.incident_id
    JOIN Locations l ON i.location_id = l.location_id
    JOIN Zones z ON l.zone_id = z.zone_id
    WHERE i.incident_date BETWEEN '2025-06-01' AND '2025-09-01' -- 3 months before revitalization
      AND l.zip_code IN ('84101', '84102')
),
early_revitalization AS (
    -- Early phase: First 3 months of revitalization
    SELECT 
        COUNT(DISTINCT i.incident_id) as incident_count,
        SUM(CASE WHEN i.incident_type = 'Theft' THEN 1 ELSE 0 END) as theft_count,
        SUM(CASE WHEN i.incident_type = 'Break-In' THEN 1 ELSE 0 END) as breakin_count,
        SUM(CASE WHEN i.incident_type = 'Vandalism' THEN 1 ELSE 0 END) as vandalism_count,
        AVG(CAST(id.property_value AS FLOAT)) as avg_property_loss,
        COUNT(DISTINCT z.zone) as zones_affected,
 'Early Revitalization' as period
    FROM Incidents i
    JOIN Incident_Details id ON i.incident_id = id.incident_id
    JOIN Locations l ON i.location_id = l.location_id
    JOIN Zones z ON l.zone_id = z.zone_id
    WHERE i.incident_date BETWEEN '2025-09-01' AND '2025-12-01' -- First 3 months of revitalization
      AND l.zip_code IN ('84101', '84102')
),
business_activity AS (
  -- Track business openings as indicator of revitalization
    SELECT 
        CAST(bo.opening_date AS DATE) as activity_date,
        COUNT(DISTINCT bo.business_id) as new_businesses,
        COUNT(DISTINCT CASE WHEN bo.closing_date IS NOT NULL THEN bo.business_id END) as closed_businesses
    FROM Business_Operations bo
    WHERE bo.opening_date >= '2025-09-01'
    GROUP BY CAST(bo.opening_date AS DATE)
),
foot_traffic_analysis AS (
    -- Track foot traffic as indicator of economic activity
    SELECT 
        CAST(ft.date AS DATE) as activity_date,
        AVG(ft.pedestrian_count) as avg_foot_traffic,
        MAX(ft.pedestrian_count) as peak_foot_traffic,
        COUNT(DISTINCT ft.location_id) as active_locations
    FROM Foot_Traffic ft
    WHERE ft.date >= '2025-09-01'
      AND ft.location_id IN (SELECT location_id FROM Locations WHERE zip_code IN ('84101', '84102'))
    GROUP BY CAST(ft.date AS DATE)
),
staffing_levels AS (
    -- Track police presence during revitalization
    SELECT 
  CAST(ps.staff_date AS DATE) as activity_date,
        COUNT(DISTINCT ps.officer_id) as officers_on_duty,
        AVG(ps.reported_patrols) as avg_patrol_frequency,
        'Staffing' as metric_type
    FROM Police_Staffing ps
    WHERE ps.staff_date >= '2025-09-01'
  GROUP BY CAST(ps.staff_date AS DATE)
),
correlation_analysis AS (
    -- Correlate revitalization (foot traffic, new businesses) with crime
    SELECT 
        ba.activity_date,
        ba.new_businesses,
  fta.avg_foot_traffic,
        sl.officers_on_duty,
        COUNT(i.incident_id) as daily_incidents,
        CASE
     WHEN fta.avg_foot_traffic > 1500 AND COUNT(i.incident_id) < 1 THEN 'Activity High, Crime Low'
            WHEN fta.avg_foot_traffic > 1500 AND COUNT(i.incident_id) >= 2 THEN 'Activity High, Crime Also High'
          WHEN fta.avg_foot_traffic <= 1500 AND COUNT(i.incident_id) < 1 THEN 'Activity Low, Crime Low'
            WHEN fta.avg_foot_traffic <= 1500 AND COUNT(i.incident_id) >= 2 THEN 'Activity Low, Crime High'
            ELSE 'Unknown Pattern'
        END as activity_crime_relationship,
     CASE
   WHEN sl.officers_on_duty >= 10 AND COUNT(i.incident_id) < 1 THEN 'Well-Staffed, Low Crime'
            WHEN sl.officers_on_duty >= 10 AND COUNT(i.incident_id) >= 2 THEN 'Well-Staffed, High Crime'
          WHEN sl.officers_on_duty < 10 AND COUNT(i.incident_id) < 1 THEN 'Under-Staffed, Low Crime'
 WHEN sl.officers_on_duty < 10 AND COUNT(i.incident_id) >= 2 THEN 'Under-Staffed, High Crime'
         ELSE 'Staffing Unknown'
        END as staffing_crime_relationship
    FROM business_activity ba
    LEFT JOIN foot_traffic_analysis fta ON ba.activity_date = fta.activity_date
    LEFT JOIN staffing_levels sl ON ba.activity_date = sl.activity_date
    LEFT JOIN Incidents i ON CAST(i.incident_date AS DATE) = ba.activity_date
      AND i.location_id IN (SELECT location_id FROM Locations WHERE zip_code IN ('84101', '84102'))
    GROUP BY ba.activity_date, ba.new_businesses, fta.avg_foot_traffic, sl.officers_on_duty
)
SELECT 
    'Pre vs Early Revitalization' as comparison_type,
    pr.incident_count as pre_incidents,
    er.incident_count as early_incidents,
    ROUND((CAST(er.incident_count AS FLOAT) / CAST(pr.incident_count AS FLOAT) - 1) * 100, 1) as pct_change,
    pr.theft_count as pre_thefts,
    er.theft_count as early_thefts,
    pr.breakin_count as pre_breakins,
    er.breakin_count as early_breakins,
    ROUND(er.avg_property_loss, 2) as avg_loss_early,
    CASE
    WHEN er.incident_count > pr.incident_count * 1.1 THEN 'CONCERN: Crimes increased significantly'
  WHEN er.incident_count < pr.incident_count * 0.9 THEN 'POSITIVE: Crimes decreased'
     ELSE 'NEUTRAL: Crimes remained stable'
    END as initial_assessment
FROM pre_revitalization pr
CROSS JOIN early_revitalization er
```

**Investigation Flow:**

**Phase 1: Baseline Comparison**
- Question 1: "How much crime before revitalization?"
  → Find: Average 2.3 incidents/day (pre-period, June-Sept)
- Question 2: "How much crime after revitalization started?"
  → Find: Average 2.8 incidents/day (early revitalization, Sept-Dec)
- Question 3: "Is that an increase?"
  → Find: Yes, +21.7% more incidents
- But wait... Question 4: "What else changed?"

**Phase 2: Confounding Variables**

- Question 5: "Did foot traffic increase?"
  → Find: Yes, from avg 900 pedestrians/day to 1600 pedestrians/day
- Question 6: "Did police staffing change?"
  → Find: YES! Police actually REDUCED staffing from 12 officers/day to 9 officers/day during same period
- Question 7: "Did new businesses open?"
  → Find: 22 new businesses in first 3 months of revitalization
- Question 8: "Did business closures happen?"
  → Find: Minimal closures; net positive growth

**Phase 3: Correlation Analysis**

Now the big question: What's causing the crime increase?

**Theory A: "Revitalization Causes Crime"**
- Evidence: Crime up 21.7%
- But: Confounded by police reduction
- Counter-evidence: Crime went up WHILE foot traffic also went up (more eyes, should mean less crime if policed)

**Theory B: "Police Reduction Causes Crime"**
- Evidence: Officers dropped from 12 to 9 (-25%)
- Timeline: Crime increased same period
- Data point: All increase occurred during lowest-staffing evening/weekend hours
- Support: In high-traffic periods with adequate staffing, crime stayed lower

**Theory C: "Transition Period"**
- Evidence: Growing pains during business transition
- Possibly: New businesses target for break-ins (less secure systems)
- Temporary: Will stabilize as businesses establish security protocols
- Data: Type of crime shifted (more break-ins, fewer thefts)

**Theory D: "Population Influx"**
- Evidence: Foot traffic up 78%
- Statistics: Larger population = more crime (mathematical reality)
- Question: Is crime rate (per 1,000 people) actually different?
- Calculation: Crime rate DECREASED when adjusted for population

**Phase 4: The Ambiguity**

Multiple valid interpretations emerge:

**Interpretation #1: "Revitalization Is Working (With Caveats)"**
- Crime count up, BUT crime rate down (adjusted for more foot traffic)
- Staffing reduction was mistake, not revitalization fault
- New businesses still securing their operations
- Recommendation: Continue revitalization, restore police staffing, monitor break-in types

**Interpretation #2: "Revitalization Is Creating Problems"**
- Absolute crime up, period ending, don't justify with statistics
- More people means more crime exposure for residents
- Broken windows theory: developing area attracts more criminals
- Recommendation: Slow revitalization until policing adequate

**Interpretation #3: "It's the Police Staffing"**
- Data clearly shows: Crime increased when staffing decreased
- The 21.7% increase correlates with 25% staffing cut
- Revitalization just revealed that staffing was already insufficient
- Recommendation: Increase police, keep revitalization on track

**Interpretation #4: "It's a Transition Effect"**
- New businesses = new targets not yet hardened
- Peak period to establish baseline security practices
- 3 months is too short to evaluate long-term impact
- Recommendation: Continue and monitor for 6 more months

**Phase 5: Competing Valid Conclusions**

As the Director of Police Operations / Downtown Manager, you must present options:

**Option 1: Halt Revitalization**
- Rationale: Crime increase is concerning
- Cost: Negative (lose momentum, community trust)
- Risk: Blame revitalization when real issue was staffing

**Option 2: Continue Revitalization + Restore Staffing**
- Rationale: Staffing was real problem, not revitalization
- Cost: +$200K/year for 3 additional officers
- Benefit: Address root cause, allow revitalization to succeed
- Risk: If this doesn't work, wasted resources

**Option 3: Selective Revitalization Pause**
- Rationale: Slow down business growth until police catch up
- Cost: $50K (delay costs)
- Benefit: Gives police time to deploy resources  
- Risk: Economic momentum lost

**Option 4: Targeted Crime Prevention**
- Rationale: Address break-ins specifically (they increased 45%)
- Actions: Mandatory security audits for new businesses, business-neighborhood watch
- Cost: $75K (security consulting program)
- Benefit: Prevent further increase without stopping growth
- Risk: Depends on business cooperation

**Your Executive Report Must Address:**

1. **What the data shows clearly:**
   - Absolute crime count increased 21.7%
   - Foot traffic increased 78%
   - Police staffing decreased 25%
   - Staffing reduction occurred during period of crime increase
   - Crime rate (per 1,000 pedestrians) actually decreased

2. **What's ambiguous:**
   - Whether revitalization inherently creates crime
   - Whether crime increase is permanent or temporary
   - Whether 3 months is enough data (statistical significance)
   - What would happen with original staffing levels during revitalization

3. **What we don't know:**
   - Long-term impact (need 12+ months data)
   - What crime would look like with adequate staffing AND revitalization
   - Whether new businesses will establish security (reducing vulnerability)
   - Community perception vs. statistical reality

4. **Your recommendation with professional caveats:**
   - "Data suggests [Option X] based on..."
   - "However, [confounding variable] complicates interpretation..."
   - "To increase confidence, we should monitor..."
   - "Alternative explanations include..."
 - "The data does NOT prove [common assumption]..."

**Learning Outcome:**
- Executive-level policy analysis with real ambiguity
- Separating correlation from causation
- Identifying confounding variables
- Statistical thinking (absolute vs. rate)
- Understanding that "more of X" isn't always bad
- Communicating uncertainty to decision-makers
- Professional responsibility when data is ambiguous
- Real-world complexity of urban planning decisions
- Critical thinking about what data actually shows vs. what people assume

**Difficulty:** ⭐⭐⭐⭐⭐ (60-90 minutes)
- Genuinely ambiguous (legitimate competing interpretations)
- Multiple valid analytical approaches
- Requires sophisticated statistical thinking
- Executive-level communication
- Real-world professional practice
- Ethical considerations (don't overstate certainty)

---

## 🎯 DESIGN PRINCIPLES APPLIED

### For Computer Science Students at Small Downtown SLC University

**Relevance:**
- Downtown SLC context (real location they experience)
- Urban crime patterns (different from suburban campus)
- Business/economic context (not student-specific incidents)
- Data-driven decision making (systems thinking they understand)

**Engagement:**
- Detective work (uncover patterns)
- Conspiracy/organized crime (mystery elements)
- Real downtown location (local relevance)
- Professional skills (what they'll use in careers)

**Learning Progression:**
- Tier 1: Verify specific data points (badge access, logs)
- Tier 2: Find relationships across data sources
- Tier 3: Verify data quality and consistency
- Tier 4: Complex pattern synthesis and investigation
- Tier 5: Executive-level ambiguity and decision-making

### Database Realism

**Tables Reflect Real Systems:**
- Badge access, parking logs (physical security)
- Police reports, incident data (law enforcement)
- Business operations, foot traffic (economic activity)
- Geographic data (downtown SLC context)

**Data Quality Issues (Like Real Systems):**
- Time entry errors (3 AM thefts during closed hours)
- Incomplete reports (new officer training)
- Location inconsistencies
- Misidentified suspects (photo, similar names)
- Staffing allocation issues

### Investigation Methodology

**Focus on JOIN Mastery, Not Advanced SQL:**
- Tier 1-3: Straightforward JOIN patterns
- Tier 4: Complex 5-6 table orchestration
- Tier 5: 8+ table analysis with CTEs
- NO subqueries (except in CTEs for Tier 5)

---

**Case Design Complete (Revised):** December 4, 2025  
**Status:** Ready for implementation  
**Audience:** CS Students at Downtown SLC University  
**Theme:** Downtown crime investigation  
**Engagement:** High (local context, realistic crime, investigation mystery)
**Appropriateness:** Traditional crimes, professional context, no student-targeting

