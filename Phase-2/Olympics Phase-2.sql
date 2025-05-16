use Olympics;

-- Table 1: Countries
-- 1️: Select country id , name and continent
SELECT country_id, country_name, continent FROM Countries;

-- 2️: Select country name and GDP per capita using alias and function
SELECT country_name AS Name, ROUND(gdp / population, 2) AS GDP_Per_Capita
FROM Countries
WHERE continent = 'Europe';

-- 3️: Update the population of a specific country
UPDATE Countries
SET population = 84000000
WHERE country_code = 'DEU';

-- 4️: Delete a country record by name
DELETE FROM Countries
WHERE country_name = 'Germany';

-- 5️: Add a foreign key in 'athletes' table that references 'Countries', with cascade rules
ALTER TABLE athletes
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id)
REFERENCES Countries(country_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 6️: Join 'Countries' and 'Athletes' to list athletes with their country and name
SELECT a.first_name, a.last_name,c.country_name
FROM athletes a
JOIN Countries c ON a.country_id = c.country_id
WHERE c.language = 'English';

-- 7️: Subquery to find countries with above average GDP
SELECT country_name, gdp
FROM Countries
WHERE gdp > (
    SELECT AVG(gdp) FROM Countries
);

-- 8: Use IN and LIKE operators to filter countries
SELECT country_name
FROM Countries
WHERE continent IN ('Europe', 'Asia') AND capital_city LIKE '%on';

-- 9️: Add a new column 'currency' to the Countries table
ALTER TABLE Countries
ADD currency VARCHAR(50);

-- 10: Aggregate query using GROUP BY to get number of countries and total population by continent
SELECT continent, COUNT(*) AS country_count, SUM(population) AS total_population
FROM Countries
GROUP BY continent;

-- Table 2: Atheletes
-- 1. Select sports name, category and it is indoor or outdoor game
SELECT sport_name, sport_category, indoor_outdoor FROM Sports;

-- 2. List all sports with their category and whether they are team sports
SELECT sport_name, sport_category, 
       CASE WHEN is_team_sport = 1 THEN 'Team Sport' ELSE 'Individual' END AS sport_type
FROM Sports;

-- 3. Top 5 longest duration sports
SELECT sport_name,sport_category,typical_duration_minutes FROM Sports ORDER BY typical_duration_minutes DESC LIMIT 5; 

-- 4. Count number of sports per category
SELECT sport_category, COUNT(*) AS Number_of_Sports FROM Sports GROUP BY sport_category ORDER BY Number_of_Sports DESC;

-- 5. Select sports added after year 2000
SELECT sport_name, sport_category, olympic_since_year FROM Sports WHERE olympic_since_year > '2000';

-- 6. Select sports that are played indoor and uses Points for scoring
SELECT sport_name, sport_category, scoring_type FROM Sports WHERE indoor_outdoor = 'indoor' AND scoring_type = 'Points';

-- 7. Average match duration grouped by sport category
SELECT sport_category ,AVG(typical_duration_minutes) AS Avg_match_duration FROM Sports GROUP BY sport_category;

-- 8. List events with their sport names
SELECT s.sport_name, s.sport_category,e.event_name
FROM Events e
JOIN Sports s ON s.sport_id = e.event_id;

-- 9. Select sports which are played outdoor and has duration greater than 60 minutes
SELECT sport_name, sport_category, typical_duration_minutes FROM Sports WHERE indoor_outdoor = 'outdoor' AND typical_duration_minutes > 60;

-- 10. Delete a sport
DELETE FROM Sports
WHERE sport_name = 'Gymnastics';

-- Table 3: Atheletes
-- 1. Select all athelets with their full names, gender and country
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Full_Name, a.gender, c.country_name FROM Athletes a
JOIN Countries c ON a.country_id = c.country_id;

-- 2. Count of Athletes by Gender
SELECT gender,COUNT(*) AS Total_Gender FROM Athletes GROUP BY Gender;

-- 3. Select athletes taller than average height
SELECT first_name, last_name, height_cm FROM Athletes WHERE height_cm > (SELECT AVG(height_cm) FROM Athletes);

-- 4. List athletes with sport name and country
SELECT a.first_name, a.last_name, s.sport_name, c.country_name
FROM  Athletes a
JOIN Sports s ON a.sport_id = s.sport_id
JOIN Countries c ON a.country_id = c.country_id;

-- 5. Select athletes with weight between 60 and 80kg
SELECT first_name, last_name, weight_kg FROM Athletes WHERE weight_kg BETWEEN 60 AND 80;

-- 6. Select athletes who play indoor games
SELECT a.first_name, a.last_name, s.sport_name
FROM Athletes a
JOIN Sports s ON a.sport_id = s.sport_id WHERE indoor_outdoor = 'outdoor';

-- 7. Select the youngest athlete
SELECT first_name, last_name, date_of_birth FROM Athletes ORDER BY date_of_birth DESC LIMIT 1;

-- 8. Select records where 'Olympic' word is located
SELECT * FROM Athletes WHERE bio LIKE '%Olympic%';

-- 9. Delete athlete id
DELETE FROM Athletes
WHERE athlete_id = 1;

-- 10. Update the athletes height
UPDATE Athletes
SET height_cm = 196
WHERE athlete_id = 1;

-- Table 4: Olympics
-- 1. Select all Olympics edition with host city and year
SELECT year, season, city FROM Olympics ORDER BY Year;

-- 2. Count number of summer and winter olympics
SELECT season, COUNT(*) AS No_of_Times FROM Olympics GROUP BY Season;

-- 3. Total athletes and sports per year
SELECT year, number_of_athletes, number_of_sports FROM Olympics
ORDER BY number_of_athletes DESC;

-- 4. List olympic editions by specific country
SELECT o.year, o.city, c.country_name
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
WHERE c.country_name = 'Japan';

-- 5. Select athlete count above average
SELECT year, city, number_of_athletes
FROM Olympics
WHERE number_of_athletes > (
    SELECT AVG(number_of_athletes) FROM Olympics
);

-- 6. Calculate duration of each Olympic edition
SELECT year, city, DATEDIFF(closing_date, opening_date) AS duration_days
FROM Olympics;

-- 7. Select Olympic years where more than 30 sports
SELECT year, city, number_of_sports
FROM Olympics
WHERE number_of_sports > 30;

-- 8. Select olympic year with its city, country and continent
SELECT o.year, o.city, c.country_name, c.continent
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id;

-- 9. Olympic editions held in Europe
SELECT o.year, o.city, c.country_name
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
WHERE c.continent = 'Europe';

-- 10. Delete a record
DELETE FROM Olympics
WHERE year = 2008;

-- Table 5: Events
-- 1. List all events with their sport and venue
SELECT e.event_name, s.sport_name, o.year AS Olympic_Year, e.venue_name
FROM Events e
JOIN Sports s ON e.sport_id = s.sport_id
JOIN Olympics o ON e.olympic_id = o.olympic_id;

-- 2. Count events by gender category
SELECT gender_category, COUNT(*) AS Total_Events FROM Events GROUP BY gender_category;

-- 3. Events that has more than 3 rounds
SELECT event_name, number_of_rounds FROM Events WHERE number_of_rounds > 3;

-- 4. Events using 'Time' as scoring method
SELECT event_name, number_of_rounds FROM Events WHERE scoring_method = 'Time';

-- 5. Events that take place in the most recent Olympic Year
SELECT event_name, event_type FROM Events WHERE olympic_id = (SELECT olympic_id FROM Olympics ORDER BY Year DESC LIMIT 1); 

-- 6. Show events with full context
SELECT e.event_name, s.sport_name, o.city AS host_city, o.year
FROM Events e
JOIN Sports s ON e.sport_id = s.sport_id
JOIN Olympics o ON e.olympic_id = o.olympic_id;

-- 7. Events held at Oympic Stadium
SELECT event_name, venue_name
FROM Events
WHERE venue_name = 'Olympic Stadium';

-- 8. Count events per Olympic Edition
SELECT o.year, COUNT(e.event_id) AS total_events
FROM Events e
JOIN Olympics o ON e.olympic_id = o.olympic_id
GROUP BY o.year
ORDER BY total_events DESC;

-- 9. Events with distance or weight info available
SELECT event_name, distance_or_weight
FROM Events
WHERE distance_or_weight IS NOT NULL AND distance_or_weight != 'N/A';

-- 10. Delete a event
DELETE FROM Events
WHERE event_name = 'boxing';

-- Table 6: Venues

-- 1. List all venues with their capacity and surface type
SELECT venue_name, capacity, surface_type, venue_type
FROM Venues
ORDER BY capacity DESC;

-- 2. Count venues by type (Indoor, Outdoor, Aquatic, etc.)
SELECT venue_type, COUNT(*) AS total_venues
FROM Venues
GROUP BY venue_type;

-- 3. Venues that were renovated after 2015
SELECT venue_name, construction_year, renovated_year
FROM Venues
WHERE renovated_year > 2015;

-- 4. Join with Olympics: Show venues with Olympic year and host city
SELECT v.venue_name, o.year, o.city
FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id;

-- 5. Subquery: Venues with above average seating capacity
SELECT venue_name, capacity
FROM Venues
WHERE capacity > (
    SELECT AVG(capacity) FROM Venues
);

-- 6. Venues using synthetic surfaces only
SELECT venue_name, surface_type
FROM Venues
WHERE surface_type LIKE '%Synthetic%';

-- 7. Count venues by country
SELECT c.country_name, COUNT(v.venue_id) AS venue_count
FROM Venues v
JOIN Countries c ON v.country_id = c.country_id
GROUP BY c.country_name;

-- 8. Venues used for Tokyo 2020 Olympics
SELECT v.venue_name, v.location
FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id
WHERE o.city = 'Tokyo' AND o.year = 2020;

-- 9. Join with Events: List events and their venue details
SELECT e.event_name, v.venue_name, v.capacity
FROM Events e
JOIN Venues v ON e.venue_name = v.venue_name;

-- 10. Remove an Olympic edition and delete all related venues
DELETE FROM Olympics
WHERE year = 2016;

-- Table 7: Teams

-- 1. List all teams with their country and sport
SELECT t.team_name, c.country_name, s.sport_name
FROM Teams t
JOIN Countries c ON t.country_id = c.country_id
JOIN Sports s ON t.sport_id = s.sport_id;

-- 2. Count number of teams per Olympic edition
SELECT o.year, COUNT(t.team_id) AS total_teams
FROM Teams t
JOIN Olympics o ON t.olympic_id = o.olympic_id
GROUP BY o.year;

-- 3. List teams with more than 100 athletes
SELECT team_name, total_athletes
FROM Teams
WHERE total_athletes > 100;

-- 4. Teams with medal count greater than average
SELECT team_name, total_medals
FROM Teams
WHERE total_medals > (
    SELECT AVG(total_medals) FROM Teams
);

-- 5. Show teams with missing team captains (NULL check)
SELECT team_name, team_captain
FROM Teams
WHERE team_captain IS NULL;

-- 6. Join with Olympics: List teams with their formation year and Olympic host city
SELECT t.team_name, t.formation_year, o.city AS host_city
FROM Teams t
JOIN Olympics o ON t.olympic_id = o.olympic_id;

-- 7. Find teams coached by people with names starting with 'C'
SELECT team_name, team_coach
FROM Teams
WHERE team_coach LIKE 'C%';

-- 8. Count teams per country
SELECT c.country_name, COUNT(t.team_id) AS team_count
FROM Teams t
JOIN Countries c ON t.country_id = c.country_id
GROUP BY c.country_name;

-- 9. Teams formed before the year 1950
SELECT team_name, formation_year
FROM Teams
WHERE formation_year < 1950;

-- 10. Remove a country and its teams
DELETE FROM Countries
WHERE country_name = 'Germany';

-- Table 8: Medals

-- 1. List all medals with athlete name, country, and medal type
SELECT CONCAT(a.first_name, ' ', a.last_name) AS athlete_name, c.country_name, m.medal_type
FROM Medals m
JOIN Athletes a ON m.athlete_id = a.athlete_id
JOIN Countries c ON m.country_id = c.country_id;

-- 2. Count of each medal type awarded
SELECT medal_type, COUNT(*) AS total_awarded
FROM Medals
GROUP BY medal_type;

-- 3. Find countries that won more than 5 medals
SELECT country_id, COUNT(*) AS total_medals
FROM Medals
GROUP BY country_id
HAVING COUNT(*) > 5;

-- 4. List medals awarded in a specific Olympic edition (e.g. 2020)
SELECT m.medal_type, a.first_name, a.last_name, o.year
FROM Medals m
JOIN Athletes a ON m.athlete_id = a.athlete_id
JOIN Olympics o ON m.olympic_id = o.olympic_id
WHERE o.year = 2020;

-- 5. Subquery: Athletes who won medals more than once
SELECT athlete_id, COUNT(*) AS medal_count
FROM Medals
GROUP BY athlete_id
HAVING COUNT(*) > 1;

-- 6. Join with Events: Show event names and medal types
SELECT e.event_name, m.medal_type
FROM Medals m
JOIN Events e ON m.event_id = e.event_id;

-- 7. Medals awarded at Tokyo Olympic Stadium
SELECT m.medal_type, v.venue_name
FROM Medals m
JOIN Venues v ON m.venue_id = v.venue_id
WHERE v.venue_name LIKE '%Tokyo%';

-- 8. Number of medals won by each team
SELECT team_id, COUNT(*) AS medals_won
FROM Medals
WHERE team_id IS NOT NULL
GROUP BY team_id;

-- 9. Latest medal awarded (by date)
SELECT *
FROM Medals
ORDER BY medal_date DESC
LIMIT 1;

-- 10. Remove an athlete and their medals
DELETE FROM Athletes
WHERE first_name = 'Usain' AND last_name = 'Bolt';

-- Table 9: Coaches

-- 1. List all coaches with full name, country, and sport
SELECT CONCAT(c.first_name, ' ', c.last_name) AS coach_name,
       cn.country_name, s.sport_name
FROM Coaches c
JOIN Countries cn ON c.country_id = cn.country_id
JOIN Sports s ON c.sport_id = s.sport_id;

-- 2. Count of coaches by gender
SELECT gender, COUNT(*) AS total_coaches
FROM Coaches
GROUP BY gender;

-- 3. Coaches with more than 20 years of experience
SELECT first_name, last_name, years_of_experience
FROM Coaches
WHERE years_of_experience > 20;

-- 4. Coaches with NULL team assignment
SELECT first_name, last_name, team_id
FROM Coaches
WHERE team_id IS NULL;

-- 5. Coaches with certification level 'Level A'
SELECT first_name, last_name, certification_level
FROM Coaches
WHERE certification_level = 'Level A';

-- 6. Join with Teams: Coaches and their respective teams (if any)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS coach_name,
       t.team_name
FROM Coaches c
JOIN Teams t ON c.team_id = t.team_id;

-- 7. Count of coaches per country
SELECT cn.country_name, COUNT(*) AS num_coaches
FROM Coaches c
JOIN Countries cn ON c.country_id = cn.country_id
GROUP BY cn.country_name;

-- 8. Subquery: Coaches older than average age
SELECT first_name, last_name, date_of_birth
FROM Coaches
WHERE date_of_birth < (
    SELECT AVG(date_of_birth) FROM Coaches
);

-- 9. List coaches who specialize in indoor sports
SELECT c.first_name, c.last_name, s.sport_name, s.indoor_outdoor
FROM Coaches c
JOIN Sports s ON c.sport_id = s.sport_id
WHERE s.indoor_outdoor = 'Indoor';

-- 10. Delete a team and all linked coaches
DELETE FROM Teams
WHERE team_name = 'India';

-- Table 10: Refrees

-- 1. List all referees with name, nationality, and sport
SELECT CONCAT(r.first_name, ' ', r.last_name) AS referee_name,
       c.country_name, s.sport_name
FROM Referees r
JOIN Countries c ON r.country_id = c.country_id
JOIN Sports s ON r.sport_id = s.sport_id;

-- 2. Count referees by gender
SELECT gender, COUNT(*) AS total_referees
FROM Referees
GROUP BY gender;

-- 3. Referees with more than 15 years of experience
SELECT first_name, last_name, experience_years
FROM Referees
WHERE experience_years > 15;

-- 4. Referees who are also certified coaches (has certification_level)
SELECT first_name, last_name, certification_level
FROM Referees
WHERE certification_level IS NOT NULL;

-- 5. Referees assigned to a specific Olympic edition (e.g., 2020)
SELECT r.first_name, r.last_name, o.year, o.city
FROM Referees r
JOIN Olympics o ON r.olympic_id = o.olympic_id
WHERE o.year = 2020;

-- 6. Join with Events: Referees and the events they officiated
SELECT r.first_name, r.last_name, e.event_name
FROM Referees r
JOIN Events e ON r.event_id = e.event_id;

-- 7. Count of referees per country
SELECT c.country_name, COUNT(*) AS referee_count
FROM Referees r
JOIN Countries c ON r.country_id = c.country_id
GROUP BY c.country_name;

-- 8. Subquery: Referees with age above average
SELECT first_name, last_name, date_of_birth
FROM Referees
WHERE date_of_birth < (
    SELECT AVG(date_of_birth) FROM Referees
);

-- 9. Referees working in indoor sports
SELECT r.first_name, r.last_name, s.sport_name
FROM Referees r
JOIN Sports s ON r.sport_id = s.sport_id
WHERE s.indoor_outdoor = 'Indoor';

-- 10. Remove a country and all its referees
DELETE FROM Countries
WHERE country_name = 'Italy';

-- Table 11: Sponorships
-- ✅ 10 SQL Queries for the Sponsorships Table (with DELETE, no INSERT)

-- 1. List all sponsorships with company name, country, and Olympic year
SELECT s.sponsor_name, c.country_name, o.year AS olympic_year
FROM Sponsorships s
JOIN Countries c ON s.country_id = c.country_id
JOIN Olympics o ON s.olympic_id = o.olympic_id;

-- 2. Total sponsorship amount per Olympic edition
SELECT o.year, SUM(s.sponsorship_amount) AS total_sponsorship
FROM Sponsorships s
JOIN Olympics o ON s.olympic_id = o.olympic_id
GROUP BY o.year
ORDER BY total_sponsorship DESC;

-- 3. Sponsorships with amount greater than 10 million
SELECT sponsor_name, sponsorship_amount
FROM Sponsorships
WHERE sponsorship_amount > 10000000;

-- 4. Count of sponsors by country
SELECT c.country_name, COUNT(s.sponsorship_id) AS sponsor_count
FROM Sponsorships s
JOIN Countries c ON s.country_id = c.country_id
GROUP BY c.country_name;

-- 5. Sponsors supporting more than one Olympic edition
SELECT sponsor_name, COUNT(DISTINCT olympic_id) AS editions_supported
FROM Sponsorships
GROUP BY sponsor_name
HAVING COUNT(DISTINCT olympic_id) > 1;

-- 6. Subquery: Sponsorships above the average amount
SELECT sponsor_name, sponsorship_amount
FROM Sponsorships
WHERE sponsorship_amount > (
    SELECT AVG(sponsorship_amount) FROM Sponsorships
);

-- 7. Sponsorships with NULL contact person
SELECT sponsor_name, contact_person
FROM Sponsorships
WHERE contact_person IS NULL;

-- 8. Join with Olympics: Sponsorships for Tokyo 2020
SELECT s.sponsor_name, s.sponsorship_amount
FROM Sponsorships s
JOIN Olympics o ON s.olympic_id = o.olympic_id
WHERE o.year = 2020 AND o.city = 'Tokyo';

-- 9. Total sponsorship amount by sponsor
SELECT sponsor_name, SUM(sponsorship_amount) AS total_amount
FROM Sponsorships
GROUP BY sponsor_name;

-- 10. Delete an Olympic edition and all related sponsorships
DELETE FROM Olympics
WHERE year = 2012;

-- Table 12: Matches

-- ✅ 10 SQL Queries for the Matches Table (with DELETE, no INSERT)

-- 1. List all matches with event, venue, and scheduled time
SELECT m.match_id, e.event_name, v.venue_name, m.match_date, m.start_time
FROM Matches m
JOIN Events e ON m.event_id = e.event_id
JOIN Venues v ON m.venue_id = v.venue_id;

-- 2. Count of matches by match status (Scheduled, Completed, Cancelled)
SELECT match_status, COUNT(*) AS total_matches
FROM Matches
GROUP BY match_status;

-- 3. Matches scheduled on a specific date (e.g., 2024-08-10)
SELECT match_id, match_date, start_time
FROM Matches
WHERE match_date = '2024-08-10';

-- 4. Matches held at venues with capacity over 50,000
SELECT m.match_id, v.venue_name, v.capacity
FROM Matches m
JOIN Venues v ON m.venue_id = v.venue_id
WHERE v.capacity > 50000;

-- 5. Subquery: Matches held after the average match date (approx. midpoint)
SELECT match_id, match_date
FROM Matches
WHERE match_date > (
    SELECT DATE_ADD('2000-01-01', INTERVAL AVG(DATEDIFF(match_date, '2000-01-01')) DAY) FROM Matches
);

-- 6. Join with Events and Olympics: Matches with Olympic year and city
SELECT m.match_id, e.event_name, o.year AS olympic_year, o.city
FROM Matches m
JOIN Events e ON m.event_id = e.event_id
JOIN Olympics o ON e.olympic_id = o.olympic_id;

-- 7. Matches involving a specific team (e.g., team_id = 12)
SELECT match_id, team1_id, team2_id, match_status
FROM Matches
WHERE team1_id = 12 OR team2_id = 12;

-- 8. Count of matches per venue
SELECT v.venue_name, COUNT(m.match_id) AS match_count
FROM Matches m
JOIN Venues v ON m.venue_id = v.venue_id
GROUP BY v.venue_name
ORDER BY match_count DESC;

-- 9. Matches that ended in a draw (if score data were present, use winner_team_id IS NULL)
SELECT match_id, team1_id, team2_id, match_status
FROM Matches
WHERE match_status = 'Completed' AND winner_team_id IS NULL;

-- 10. Remove an event and all its matches
DELETE FROM Events
WHERE event_name = '100m Sprint';

-- Table 13: Broadcasts
-- ✅ 10 SQL Queries for the Broadcasts Table (with DELETE, no INSERT)

-- 1. List all broadcasts with broadcaster name, event ID, and country ID
SELECT broadcast_id, broadcaster_name, event_id, country_id, language
FROM Broadcasts
ORDER BY broadcast_date;

-- 2. Count total broadcasts grouped by language
SELECT language, COUNT(*) AS total_broadcasts
FROM Broadcasts
GROUP BY language;

-- 3. Broadcasts scheduled on a specific date (e.g., 2024-07-25)
SELECT *
FROM Broadcasts
WHERE broadcast_date = '2024-07-25';

-- 4. Broadcasts on the 'Online' platform with high viewership (over 15 million)
SELECT broadcaster_name, platform, viewership_estimate
FROM Broadcasts
WHERE platform = 'Online' AND viewership_estimate > 15000000;

-- 5. Subquery: Broadcasts with above-average viewership
SELECT broadcaster_name, viewership_estimate
FROM Broadcasts
WHERE viewership_estimate > (
    SELECT AVG(viewership_estimate) FROM Broadcasts
);

-- 6. Join with Countries: Show broadcaster and country name
SELECT b.broadcaster_name, c.country_name, b.language
FROM Broadcasts b
JOIN Countries c ON b.country_id = c.country_id;

-- 7. Count of broadcasts per platform (TV, Online, Radio)
SELECT platform, COUNT(*) AS total
FROM Broadcasts
GROUP BY platform;

-- 8. Find all broadcasts from broadcasters using 'English' language
SELECT broadcast_id, broadcaster_name, broadcast_date
FROM Broadcasts
WHERE language = 'English';

-- 9. Latest broadcast by date and time
SELECT *
FROM Broadcasts
ORDER BY broadcast_date DESC, start_time DESC
LIMIT 1;

-- 10. Delete an event and its broadcasts
DELETE FROM Events
WHERE event_id = 5;

-- Table 14: Refrees

-- 1. List all referees with full name, gender, nationality, and sport
SELECT r.full_name, r.gender, c.country_name, s.sport_name
FROM Referees r
JOIN Countries c ON r.nationality_id = c.country_id
JOIN Sports s ON r.sport_id = s.sport_id;

-- 2. Count referees by gender
SELECT gender, COUNT(*) AS total_referees
FROM Referees
GROUP BY gender;

-- 3. Referees with more than 10 years of experience
SELECT full_name, experience_years
FROM Referees
WHERE experience_years > 10;

-- 4. Referees who are not certified
SELECT full_name, certified
FROM Referees
WHERE certified = FALSE;

-- 5. Referees with status 'Retired'
SELECT full_name, status
FROM Referees
WHERE status = 'Retired';

-- 6. Referees assigned to an event with its name
SELECT r.full_name, e.event_name
FROM Referees r
JOIN Events e ON r.assigned_event_id = e.event_id;

-- 7. Count of referees per country
SELECT c.country_name, COUNT(r.referee_id) AS referee_count
FROM Referees r
JOIN Countries c ON r.nationality_id = c.country_id
GROUP BY c.country_name;

-- 8. Referees by sport (with sport name and certification)
SELECT r.full_name, s.sport_name, r.certified
FROM Referees r
JOIN Sports s ON r.sport_id = s.sport_id;

-- 9. Subquery: Referees who have more experience than the average
SELECT full_name, experience_years
FROM Referees
WHERE experience_years > (
    SELECT AVG(experience_years) FROM Referees
);

-- 10. Demonstrate cascading delete: Remove an event and all referees linked via assigned_event_id
DELETE FROM Events
WHERE event_id = 5;

-- Table 15:Schedules

-- 1. List all scheduled events with date, time, session, and venue name
SELECT s.schedule_id, e.event_name, s.scheduled_date, s.start_time, s.end_time, s.session, v.venue_name
FROM Schedules s
JOIN Events e ON s.event_id = e.event_id
JOIN Venues v ON s.venue_id = v.venue_id;

-- 2. Count of events by status (Scheduled, Completed, Cancelled)
SELECT status, COUNT(*) AS total_events
FROM Schedules
GROUP BY status;

-- 3. Events scheduled in the Morning session
SELECT schedule_id, scheduled_date, session
FROM Schedules
WHERE session = 'Morning';

-- 4. Events scheduled on a specific date (e.g., 2024-07-25)
SELECT schedule_id, event_id, scheduled_date, start_time
FROM Schedules
WHERE scheduled_date = '2024-07-25';

-- 5. Subquery: Events scheduled after the average date
SELECT schedule_id, scheduled_date
FROM Schedules
WHERE scheduled_date > (
  SELECT DATE_ADD('2000-01-01', INTERVAL AVG(DATEDIFF(scheduled_date, '2000-01-01')) DAY) FROM Schedules
);

-- 6. List of completed events and their sports
SELECT s.schedule_id, e.event_name, sp.sport_name, s.status
FROM Schedules s
JOIN Events e ON s.event_id = e.event_id
JOIN Sports sp ON s.sport_id = sp.sport_id
WHERE s.status = 'Completed';

-- 7. Number of events scheduled per venue
SELECT v.venue_name, COUNT(*) AS event_count
FROM Schedules s
JOIN Venues v ON s.venue_id = v.venue_id
GROUP BY v.venue_name;

-- 8. List of events that were cancelled
SELECT s.schedule_id, e.event_name, s.scheduled_date
FROM Schedules s
JOIN Events e ON s.event_id = e.event_id
WHERE s.status = 'Cancelled';

-- 9. Most recent event schedule updated (based on last_updated timestamp)
SELECT *
FROM Schedules
ORDER BY last_updated DESC
LIMIT 1;

-- 10. Delete a venue and related schedules
DELETE FROM Venues
WHERE venue_id = 5;

-- Table 16: Judges

-- 1. List all judges with name, nationality, sport, and certification
SELECT j.full_name, c.country_name, s.sport_name, j.certification_level
FROM Judges j
JOIN Countries c ON j.nationality_id = c.country_id
JOIN Sports s ON j.sport_id = s.sport_id;

-- 2. Count of judges by gender
SELECT gender, COUNT(*) AS total_judges
FROM Judges
GROUP BY gender;

-- 3. Judges with more than 10 years of experience
SELECT full_name, years_of_experience
FROM Judges
WHERE years_of_experience > 10;

-- 4. Judges who are chief judges
SELECT full_name, is_chief_judge
FROM Judges
WHERE is_chief_judge = TRUE;

-- 5. Judges who are currently retired
SELECT full_name, status
FROM Judges
WHERE status = 'Retired';

-- 6. Judges and the events they are assigned to (if any)
SELECT j.full_name, e.event_name
FROM Judges j
JOIN Events e ON j.assigned_event_id = e.event_id;

-- 7. Count of judges per country
SELECT c.country_name, COUNT(*) AS judge_count
FROM Judges j
JOIN Countries c ON j.nationality_id = c.country_id
GROUP BY c.country_name;

-- 8. Judges with 'International' certification level
SELECT full_name, certification_level
FROM Judges
WHERE certification_level = 'International';

-- 9. Subquery: Judges with more experience than the average
SELECT full_name, years_of_experience
FROM Judges
WHERE years_of_experience > (
  SELECT AVG(years_of_experience) FROM Judges
);

-- 10. Remove an event and all linked judges
DELETE FROM Events
WHERE event_id = 5;

-- Table 17: Scores

-- 1. List all scores with athlete, judge, and event info
SELECT s.score_id, a.first_name, a.last_name, j.full_name AS judge_name, e.event_name, s.score, s.score_type
FROM Scores s
JOIN Athletes a ON s.athlete_id = a.athlete_id
JOIN Judges j ON s.judge_id = j.judge_id
JOIN Events e ON s.event_id = e.event_id;

-- 2. Average score by score type
SELECT score_type, ROUND(AVG(score), 2) AS average_score
FROM Scores
GROUP BY score_type;

-- 3. Scores marked as 'Final'
SELECT score_id, score, score_type, status
FROM Scores
WHERE status = 'Final';

-- 4. Judges who gave 'Artistic' scores above 9.0
SELECT j.full_name, s.score, s.score_type
FROM Scores s
JOIN Judges j ON s.judge_id = j.judge_id
WHERE s.score_type = 'Artistic' AND s.score > 9.0;

-- 5. Subquery: Scores higher than average for the same score type
SELECT score_id, score, score_type
FROM Scores
WHERE score > (
    SELECT AVG(score) FROM Scores WHERE score_type = Scores.score_type
);

-- 6. Count of scores per athlete
SELECT a.first_name, a.last_name, COUNT(*) AS total_scores
FROM Scores s
JOIN Athletes a ON s.athlete_id = a.athlete_id
GROUP BY s.athlete_id;

-- 7. Most recent score recorded
SELECT *
FROM Scores
ORDER BY score_date DESC
LIMIT 1;

-- 8. Scores with remarks mentioning 'technique'
SELECT score_id, remarks
FROM Scores
WHERE remarks LIKE '%technique%';

-- 9. Judges who submitted more than 2 scores
SELECT j.full_name, COUNT(*) AS score_count
FROM Scores s
JOIN Judges j ON s.judge_id = j.judge_id
GROUP BY j.judge_id
HAVING COUNT(*) > 2;

-- 10. Delete an athlete and related scores
DELETE FROM Athletes
WHERE athlete_id = 1;

-- Table 18: Ticket Sales

-- 1. List all tickets sold with buyer name, event ID, ticket type, and price
SELECT ticket_id, buyer_name, event_id, ticket_type, price
FROM ticket_sales
ORDER BY purchase_date;

-- 2. Count of tickets sold by ticket type
SELECT ticket_type, COUNT(*) AS total_sold
FROM ticket_sales
GROUP BY ticket_type;

-- 3. Tickets with payment status 'Pending'
SELECT ticket_id, buyer_name, payment_status
FROM ticket_sales
WHERE payment_status = 'Pending';

-- 4. Tickets purchased through 'Online' sale channel
SELECT ticket_id, buyer_name, sale_channel
FROM ticket_sales
WHERE sale_channel = 'Online';

-- 5. Subquery: Tickets priced above average
SELECT ticket_id, buyer_name, price
FROM ticket_sales
WHERE price > (
    SELECT AVG(price) FROM ticket_sales
);

-- 6. Count of tickets sold per payment status
SELECT payment_status, COUNT(*) AS count_by_status
FROM ticket_sales
GROUP BY payment_status;

-- 7. Tickets purchased on a specific date (e.g., 2024-06-03)
SELECT ticket_id, buyer_name, purchase_date
FROM ticket_sales
WHERE purchase_date = '2024-06-03';

-- 8. Highest-priced VIP ticket sold
SELECT *
FROM ticket_sales
WHERE ticket_type = 'VIP'
ORDER BY price DESC
LIMIT 1;

-- 9. Count of tickets sold per sale channel
SELECT sale_channel, COUNT(*) AS total
FROM ticket_sales
GROUP BY sale_channel;

-- 10. Demonstrate cascading delete: Delete an event and its related ticket sales
DELETE FROM events
WHERE event_id = 2;

-- Table 19: Ceremonies

-- 1. List all ceremonies with type, date, venue, and host country
SELECT c.ceremony_id, c.ceremony_type, c.ceremony_date, v.venue_name, c.host_country
FROM ceremonies c
JOIN venues v ON c.venue_id = v.venue_id
ORDER BY c.ceremony_date;

-- 2. Count ceremonies grouped by type
SELECT ceremony_type, COUNT(*) AS total_ceremonies
FROM ceremonies
GROUP BY ceremony_type;

-- 3. Ceremonies hosted by a specific country (e.g., 'France')
SELECT *
FROM ceremonies
WHERE host_country = 'France';

-- 4. Ceremonies happening in July 2024
SELECT *
FROM ceremonies
WHERE MONTH(ceremony_date) = 7 AND YEAR(ceremony_date) = 2024;

-- 5. Ceremonies with themes containing 'Unity'
SELECT ceremony_id, theme, main_performer
FROM ceremonies
WHERE theme LIKE '%Unity%';

-- 6. List ceremonies and their main performer for the Olympics with id 1
SELECT ceremony_type, main_performer, ceremony_date
FROM ceremonies
WHERE olympic_id = 1;

-- 7. Count ceremonies per venue
SELECT v.venue_name, COUNT(*) AS ceremonies_count
FROM ceremonies c
JOIN venues v ON c.venue_id = v.venue_id
GROUP BY v.venue_name;

-- 8. Ceremonies ordered by start time
SELECT ceremony_id, ceremony_type, start_time, end_time
FROM ceremonies
ORDER BY start_time;

-- 9. Ceremonies held after the average ceremony date
SELECT ceremony_id, ceremony_date
FROM ceremonies
WHERE ceremony_date > (
    SELECT AVG(UNIX_TIMESTAMP(ceremony_date)) FROM ceremonies
);

-- 10. Delete ceremonies held at a specific venue (e.g., venue_id = 2)
DELETE FROM ceremonies
WHERE venue_id = 2;

-- Table 20: Medical Records
-- 1. List all medical records with athlete name and checkup date
SELECT mr.record_id, a.first_name, a.last_name, mr.checkup_date, mr.injury_description, mr.fitness_clearance
FROM medical_records mr
JOIN athletes a ON mr.athlete_id = a.athlete_id
ORDER BY mr.checkup_date DESC;

-- 2. Count records by fitness clearance status
SELECT fitness_clearance, COUNT(*) AS total_records
FROM medical_records
GROUP BY fitness_clearance;

-- 3. Medical records where follow-up is required
SELECT record_id, athlete_id, checkup_date, follow_up_required
FROM medical_records
WHERE follow_up_required = TRUE;

-- 4. Records with injury description containing 'fracture'
SELECT record_id, injury_description, treatment_given
FROM medical_records
WHERE injury_description LIKE '%fracture%';

-- 5. Records checked by a specific doctor (e.g., 'Dr. Smith')
SELECT record_id, doctor_name, hospital_name
FROM medical_records
WHERE doctor_name = 'Dr. Smith';

-- 6. Count of medical records per hospital
SELECT hospital_name, COUNT(*) AS total_records
FROM medical_records
GROUP BY hospital_name;

-- 7. Latest medical checkup for each athlete
SELECT athlete_id, MAX(checkup_date) AS latest_checkup
FROM medical_records
GROUP BY athlete_id;

-- 8. Records where treatment was 'Physiotherapy'
SELECT record_id, treatment_given, fitness_clearance
FROM medical_records
WHERE treatment_given LIKE '%Physiotherapy%';

-- 9. Records with notes mentioning 'healing'
SELECT record_id, notes
FROM medical_records
WHERE notes LIKE '%Healing%';

-- 10. Delete records older than 3 years
DELETE FROM medical_records
WHERE checkup_date < DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

-- Table 21: Training Sessions
-- 1. List all training sessions with athlete, coach, sport, date, and location
SELECT ts.session_id, a.first_name, a.last_name, c.first_name AS coach_first, c.last_name AS coach_last, sp.sport_name, ts.session_date, ts.location, ts.intensity_level
FROM training_sessions ts
JOIN athletes a ON ts.athlete_id = a.athlete_id
JOIN coaches c ON ts.coach_id = c.coach_id
JOIN sports sp ON ts.sport_id = sp.sport_id
ORDER BY ts.session_date DESC;

-- 2. Count sessions by intensity level
SELECT intensity_level, COUNT(*) AS total_sessions
FROM training_sessions
GROUP BY intensity_level;

-- 3. Sessions held at a specific location (e.g., 'Olympic Training Center')
SELECT *
FROM training_sessions
WHERE location = 'Olympic Training Center';

-- 4. Sessions with duration longer than 2 hours
SELECT session_id, TIMEDIFF(end_time, start_time) AS duration
FROM training_sessions
WHERE TIMEDIFF(end_time, start_time) > '02:00:00';

-- 5. Latest training session for each athlete
SELECT athlete_id, MAX(session_date) AS last_session
FROM training_sessions
GROUP BY athlete_id;

-- 6. Sessions coached by a specific coach (e.g., coach_id = 10)
SELECT session_id, athlete_id, session_date, intensity_level
FROM training_sessions
WHERE coach_id = 10;

-- 7. Sessions with notes mentioning 'injury prevention'
SELECT session_id, notes
FROM training_sessions
WHERE notes LIKE '%injury prevention%';

-- 8. Count training sessions per sport
SELECT sp.sport_name, COUNT(*) AS total_sessions
FROM training_sessions ts
JOIN sports sp ON ts.sport_id = sp.sport_id
GROUP BY sp.sport_name;

-- 9. Sessions that happened in the last 7 days
SELECT *
FROM training_sessions
WHERE session_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 10. Delete sessions with low intensity older than 1 year
DELETE FROM training_sessions
WHERE intensity_level = 'Low' AND session_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Table 22: Volunteers
-- 1. List all volunteers with name, age, gender, and assigned area
SELECT volunteer_id, full_name, age, gender, assigned_area, shift_time
FROM volunteers
ORDER BY full_name;

-- 2. Count volunteers by gender
SELECT gender, COUNT(*) AS total_volunteers
FROM volunteers
GROUP BY gender;

-- 3. Volunteers available in the Morning shift
SELECT volunteer_id, full_name, shift_time
FROM volunteers
WHERE shift_time = 'Morning';

-- 4. Volunteers assigned to a specific area (e.g., 'Main Stadium')
SELECT *
FROM volunteers
WHERE assigned_area = 'Main Stadium';

-- 5. Volunteers available on Sundays (assuming availability_days stores days as CSV like 'Mon,Tue,Sun')
SELECT volunteer_id, full_name, availability_days
FROM volunteers
WHERE FIND_IN_SET('Sun', availability_days) > 0;

-- 6. Volunteers older than 30 years
SELECT volunteer_id, full_name, age
FROM volunteers
WHERE age > 30;

-- 7. Count volunteers per shift
SELECT shift_time, COUNT(*) AS volunteers_count
FROM volunteers
GROUP BY shift_time;

-- 8. Volunteers with role descriptions containing 'security'
SELECT volunteer_id, full_name, role_description
FROM volunteers
WHERE role_description LIKE '%security%';

-- 9. List volunteers sorted by age descending
SELECT *
FROM volunteers
ORDER BY age DESC;

-- 10. Delete volunteers who are unavailable for all days (empty availability_days)
DELETE FROM volunteers
WHERE availability_days = '' OR availability_days IS NULL;

-- Table 23: Security Staff
-- 1. List all security staff with name, age, gender, and assigned location
SELECT staff_id, full_name, age, gender, assigned_location, shift_time, duty_type
FROM security_staff
ORDER BY full_name;

-- 2. Count security staff by gender
SELECT gender, COUNT(*) AS total_staff
FROM security_staff
GROUP BY gender;

-- 3. Staff working the Night shift
SELECT staff_id, full_name, shift_time
FROM security_staff
WHERE shift_time = 'Night';

-- 4. Staff assigned to a specific location (e.g., 'Main Gate')
SELECT *
FROM security_staff
WHERE assigned_location = 'Main Gate';

-- 5. Staff supervised by a specific supervisor (e.g., 'John Doe')
SELECT staff_id, full_name, supervisor_name
FROM security_staff
WHERE supervisor_name = 'John Doe';

-- 6. Staff older than 40 years
SELECT staff_id, full_name, age
FROM security_staff
WHERE age > 40;

-- 7. Count staff per shift
SELECT shift_time, COUNT(*) AS staff_count
FROM security_staff
GROUP BY shift_time;

-- 8. Staff with duty type containing 'Crowd Control'
SELECT staff_id, full_name, duty_type
FROM security_staff
WHERE duty_type LIKE '%Crowd Control%';

-- 9. List staff sorted by age descending
SELECT *
FROM security_staff
ORDER BY age DESC;

-- 10. Delete staff not assigned to any location
DELETE FROM security_staff
WHERE assigned_location IS NULL OR assigned_location = '';

-- Table 24: Media Coverage
-- 1. List all media coverage records with media house, event, and date
SELECT coverage_id, media_house, reporter_name, event_covered, coverage_date
FROM media_coverage
ORDER BY coverage_date DESC;

-- 2. Count coverage by type (Live, Recorded, Written)
SELECT coverage_type, COUNT(*) AS total_coverage
FROM media_coverage
GROUP BY coverage_type;

-- 3. Coverage for a specific event (e.g., '100m Sprint')
SELECT *
FROM media_coverage
WHERE event_covered = '100m Sprint';

-- 4. Coverage in English language
SELECT *
FROM media_coverage
WHERE language = 'English';

-- 5. Media houses from a specific country (e.g., 'USA')
SELECT DISTINCT media_house, country
FROM media_coverage
WHERE country = 'USA';

-- 6. Coverage by a specific reporter
SELECT coverage_id, media_house, coverage_type, coverage_date
FROM media_coverage
WHERE reporter_name = 'John Smith';

-- 7. Count coverage per broadcast channel
SELECT broadcast_channel, COUNT(*) AS coverage_count
FROM media_coverage
GROUP BY broadcast_channel;

-- 8. Coverage records in the last 7 days
SELECT *
FROM media_coverage
WHERE coverage_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 9. Coverage with accreditation ID starting with 'ACC-'
SELECT *
FROM media_coverage
WHERE accreditation_id LIKE 'ACC%';

-- 10. Delete coverage records older than 1 year
DELETE FROM media_coverage
WHERE coverage_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Table 25: Doping test
-- 1. List all doping tests with athlete ID, sport, test date, and result
SELECT test_id, athlete_id, sport, test_date, result
FROM doping_tests
ORDER BY test_date DESC;

-- 2. Count of tests by result (Negative, Positive)
SELECT result, COUNT(*) AS total_tests
FROM doping_tests
GROUP BY result;

-- 3. Tests conducted in 2024
SELECT *
FROM doping_tests
WHERE YEAR(test_date) = 2024;

-- 4. Positive test records with substance found
SELECT test_id, athlete_id, substance_found, testing_agency
FROM doping_tests
WHERE result = 'Positive';

-- 5. Tests done by a specific agency (e.g., 'WADA')
SELECT *
FROM doping_tests
WHERE testing_agency = 'WADA';

-- 6. Count tests per sport
SELECT sport, COUNT(*) AS test_count
FROM doping_tests
GROUP BY sport;

-- 7. Tests using 'Blood' samples
SELECT test_id, athlete_id, sample_type, location
FROM doping_tests
WHERE sample_type = 'Blood';

-- 8. Tests conducted at a specific location (e.g., 'Olympic Village')
SELECT *
FROM doping_tests
WHERE location = 'Olympic Village';

-- 9. Tests with remarks mentioning 'good'
SELECT test_id, remarks
FROM doping_tests
WHERE remarks LIKE '%good%';

-- 10. Delete test records older than 5 years
DELETE FROM doping_tests
WHERE test_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
