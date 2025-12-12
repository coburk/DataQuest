# 🔍 DataQuest Case Design Examples - Crime Database Theme

**Date:** December 4, 2025  
**Status:** CREATIVE CASE DESIGNS FOR ALL TIERS  
**Audience:** College Students  
**Dataset:** Crime Database (Realistic, Engaging, Educational)

---

## 📋 TIER SYSTEM CASES - COMPLETE EXAMPLES

### TIER 1: Junior Data Analyst - "Campus Safety 101"

#### Case 1.1: "Missing Report"

**Scenario:**
You're a new analyst at the University Police Department. A report is missing from the incident log, and your boss asks you to find it. The database shows 45 incidents were reported yesterday, but you can only see 44 in the system.

**Story:**
```
Incident Date: November 15, 2025 (Yesterday)
Reports Expected: 45 (per officer count)
Reports Visible: 44
Missing: 1 report (either lost or never entered)

Your Task: Find the missing incident report from yesterday
```

**SQL Skills Required:**
- Simple SELECT query
- WHERE clause with date filter
- COUNT aggregation

**Canonical Query:**
```sql
SELECT COUNT(*) as incident_count
FROM Incidents
WHERE CAST(IncidentDate AS DATE) = '2025-11-15'
```

**Investigation:**
- Question 1: "How many incidents were reported yesterday?"
  → Find: 44 incidents
- Question 2: "But the shift log says 45 reports. What's missing?"
  → Find: One incident_id missing in sequence
- Question 3: "What details do we have about that incident?"
  → Find: Partially logged in dispatch_calls table

**Learning Outcome:**
- Basic SELECT queries work
- Data verification is important
- Simple WHERE filters
- Counting and verifying data

**Difficulty:** ⭐ (5-7 minutes)

---

#### Case 1.2: "Late Night Activity Pattern"

**Scenario:**
Campus safety is concerned about crime patterns. You're asked to identify what types of incidents happen late at night (after 10 PM) so they can plan late-night patrols.

**Story:**
```
Question: What types of crimes happen after 10 PM on campus?
Reason: Planning targeted late-night patrol strategy
Data Available: Incident types, times, locations
```

**SQL Skills Required:**
- SELECT specific columns
- WHERE with time filtering
- Simple ORDER BY

**Canonical Query:**
```sql
SELECT IncidentType, IncidentTime, Location
FROM Incidents
WHERE HOUR(IncidentTime) >= 22
ORDER BY IncidentTime DESC
```

**Investigation:**
- Question 1: "What time range should we look at?"
  → Find: After 10 PM = hour >= 22
- Question 2: "What types of incidents happen then?"
  → Find: Theft, Vandalism, Noise Complaints
- Question 3: "Which locations are most affected?"
  → Find: Parking lots and residential areas

**Learning Outcome:**
- Filter data by conditions
- Sort results meaningfully
- Identify patterns in simple data

**Difficulty:** ⭐ (3-7 minutes)

---

### TIER 2: Senior Data Analyst - "Who's Reporting Crimes?"

#### Case 2.1: "Witness Investigation"

**Scenario:**
A series of thefts has been reported by various people. You need to determine if there's a pattern in who reports crimes. Are certain individuals reporting multiple incidents? Could there be false reports?

**Story:**
```
Incidents: 12 thefts in past 2 weeks
Reporters: Mix of students, staff, security
Question: Is there one person reporting many incidents?
Concern: Possible pattern (helpful witness vs. false reports)
```

**Data Tables Involved:**
- Incidents (incident_id, description, reporter_id, date)
- Reporters (reporter_id, name, affiliation, phone)
- ReporterHistory (reporter_id, total_reports, reliability_score)

**SQL Skills Required:**
- JOIN two tables
- GROUP BY and COUNT
- HAVING clause for filtering groups
- ORDER BY aggregated results

**Canonical Query:**
```sql
SELECT r.name, r.affiliation, COUNT(i.incident_id) as report_count
FROM Reporters r
JOIN Incidents i ON r.reporter_id = i.reporter_id
WHERE i.IncidentDate >= DATEADD(DAY, -14, GETDATE())
  AND i.IncidentType = 'Theft'
GROUP BY r.reporter_id, r.name, r.affiliation
HAVING COUNT(i.incident_id) > 2
ORDER BY report_count DESC
```

**Investigation:**
- Question 1: "How many different reporters are there?"
  → Count distinct reporters
- Question 2: "Who reported the most thefts?"
  → Join and group by reporter
- Question 3: "Is one person reporting most of them?"
  → Find: One witness reported 5 out of 12
- Question 4: "Is this person reliable?"
  → Check: 98% of their reports verified

**Red Herring:** 
One reporter (Tom, campus security) reported 5 incidents. Seems suspicious until you realize he's the night shift guard—of course he reports more incidents!

**Learning Outcome:**
- Joining multiple data sources
- Aggregating with GROUP BY
- Filtering groups with HAVING
- Understanding context in data

**Difficulty:** ⭐⭐ (10-15 minutes)

---

#### Case 2.2: "Crime Hotspots"

**Scenario:**
Your university is creating a safety map to show students which areas have the most crime. You need to identify the top locations where incidents occur so they can install additional lighting or increase patrols.

**Story:**
```
Goal: Identify crime hotspots on campus
Action: Light installation budget available for 5 locations
Data: All incidents in the past semester
Task: Rank locations by incident frequency
```

**SQL Skills Required:**
- GROUP BY location
- COUNT incidents
- JOIN with location details
- ORDER BY count descending

**Canonical Query:**
```sql
SELECT TOP 5 
    l.LocationName, l.BuildingType, COUNT(i.incident_id) as incident_count
FROM Locations l
JOIN Incidents i ON l.location_id = i.location_id
WHERE i.IncidentDate >= DATEADD(MONTH, -4, GETDATE())
GROUP BY l.location_id, l.LocationName, l.BuildingType
ORDER BY incident_count DESC
```

**Investigation:**
- Question 1: "What's the total incident count by location?"
  → Find: Library has 18, Science Building 14, Dorm Complex 12
- Question 2: "Are parking lots more dangerous than buildings?"
  → Find: Parking Lot A has 22 incidents (highest)
- Question 3: "What types of crimes happen in each location?"
  → Find: Parking = Theft/Vandalism, Library = Noise/Alcohol
- Question 4: "Should we light them equally?"
  → Analyze: Yes, but different security measures needed

**Learning Outcome:**
- Aggregating large datasets
- Practical application (safety decisions)
- Understanding location-crime relationships
- Data informing real policy

**Difficulty:** ⭐⭐ (10-15 minutes)

---

### TIER 3: Data Inspector - "The Suspicious Pattern"

#### Case 3.1: "Incident Inconsistencies"

**Scenario:**
A new dispatcher just started and their incident reports look odd. Some reports have missing information, inconsistent classifications, or data quality issues. Your job: identify ALL the quality problems with this dispatcher's work.

**Story:**
```
New Dispatcher: Marcus Chen (started 3 weeks ago)
Quality Concern: His reports seem incomplete
Manager: "Check all his reports for any issues"
Task: Identify data quality problems
```

**Data Tables:**
- Incidents (incident_id, dispatcher_id, report_date, incident_type, location_id, severity)
- IncidentDetails (incident_id, description, witness_count, evidence_count)
- Locations (location_id, location_name, building_id)

**SQL Skills Required:**
- Multiple JOINs (3-4 tables)
- Multiple WHERE conditions with AND/OR
- NULL handling with IS NULL
- GROUP BY with multiple columns
- HAVING with complex conditions

**Canonical Query:**
```sql
SELECT 
    i.incident_id,
    d.dispatcher_name,
    i.incident_type,
    i.severity,
    CASE 
        WHEN i.location_id IS NULL THEN 'Missing Location'
        WHEN id.description IS NULL THEN 'Missing Description'
 WHEN id.witness_count = 0 THEN 'No Witnesses Recorded'
        WHEN i.severity = 'Unknown' THEN 'Unknown Severity'
     WHEN LEN(id.description) < 10 THEN 'Description Too Short'
        ELSE 'OK'
    END as quality_issue
FROM Incidents i
JOIN Dispatchers d ON i.dispatcher_id = d.dispatcher_id
LEFT JOIN IncidentDetails id ON i.incident_id = id.incident_id
LEFT JOIN Locations l ON i.location_id = l.location_id
WHERE d.dispatcher_name = 'Marcus Chen'
    AND (i.location_id IS NULL 
        OR id.description IS NULL 
        OR id.witness_count = 0
        OR i.severity = 'Unknown'
        OR LEN(id.description) < 10)
ORDER BY i.report_date DESC
```

**Investigation:**
- Question 1: "How many reports did Marcus file?"
  → Find: 47 in 3 weeks (about 15/week - reasonable)
- Question 2: "Do any reports have missing data?"
  → Find: 8 reports missing location_id, 3 with no description
- Question 3: "Are his reports less detailed than other dispatchers?"
  → Compare: Avg description length Marcus=35 chars, Others=87 chars
- Question 4: "What pattern emerges?"
  → Find: All quality issues are on late-night shifts (10 PM - 6 AM)
- Question 5: "Why late-night specifically?"
  → Discover: Marcus works night shift; might need training on proper procedures

**Contradictions:**
- Seems like Marcus is doing poor work, but actually he's under-trained on night procedures
- His supervisor (Jane) only works days and hasn't noticed his night shift struggles
- Resolution: Additional training for Marcus on night shift protocols

**Learning Outcome:**
- Complex data quality verification
- Multiple JOIN patterns
- NULL handling and edge cases
- Using CASE for conditional analysis
- Finding root causes, not just symptoms

**Difficulty:** ⭐⭐⭐ (20-30 minutes)

---

#### Case 3.2: "Victim Investigation Chain"

**Scenario:**
The campus has had several incidents where the same person was reported as a victim multiple times. Is this person targeted? Is data entry making mistakes? Or is something else happening?

**Story:**
```
Observation: Jennifer Park appears as victim in 4 incidents
Question: Is she being targeted? Or is this data error?
Context: She's an RA (Resident Assistant)
Task: Investigate all her incidents for patterns
```

**Data Tables:**
- Incidents (incident_id, victim_id, incident_type, date, location)
- Victims (victim_id, name, affiliation, dorm_assigned)
- IncidentDetails (incident_id, description, property_value, status)

**SQL Skills Required:**
- Multiple JOINs with same table (victim appears multiple times)
- GROUP BY with temporal analysis
- WHERE with multiple conditions
- NULL handling
- Pattern recognition across dates

**Canonical Query:**
```sql
SELECT 
    i.incident_id,
    v.name,
    v.affiliation,
    i.incident_type,
    i.IncidentDate,
i.location_id,
    id.description,
    id.status
FROM Incidents i
JOIN Victims v ON i.victim_id = v.victim_id
LEFT JOIN IncidentDetails id ON i.incident_id = id.incident_id
WHERE v.name = 'Jennifer Park'
ORDER BY i.IncidentDate ASC
```

**Investigation:**
- Question 1: "How many incidents involves Jennifer Park?"
  → Find: 4 incidents as victim
- Question 2: "What types of incidents?"
  → Find: 2 Noise Complaints, 1 Package Theft, 1 Door Damage
- Question 3: "Are they all in same location?"
  → Find: All 4 in her dorm room (Residence Hall C, Room 412)
- Question 4: "Are they clustered in time?"
  → Find: Oct 12, Oct 15, Oct 18, Oct 22 (every 3-4 days)
- Question 5: "What's her affiliation?"
  → Find: She's an RA (Resident Assistant)
- Question 6: "Pattern explanation?"
  → Find: Roommate issues (filing complaints about each other)

**Contradictions:**
- Looks like Jennifer is being targeted (4 incidents)
- But she's also listed as REPORTER on 3 of the 4 incidents
- Reveals: Roommate conflict situation, not targeting

**Red Herring:**
One incident (Oct 15) makes it look worse—but that's when campus was having events. Not specific to Jennifer.

**Learning Outcome:**
- Temporal pattern analysis
- Understanding context (RA role)
- Distinguishing correlation from causation
- Data verification and triangulation

**Difficulty:** ⭐⭐⭐ (20-30 minutes)

---

### TIER 4: Data Detective - "The Campus Crime Conspiracy"

#### Case 4.1: "Coordinated Theft Ring?"

**Scenario:**
Multiple high-value items have been stolen from different locations and dorms. Police suspect an organized theft ring. Your job: analyze all the theft incidents to determine if there's evidence of coordination (same people, similar M.O., sequential timing).

**Story:**
```
Crime Pattern: 8 thefts in 2 weeks (unusually high)
Locations: 5 different dorms + Bookstore + Library
Stolen: High-value electronics and jewelry
Suspicion: Could this be organized? 

Detective's Question:
"If this is organized, we'd expect:
- Similar method of operation
- Targeting high-value items only
- Maybe same timeframe
- Possibly overlapping suspects"
```

**Data Tables:**
- Incidents (incident_id, incident_type, date, time, location_id, status)
- IncidentDetails (incident_id, description, property_value, stolen_items)
- Suspects (suspect_id, name, known_associates)
- SuspectInvolvement (incident_id, suspect_id, involvement_type)
- Witnesses (witness_id, incident_id, description_of_suspect)
- ReporterDetails (reporter_id, role, reliability)

**SQL Skills Required:**
- Multiple complex JOINs (5-6 tables)
- CASE statements for conditional logic
- GROUP BY with multiple columns
- Pattern matching with WHERE conditions
- Temporal analysis (date/time ranges)
- String matching for pattern analysis

**Canonical Query:**
```sql
SELECT 
    i.incident_id,
    i.IncidentDate,
    i.IncidentTime,
    l.LocationName,
  id.stolen_items,
    id.property_value,
    COUNT(DISTINCT si.suspect_id) as suspect_count,
    STRING_AGG(s.name, ', ') as suspect_names,
    CASE 
    WHEN id.property_value > 500 AND 
  DATEDIFF(DAY, i.IncidentDate, LAG(i.IncidentDate) OVER (ORDER BY i.IncidentDate)) BETWEEN 1 AND 3
        THEN 'Possible Coordinated'
        ELSE 'Isolated Incident'
    END as pattern_assessment
FROM Incidents i
JOIN Locations l ON i.location_id = l.location_id
JOIN IncidentDetails id ON i.incident_id = id.incident_id
LEFT JOIN SuspectInvolvement si ON i.incident_id = si.incident_id
LEFT JOIN Suspects s ON si.suspect_id = s.suspect_id
WHERE i.incident_type = 'Theft'
    AND i.IncidentDate >= DATEADD(DAY, -14, GETDATE())
 AND id.property_value > 200
GROUP BY i.incident_id, i.IncidentDate, i.IncidentTime, l.LocationName, id.stolen_items, id.property_value
ORDER BY i.IncidentDate DESC
```

**Investigation Flow:**

**Phase 1: Establish Pattern**
- Question 1: "How many thefts in past 2 weeks?"
  → Find: 8 thefts (normal is 1-2/week)
- Question 2: "What's being stolen?"
  → Find: Laptops (5), Jewelry (2), Headphones (1) - high value items
- Question 3: "From where?"
  → Find: Mix of dorms, bookstore, library (coordinated locations)

**Phase 2: Temporal Analysis**
- Question 4: "When are these happening?"
  → Find: 
    - 3 incidents at night (10 PM - 2 AM)
    - 5 incidents in afternoon (1 PM - 4 PM)
  - Pattern: Targeting when buildings are crowded
- Question 5: "Any timing pattern?"
  → Find: 7 of 8 thefts on weekends (Fri-Sat)
  → Indicator: Planned activity, not opportunistic

**Phase 3: Suspect Analysis**
- Question 6: "Any common suspects?"
  → Find: 
    - Alex Martinez appears in 3 incidents
    - Tyler Johnson appears in 2 incidents
    - Different suspects for other incidents
  → Pattern: Might not be single ring, OR different roles
- Question 7: "Are Alex and Tyler known associates?"
  → Check: SuspectInvolvement shows Alex = "Primary Suspect", Tyler = "Witness" but actually he was arrested for separate incident
  → Contradiction: Tyler can't be involved in 2 thefts because he was in custody for one!

**Phase 4: Method Analysis**
- Question 8: "Similar method of operation?"
  → Find: 
- All target electronics/valuables
  - 6 of 8 involved forced entry to lockers/rooms
    - 2 involved careless security (unlocked door)
  → Pattern: Professional operation, not random theft

**Phase 5: The Twist**
- Question 9: "Who reported these incidents?"
  → Find: Most reported by RAs (student staff), not victims themselves
  → Discovery: RAs discovered items missing during room checks
- Question 10: "Any timing pattern with RA schedules?"
  → Find: All discovered by the Monday morning RA checks
  → Revelation: Thefts probably occurred Friday-Saturday night
  → Pattern: Thieves know RA schedule - possible inside knowledge?

**Contradictions & Red Herrings:**

**Red Herring 1: "Alex Martinez is the ringleader"**
- He appears in 3 incidents as primary suspect
- BUT: One of those incidents he was studying in library during the theft
- Mistaken identity? Similar name? Or false report?
- Resolution: Police need to re-interview witnesses

**Red Herring 2: "Tyler Johnson is involved"**
- Appears in 2 incidents
- BUT: During one incident, he was in police custody for unrelated matter
- Strong alibi proves he's not involved in that one
- Resolution: Re-examine how he was linked to incidents

**Contradiction: "RAs discovered all thefts"**
- Seems like RAs are very alert and security-conscious
- But: RAs only discovered missing items DAYS later
- Implication: Victims never noticed items were missing until RA checks
- Question: Are students not checking their valuables?

**True Pattern Emerges:**
After careful analysis, you discover:
- Thefts ARE coordinated (8 in 2 weeks, vs. 1-2 normal)
- BUT suspect list doesn't match (multiple false leads)
- REAL issue: Security vulnerability in dorm locking system
- One lock manufacturer's model is easily bypassed
- All affected rooms use that lock model

**Final Query (The Real Answer):**
```sql
SELECT DISTINCT l.LocationName, l.DormName, r.RoomNumber, r.LockModel
FROM Incidents i
JOIN Locations l ON i.location_id = l.location_id
JOIN Rooms r ON l.room_id = r.room_id
WHERE i.incident_type = 'Theft'
    AND i.IncidentDate >= DATEADD(DAY, -14, GETDATE())
    AND r.LockModel = 'SmartLock-3000' -- Security flaw identified
```

**Learning Outcome:**
- Complex multi-table JOIN patterns
- Temporal analysis and pattern recognition
- Distinguishing causation from correlation
- Following data to surprising conclusions
- Understanding context and constraints (alibis)
- Critical thinking about data quality
- Real-world complexity of investigations

**Difficulty:** ⭐⭐⭐⭐ (35-50 minutes)

---

### TIER 5: Director of Data Integrity - "The Campus Crime Ecosystem"

#### Case 5.1: "Crime Pattern Hypothesis: Spring Party Season"

**Scenario:**
Spring Break is approaching, and campus will see influx of visitors. Historical data suggests crime increases during party season. You need to create an executive-level analysis: What will likely happen? What should administration prepare for?

**Story:**
```
Time: Early March, Spring Break begins in 3 weeks
Issue: Last year, crime increased 35% during party season
Question: Can we predict this year's pattern?
Complexity: Multiple factors interact (weather, events, staffing)

Executive Task:
"Give me a forecast model showing:
1. Expected incident types and frequencies
2. Likely hotspot locations
3. Timing patterns to staff for
4. Confidence in predictions
5. What unknowns could change this"
```

**Data Tables:**
- Incidents (incident_id, type, date, time, location_id, severity, status)
- IncidentDetails (incident_id, description, property_value, victim_count, weapons)
- Locations (location_id, name, building_type, capacity, accessibility)
- EventCalendar (event_id, event_name, date, expected_attendance, event_type)
- Weather (weather_id, date, temperature, precipitation, conditions)
- Staffing (staff_id, role, shift_date, shift_time, location_assignment)
- SeasonalPatterns (pattern_id, season, incident_type, avg_frequency, std_dev)
- ExternalFactors (factor_id, date, factor_type, impact_level) -- COVID, etc.

**SQL Skills Required:**
- 8+ table JOINs with complex relationships
- Multiple aggregation strategies
- Window functions for temporal analysis (LAG, LEAD, ROW_NUMBER)
- CASE statements with business logic
- Subqueries for comparative analysis
- String pattern matching
- Date arithmetic and forecasting logic
- Statistical thinking (averages, deviations, confidence intervals)

**Complex Analytical Query (Executive Forecast):**
```sql
WITH historical_spring AS (
    -- Get spring break incident patterns from previous years
    SELECT 
        i.incident_type,
   COUNT(i.incident_id) as incident_count,
        AVG(CAST(id.property_value AS FLOAT)) as avg_property_loss,
      AVG(CAST(id.victim_count AS FLOAT)) as avg_victims,
        l.LocationName,
        DATEPART(HOUR, i.IncidentTime) as incident_hour,
        ROW_NUMBER() OVER (PARTITION BY i.incident_type ORDER BY COUNT(i.incident_id) DESC) as frequency_rank
    FROM Incidents i
    JOIN IncidentDetails id ON i.incident_id = id.incident_id
    JOIN Locations l ON i.location_id = l.location_id
    JOIN EventCalendar ec ON CAST(i.IncidentDate AS DATE) BETWEEN DATEADD(DAY, -3, ec.event_date) AND DATEADD(DAY, 3, ec.event_date)
  WHERE MONTH(i.IncidentDate) = 3 -- March only
        AND YEAR(i.IncidentDate) IN (2023, 2024) -- Previous spring breaks
        AND ec.event_type = 'Spring Break'
    GROUP BY i.incident_type, l.LocationName, DATEPART(HOUR, i.IncidentTime)
),
staffing_assessment AS (
    -- Analyze staffing levels during spring break
    SELECT 
        s.shift_date,
        COUNT(DISTINCT s.staff_id) as officers_on_duty,
   COUNT(DISTINCT s.location_assignment) as locations_covered,
        CASE 
  WHEN COUNT(DISTINCT s.staff_id) < 4 THEN 'Understaffed'
            WHEN COUNT(DISTINCT s.staff_id) = 4 THEN 'Adequate'
            ELSE 'Well-Staffed'
        END as staffing_level
    FROM Staffing s
    WHERE MONTH(s.shift_date) = 3
    GROUP BY s.shift_date
),
risk_assessment AS (
    -- Combine to create risk forecast
    SELECT 
   hs.incident_type,
        hs.LocationName,
        hs.incident_hour,
    hs.incident_count as last_year_frequency,
        hs.avg_property_loss,
 hs.avg_victims,
        sa.staffing_level,
        CASE 
  WHEN hs.incident_count > 3 AND sa.staffing_level = 'Understaffed' THEN 'HIGH RISK'
            WHEN hs.incident_count > 3 THEN 'MEDIUM RISK'
            WHEN hs.incident_count > 1 AND sa.staffing_level = 'Understaffed' THEN 'MEDIUM RISK'
            ELSE 'LOW RISK'
        END as forecast_risk_level,
        ROUND((hs.incident_count * 1.35), 1) as predicted_count_with_growth,
ROUND((hs.incident_count * 1.35 * CAST(hs.avg_property_loss AS FLOAT)), 2) as predicted_property_loss
    FROM historical_spring hs
    CROSS JOIN staffing_assessment sa
    WHERE hs.frequency_rank = 1 -- Only top incident type per location
)
SELECT 
    incident_type,
LocationName,
    incident_hour,
    forecast_risk_level,
    last_year_frequency as 'Expected_Incidents_Last_Year',
    predicted_count_with_growth as 'Predicted_Incidents_This_Year',
    predicted_property_loss as 'Est_Property_Loss_Value',
 staffing_level as 'Current_Staffing',
    CASE 
        WHEN forecast_risk_level = 'HIGH RISK' THEN 'URGENT: Increase patrols, notify victim advocacy'
        WHEN forecast_risk_level = 'MEDIUM RISK' THEN 'Recommended: Monitor closely, consider additional staff'
        ELSE 'Standard monitoring adequate'
    END as recommended_action
FROM risk_assessment
ORDER BY forecast_risk_level DESC, predicted_property_loss DESC
```

**Investigation Flow:**

**Phase 1: Historical Pattern Analysis**
- Question 1: "What happened last spring break?"
  → Find: 
    - Thefts increased 40% vs. normal weeks
 - Alcohol violations increased 60%
  - Vandalism increased 25%
    - Violence-related incidents increased 15%
    - "Noise complaints" nearly doubled
- Question 2: "When specifically did incidents spike?"
  → Find: Thursday through Sunday nights (10 PM - 4 AM)
  → Pattern: Aligns with party times

**Phase 2: Location Analysis**
- Question 3: "Which areas were affected most?"
  → Find:
    - Residence halls: 35 incidents
    - Library parking: 12 incidents
    - Student center: 8 incidents
    - Off-campus near campus: 6 incidents
  → Pattern: Social spaces and dorms
- Question 4: "Why those specific locations?"
→ Discover:
    - High concentration of students
    - Natural gathering points
 - Visitor parking areas
    - Less supervision (especially parking)

**Phase 3: Staffing & Resource Analysis**
- Question 5: "How were police staffed during spring break?"
  → Find: Same staffing as normal weeks (PROBLEM!)
  → Discovery: Police didn't increase staffing despite 35% crime increase
- Question 6: "What did supervisors say about coverage?"
  → Find: No incidents during hours when police were present
  → Implication: More visible police = fewer crimes

**Phase 4: The Ambiguity**

**Interpretation A: "Causation"**
- "More visitors and parties CAUSE more crime"
- Evidence: Crime increases during spring break
- Action: Prevent spring break or parties
- Problem: Unfeasible and unpopular

**Interpretation B: "Correlation with Third Factor"**
- "More visitors are present, AND police don't increase staffing"
- Evidence: Crime increases; staffing stays same
- Action: Increase police presence during events
- Problem: Expensive

**Interpretation C: "Both True"**
- "Visitors increase crime risk, BUT adequate policing prevents it"
- Evidence: Last year (understaffed) had high crime; year before (normal staffing) had less
- Action: Maintain normal staffing or increase slightly
- Complication: Budget constraints

**Interpretation D: "Something Else"**
- "Weather changes, class schedule changes, or other factor drives pattern"
- Evidence: Spring break weeks are warmer (more outdoor activity)
- Action: Could be natural seasonal pattern unrelated to visitors
- Question: How to distinguish?

**Phase 5: Competing Valid Conclusions**

As the Director, you must present options to administration:

**Option 1: Aggressive Staffing Increase**
- Increase police by 30% during spring break
- Cost: $8,000
- Expected benefit: 35% crime reduction (est. $50,000 in prevented losses)
- Risk: If pattern is natural seasonal trend (not visitor-driven), money wasted
- Student impact: More visible police (positive or negative?)

**Option 2: Targeted Intervention**
- Increase visibility at high-risk locations (parking, dorms)
- Deploy officers where data shows problems
- Cost: $3,000
- Expected benefit: 15% crime reduction
- Risk: Might miss emerging patterns
- Student impact: Targeted safety vs. fortress mentality

**Option 3: Environmental/Situational**
- Improve lighting in parking lots
- Install additional cameras
- Increase RA training
- Cost: $5,000
- Expected benefit: Unknown (no historical data)
- Rationale: Address root causes (dark, unsupervised areas)

**Option 4: Data-Driven Forecasting**
- Deploy officers predictively at peak times/locations
- Use real-time incident data to shift resources
- Cost: $2,000 (software system)
- Expected benefit: Optimized response
- Risk: Still need baseline officers

**Your Executive Report Must Address:**

1. **What the data shows clearly:**
   - Crime increases 35% during spring break
   - Specific times (Thu-Sun, 10 PM-4 AM)
   - Specific locations (residences, parking)
   - Current staffing is static

2. **What's ambiguous:**
   - Whether visitors CAUSE increased crime
   - Whether staffing level is the limiting factor
   - Whether seasonal/weather factors play a role
   - Whether situational changes (unlocked doors) contribute

3. **What we don't know:**
   - How weather affects patterns
   - Whether additional staff would prevent crimes
   - What students perceive as "safety"
   - Cost-benefit of various interventions

4. **Your recommendation with caveats:**
   - "Data suggests option X is most effective based on..."
   - "However, we should monitor Y because..."
   - "The interpretation relies on assumption Z"
   - "We should collect additional data about..."

**Learning Outcome:**
- Executive-level data analysis and decision-making
- Distinguishing data from interpretation
- Multiple valid conclusions from same data
- Communicating uncertainty and assumptions
- Professional judgment with incomplete information
- Understanding that "the data" doesn't always give clear answers
- Real-world complexity of using analytics for policy

**Difficulty:** ⭐⭐⭐⭐⭐ (60-90 minutes)
- Truly ambiguous (no single "right" answer)
- Multiple valid interpretations
- Requires sophisticated analysis
- Executive-level communication
- Real-world professional practice

---

## 🎯 DESIGN PRINCIPLES APPLIED

### For College Students (Age 18-23)

**Relevance:**
- Crime that affects them (campus theft, party noise, parking issues)
- Characters they relate to (RAs, fellow students, dispatchers)
- Real stakes (their safety, their belongings, their schedules)

**Engagement:**
- Mystery elements (who stole the laptop?)
- Conspiracy potential (coordinated theft ring)
- Investigation narrative (uncover the truth)
- Ambiguity (multiple valid conclusions)

**Learning Progression:**
- Tier 1: Simple data verification (do we have all the reports?)
- Tier 2: Relationships (who reports what? where is it happening?)
- Tier 3: Quality and patterns (data integrity, investigating inconsistencies)
- Tier 4: Complex orchestration (coordinated patterns, temporal analysis)
- Tier 5: Professional analysis (executive decisions with ambiguity)

### Database Realism

**Tables Reflect Real System:**
- Incidents, Reporters, Victims, Suspects (standard)
- IncidentDetails (properties stolen, descriptions)
- Locations (where crimes happen)
- Evidence (proof of involvement)
- Staffing (operational reality)

**Data Quality Issues (Like Real Systems):**
- Missing location data
- Incomplete descriptions
- Typing errors (witness descriptions)
- False leads
- Multiple people with similar names

### Investigation Methodology

**Each Tier Emphasizes:**
- Tier 1: Data verification basics
- Tier 2: Information correlation
- Tier 3: Quality and consistency checking
- Tier 4: Pattern recognition and synthesis
- Tier 5: Professional interpretation and decision-making

**Core Skills:**
- JOINs get more complex (2-3 → 3-4 → 5-6 → 6-8+)
- Investigation logic deepens (simple → structured → sophisticated)
- Ambiguity increases (clear answers → multiple interpretations)
- Professional judgment emphasized at higher tiers

---

**Case Design Complete:** December 4, 2025  
**Status:** Ready for implementation  
**Audience:** College students  
**Theme:** Crime database investigations  
**Engagement:** High (real scenarios, mystery elements, relevant stakes)

