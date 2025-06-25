use Olympics;

-- Table 1: Countries
-- 1. View to show countries with GDP above 1 trillion
CREATE VIEW rich_countries AS
SELECT country_name, gdp
FROM Countries
WHERE gdp > 1000000000000;

SELECT * FROM rich_countries;

-- 2. View to display population by continent
CREATE VIEW population_by_continent AS
SELECT continent, SUM(population) AS total_population
FROM Countries
GROUP BY continent;

SELECT * FROM population_by_continent;

-- 3. View for European countries with capital cities
CREATE VIEW european_capitals AS
SELECT country_name, capital_city
FROM Countries
WHERE continent = 'Europe';

SELECT * FROM european_capitals;

-- 4. Drop view if exists
DROP VIEW IF EXISTS european_capitals;

-- 5. CTE to get top 3 most populated countries
WITH top_populated AS (
  SELECT country_name, population
  FROM Countries
  ORDER BY population DESC
  LIMIT 3
)
SELECT * FROM top_populated;

-- 6. CTE to calculate average GDP per continent
WITH gdp_avg AS (
  SELECT continent, AVG(gdp) AS avg_gdp
  FROM Countries
  GROUP BY continent
)
SELECT * FROM gdp_avg WHERE avg_gdp > 500000000000;

-- 7. CTE to find countries with names longer than 10 characters
WITH long_names AS (
  SELECT country_name
  FROM Countries
  WHERE CHAR_LENGTH(country_name) > 10
)
SELECT * FROM long_names;

-- 8. Nested CTEs to get top continent by average GDP
WITH gdp_data AS (
  SELECT continent, AVG(gdp) AS avg_gdp
  FROM Countries
  GROUP BY continent
),
ranked_gdp AS (
  SELECT *, RANK() OVER (ORDER BY avg_gdp DESC) AS ranks
  FROM gdp_data
)
SELECT continent, avg_gdp FROM ranked_gdp WHERE ranks = 1;

-- 9. Procedure to insert a new country
DELIMITER //
CREATE PROCEDURE add_country(
  IN cname VARCHAR(100), IN code VARCHAR(3), IN cont VARCHAR(50),
  IN pop BIGINT, IN gdpval DECIMAL(20,2), IN capital VARCHAR(100),
  IN lang VARCHAR(50), IN tz VARCHAR(50), IN flag TEXT
)
BEGIN
  INSERT INTO Countries (country_name, country_code, continent, population, gdp, capital_city, language, time_zone, flag_url)
  VALUES (cname, code, cont, pop, gdpval, capital, lang, tz, flag);
END;
//
DELIMITER ;

CALL add_country('Wakanda', 'WAK', 'Africa', 5000000, 10000000000.00, 'Birnin Zana', 'Xhosa', 'UTC+2', 'https://wakanda.flag');

-- 10. Procedure to update GDP of a country
DELIMITER //
CREATE PROCEDURE update_gdp(IN cid INT, IN new_gdp DECIMAL(20,2))
BEGIN
  UPDATE Countries SET gdp = new_gdp WHERE country_id = cid;
END;
//
DELIMITER ;

CALL update_gdp(1, 1500000000000.00);

-- 11. Rank countries by GDP within each continent (highest GDP gets rank 1)
SELECT 
    country_name,
    continent,
    gdp,
    RANK() OVER (PARTITION BY continent ORDER BY gdp DESC) AS gdp_rank_in_continent
FROM Countries;

-- 12. Calculate each country's GDP as a percentage of the total GDP
SELECT 
    country_name,
    gdp,
    ROUND((gdp / SUM(gdp) OVER ()) * 100, 2) AS gdp_percentage_of_world
FROM Countries;

-- 13. Grant SELECT access on Countries to user 'analyst'
GRANT SELECT ON Countries TO 'analyst'@'localhost';

-- 14. Revoke INSERT access from user 'intern'
REVOKE INSERT ON Countries FROM 'intern'@'localhost';

-- 15. Grant ALL privileges to admin user
GRANT ALL PRIVILEGES ON Countries TO 'admin'@'localhost';

-- 16. Start a transaction to update multiple records
START TRANSACTION;
UPDATE Countries SET population = population + 100000 WHERE country_name = 'India';
UPDATE Countries SET gdp = gdp + 5000000000 WHERE country_name = 'India';
COMMIT;

-- 17. Rollback example
START TRANSACTION;
UPDATE Countries SET population = population * 2 WHERE country_name = 'USA';
ROLLBACK;

-- 18. Savepoint usage
START TRANSACTION;
UPDATE Countries SET gdp = gdp + 1000000000 WHERE country_name = 'Brazil';
SAVEPOINT before_update;
UPDATE Countries SET population = population - 1000000 WHERE country_name = 'Brazil';
ROLLBACK TO before_update;
COMMIT;

-- 19. Trigger to log inserts into Countries table
CREATE TABLE country_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  country_id INT,
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  action_type VARCHAR(20)
);

DELIMITER //
CREATE TRIGGER log_country_insert
AFTER INSERT ON Countries
FOR EACH ROW
BEGIN
  INSERT INTO country_logs (country_id, action_type)
  VALUES (NEW.country_id, 'INSERT');
END;
//
DELIMITER ;

-- 20. Trigger to prevent countries with population less than 10,000 from being inserted
DELIMITER //
CREATE TRIGGER prevent_small_population
BEFORE INSERT ON Countries
FOR EACH ROW
BEGIN
  IF NEW.population < 10000 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Population too small to be valid';
  END IF;
END;
//
DELIMITER ;

-- Table 2: Sports
-- 1. View of team sports only
CREATE VIEW team_sports AS
SELECT sport_id, sport_name, sport_category
FROM Sports
WHERE is_team_sport = 1;

-- 2. View of sports added after year 2000
CREATE VIEW modern_sports AS
SELECT sport_name, olympic_since_year
FROM Sports
WHERE olympic_since_year > 2000;

-- 3. View of outdoor sports with match duration over 60 minutes
CREATE VIEW long_outdoor_sports AS
SELECT sport_name, typical_duration_minutes
FROM Sports
WHERE indoor_outdoor = 'Outdoor' AND typical_duration_minutes > 60;

-- 4. Drop view if exists
DROP VIEW IF EXISTS modern_sports;

-- 5. CTE for average match duration by category
WITH category_avg_duration AS (
  SELECT sport_category, AVG(typical_duration_minutes) AS avg_duration
  FROM Sports
  GROUP BY sport_category
)
SELECT * FROM category_avg_duration;

-- 6. CTE for team vs individual sport count
WITH sport_counts AS (
  SELECT 
    CASE WHEN is_team_sport = 1 THEN 'Team' ELSE 'Individual' END AS sport_type,
    COUNT(*) AS total
  FROM Sports
  GROUP BY is_team_sport
)
SELECT * FROM sport_counts;

-- 7. CTE to list sports needing equipment with "ball"
WITH ball_sports AS (
  SELECT sport_name, equipment_required
  FROM Sports
  WHERE equipment_required LIKE '%ball%'
)
SELECT * FROM ball_sports;

-- 8. CTE to rank sports by duration
WITH ranked_sports AS (
  SELECT sport_name, typical_duration_minutes,
         RANK() OVER (ORDER BY typical_duration_minutes DESC) AS duration_rank
  FROM Sports
)
SELECT * FROM ranked_sports WHERE duration_rank <= 5;

-- 9. Stored procedure to insert a new sport
DELIMITER //
CREATE PROCEDURE add_sport(
  IN s_name VARCHAR(100), IN s_cat VARCHAR(50), IN is_team BOOLEAN,
  IN year SMALLINT, IN equipment TEXT, IN arena VARCHAR(20),
  IN duration INT, IN score_type VARCHAR(50), IN gov_body VARCHAR(100)
)
BEGIN
  INSERT INTO Sports (sport_name, sport_category, is_team_sport, olympic_since_year,
                      equipment_required, indoor_outdoor, typical_duration_minutes,
                      scoring_type, governing_body)
  VALUES (s_name, s_cat, is_team, year, equipment, arena, duration, score_type, gov_body);
END;
//
DELIMITER ;

CALL add_sport('Laser Tag', 'Combat', 1, 2024, 'Laser Gun, Vest', 'Indoor', 30, 'Points', 'World Laser Federation');

-- 10. Procedure to update sport duration
DELIMITER //
CREATE PROCEDURE update_duration(IN sportID INT, IN new_duration INT)
BEGIN
  UPDATE Sports SET typical_duration_minutes = new_duration WHERE sport_id = sportID;
END;
//
DELIMITER ;

-- 11.
-- 12.
CALL update_duration(1, 90);

-- 13. Grant SELECT access to 'coach' user
GRANT SELECT ON Sports TO 'coach'@'localhost';

-- 14. Revoke INSERT access from 'intern'
REVOKE INSERT ON Sports FROM 'intern'@'localhost';

-- 15. Grant ALL privileges to 'admin'
GRANT ALL PRIVILEGES ON Sports TO 'admin'@'localhost';

-- 16. Start transaction to update sport duration and category
START TRANSACTION;
UPDATE Sports SET typical_duration_minutes = 75 WHERE sport_name = 'Basketball';
UPDATE Sports SET sport_category = 'Ball Sport' WHERE sport_name = 'Basketball';
COMMIT;

-- 17. Rollback example
START TRANSACTION;
UPDATE Sports SET is_team_sport = 0 WHERE sport_name = 'Volleyball';
ROLLBACK;

-- 18. Savepoint example with rollback to point
START TRANSACTION;
UPDATE Sports SET olympic_since_year = 2020 WHERE sport_name = 'Skateboarding';
SAVEPOINT before_update;
UPDATE Sports SET scoring_type = 'Style Points' WHERE sport_name = 'Skateboarding';
ROLLBACK TO before_update;
COMMIT;

-- 19. Trigger to log new sports added
CREATE TABLE sport_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  sport_id INT,
  action_type VARCHAR(20),
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER log_new_sport
AFTER INSERT ON Sports
FOR EACH ROW
BEGIN
  INSERT INTO sport_log (sport_id, action_type) VALUES (NEW.sport_id, 'INSERT');
END;
//
DELIMITER ;

-- 20. Trigger to prevent adding sport with blank name
DELIMITER //
CREATE TRIGGER prevent_blank_sport_name
BEFORE INSERT ON Sports
FOR EACH ROW
BEGIN
  IF NEW.sport_name = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sport name cannot be blank';
  END IF;
END;
//
DELIMITER ;

-- Table 3: Athletes
-- 1. View showing athlete full name with country and sport
CREATE VIEW athlete_profiles AS
SELECT 
  a.athlete_id,
  CONCAT(a.first_name, ' ', a.last_name) AS full_name,
  a.gender, a.date_of_birth,
  c.country_name,
  s.sport_name
FROM Athletes a
JOIN Countries c ON a.country_id = c.country_id
JOIN Sports s ON a.sport_id = s.sport_id;

-- 2. View to list all female athletes
CREATE VIEW female_athletes AS
SELECT athlete_id, first_name, last_name, country_id
FROM Athletes
WHERE gender = 'Female';

-- 3. View of athletes born after 2000
CREATE VIEW young_athletes AS
SELECT athlete_id, first_name, last_name, date_of_birth
FROM Athletes
WHERE date_of_birth > '2000-01-01';

-- 4. Drop athlete_profiles view
DROP VIEW IF EXISTS athlete_profiles;

-- 5. CTE to calculate average height by gender
WITH avg_height_gender AS (
  SELECT gender, AVG(height_cm) AS avg_height
  FROM Athletes
  GROUP BY gender
)
SELECT * FROM avg_height_gender;

-- 6. CTE to find athletes above average weight
WITH avg_weight AS (
  SELECT AVG(weight_kg) AS avg_wt FROM Athletes
)
SELECT a.athlete_id, a.first_name, a.weight_kg
FROM Athletes a, avg_weight
WHERE a.weight_kg > avg_weight.avg_wt;

-- 7. CTE for top 5 tallest athletes
WITH ranked_athletes AS (
  SELECT athlete_id, first_name, last_name, height_cm,
         RANK() OVER (ORDER BY height_cm DESC) AS rnk
  FROM Athletes
)
SELECT * FROM ranked_athletes WHERE rnk <= 5;

-- 8. CTE to count number of athletes per country
WITH country_athlete_count AS (
  SELECT country_id, COUNT(*) AS total_athletes
  FROM Athletes
  GROUP BY country_id
)
SELECT c.country_name, total_athletes
FROM country_athlete_count cac
JOIN Countries c ON cac.country_id = c.country_id;

-- 9. Stored procedure to insert a new athlete
DELIMITER //
CREATE PROCEDURE add_athlete(
  IN fname VARCHAR(50), IN lname VARCHAR(50), IN gen ENUM('Male','Female','Other'),
  IN dob DATE, IN c_id INT, IN s_id INT, IN ht INT, IN wt INT, IN biography TEXT
)
BEGIN
  INSERT INTO Athletes (first_name, last_name, gender, date_of_birth, country_id, sport_id, height_cm, weight_kg, bio)
  VALUES (fname, lname, gen, dob, c_id, s_id, ht, wt, biography);
END;
//
DELIMITER ;

-- 10. Call procedure to add athlete
CALL add_athlete('Lia', 'Thomas', 'Female', '1999-05-21', 3, 2, 180, 72, 'An Olympic swimmer.');

-- 11. Procedure to update weight of athlete
DELIMITER //
CREATE PROCEDURE update_athlete_weight(IN aid INT, IN new_weight INT)
BEGIN
  UPDATE Athletes SET weight_kg = new_weight WHERE athlete_id = aid;
END;
//
DELIMITER ;

-- 12. Call update procedure
CALL update_athlete_weight(1, 75);

-- 13. Grant SELECT access to 'coach' user
GRANT SELECT ON Athletes TO 'coach'@'localhost';

-- 14. Revoke DELETE access from 'intern'
REVOKE DELETE ON Athletes FROM 'intern'@'localhost';

-- 15. Grant all privileges to 'admin'
GRANT ALL PRIVILEGES ON Athletes TO 'admin'@'localhost';

-- 16. Transaction to change height and weight
START TRANSACTION;
UPDATE Athletes SET height_cm = 190 WHERE athlete_id = 2;
UPDATE Athletes SET weight_kg = 85 WHERE athlete_id = 2;
COMMIT;

-- 17. Rollback weight change
START TRANSACTION;
UPDATE Athletes SET weight_kg = 200 WHERE athlete_id = 3;
ROLLBACK;

-- 18. Savepoint transaction with rollback to point
START TRANSACTION;
UPDATE Athletes SET date_of_birth = '1990-01-01' WHERE athlete_id = 4;
SAVEPOINT before_bio;
UPDATE Athletes SET bio = 'Updated biography' WHERE athlete_id = 4;
ROLLBACK TO before_bio;
COMMIT;

-- 19. Trigger to log inserts
CREATE TABLE athlete_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  athlete_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER log_athlete_insert
AFTER INSERT ON Athletes
FOR EACH ROW
BEGIN
  INSERT INTO athlete_log (athlete_id, action) VALUES (NEW.athlete_id, 'INSERT');
END;
//
DELIMITER ;

-- 20. Trigger to block underweight athletes
DELIMITER //
CREATE TRIGGER check_athlete_weight
BEFORE INSERT ON Athletes
FOR EACH ROW
BEGIN
  IF NEW.weight_kg < 30 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Athlete weight too low to register';
  END IF;
END;
//
DELIMITER ;

-- Table 4: Olympics
-- 1. View of all Summer Olympics
CREATE VIEW summer_olympics AS
SELECT olympic_id, year, city, country_id
FROM Olympics
WHERE season = 'Summer';

-- 2. View showing Olympics with more than 30 sports
CREATE VIEW large_olympics AS
SELECT year, season, city, number_of_sports
FROM Olympics
WHERE number_of_sports > 30;

-- 3. View combining year and slogan
CREATE VIEW olympic_slogans AS
SELECT year, CONCAT('"', slogan, '"') AS formatted_slogan
FROM Olympics;

-- 4. Drop a view if it exists
DROP VIEW IF EXISTS large_olympics;

-- 5. CTE for average number of sports by season
WITH avg_sports AS (
  SELECT season, AVG(number_of_sports) AS avg_sport_count
  FROM Olympics
  GROUP BY season
)
SELECT * FROM avg_sports;

-- 6. CTE to count Olympics hosted by each country
WITH olympics_by_country AS (
  SELECT country_id, COUNT(*) AS total_hosted
  FROM Olympics
  GROUP BY country_id
)
SELECT c.country_name, total_hosted
FROM olympics_by_country obc
JOIN Countries c ON obc.country_id = c.country_id;

-- 7. CTE to find Olympics with max athletes
WITH max_athletes AS (
  SELECT MAX(number_of_athletes) AS max_participants FROM Olympics
)
SELECT o.year, o.city, o.number_of_athletes
FROM Olympics o, max_athletes
WHERE o.number_of_athletes = max_athletes.max_participants;

-- 8. CTE to calculate duration in days
WITH olympic_duration AS (
  SELECT olympic_id, DATEDIFF(closing_date, opening_date) AS duration_days
  FROM Olympics
)
SELECT * FROM olympic_duration WHERE duration_days > 15;

-- 9. Stored procedure to add a new Olympics edition
DELIMITER //
CREATE PROCEDURE add_olympics(
  IN yr INT, IN seas ENUM('Summer', 'Winter'), IN host_city VARCHAR(100),
  IN host_country INT, IN open_dt DATE, IN close_dt DATE,
  IN num_sports INT, IN num_athletes INT, IN motto VARCHAR(100)
)
BEGIN
  INSERT INTO Olympics (year, season, city, country_id, opening_date, closing_date, number_of_sports, number_of_athletes, slogan)
  VALUES (yr, seas, host_city, host_country, open_dt, close_dt, num_sports, num_athletes, motto);
END;
//
DELIMITER ;

-- 10. Call the procedure
CALL add_olympics(2028, 'Summer', 'Los Angeles', 1, '2028-07-14', '2028-07-30', 32, 11000, 'Together for a better future');

-- 11. Stored procedure to update slogan
DELIMITER //
CREATE PROCEDURE update_olympic_slogan(IN oid INT, IN new_slogan VARCHAR(100))
BEGIN
  UPDATE Olympics SET slogan = new_slogan WHERE olympic_id = oid;
END;
//
DELIMITER ;

-- 12. Call procedure to update slogan
CALL update_olympic_slogan(1, 'Stronger Together');

-- 13. Grant SELECT access on Olympics to user 'reporter'
GRANT SELECT ON Olympics TO 'reporter'@'localhost';

-- 14. Revoke UPDATE access from 'volunteer'
REVOKE UPDATE ON Olympics FROM 'volunteer'@'localhost';

-- 15. Grant all privileges on Olympics to 'admin'
GRANT ALL PRIVILEGES ON Olympics TO 'admin'@'localhost';

-- 16. Transaction to modify host city and number of sports
START TRANSACTION;
UPDATE Olympics SET city = 'New Tokyo' WHERE olympic_id = 2;
UPDATE Olympics SET number_of_sports = 45 WHERE olympic_id = 2;
COMMIT;

-- 17. Rollback if closing date is wrong
START TRANSACTION;
UPDATE Olympics SET closing_date = '2025-12-31' WHERE olympic_id = 3;
ROLLBACK;

-- 18. Savepoint and rollback to before updating athletes count
START TRANSACTION;
UPDATE Olympics SET number_of_athletes = 8500 WHERE olympic_id = 4;
SAVEPOINT before_update;
UPDATE Olympics SET number_of_athletes = 8200 WHERE olympic_id = 4;
ROLLBACK TO before_update;
COMMIT;

-- 19. Create a log table for Olympics changes
CREATE TABLE olympics_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  olympic_id INT,
  action VARCHAR(20),
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log inserts into Olympics table
DELIMITER //
CREATE TRIGGER log_olympics_insert
AFTER INSERT ON Olympics
FOR EACH ROW
BEGIN
  INSERT INTO olympics_log (olympic_id, action) VALUES (NEW.olympic_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 5: Events
-- 1. View of all final events
CREATE VIEW final_events AS
SELECT event_id, event_name, gender_category, event_type
FROM Events
WHERE event_type = 'Final';

-- 2. View of events with more than 3 rounds
CREATE VIEW multiround_events AS
SELECT event_name, number_of_rounds
FROM Events
WHERE number_of_rounds > 3;

-- 3. View of all mixed gender events
CREATE VIEW mixed_events AS
SELECT event_id, event_name, distance_or_weight
FROM Events
WHERE gender_category = 'Mixed';

-- 4. Drop the view if it exists
DROP VIEW IF EXISTS final_events;

-- 5. CTE to count number of events by gender category
WITH gender_event_count AS (
  SELECT gender_category, COUNT(*) AS total_events
  FROM Events
  GROUP BY gender_category
)
SELECT * FROM gender_event_count;

-- 6. CTE to find events with scoring based on time
WITH time_based_events AS (
  SELECT * FROM Events WHERE scoring_method = 'Time'
)
SELECT event_name, distance_or_weight FROM time_based_events;

-- 7. CTE to get event count per sport
WITH sport_event_count AS (
  SELECT sport_id, COUNT(*) AS event_total
  FROM Events
  GROUP BY sport_id
)
SELECT s.sport_name, event_total
FROM sport_event_count sec
JOIN Sports s ON sec.sport_id = s.sport_id;

-- 8. CTE to find top 5 events with the most rounds
WITH ranked_events AS (
  SELECT event_id, event_name, number_of_rounds,
         RANK() OVER (ORDER BY number_of_rounds DESC) AS rnk
  FROM Events
)
SELECT * FROM ranked_events WHERE rnk <= 5;

-- 9. Stored procedure to insert a new event
DELIMITER //
CREATE PROCEDURE add_event(
  IN ename VARCHAR(100), IN sid INT, IN gender ENUM('Men','Women','Mixed'),
  IN etype VARCHAR(50), IN dist_weight VARCHAR(50), IN rounds INT,
  IN score_method VARCHAR(50), IN oid INT, IN venue VARCHAR(100)
)
BEGIN
  INSERT INTO Events (
    event_name, sport_id, gender_category, event_type, distance_or_weight,
    number_of_rounds, scoring_method, olympic_id, venue_name
  ) VALUES (
    ename, sid, gender, etype, dist_weight, rounds, score_method, oid, venue
  );
END;
//
DELIMITER ;

-- 10. Call procedure to insert a new event
CALL add_event('100m Sprint Final', 1, 'Men', 'Final', '100m', 2, 'Time', 1, 'National Stadium');

-- 11. Stored procedure to update venue
DELIMITER //
CREATE PROCEDURE update_event_venue(IN eid INT, IN new_venue VARCHAR(100))
BEGIN
  UPDATE Events SET venue_name = new_venue WHERE event_id = eid;
END;
//
DELIMITER ;

-- 12. Call procedure to update venue
CALL update_event_venue(1, 'Olympic Arena');

-- 13. Grant SELECT on Events table to 'analyst'
GRANT SELECT ON Events TO 'analyst'@'localhost';

-- 14. Revoke DELETE permission from 'editor'
REVOKE DELETE ON Events FROM 'editor'@'localhost';

-- 15. Grant all privileges to 'admin'
GRANT ALL PRIVILEGES ON Events TO 'admin'@'localhost';

-- 16. Transaction to update event type and scoring
START TRANSACTION;
UPDATE Events SET event_type = 'Semi Final' WHERE event_id = 2;
UPDATE Events SET scoring_method = 'Points' WHERE event_id = 2;
COMMIT;

-- 17. Transaction with rollback
START TRANSACTION;
UPDATE Events SET distance_or_weight = '3000m' WHERE event_id = 3;
ROLLBACK;

-- 18. Savepoint with rollback
START TRANSACTION;
UPDATE Events SET number_of_rounds = 6 WHERE event_id = 4;
SAVEPOINT before_scoring;
UPDATE Events SET scoring_method = 'Goals' WHERE event_id = 4;
ROLLBACK TO before_scoring;
COMMIT;

-- 19. Create event log table
CREATE TABLE event_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  event_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log insert into Events
DELIMITER //
CREATE TRIGGER log_event_insert
AFTER INSERT ON Events
FOR EACH ROW
BEGIN
  INSERT INTO event_log (event_id, action) VALUES (NEW.event_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 6: Venues
-- 1. View of all outdoor venues
CREATE VIEW outdoor_venues AS
SELECT venue_id, venue_name, location
FROM Venues
WHERE venue_type = 'Outdoor';

-- 2. View of venues built before 2000
CREATE VIEW old_venues AS
SELECT venue_name, construction_year
FROM Venues
WHERE construction_year < 2000;

-- 3. View showing venue names and their associated Olympic year
CREATE VIEW venue_olympics AS
SELECT v.venue_name, o.year AS olympic_year
FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id;

-- 4. Drop view if it exists
DROP VIEW IF EXISTS outdoor_venues;

-- 5. CTE to count venues by type
WITH venue_type_count AS (
  SELECT venue_type, COUNT(*) AS total
  FROM Venues
  GROUP BY venue_type
)
SELECT * FROM venue_type_count;

-- 6. CTE to find venues with large capacity (> 50,000)
WITH large_venues AS (
  SELECT * FROM Venues WHERE capacity > 50000
)
SELECT venue_name, capacity FROM large_venues;

-- 7. CTE to list venues that have been renovated
WITH renovated AS (
  SELECT venue_name, renovated_year
  FROM Venues
  WHERE renovated_year IS NOT NULL
)
SELECT * FROM renovated;

-- 8. CTE to find top 3 newest venues
WITH recent_venues AS (
  SELECT *, RANK() OVER (ORDER BY construction_year DESC) AS rank_order
  FROM Venues
)
SELECT venue_name, construction_year
FROM recent_venues
WHERE rank_order <= 3;

-- 9. Stored procedure to add a new venue
DELIMITER //
CREATE PROCEDURE add_venue(
  IN vname VARCHAR(100), IN vloc VARCHAR(100), IN cap INT, IN vtype VARCHAR(50),
  IN surface VARCHAR(50), IN c_year INT, IN r_year INT,
  IN oid INT, IN cid INT
)
BEGIN
  INSERT INTO Venues (
    venue_name, location, capacity, venue_type, surface_type,
    construction_year, renovated_year, olympic_id, country_id
  ) VALUES (
    vname, vloc, cap, vtype, surface, c_year, r_year, oid, cid
  );
END;
//
DELIMITER ;

-- 10. Call procedure to add a venue
CALL add_venue('Oceanic Aquatics Center', 'Tokyo', 12000, 'Aquatic', 'Water', 2018, 2020, 5, 2);

-- 11. Stored procedure to update a venue's capacity
DELIMITER //
CREATE PROCEDURE update_venue_capacity(IN vid INT, IN new_cap INT)
BEGIN
  UPDATE Venues SET capacity = new_cap WHERE venue_id = vid;
END;
//
DELIMITER ;

-- 12. Call the update capacity procedure
CALL update_venue_capacity(1, 55000);

-- 13. Grant SELECT on Venues to 'viewer'
GRANT SELECT ON Venues TO 'viewer'@'localhost';

-- 14. Revoke UPDATE on Venues from 'guest'
REVOKE UPDATE ON Venues FROM 'guest'@'localhost';

-- 15. Grant ALL privileges on Venues to 'admin'
GRANT ALL PRIVILEGES ON Venues TO 'admin'@'localhost';

-- 16. Transaction: change venue surface and capacity
START TRANSACTION;
UPDATE Venues SET surface_type = 'Synthetic' WHERE venue_id = 2;
UPDATE Venues SET capacity = 60000 WHERE venue_id = 2;
COMMIT;

-- 17. Transaction with rollback
START TRANSACTION;
UPDATE Venues SET location = 'Changed City' WHERE venue_id = 3;
ROLLBACK;

-- 18. Transaction with savepoint
START TRANSACTION;
UPDATE Venues SET venue_type = 'Indoor' WHERE venue_id = 4;
SAVEPOINT type_update;
UPDATE Venues SET surface_type = 'Hardwood' WHERE venue_id = 4;
ROLLBACK TO type_update;
COMMIT;

-- 19. Create a venue_log table
CREATE TABLE venue_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  venue_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log insert into Venues
DELIMITER //
CREATE TRIGGER log_venue_insert
AFTER INSERT ON Venues
FOR EACH ROW
BEGIN
  INSERT INTO venue_log (venue_id, action) VALUES (NEW.venue_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 7: Teams
-- 1. View of teams with more than 10 athletes
CREATE VIEW large_teams AS
SELECT team_id, team_name, total_athletes
FROM Teams
WHERE total_athletes > 10;

-- 2. View of teams with medals won
CREATE VIEW medal_winning_teams AS
SELECT team_name, total_medals
FROM Teams
WHERE total_medals > 0;

-- 3. View teams and their coach names
CREATE VIEW team_coaches AS
SELECT team_name, team_coach
FROM Teams
WHERE team_coach IS NOT NULL;

-- 4. Drop view if exists
DROP VIEW IF EXISTS large_teams;

-- 5. CTE to count teams by sport
WITH sport_team_count AS (
  SELECT sport_id, COUNT(*) AS team_count
  FROM Teams
  GROUP BY sport_id
)
SELECT s.sport_name, team_count
FROM sport_team_count stc
JOIN Sports s ON stc.sport_id = s.sport_id;

-- 6. CTE to find teams formed before 2000
WITH old_teams AS (
  SELECT team_name, formation_year
  FROM Teams
  WHERE formation_year < 2000
)
SELECT * FROM old_teams;

-- 7. CTE to find top 3 teams with most medals
WITH top_medal_teams AS (
  SELECT team_id, team_name, total_medals,
         RANK() OVER (ORDER BY total_medals DESC) AS rank_medals
  FROM Teams
)
SELECT team_name, total_medals
FROM top_medal_teams
WHERE rank_medals <= 3;

-- 8. CTE to count teams by country
WITH country_team_count AS (
  SELECT country_id, COUNT(*) AS total_teams
  FROM Teams
  GROUP BY country_id
)
SELECT c.country_name, total_teams
FROM country_team_count ctc
JOIN Countries c ON ctc.country_id = c.country_id;

-- 9. Stored procedure to add a new team
DELIMITER //
CREATE PROCEDURE add_team(
  IN tname VARCHAR(100), IN cid INT, IN oid INT, IN sid INT,
  IN athletes INT, IN medals INT, IN captain VARCHAR(100),
  IN coach VARCHAR(100), IN form_year INT
)
BEGIN
  INSERT INTO Teams (
    team_name, country_id, olympic_id, sport_id,
    total_athletes, total_medals, team_captain, team_coach, formation_year
  ) VALUES (
    tname, cid, oid, sid, athletes, medals, captain, coach, form_year
  );
END;
//
DELIMITER ;

-- 10. Call procedure to add a team
CALL add_team('Dream Warriors', 1, 2, 3, 15, 7, 'John Doe', 'Jane Smith', 1995);

-- 11. Stored procedure to update team captain
DELIMITER //
CREATE PROCEDURE update_team_captain(
  IN tid INT, IN new_captain VARCHAR(100)
)
BEGIN
  UPDATE Teams SET team_captain = new_captain WHERE team_id = tid;
END;
//
DELIMITER ;

-- 12. Call procedure to update team captain
CALL update_team_captain(1, 'Michael Johnson');

-- 13. Grant SELECT permission on Teams to 'viewer'
GRANT SELECT ON Teams TO 'viewer'@'localhost';

-- 14. Revoke DELETE permission on Teams from 'guest'
REVOKE DELETE ON Teams FROM 'guest'@'localhost';

-- 15. Grant ALL privileges on Teams to 'admin'
GRANT ALL PRIVILEGES ON Teams TO 'admin'@'localhost';

-- 16. Transaction to update total medals and athletes
START TRANSACTION;
UPDATE Teams SET total_medals = total_medals + 1 WHERE team_id = 1;
UPDATE Teams SET total_athletes = total_athletes + 1 WHERE team_id = 1;
COMMIT;

-- 17. Transaction rollback example
START TRANSACTION;
UPDATE Teams SET total_athletes = 20 WHERE team_id = 2;
ROLLBACK;

-- 18. Savepoint in transaction
START TRANSACTION;
UPDATE Teams SET team_coach = 'New Coach' WHERE team_id = 3;
SAVEPOINT coach_update;
UPDATE Teams SET formation_year = 2020 WHERE team_id = 3;
ROLLBACK TO coach_update;
COMMIT;

-- 19. Create a team_log table to log actions
CREATE TABLE team_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  team_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log inserts into Teams
DELIMITER //
CREATE TRIGGER log_team_insert
AFTER INSERT ON Teams
FOR EACH ROW
BEGIN
  INSERT INTO team_log (team_id, action) VALUES (NEW.team_id, 'INSERT');
END;
//
DELIMITER ;
 
 -- Table 8: Medals
 -- 1. View of all Gold medal winners
CREATE VIEW gold_medalists AS
SELECT medal_id, athlete_id, event_id, medal_date
FROM Medals
WHERE medal_type = 'Gold';

-- 2. View of medals won by country
CREATE VIEW country_medal_counts AS
SELECT country_id, medal_type, COUNT(*) AS total_medals
FROM Medals
GROUP BY country_id, medal_type;

-- 3. View medals by event category
CREATE VIEW medals_by_category AS
SELECT event_category, medal_type, COUNT(*) AS count_medals
FROM Medals
GROUP BY event_category, medal_type;

-- 4. Drop view if exists
DROP VIEW IF EXISTS gold_medalists;

-- 5. CTE to count medals by athlete
WITH athlete_medal_counts AS (
  SELECT athlete_id, COUNT(*) AS medals_won
  FROM Medals
  GROUP BY athlete_id
)
SELECT a.first_name, a.last_name, medals_won
FROM athlete_medal_counts amc
JOIN Athletes a ON amc.athlete_id = a.athlete_id
ORDER BY medals_won DESC;

-- 6. CTE to count medals by team
WITH team_medal_counts AS (
  SELECT team_id, COUNT(*) AS medals_won
  FROM Medals
  WHERE team_id IS NOT NULL
  GROUP BY team_id
)
SELECT t.team_name, medals_won
FROM team_medal_counts tmc
JOIN Teams t ON tmc.team_id = t.team_id
ORDER BY medals_won DESC;

-- 7. CTE to count medals by Olympic edition
WITH olympic_medals AS (
  SELECT olympic_id, medal_type, COUNT(*) AS count_medals
  FROM Medals
  GROUP BY olympic_id, medal_type
)
SELECT o.year, o.season, medal_type, count_medals
FROM olympic_medals om
JOIN Olympics o ON om.olympic_id = o.olympic_id;

-- 8. CTE to get medal count by venue
WITH venue_medal_counts AS (
  SELECT venue_id, COUNT(*) AS total_medals
  FROM Medals
  GROUP BY venue_id
)
SELECT v.venue_name, total_medals
FROM venue_medal_counts vmc
JOIN Venues v ON vmc.venue_id = v.venue_id;

-- 9. Stored procedure to add a medal record
DELIMITER //
CREATE PROCEDURE add_medal(
  IN aid INT, IN eid INT, IN mtype ENUM('Gold','Silver','Bronze'),
  IN tid INT, IN cid INT, IN oid INT, IN mdate DATE,
  IN ecat VARCHAR(100), IN vid INT
)
BEGIN
  INSERT INTO Medals (
    athlete_id, event_id, medal_type, team_id, country_id, olympic_id,
    medal_date, event_category, venue_id
  ) VALUES (
    aid, eid, mtype, tid, cid, oid, mdate, ecat, vid
  );
END;
//
DELIMITER ;

-- 10. Call procedure to insert a medal
CALL add_medal(1, 5, 'Gold', NULL, 1, 1, '2024-07-28', 'Men\'s 100m', 2);

-- 11. Stored procedure to update medal type
DELIMITER //
CREATE PROCEDURE update_medal_type(
  IN mid INT, IN new_type ENUM('Gold','Silver','Bronze')
)
BEGIN
  UPDATE Medals SET medal_type = new_type WHERE medal_id = mid;
END;
//
DELIMITER ;

-- 12. Call procedure to update medal type
CALL update_medal_type(3, 'Silver');

-- 13. Grant SELECT permission on Medals to 'reporter'
GRANT SELECT ON Medals TO 'reporter'@'localhost';

-- 14. Revoke UPDATE permission on Medals from 'guest'
REVOKE UPDATE ON Medals FROM 'guest'@'localhost';

-- 15. Grant ALL privileges on Medals to 'admin'
GRANT ALL PRIVILEGES ON Medals TO 'admin'@'localhost';

-- 16. Transaction to update medal date and event category
START TRANSACTION;
UPDATE Medals SET medal_date = '2024-08-01' WHERE medal_id = 4;
UPDATE Medals SET event_category = 'Women\'s Marathon' WHERE medal_id = 4;
COMMIT;

-- 17. Transaction rollback example
START TRANSACTION;
UPDATE Medals SET medal_type = 'Bronze' WHERE medal_id = 5;
ROLLBACK;

-- 18. Savepoint in transaction
START TRANSACTION;
UPDATE Medals SET team_id = 10 WHERE medal_id = 6;
SAVEPOINT team_update;
UPDATE Medals SET medal_type = 'Gold' WHERE medal_id = 6;
ROLLBACK TO team_update;
COMMIT;

-- 19. Create medal_log table for audit
CREATE TABLE medal_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  medal_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log medal inserts
DELIMITER //
CREATE TRIGGER log_medal_insert
AFTER INSERT ON Medals
FOR EACH ROW
BEGIN
  INSERT INTO medal_log (medal_id, action) VALUES (NEW.medal_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 9: Coaches
-- 1. View of all coaches with over 10 years of experience
CREATE VIEW experienced_coaches AS
SELECT coach_id, first_name, last_name, years_of_experience
FROM Coaches
WHERE years_of_experience > 10;

-- 2. View of coaches assigned to a team
CREATE VIEW team_coaches AS
SELECT coach_id, first_name, last_name, team_id
FROM Coaches
WHERE team_id IS NOT NULL;

-- 3. View showing full name and sport of each coach
CREATE VIEW coach_sport_view AS
SELECT CONCAT(first_name, ' ', last_name) AS full_name, s.sport_name
FROM Coaches c
JOIN Sports s ON c.sport_id = s.sport_id;

-- 4. Drop view if exists
DROP VIEW IF EXISTS team_coaches;

-- 5. CTE to count coaches per sport
WITH sport_coach_count AS (
  SELECT sport_id, COUNT(*) AS coach_total
  FROM Coaches
  GROUP BY sport_id
)
SELECT s.sport_name, coach_total
FROM sport_coach_count scc
JOIN Sports s ON scc.sport_id = s.sport_id;

-- 6. CTE to list coaches with Level A certification
WITH level_a_coaches AS (
  SELECT * FROM Coaches WHERE certification_level = 'Level A'
)
SELECT first_name, last_name, years_of_experience FROM level_a_coaches;

-- 7. CTE to count coaches per country
WITH country_coach_count AS (
  SELECT country_id, COUNT(*) AS total_coaches
  FROM Coaches
  GROUP BY country_id
)
SELECT co.country_name, total_coaches
FROM country_coach_count ccc
JOIN Countries co ON ccc.country_id = co.country_id;

-- 8. CTE to get youngest 5 coaches
WITH ranked_coaches AS (
  SELECT *, RANK() OVER (ORDER BY date_of_birth DESC) AS rnk
  FROM Coaches
)
SELECT first_name, last_name, date_of_birth FROM ranked_coaches
WHERE rnk <= 5;

-- 9. Stored procedure to insert a new coach
DELIMITER //
CREATE PROCEDURE add_coach(
  IN fname VARCHAR(50), IN lname VARCHAR(50), IN gen ENUM('Male','Female','Other'),
  IN dob DATE, IN cid INT, IN sid INT, IN tid INT,
  IN exp INT, IN cert VARCHAR(50)
)
BEGIN
  INSERT INTO Coaches (
    first_name, last_name, gender, date_of_birth,
    country_id, sport_id, team_id, years_of_experience, certification_level
  ) VALUES (
    fname, lname, gen, dob, cid, sid, tid, exp, cert
  );
END;
//
DELIMITER ;

-- 10. Call procedure to insert new coach
CALL add_coach('Anita', 'Rao', 'Female', '1980-05-23', 1, 2, NULL, 15, 'Level A');

-- 11. Stored procedure to update team assignment
DELIMITER //
CREATE PROCEDURE assign_team_to_coach(IN cid INT, IN tid INT)
BEGIN
  UPDATE Coaches SET team_id = tid WHERE coach_id = cid;
END;
//
DELIMITER ;

-- 12. Call to assign a coach to a team
CALL assign_team_to_coach(1, 3);

-- 13. Grant SELECT permission on Coaches to 'viewer'
GRANT SELECT ON Coaches TO 'viewer'@'localhost';

-- 14. Revoke INSERT permission from 'readonly_user'
REVOKE INSERT ON Coaches FROM 'readonly_user'@'localhost';

-- 15. Grant all privileges on Coaches table to 'admin'
GRANT ALL PRIVILEGES ON Coaches TO 'admin'@'localhost';

-- 16. Transaction to update experience and certification level
START TRANSACTION;
UPDATE Coaches SET years_of_experience = 12 WHERE coach_id = 2;
UPDATE Coaches SET certification_level = 'Level B' WHERE coach_id = 2;
COMMIT;

-- 17. Transaction with rollback
START TRANSACTION;
UPDATE Coaches SET team_id = 4 WHERE coach_id = 5;
ROLLBACK;

-- 18. Savepoint with rollback example
START TRANSACTION;
UPDATE Coaches SET certification_level = 'Level A' WHERE coach_id = 6;
SAVEPOINT before_exp_update;
UPDATE Coaches SET years_of_experience = 20 WHERE coach_id = 6;
ROLLBACK TO before_exp_update;
COMMIT;

-- 19. Create audit table for coach actions
CREATE TABLE coach_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  coach_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log coach insert
DELIMITER //
CREATE TRIGGER log_coach_insert
AFTER INSERT ON Coaches
FOR EACH ROW
BEGIN
  INSERT INTO coach_log (coach_id, action)
  VALUES (NEW.coach_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 10: Stadiums
-- 1. View of all main Olympic stadiums
CREATE VIEW main_stadiums AS
SELECT stadium_id, stadium_name, city
FROM Stadiums
WHERE is_main_stadium = TRUE;

-- 2. View of stadiums with capacity above 50,000
CREATE VIEW large_stadiums AS
SELECT stadium_name, capacity, city
FROM Stadiums
WHERE capacity > 50000;

-- 3. View listing stadiums by type and surface
CREATE VIEW stadium_surface_type AS
SELECT stadium_name, stadium_type, surface_type
FROM Stadiums;

-- 4. Drop the main stadium view if it exists
DROP VIEW IF EXISTS main_stadiums;

-- 5. CTE to count number of stadiums per country
WITH stadium_count_per_country AS (
  SELECT country_id, COUNT(*) AS stadium_total
  FROM Stadiums
  GROUP BY country_id
)
SELECT c.country_name, stadium_total
FROM stadium_count_per_country sc
JOIN Countries c ON sc.country_id = c.country_id;

-- 6. CTE to find stadiums built before the year 2000
WITH old_stadiums AS (
  SELECT * FROM Stadiums WHERE year_built < 2000
)
SELECT stadium_name, city, year_built FROM old_stadiums;

-- 7. CTE to get Olympic stadium count
WITH olympic_stadiums AS (
  SELECT olympic_id, COUNT(*) AS total_stadiums
  FROM Stadiums
  GROUP BY olympic_id
)
SELECT o.year, o.city, total_stadiums
FROM olympic_stadiums os
JOIN Olympics o ON os.olympic_id = o.olympic_id;

-- 8. CTE to find top 3 stadiums with highest capacity
WITH ranked_stadiums AS (
  SELECT *, RANK() OVER (ORDER BY capacity DESC) AS rnk
  FROM Stadiums
)
SELECT stadium_name, capacity FROM ranked_stadiums WHERE rnk <= 3;

-- 9. Stored procedure to insert a new stadium
DELIMITER //
CREATE PROCEDURE add_stadium(
  IN sname VARCHAR(100), IN scity VARCHAR(50), IN cid INT, IN cap INT,
  IN ybuilt INT, IN stype VARCHAR(50), IN ismain BOOLEAN,
  IN surface VARCHAR(50), IN oid INT
)
BEGIN
  INSERT INTO Stadiums (
    stadium_name, city, country_id, capacity, year_built,
    stadium_type, is_main_stadium, surface_type, olympic_id
  ) VALUES (
    sname, scity, cid, cap, ybuilt, stype, ismain, surface, oid
  );
END;
//
DELIMITER ;

-- 10. Call the procedure to insert a stadium
CALL add_stadium('Sunshine Stadium', 'Tokyo', 2, 60000, 1988, 'Outdoor', TRUE, 'Grass', 1);

-- 11. Stored procedure to update stadium surface type
DELIMITER //
CREATE PROCEDURE update_stadium_surface(IN sid INT, IN new_surface VARCHAR(50))
BEGIN
  UPDATE Stadiums SET surface_type = new_surface WHERE stadium_id = sid;
END;
//
DELIMITER ;

-- 12. Call procedure to update surface type
CALL update_stadium_surface(1, 'Synthetic');

-- 13. Grant SELECT on Stadiums to user 'analyst'
GRANT SELECT ON Stadiums TO 'analyst'@'localhost';

-- 14. Revoke DELETE on Stadiums from 'guest_user'
REVOKE DELETE ON Stadiums FROM 'guest_user'@'localhost';

-- 15. Grant ALL privileges to 'admin_user'
GRANT ALL PRIVILEGES ON Stadiums TO 'admin_user'@'localhost';

-- 16. Transaction to update type and main status
START TRANSACTION;
UPDATE Stadiums SET stadium_type = 'Dome' WHERE stadium_id = 2;
UPDATE Stadiums SET is_main_stadium = TRUE WHERE stadium_id = 2;
COMMIT;

-- 17. Transaction with rollback
START TRANSACTION;
UPDATE Stadiums SET capacity = 100000 WHERE stadium_id = 3;
ROLLBACK;

-- 18. Savepoint and rollback example
START TRANSACTION;
UPDATE Stadiums SET capacity = 75000 WHERE stadium_id = 4;
SAVEPOINT before_surface_change;
UPDATE Stadiums SET surface_type = 'Clay' WHERE stadium_id = 4;
ROLLBACK TO before_surface_change;
COMMIT;

-- 19. Create stadium log table
CREATE TABLE stadium_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  stadium_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log stadium inserts
DELIMITER //
CREATE TRIGGER log_stadium_insert
AFTER INSERT ON Stadiums
FOR EACH ROW
BEGIN
  INSERT INTO stadium_log (stadium_id, action) VALUES (NEW.stadium_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 11: Sponsors
-- 1. View showing all global sponsors
CREATE VIEW global_sponsors AS
SELECT sponsor_id, sponsor_name, amount_sponsored
FROM Sponsors
WHERE sponsor_type = 'Global';

-- 2. View showing sponsors who donated more than 1 million
CREATE VIEW major_sponsors AS
SELECT sponsor_name, amount_sponsored
FROM Sponsors
WHERE amount_sponsored > 1000000;

-- 3. View to display sponsor contact details
CREATE VIEW sponsor_contacts AS
SELECT sponsor_name, contact_email, contact_phone
FROM Sponsors;

-- 4. Drop global_sponsors view if exists
DROP VIEW IF EXISTS global_sponsors;

-- 5. CTE to count sponsors by country
WITH sponsor_country_count AS (
  SELECT country_id, COUNT(*) AS sponsor_total
  FROM Sponsors
  GROUP BY country_id
)
SELECT c.country_name, sponsor_total
FROM sponsor_country_count scc
JOIN Countries c ON scc.country_id = c.country_id;

-- 6. CTE to calculate total sponsored amount per Olympic edition
WITH sponsor_olympic_amount AS (
  SELECT olympic_id, SUM(amount_sponsored) AS total_amount
  FROM Sponsors
  GROUP BY olympic_id
)
SELECT o.year, o.city, total_amount
FROM sponsor_olympic_amount soa
JOIN Olympics o ON soa.olympic_id = o.olympic_id;

-- 7. CTE to find sponsors for athletes only
WITH athlete_sponsors AS (
  SELECT * FROM Sponsors WHERE sponsored_entity_type = 'Athlete'
)
SELECT sponsor_name, amount_sponsored FROM athlete_sponsors;

-- 8. CTE to list top 5 highest paying sponsors
WITH sponsor_ranking AS (
  SELECT *, RANK() OVER (ORDER BY amount_sponsored DESC) AS rnk
  FROM Sponsors
)
SELECT sponsor_name, amount_sponsored
FROM sponsor_ranking
WHERE rnk <= 5;

-- 9. Stored procedure to add a new sponsor
DELIMITER //
CREATE PROCEDURE add_sponsor(
  IN sname VARCHAR(100), IN stype VARCHAR(50), IN cid INT,
  IN email VARCHAR(100), IN phone VARCHAR(20),
  IN amount DECIMAL(15,2), IN oid INT,
  IN entity_type ENUM('Team','Athlete','Event'), IN entity_id INT
)
BEGIN
  INSERT INTO Sponsors (
    sponsor_name, sponsor_type, country_id, contact_email, contact_phone,
    amount_sponsored, olympic_id, sponsored_entity_type, sponsored_entity_id
  )
  VALUES (
    sname, stype, cid, email, phone, amount, oid, entity_type, entity_id
  );
END;
//
DELIMITER ;

-- 10. Call stored procedure to insert sponsor
CALL add_sponsor('Nike', 'Global', 1, 'contact@nike.com', '1234567890', 2500000.00, 1, 'Athlete', 101);

-- 11. Stored procedure to update sponsor amount
DELIMITER //
CREATE PROCEDURE update_sponsor_amount(IN sid INT, IN new_amount DECIMAL(15,2))
BEGIN
  UPDATE Sponsors SET amount_sponsored = new_amount WHERE sponsor_id = sid;
END;
//
DELIMITER ;

-- 12. Call to update sponsor amount
CALL update_sponsor_amount(1, 3000000.00);

-- 13. Grant SELECT access on Sponsors to analyst
GRANT SELECT ON Sponsors TO 'analyst'@'localhost';

-- 14. Revoke UPDATE access from user editor
REVOKE UPDATE ON Sponsors FROM 'editor'@'localhost';

-- 15. Grant all privileges to admin
GRANT ALL PRIVILEGES ON Sponsors TO 'admin'@'localhost';

-- 16. Transaction to update sponsor type and amount
START TRANSACTION;
UPDATE Sponsors SET sponsor_type = 'National' WHERE sponsor_id = 2;
UPDATE Sponsors SET amount_sponsored = 750000 WHERE sponsor_id = 2;
COMMIT;

-- 17. Transaction with rollback
START TRANSACTION;
UPDATE Sponsors SET contact_email = 'fake@domain.com' WHERE sponsor_id = 3;
ROLLBACK;

-- 18. Savepoint with rollback
START TRANSACTION;
UPDATE Sponsors SET contact_phone = '9876543210' WHERE sponsor_id = 4;
SAVEPOINT before_amount_change;
UPDATE Sponsors SET amount_sponsored = 500000 WHERE sponsor_id = 4;
ROLLBACK TO before_amount_change;
COMMIT;

-- 19. Create sponsor_log table
CREATE TABLE sponsor_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  sponsor_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log sponsor inserts
DELIMITER //
CREATE TRIGGER log_sponsor_insert
AFTER INSERT ON Sponsors
FOR EACH ROW
BEGIN
  INSERT INTO sponsor_log (sponsor_id, action) VALUES (NEW.sponsor_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 12: Matches
-- 1. View of all completed matches
CREATE VIEW completed_matches AS
SELECT match_id, match_date, team1_id, team2_id, winner_team_id
FROM Matches
WHERE match_status = 'Completed';

-- 2. View of upcoming (scheduled) matches
CREATE VIEW upcoming_matches AS
SELECT match_id, match_date, start_time, venue_id
FROM Matches
WHERE match_status = 'Scheduled';

-- 3. View showing match durations (in minutes) for completed matches
CREATE VIEW match_durations AS
SELECT match_id, TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes
FROM Matches
WHERE match_status = 'Completed';

-- 4. Drop view if exists
DROP VIEW IF EXISTS upcoming_matches;

-- 5. CTE to count matches per venue
WITH venue_match_count AS (
  SELECT venue_id, COUNT(*) AS total_matches
  FROM Matches
  GROUP BY venue_id
)
SELECT v.venue_name, total_matches
FROM venue_match_count vmc
JOIN Venues v ON vmc.venue_id = v.venue_id;

-- 6. CTE to count matches per event
WITH event_match_count AS (
  SELECT event_id, COUNT(*) AS total_matches
  FROM Matches
  GROUP BY event_id
)
SELECT e.event_name, total_matches
FROM event_match_count emc
JOIN Events e ON emc.event_id = e.event_id;

-- 7. CTE to find matches played between same teams
WITH duplicate_matches AS (
  SELECT team1_id, team2_id, COUNT(*) AS match_count
  FROM Matches
  GROUP BY team1_id, team2_id
  HAVING COUNT(*) > 1
)
SELECT * FROM duplicate_matches;

-- 8. CTE for top 5 venues with most matches
WITH venue_ranking AS (
  SELECT venue_id, COUNT(*) AS total,
         RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
  FROM Matches
  GROUP BY venue_id
)
SELECT v.venue_name, total
FROM venue_ranking vr
JOIN Venues v ON vr.venue_id = v.venue_id
WHERE rnk <= 5;

-- 9. Procedure to insert a new match
DELIMITER //
CREATE PROCEDURE add_match(
  IN eid INT, IN t1 INT, IN t2 INT, IN mdate DATE,
  IN stime TIME, IN etime TIME, IN vid INT
)
BEGIN
  INSERT INTO Matches (
    event_id, team1_id, team2_id, match_date,
    start_time, end_time, venue_id
  ) VALUES (
    eid, t1, t2, mdate, stime, etime, vid
  );
END;
//
DELIMITER ;

-- 10. Call the add_match procedure
CALL add_match(1, 10, 11, '2025-07-21', '10:00:00', '11:30:00', 3);

-- 11. Procedure to update match winner and status
DELIMITER //
CREATE PROCEDURE update_match_result(IN mid INT, IN winner INT)
BEGIN
  UPDATE Matches
  SET winner_team_id = winner, match_status = 'Completed'
  WHERE match_id = mid;
END;
//
DELIMITER ;

-- 12. Call the update_match_result procedure
CALL update_match_result(1, 10);

-- 13. Grant SELECT on Matches to analyst
GRANT SELECT ON Matches TO 'analyst'@'localhost';

-- 14. Revoke INSERT from editor
REVOKE INSERT ON Matches FROM 'editor'@'localhost';

-- 15. Grant full access to admin
GRANT ALL PRIVILEGES ON Matches TO 'admin'@'localhost';

-- 16. Transaction to cancel a match
START TRANSACTION;
UPDATE Matches SET match_status = 'Cancelled' WHERE match_id = 4;
COMMIT;

-- 17. Transaction with rollback for wrong update
START TRANSACTION;
UPDATE Matches SET winner_team_id = 5 WHERE match_id = 6;
ROLLBACK;

-- 18. Savepoint use: change winner and rollback winner only
START TRANSACTION;
UPDATE Matches SET winner_team_id = 9 WHERE match_id = 2;
SAVEPOINT before_status;
UPDATE Matches SET match_status = 'Completed' WHERE match_id = 2;
ROLLBACK TO before_status;
COMMIT;

-- 19. Create match log table
CREATE TABLE match_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  match_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log inserts into Matches
DELIMITER //
CREATE TRIGGER log_match_insert
AFTER INSERT ON Matches
FOR EACH ROW
BEGIN
  INSERT INTO match_log (match_id, action)
  VALUES (NEW.match_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 13: Broadcasts
-- 1. View of all broadcasts done on TV platform
CREATE VIEW tv_broadcasts AS
SELECT broadcast_id, broadcaster_name, event_id, broadcast_date
FROM Broadcasts
WHERE platform = 'TV';

-- 2. View showing high viewership broadcasts (above 1 million)
CREATE VIEW high_viewership AS
SELECT broadcast_id, broadcaster_name, viewership_estimate
FROM Broadcasts
WHERE viewership_estimate > 1000000;

-- 3. View for broadcasts with known end time
CREATE VIEW finished_broadcasts AS
SELECT broadcast_id, broadcaster_name, start_time, end_time
FROM Broadcasts
WHERE end_time IS NOT NULL;

-- 4. Drop a view if it exists
DROP VIEW IF EXISTS tv_broadcasts;

-- 5. CTE to count broadcasts per platform
WITH platform_counts AS (
  SELECT platform, COUNT(*) AS total_broadcasts
  FROM Broadcasts
  GROUP BY platform
)
SELECT * FROM platform_counts;

-- 6. CTE to find average viewership per language
WITH language_avg_view AS (
  SELECT language, AVG(viewership_estimate) AS avg_viewers
  FROM Broadcasts
  GROUP BY language
)
SELECT * FROM language_avg_view;

-- 7. CTE to count broadcasts per broadcaster
WITH broadcaster_count AS (
  SELECT broadcaster_name, COUNT(*) AS total
  FROM Broadcasts
  GROUP BY broadcaster_name
)
SELECT * FROM broadcaster_count;

-- 8. CTE to find top 5 broadcasts by viewership
WITH ranked_broadcasts AS (
  SELECT broadcast_id, broadcaster_name, viewership_estimate,
         RANK() OVER (ORDER BY viewership_estimate DESC) AS rnk
  FROM Broadcasts
)
SELECT * FROM ranked_broadcasts WHERE rnk <= 5;

-- 9. Procedure to insert new broadcast
DELIMITER //
CREATE PROCEDURE add_broadcast(
  IN eid INT, IN bname VARCHAR(100), IN cid INT,
  IN lang VARCHAR(50), IN bdate DATE,
  IN stime TIME, IN etime TIME,
  IN plat ENUM('TV', 'Online', 'Radio'), IN viewers INT
)
BEGIN
  INSERT INTO Broadcasts (
    event_id, broadcaster_name, country_id, language,
    broadcast_date, start_time, end_time, platform, viewership_estimate
  )
  VALUES (
    eid, bname, cid, lang, bdate, stime, etime, plat, viewers
  );
END;
//
DELIMITER ;

-- 10. Call procedure to insert sample broadcast
CALL add_broadcast(2, 'ESPN', 1, 'English', '2025-07-22', '14:00:00', '16:00:00', 'TV', 2500000);

-- 11. Procedure to update viewership estimate
DELIMITER //
CREATE PROCEDURE update_viewership(IN bid INT, IN new_viewers INT)
BEGIN
  UPDATE Broadcasts SET viewership_estimate = new_viewers WHERE broadcast_id = bid;
END;
//
DELIMITER ;

-- 12. Call to update viewership
CALL update_viewership(1, 3000000);

-- 13. Grant SELECT access to analyst
GRANT SELECT ON Broadcasts TO 'analyst'@'localhost';

-- 14. Revoke DELETE permission from editor
REVOKE DELETE ON Broadcasts FROM 'editor'@'localhost';

-- 15. Grant full access to admin
GRANT ALL PRIVILEGES ON Broadcasts TO 'admin'@'localhost';

-- 16. Transaction to reschedule a broadcast
START TRANSACTION;
UPDATE Broadcasts SET broadcast_date = '2025-07-24' WHERE broadcast_id = 3;
UPDATE Broadcasts SET start_time = '18:00:00' WHERE broadcast_id = 3;
COMMIT;

-- 17. Transaction with rollback for accidental time change
START TRANSACTION;
UPDATE Broadcasts SET end_time = '12:00:00' WHERE broadcast_id = 5;
ROLLBACK;

-- 18. Savepoint and rollback use
START TRANSACTION;
UPDATE Broadcasts SET language = 'Spanish' WHERE broadcast_id = 2;
SAVEPOINT before_platform;
UPDATE Broadcasts SET platform = 'Radio' WHERE broadcast_id = 2;
ROLLBACK TO before_platform;
COMMIT;

-- 19. Create broadcast log table
CREATE TABLE broadcast_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  broadcast_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log new broadcast inserts
DELIMITER //
CREATE TRIGGER log_broadcast_insert
AFTER INSERT ON Broadcasts
FOR EACH ROW
BEGIN
  INSERT INTO broadcast_log (broadcast_id, action)
  VALUES (NEW.broadcast_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 14: Referees
-- 1. View of all certified referees
CREATE VIEW certified_referees AS
SELECT referee_id, full_name, sport_id, status
FROM Referees
WHERE certified = TRUE;

-- 2. View of active referees with more than 5 years of experience
CREATE VIEW experienced_referees AS
SELECT referee_id, full_name, experience_years
FROM Referees
WHERE status = 'Active' AND experience_years > 5;

-- 3. View of referees assigned to an event
CREATE VIEW assigned_referees AS
SELECT referee_id, full_name, assigned_event_id
FROM Referees
WHERE assigned_event_id IS NOT NULL;

-- 4. Drop the certified referees view if it exists
DROP VIEW IF EXISTS certified_referees;

-- 5. CTE to count referees by gender
WITH gender_count AS (
  SELECT gender, COUNT(*) AS total
  FROM Referees
  GROUP BY gender
)
SELECT * FROM gender_count;

-- 6. CTE to find referees by sport
WITH referee_sport AS (
  SELECT sport_id, COUNT(*) AS total_referees
  FROM Referees
  GROUP BY sport_id
)
SELECT s.sport_name, rs.total_referees
FROM referee_sport rs
JOIN Sports s ON rs.sport_id = s.sport_id;

-- 7. CTE to list all retired referees with more than 10 years of experience
WITH retired_experts AS (
  SELECT full_name, experience_years
  FROM Referees
  WHERE status = 'Retired' AND experience_years > 10
)
SELECT * FROM retired_experts;

-- 8. CTE to rank referees by experience
WITH ranked_referees AS (
  SELECT referee_id, full_name, experience_years,
         RANK() OVER (ORDER BY experience_years DESC) AS rank_num
  FROM Referees
)
SELECT * FROM ranked_referees WHERE rank_num <= 5;

-- 9. Procedure to insert a new referee
DELIMITER //
CREATE PROCEDURE add_referee(
  IN name VARCHAR(100), IN gen ENUM('Male','Female','Other'),
  IN nat_id INT, IN exp INT, IN sid INT, IN cert BOOLEAN,
  IN email VARCHAR(100), IN event_id INT, IN stat ENUM('Active','Retired','Suspended')
)
BEGIN
  INSERT INTO Referees (
    full_name, gender, nationality_id, experience_years,
    sport_id, certified, contact_email, assigned_event_id, status
  ) VALUES (
    name, gen, nat_id, exp, sid, cert, email, event_id, stat
  );
END;
//
DELIMITER ;

-- 10. Call procedure to add a new referee
CALL add_referee('Rajiv Kumar', 'Male', 1, 12, 3, TRUE, 'rajiv.k@example.com', 4, 'Active');

-- 11. Procedure to update referee status
DELIMITER //
CREATE PROCEDURE update_referee_status(IN ref_id INT, IN new_status ENUM('Active','Retired','Suspended'))
BEGIN
  UPDATE Referees SET status = new_status WHERE referee_id = ref_id;
END;
//
DELIMITER ;

-- 12. Call to update referee status
CALL update_referee_status(1, 'Retired');

-- 13. Grant SELECT access to referee table
GRANT SELECT ON Referees TO 'analyst'@'localhost';

-- 14. Revoke INSERT from editor
REVOKE INSERT ON Referees FROM 'editor'@'localhost';

-- 15. Grant all privileges to admin
GRANT ALL PRIVILEGES ON Referees TO 'admin'@'localhost';

-- 16. Transaction to reassign referee to a different event
START TRANSACTION;
UPDATE Referees SET assigned_event_id = 6 WHERE referee_id = 2;
UPDATE Referees SET status = 'Active' WHERE referee_id = 2;
COMMIT;

-- 17. Transaction with rollback (wrong status update)
START TRANSACTION;
UPDATE Referees SET status = 'Suspended' WHERE referee_id = 3;
ROLLBACK;

-- 18. Savepoint example: change contact info and revert one change
START TRANSACTION;
UPDATE Referees SET contact_email = 'update1@ref.com' WHERE referee_id = 4;
SAVEPOINT after_email;
UPDATE Referees SET status = 'Retired' WHERE referee_id = 4;
ROLLBACK TO after_email;
COMMIT;

-- 19. Create referee log table
CREATE TABLE referee_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  referee_id INT,
  action VARCHAR(50),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log new referee insert
DELIMITER //
CREATE TRIGGER log_referee_insert
AFTER INSERT ON Referees
FOR EACH ROW
BEGIN
  INSERT INTO referee_log (referee_id, action)
  VALUES (NEW.referee_id, 'INSERT');
END;
//
DELIMITER ;

-- Table 15: Schedules
-- 1. View showing all completed events with schedule details
CREATE VIEW completed_schedules AS
SELECT schedule_id, event_id, scheduled_date, start_time, end_time, status
FROM Schedules
WHERE status = 'Completed';

-- 2. View showing upcoming events (scheduled and not yet held)
CREATE VIEW upcoming_schedules AS
SELECT schedule_id, event_id, scheduled_date, start_time
FROM Schedules
WHERE scheduled_date > CURDATE() AND status = 'Scheduled';

-- 3. View showing schedule by session
CREATE VIEW evening_sessions AS
SELECT schedule_id, event_id, scheduled_date, session
FROM Schedules
WHERE session = 'Evening';

-- 4. Drop the completed schedules view
DROP VIEW IF EXISTS completed_schedules;

-- 5. CTE to count number of events per session
WITH session_count AS (
  SELECT session, COUNT(*) AS total_events
  FROM Schedules
  GROUP BY session
)
SELECT * FROM session_count;

-- 6. CTE to list all cancelled events with venue
WITH cancelled_events AS (
  SELECT schedule_id, event_id, venue_id
  FROM Schedules
  WHERE status = 'Cancelled'
)
SELECT ce.*, v.venue_name
FROM cancelled_events ce
JOIN Venues v ON ce.venue_id = v.venue_id;

-- 7. CTE to get daily event counts
WITH daily_events AS (
  SELECT scheduled_date, COUNT(*) AS events_count
  FROM Schedules
  GROUP BY scheduled_date
)
SELECT * FROM daily_events ORDER BY scheduled_date;

-- 8. CTE to rank days by number of events
WITH event_ranks AS (
  SELECT scheduled_date, COUNT(*) AS events_count,
         RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_no
  FROM Schedules
  GROUP BY scheduled_date
)
SELECT * FROM event_ranks WHERE rank_no <= 3;

-- 9. Procedure to add a new schedule entry
DELIMITER //
CREATE PROCEDURE add_schedule(
  IN e_id INT, IN s_id INT, IN v_id INT, IN s_date DATE,
  IN s_time TIME, IN e_time TIME, IN sess VARCHAR(50)
)
BEGIN
  INSERT INTO Schedules (
    event_id, sport_id, venue_id, scheduled_date,
    start_time, end_time, session
  ) VALUES (
    e_id, s_id, v_id, s_date, s_time, e_time, sess
  );
END;
//
DELIMITER ;

-- 10. Call the procedure to insert a schedule
CALL add_schedule(2, 1, 5, '2025-07-18', '09:00:00', '11:00:00', 'Morning');

-- 11. Procedure to update schedule status
DELIMITER //
CREATE PROCEDURE update_schedule_status(IN sch_id INT, IN new_status ENUM('Scheduled','Completed','Cancelled'))
BEGIN
  UPDATE Schedules SET status = new_status WHERE schedule_id = sch_id;
END;
//
DELIMITER ;

-- 12. Call the procedure to mark an event as completed
CALL update_schedule_status(3, 'Completed');

-- 13. Grant SELECT access on schedules table to analyst
GRANT SELECT ON Schedules TO 'analyst'@'localhost';

-- 14. Revoke UPDATE from editor user
REVOKE UPDATE ON Schedules FROM 'editor'@'localhost';

-- 15. Grant all privileges to admin user
GRANT ALL PRIVILEGES ON Schedules TO 'admin'@'localhost';

-- 16. Transaction: move a schedule to new venue
START TRANSACTION;
UPDATE Schedules SET venue_id = 6 WHERE schedule_id = 4;
UPDATE Schedules SET last_updated = CURRENT_TIMESTAMP WHERE schedule_id = 4;
COMMIT;

-- 17. Transaction rollback for an incorrect reschedule
START TRANSACTION;
UPDATE Schedules SET scheduled_date = '2025-08-01' WHERE schedule_id = 5;
ROLLBACK;

-- 18. Savepoint example: change session and revert date change
START TRANSACTION;
UPDATE Schedules SET scheduled_date = '2025-08-15' WHERE schedule_id = 6;
SAVEPOINT after_date;
UPDATE Schedules SET session = 'Evening' WHERE schedule_id = 6;
ROLLBACK TO after_date;
COMMIT;

-- 19. Create a table to log changes in schedule status
CREATE TABLE schedule_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  schedule_id INT,
  old_status ENUM('Scheduled','Completed','Cancelled'),
  new_status ENUM('Scheduled','Completed','Cancelled'),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger to log status changes
DELIMITER //
CREATE TRIGGER log_schedule_status_change
BEFORE UPDATE ON Schedules
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO schedule_log(schedule_id, old_status, new_status)
    VALUES (OLD.schedule_id, OLD.status, NEW.status);
  END IF;
END;
//
DELIMITER ;

-- Table 16: Judges
-- 1. View: Active judges only
CREATE VIEW active_judges AS
SELECT judge_id, full_name, sport_id, is_chief_judge
FROM Judges
WHERE status = 'Active';

-- 2. View: Chief judges list
CREATE VIEW chief_judges AS
SELECT judge_id, full_name, sport_id
FROM Judges
WHERE is_chief_judge = TRUE;

-- 3. View: Judges assigned to events
CREATE VIEW assigned_judges AS
SELECT judge_id, full_name, assigned_event_id
FROM Judges
WHERE assigned_event_id IS NOT NULL;

-- 4. Drop the chief_judges view
DROP VIEW IF EXISTS chief_judges;

-- 5. CTE: Count of judges per sport
WITH judge_sport_count AS (
  SELECT sport_id, COUNT(*) AS total_judges
  FROM Judges
  GROUP BY sport_id
)
SELECT * FROM judge_sport_count;

-- 6. CTE: Average years of experience by status
WITH experience_avg AS (
  SELECT status, AVG(years_of_experience) AS avg_experience
  FROM Judges
  GROUP BY status
)
SELECT * FROM experience_avg;

-- 7. CTE: Judges with over 10 years experience
WITH senior_judges AS (
  SELECT judge_id, full_name, years_of_experience
  FROM Judges
  WHERE years_of_experience > 10
)
SELECT * FROM senior_judges ORDER BY years_of_experience DESC;

-- 8. CTE: Count of active vs retired judges
WITH status_count AS (
  SELECT status, COUNT(*) AS count
  FROM Judges
  GROUP BY status
)
SELECT * FROM status_count;

-- 9. Procedure: Add a new judge
DELIMITER //
CREATE PROCEDURE add_judge(
  IN name VARCHAR(100), IN g ENUM('Male','Female','Other'), IN nat_id INT,
  IN sport INT, IN cert_lvl VARCHAR(50), IN exp INT, IN chief BOOLEAN, IN evt INT
)
BEGIN
  INSERT INTO Judges (
    full_name, gender, nationality_id, sport_id, certification_level,
    years_of_experience, is_chief_judge, assigned_event_id
  ) VALUES (
    name, g, nat_id, sport, cert_lvl, exp, chief, evt
  );
END;
//
DELIMITER ;

-- 10. Call the procedure to add a judge
CALL add_judge('Alex Kim', 'Male', 3, 2, 'Level A', 12, TRUE, 10);

-- 11. Procedure: Update judge status
DELIMITER //
CREATE PROCEDURE update_judge_status(IN j_id INT, IN new_status ENUM('Active','Retired','Suspended'))
BEGIN
  UPDATE Judges SET status = new_status WHERE judge_id = j_id;
END;
//
DELIMITER ;

-- 12. Call procedure to suspend a judge
CALL update_judge_status(5, 'Suspended');

-- 13. Grant SELECT and INSERT access on Judges table to reviewer
GRANT SELECT, INSERT ON Judges TO 'reviewer'@'localhost';

-- 14. Revoke DELETE permission from junior_staff
REVOKE DELETE ON Judges FROM 'junior_staff'@'localhost';

-- 15. Grant full access on Judges table to olympic_admin
GRANT ALL PRIVILEGES ON Judges TO 'olympic_admin'@'localhost';

-- 16. Transaction: Assign a judge to a new event
START TRANSACTION;
UPDATE Judges SET assigned_event_id = 9 WHERE judge_id = 4;
UPDATE Judges SET last_updated = CURRENT_TIMESTAMP WHERE judge_id = 4;
COMMIT;

-- 17. Transaction rollback example for wrong assignment
START TRANSACTION;
UPDATE Judges SET assigned_event_id = 12 WHERE judge_id = 6;
ROLLBACK;

-- 18. Savepoint to safely update chief status
START TRANSACTION;
UPDATE Judges SET is_chief_judge = TRUE WHERE judge_id = 2;
SAVEPOINT after_chief_update;
UPDATE Judges SET assigned_event_id = 15 WHERE judge_id = 2;
ROLLBACK TO after_chief_update;
COMMIT;

-- 19. Create judge_status_log table
CREATE TABLE judge_status_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  judge_id INT,
  old_status ENUM('Active','Retired','Suspended'),
  new_status ENUM('Active','Retired','Suspended'),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger: Log status changes of judges
DELIMITER //
CREATE TRIGGER log_judge_status_update
BEFORE UPDATE ON Judges
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO judge_status_log(judge_id, old_status, new_status)
    VALUES (OLD.judge_id, OLD.status, NEW.status);
  END IF;
END;
//
DELIMITER ;

-- Table 17: Scores
-- 1. View: Final scores only
CREATE VIEW final_scores AS
SELECT score_id, athlete_id, event_id, score, score_type
FROM Scores
WHERE status = 'Final';

-- 2. View: Average technical scores by athlete
CREATE VIEW avg_technical_scores AS
SELECT athlete_id, AVG(score) AS avg_score
FROM Scores
WHERE score_type = 'Technical'
GROUP BY athlete_id;

-- 3. View: Judges with highest average score given
CREATE VIEW judge_avg_scores AS
SELECT judge_id, AVG(score) AS average_score
FROM Scores
GROUP BY judge_id;

-- 4. Drop a view safely if it exists
DROP VIEW IF EXISTS final_scores;

-- 5. CTE: Total scores per athlete per event
WITH total_scores AS (
  SELECT athlete_id, event_id, SUM(score) AS total_score
  FROM Scores
  GROUP BY athlete_id, event_id
)
SELECT * FROM total_scores;

-- 6. CTE: Recent scores in last 7 days
WITH recent_scores AS (
  SELECT * FROM Scores
  WHERE score_date >= NOW() - INTERVAL 7 DAY
)
SELECT * FROM recent_scores;

-- 7. CTE: Reviewed but not Final scores
WITH in_review AS (
  SELECT score_id, athlete_id, judge_id
  FROM Scores
  WHERE status = 'Reviewed'
)
SELECT * FROM in_review;

-- 8. CTE: Count of scores by score type
WITH score_type_count AS (
  SELECT score_type, COUNT(*) AS count
  FROM Scores
  GROUP BY score_type
)
SELECT * FROM score_type_count;

-- 9. Procedure: Insert a new score entry
DELIMITER //
CREATE PROCEDURE add_score(
  IN a_id INT, IN j_id INT, IN e_id INT,
  IN sc DECIMAL(5,2), IN s_type ENUM('Technical','Artistic','Performance'),
  IN rmk VARCHAR(255)
)
BEGIN
  INSERT INTO Scores (
    athlete_id, judge_id, event_id, score, score_type, remarks
  ) VALUES (
    a_id, j_id, e_id, sc, s_type, rmk
  );
END;
//
DELIMITER ;

-- 10. Call the add_score procedure
CALL add_score(5, 2, 3, 9.75, 'Artistic', 'Excellent execution');

-- 11. Procedure: Update score status
DELIMITER //
CREATE PROCEDURE update_score_status(IN s_id INT, IN new_status ENUM('Submitted','Reviewed','Final'))
BEGIN
  UPDATE Scores SET status = new_status WHERE score_id = s_id;
END;
//
DELIMITER ;

-- 12. Call the procedure to finalize a score
CALL update_score_status(7, 'Final');

-- 13. Grant SELECT and INSERT on Scores table to user 'scorer'
GRANT SELECT, INSERT ON Scores TO 'scorer'@'localhost';

-- 14. Revoke UPDATE from trainee accounts
REVOKE UPDATE ON Scores FROM 'trainee'@'localhost';

-- 15. Grant full privileges on Scores to scoring_admin
GRANT ALL PRIVILEGES ON Scores TO 'scoring_admin'@'localhost';

-- 16. Transaction: Add a score and immediately mark it as reviewed
START TRANSACTION;
INSERT INTO Scores (athlete_id, judge_id, event_id, score, score_type, remarks)
VALUES (8, 3, 6, 8.90, 'Performance', 'Strong performance');
UPDATE Scores SET status = 'Reviewed' WHERE score_id = LAST_INSERT_ID();
COMMIT;

-- 17. Transaction: Rollback if score exceeds 10 (invalid)
START TRANSACTION;
INSERT INTO Scores (athlete_id, judge_id, event_id, score, score_type)
VALUES (9, 1, 4, 10.50, 'Technical');  -- Invalid score
ROLLBACK;

-- 18. Savepoint usage example
START TRANSACTION;
INSERT INTO Scores (athlete_id, judge_id, event_id, score, score_type)
VALUES (10, 2, 5, 9.50, 'Artistic');
SAVEPOINT after_insert;
UPDATE Scores SET status = 'Reviewed' WHERE score_id = LAST_INSERT_ID();
ROLLBACK TO after_insert;
COMMIT;

-- 19. Create score_audit table for tracking changes
CREATE TABLE score_audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  score_id INT,
  old_score DECIMAL(5,2),
  new_score DECIMAL(5,2),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. Trigger: Log changes in score value
DELIMITER //
CREATE TRIGGER log_score_change
BEFORE UPDATE ON Scores
FOR EACH ROW
BEGIN
  IF OLD.score <> NEW.score THEN
    INSERT INTO score_audit(score_id, old_score, new_score)
    VALUES (OLD.score_id, OLD.score, NEW.score);
  END IF;
END;
//
DELIMITER ;

-- Table 18: Ticket Sales
-- 1. View: All paid tickets
CREATE VIEW paid_tickets AS
SELECT * FROM ticket_sales
WHERE payment_status = 'Paid';

-- 2. View: Total sales per ticket type
CREATE VIEW sales_by_type AS
SELECT ticket_type, COUNT(*) AS total_tickets, SUM(price) AS total_revenue
FROM ticket_sales
WHERE payment_status = 'Paid'
GROUP BY ticket_type;

-- 3. View: Daily ticket sales
CREATE VIEW daily_ticket_sales AS
SELECT purchase_date, COUNT(*) AS tickets_sold, SUM(price) AS revenue
FROM ticket_sales
WHERE payment_status = 'Paid'
GROUP BY purchase_date;

-- 4. Drop view if exists
DROP VIEW IF EXISTS sales_by_type;

-- 5. CTE: Total tickets sold for an event
WITH tickets_per_event AS (
  SELECT event_id, COUNT(*) AS total_tickets
  FROM ticket_sales
  WHERE payment_status = 'Paid'
  GROUP BY event_id
)
SELECT * FROM tickets_per_event;

-- 6. CTE: Tickets sold online vs onsite
WITH channel_sales AS (
  SELECT sale_channel, COUNT(*) AS count
  FROM ticket_sales
  GROUP BY sale_channel
)
SELECT * FROM channel_sales;

-- 7. CTE: Unpaid or cancelled tickets
WITH issues AS (
  SELECT * FROM ticket_sales
  WHERE payment_status IN ('Pending', 'Cancelled')
)
SELECT * FROM issues;

-- 8. CTE: VIP buyers
WITH vip_buyers AS (
  SELECT DISTINCT buyer_name, buyer_email
  FROM ticket_sales
  WHERE ticket_type = 'VIP'
)
SELECT * FROM vip_buyers;

-- 9. Procedure: Insert new ticket sale
DELIMITER //
CREATE PROCEDURE add_ticket(
  IN e_id INT, IN name VARCHAR(100), IN email VARCHAR(100),
  IN t_type ENUM('Regular','VIP','Student'),
  IN seat VARCHAR(20), IN amount DECIMAL(8,2),
  IN status ENUM('Paid','Pending','Cancelled'),
  IN channel ENUM('Online','Onsite')
)
BEGIN
  INSERT INTO ticket_sales (
    event_id, buyer_name, buyer_email, ticket_type,
    purchase_date, seat_number, price, payment_status, sale_channel
  ) VALUES (
    e_id, name, email, t_type,
    CURDATE(), seat, amount, status, channel
  );
END;
//
DELIMITER ;

-- 10. Call the procedure to add ticket
CALL add_ticket(2, 'Om Porje', 'om@example.com', 'VIP', 'A12', 1500.00, 'Paid', 'Online');

-- 11. Procedure: Cancel a ticket
DELIMITER //
CREATE PROCEDURE cancel_ticket(IN t_id INT)
BEGIN
  UPDATE ticket_sales
  SET payment_status = 'Cancelled'
  WHERE ticket_id = t_id;
END;
//
DELIMITER ;

-- 12. Call the procedure to cancel ticket ID 101
CALL cancel_ticket(101);

-- 13. Grant SELECT, INSERT to 'ticket_agent'
GRANT SELECT, INSERT ON ticket_sales TO 'ticket_agent'@'localhost';

-- 14. Revoke DELETE from 'intern'
REVOKE DELETE ON ticket_sales FROM 'intern'@'localhost';

-- 15. Grant full privileges to 'sales_admin'
GRANT ALL PRIVILEGES ON ticket_sales TO 'sales_admin'@'localhost';

-- 16. Transaction: Add a ticket and rollback if price is too high
START TRANSACTION;
INSERT INTO ticket_sales (event_id, buyer_name, buyer_email, ticket_type, purchase_date, seat_number, price, payment_status, sale_channel)
VALUES (4, 'Test User', 'test@example.com', 'Regular', CURDATE(), 'B5', 10000.00, 'Paid', 'Online');
-- Check price limit
ROLLBACK;

-- 17. Savepoint example during insert process
START TRANSACTION;
INSERT INTO ticket_sales (event_id, buyer_name, buyer_email, ticket_type, purchase_date, seat_number, price, payment_status, sale_channel)
VALUES (3, 'Temp User', 'temp@example.com', 'Student', CURDATE(), 'S12', 200.00, 'Pending', 'Onsite');
SAVEPOINT after_insert;
UPDATE ticket_sales SET payment_status = 'Paid' WHERE buyer_email = 'temp@example.com';
ROLLBACK TO after_insert;
COMMIT;

-- 18. Create audit table for ticket changes
CREATE TABLE ticket_audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  ticket_id INT,
  old_status ENUM('Paid','Pending','Cancelled'),
  new_status ENUM('Paid','Pending','Cancelled'),
  changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 19. Trigger to log status changes
DELIMITER //
CREATE TRIGGER log_ticket_status_change
BEFORE UPDATE ON ticket_sales
FOR EACH ROW
BEGIN
  IF OLD.payment_status <> NEW.payment_status THEN
    INSERT INTO ticket_audit(ticket_id, old_status, new_status)
    VALUES (OLD.ticket_id, OLD.payment_status, NEW.payment_status);
  END IF;
END;
//
DELIMITER ;

-- 20. Trigger to auto-fill seat for Regular tickets
DELIMITER //
CREATE TRIGGER auto_assign_seat
BEFORE INSERT ON ticket_sales
FOR EACH ROW
BEGIN
  IF NEW.seat_number IS NULL AND NEW.ticket_type = 'Regular' THEN
    SET NEW.seat_number = CONCAT('R', FLOOR(1 + (RAND() * 100)));
  END IF;
END;
//
DELIMITER ;

-- Table 19: Ceremonies
-- 1. View: All opening ceremonies with venue details
CREATE VIEW opening_ceremonies AS
SELECT c.*, v.stadium_name
FROM ceremonies c
JOIN venues v ON c.venue_id = v.venue_id
WHERE ceremony_type = 'Opening';

-- 2. View: Number of ceremonies by type
CREATE VIEW ceremony_counts AS
SELECT ceremony_type, COUNT(*) AS total
FROM ceremonies
GROUP BY ceremony_type;

-- 3. View: Ceremonies per Olympics
CREATE VIEW ceremonies_by_olympics AS
SELECT o.olympic_year, COUNT(c.ceremony_id) AS total_ceremonies
FROM ceremonies c
JOIN olympics o ON c.olympic_id = o.olympic_id
GROUP BY o.olympic_year;

-- 4. Drop view safely
DROP VIEW IF EXISTS ceremonies_by_olympics;

-- 5. CTE: Longest ceremonies (duration > 3 hours)
WITH long_ceremonies AS (
  SELECT ceremony_id, TIMEDIFF(end_time, start_time) AS duration
  FROM ceremonies
)
SELECT * FROM long_ceremonies
WHERE duration > '03:00:00';

-- 6. CTE: Performers who performed more than once
WITH performer_counts AS (
  SELECT main_performer, COUNT(*) AS performances
  FROM ceremonies
  GROUP BY main_performer
)
SELECT * FROM performer_counts WHERE performances > 1;

-- 7. CTE: Ceremonies held in a specific venue
WITH venue_events AS (
  SELECT * FROM ceremonies WHERE venue_id = 2
)
SELECT * FROM venue_events;

-- 8. CTE: Evening ceremonies (start time after 6 PM)
WITH evening_events AS (
  SELECT * FROM ceremonies WHERE start_time > '18:00:00'
)
SELECT * FROM evening_events;

-- 9. Procedure: Add a new ceremony
DELIMITER //
CREATE PROCEDURE add_ceremony(
  IN o_id INT, IN type ENUM('Opening','Closing','Medal'),
  IN c_date DATE, IN s_time TIME, IN e_time TIME,
  IN v_id INT, IN host VARCHAR(100), IN performer VARCHAR(100), IN c_theme VARCHAR(255)
)
BEGIN
  INSERT INTO ceremonies (
    olympic_id, ceremony_type, ceremony_date,
    start_time, end_time, venue_id,
    host_country, main_performer, theme
  ) VALUES (
    o_id, type, c_date, s_time, e_time, v_id, host, performer, c_theme
  );
END;
//
DELIMITER ;

-- 10. Call procedure to insert new ceremony
CALL add_ceremony(3, 'Opening', '2024-07-23', '20:00:00', '23:00:00', 1, 'France', 'Daft Punk', 'Unity in Diversity');

-- 11. Procedure: Update ceremony performer
DELIMITER //
CREATE PROCEDURE update_performer(IN c_id INT, IN performer_name VARCHAR(100))
BEGIN
  UPDATE ceremonies SET main_performer = performer_name WHERE ceremony_id = c_id;
END;
//
DELIMITER ;

-- 12. Call procedure to update a performer
CALL update_performer(5, 'Coldplay');

-- 13. Grant SELECT, INSERT to event_organizer
GRANT SELECT, INSERT ON ceremonies TO 'event_organizer'@'localhost';

-- 14. Revoke UPDATE from volunteer account
REVOKE UPDATE ON ceremonies FROM 'volunteer'@'localhost';

-- 15. Grant ALL privileges to admin user
GRANT ALL PRIVILEGES ON ceremonies TO 'admin_user'@'localhost';

-- 16. Transaction: Insert ceremony and verify time logic
START TRANSACTION;
INSERT INTO ceremonies (
  olympic_id, ceremony_type, ceremony_date, start_time,
  end_time, venue_id, host_country, main_performer, theme
)
VALUES (2, 'Closing', '2024-08-08', '20:00:00', '19:30:00', 1, 'Japan', 'Perfume', 'Gratitude');
-- End time before start time, rollback
ROLLBACK;

-- 17. Savepoint example in ceremony insert
START TRANSACTION;
INSERT INTO ceremonies (olympic_id, ceremony_type, ceremony_date, start_time, end_time, venue_id, host_country, main_performer, theme)
VALUES (1, 'Medal', '2024-08-01', '15:00:00', '17:00:00', 2, 'USA', 'John Legend', 'Celebrating Champions');
SAVEPOINT after_insert;
UPDATE ceremonies SET theme = 'Revised Theme' WHERE main_performer = 'John Legend';
ROLLBACK TO after_insert;
COMMIT;

-- 18. Create audit table to log theme changes
CREATE TABLE ceremony_theme_audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  ceremony_id INT,
  old_theme VARCHAR(255),
  new_theme VARCHAR(255),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 19. Trigger to log theme updates
DELIMITER //
CREATE TRIGGER log_theme_change
BEFORE UPDATE ON ceremonies
FOR EACH ROW
BEGIN
  IF OLD.theme <> NEW.theme THEN
    INSERT INTO ceremony_theme_audit(ceremony_id, old_theme, new_theme)
    VALUES (OLD.ceremony_id, OLD.theme, NEW.theme);
  END IF;
END;
//
DELIMITER ;

-- 20. Trigger to auto-set theme for medal ceremonies
DELIMITER //
CREATE TRIGGER auto_theme_medal
BEFORE INSERT ON ceremonies
FOR EACH ROW
BEGIN
  IF NEW.ceremony_type = 'Medal' AND NEW.theme IS NULL THEN
    SET NEW.theme = 'Medal of Honor';
  END IF;
END;
//
DELIMITER ;

-- Table 20: Medical Records
-- 1. View: All cleared athletes with last checkup date
CREATE VIEW cleared_athletes_medical AS
SELECT athlete_id, MAX(checkup_date) AS last_checkup
FROM medical_records
WHERE fitness_clearance = 'Yes'
GROUP BY athlete_id;

-- 2. View: Injuries treated at a specific hospital
CREATE VIEW hospital_injuries AS
SELECT hospital_name, COUNT(*) AS total_cases
FROM medical_records
GROUP BY hospital_name;

-- 3. View: Follow-up required athletes with treatment info
CREATE VIEW follow_up_list AS
SELECT athlete_id, treatment_given, doctor_name, follow_up_required
FROM medical_records
WHERE follow_up_required = TRUE;

-- 4. View: Recent 30-day medical cases
CREATE VIEW recent_medical_cases AS
SELECT * FROM medical_records
WHERE checkup_date >= CURDATE() - INTERVAL 30 DAY;

-- 5. CTE: Athletes with more than 2 injuries
WITH injury_counts AS (
  SELECT athlete_id, COUNT(*) AS num_cases
  FROM medical_records
  GROUP BY athlete_id
)
SELECT * FROM injury_counts WHERE num_cases > 2;

-- 6. CTE: Unfit athletes needing follow-up
WITH pending_cases AS (
  SELECT * FROM medical_records
  WHERE fitness_clearance IN ('No', 'Pending') AND follow_up_required = TRUE
)
SELECT athlete_id, checkup_date FROM pending_cases;

-- 7. CTE: Top 3 doctors with most records
WITH doctor_cases AS (
  SELECT doctor_name, COUNT(*) AS total
  FROM medical_records
  GROUP BY doctor_name
)
SELECT * FROM doctor_cases ORDER BY total DESC LIMIT 3;

-- 8. CTE: Athletes who visited a specific doctor
WITH visits AS (
  SELECT * FROM medical_records
  WHERE doctor_name = 'Dr. Smith'
)
SELECT athlete_id, checkup_date FROM visits;

-- 9. Stored Procedure: Add a medical record
DELIMITER //
CREATE PROCEDURE add_medical_record (
  IN a_id INT, IN c_date DATE, IN injury VARCHAR(255),
  IN treatment VARCHAR(255), IN doctor VARCHAR(100),
  IN hospital VARCHAR(100), IN fit ENUM('Yes','No','Pending'),
  IN follow_up BOOLEAN, IN extra_notes TEXT
)
BEGIN
  INSERT INTO medical_records (
    athlete_id, checkup_date, injury_description,
    treatment_given, doctor_name, hospital_name,
    fitness_clearance, follow_up_required, notes
  ) VALUES (
    a_id, c_date, injury, treatment, doctor,
    hospital, fit, follow_up, extra_notes
  );
END;
//
DELIMITER ;

-- 10. Call the above procedure
CALL add_medical_record(2, '2025-06-05', 'Sprained ankle', 'Rest and physiotherapy', 'Dr. Lee', 'Olympic Health Center', 'Pending', TRUE, 'Follow-up in 10 days');

-- 11. Procedure: Mark athlete fit after treatment
DELIMITER //
CREATE PROCEDURE update_clearance(IN a_id INT)
BEGIN
  UPDATE medical_records
  SET fitness_clearance = 'Yes'
  WHERE athlete_id = a_id AND fitness_clearance <> 'Yes';
END;
//
DELIMITER ;

-- 12. Call procedure to mark athlete fit
CALL update_clearance(4);

-- 13. Grant SELECT, INSERT on medical_records to medical_staff
GRANT SELECT, INSERT ON medical_records TO 'medical_staff'@'localhost';

-- 14. Revoke DELETE privilege from interns
REVOKE DELETE ON medical_records FROM 'intern_user'@'localhost';

-- 15. Grant full privileges to senior_medical
GRANT ALL PRIVILEGES ON medical_records TO 'senior_medical'@'localhost';

-- 16. Transaction: Insert and verify mandatory fields
START TRANSACTION;
INSERT INTO medical_records (
  athlete_id, checkup_date, fitness_clearance
)
VALUES (3, '2025-06-01', 'No');
-- Missing mandatory treatment data, rollback
ROLLBACK;

-- 17. Savepoint & rollback example
START TRANSACTION;
INSERT INTO medical_records (
  athlete_id, checkup_date, injury_description,
  treatment_given, doctor_name, hospital_name,
  fitness_clearance, follow_up_required
)
VALUES (7, '2025-06-05', 'Back pain', 'Heat therapy', 'Dr. Jane', 'Elite Med', 'Pending', TRUE);
SAVEPOINT after_insert;
UPDATE medical_records SET treatment_given = 'Heat + Massage' WHERE doctor_name = 'Dr. Jane';
ROLLBACK TO after_insert;
COMMIT;

-- 18. Create audit table for treatment changes
CREATE TABLE treatment_audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  record_id INT,
  old_treatment VARCHAR(255),
  new_treatment VARCHAR(255),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 19. Trigger: Log when treatment_given changes
DELIMITER //
CREATE TRIGGER log_treatment_change
BEFORE UPDATE ON medical_records
FOR EACH ROW
BEGIN
  IF OLD.treatment_given <> NEW.treatment_given THEN
    INSERT INTO treatment_audit(record_id, old_treatment, new_treatment)
    VALUES (OLD.record_id, OLD.treatment_given, NEW.treatment_given);
  END IF;
END;
//
DELIMITER ;

-- 20. Trigger: Auto-mark follow-up as TRUE if injury is critical
DELIMITER //
CREATE TRIGGER auto_follow_up
BEFORE INSERT ON medical_records
FOR EACH ROW
BEGIN
  IF NEW.injury_description LIKE '%fracture%' OR NEW.injury_description LIKE '%tear%' THEN
    SET NEW.follow_up_required = TRUE;
  END IF;
END;
//
DELIMITER ;

-- Table 21: Training Sessions
-- 1. View: All training sessions with athlete and coach info
CREATE VIEW training_details AS
SELECT ts.session_id, ts.session_date, ts.start_time, ts.end_time, ts.location,
       a.first_name AS athlete_first_name, a.last_name AS athlete_last_name,
       c.first_name AS coach_first_name, c.last_name AS coach_last_name,
       ts.intensity_level
FROM training_sessions ts
JOIN athletes a ON ts.athlete_id = a.athlete_id
JOIN coaches c ON ts.coach_id = c.coach_id;

-- 2. View: High intensity sessions count per athlete
CREATE VIEW high_intensity_count AS
SELECT athlete_id, COUNT(*) AS high_sessions
FROM training_sessions
WHERE intensity_level = 'High'
GROUP BY athlete_id;

-- 3. View: Sessions per sport per day
CREATE VIEW daily_sport_sessions AS
SELECT sport_id, session_date, COUNT(*) AS sessions_count
FROM training_sessions
GROUP BY sport_id, session_date;

-- 4. CTE: Recent training sessions last 7 days
WITH recent_sessions AS (
  SELECT * FROM training_sessions
  WHERE session_date >= CURDATE() - INTERVAL 7 DAY
)
SELECT * FROM recent_sessions ORDER BY session_date DESC;

-- 5. CTE: Coaches with more than 10 sessions this month
WITH coach_sessions AS (
  SELECT coach_id, COUNT(*) AS session_count
  FROM training_sessions
  WHERE MONTH(session_date) = MONTH(CURDATE()) AND YEAR(session_date) = YEAR(CURDATE())
  GROUP BY coach_id
)
SELECT * FROM coach_sessions WHERE session_count > 10;

-- 6. CTE: Athletes training with a particular coach
WITH athlete_coach AS (
  SELECT DISTINCT athlete_id
  FROM training_sessions
  WHERE coach_id = 5
)
SELECT * FROM athlete_coach;

-- 7. Stored Procedure: Add a training session
DELIMITER //
CREATE PROCEDURE add_training_session (
  IN a_id INT, IN c_id INT, IN s_id INT,
  IN s_date DATE, IN s_start TIME, IN s_end TIME,
  IN loc VARCHAR(100), IN intensity ENUM('Low', 'Medium', 'High'),
  IN notes_text TEXT
)
BEGIN
  INSERT INTO training_sessions (athlete_id, coach_id, sport_id, session_date, start_time, end_time, location, intensity_level, notes)
  VALUES (a_id, c_id, s_id, s_date, s_start, s_end, loc, intensity, notes_text);
END;
//
DELIMITER ;

-- 8. Call procedure to insert a training session
CALL add_training_session(2, 3, 1, '2025-06-07', '09:00:00', '10:30:00', 'Main Gym', 'High', 'Focused on endurance');

-- 9. Procedure: Update session notes
DELIMITER //
CREATE PROCEDURE update_training_notes (
  IN session INT, IN new_notes TEXT
)
BEGIN
  UPDATE training_sessions
  SET notes = new_notes
  WHERE session_id = session;
END;
//
DELIMITER ;

-- 10. Call procedure to update notes
CALL update_training_notes(5, 'Improved technique in sprint');

-- 11. Grant SELECT and INSERT privileges to trainers role
GRANT SELECT, INSERT ON training_sessions TO 'trainers'@'localhost';

-- 12. Revoke DELETE from temporary_staff
REVOKE DELETE ON training_sessions FROM 'temporary_staff'@'localhost';

-- 13. Transaction: Insert new session and verify location not null
START TRANSACTION;
INSERT INTO training_sessions (athlete_id, coach_id, sport_id, session_date, location)
VALUES (4, 2, 3, '2025-06-08', 'Field 2');
-- Check for null location
SELECT location FROM training_sessions WHERE session_id = LAST_INSERT_ID();
COMMIT;

-- 14. Savepoint example: insert and update notes, then rollback update
START TRANSACTION;
INSERT INTO training_sessions (athlete_id, coach_id, sport_id, session_date, location, intensity_level)
VALUES (6, 4, 2, '2025-06-09', 'Indoor Court', 'Medium');
SAVEPOINT after_insert;
UPDATE training_sessions SET notes = 'Focus on defense' WHERE session_id = LAST_INSERT_ID();
ROLLBACK TO after_insert;
COMMIT;

-- 15. Trigger: Update notes with "Session completed" when end_time is set
DELIMITER //
CREATE TRIGGER mark_session_complete
BEFORE UPDATE ON training_sessions
FOR EACH ROW
BEGIN
  IF NEW.end_time IS NOT NULL AND OLD.end_time IS NULL THEN
    SET NEW.notes = CONCAT(IFNULL(NEW.notes, ''), ' Session completed.');
  END IF;
END;
//
DELIMITER ;

-- 16. Trigger: Auto-set intensity to 'Low' if NULL on insert
DELIMITER //
CREATE TRIGGER set_default_intensity
BEFORE INSERT ON training_sessions
FOR EACH ROW
BEGIN
  IF NEW.intensity_level IS NULL THEN
    SET NEW.intensity_level = 'Low';
  END IF;
END;
//
DELIMITER ;

-- 17. Trigger: Prevent overlapping sessions for same athlete on same day
DELIMITER //
CREATE TRIGGER prevent_overlap
BEFORE INSERT ON training_sessions
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM training_sessions
    WHERE athlete_id = NEW.athlete_id
      AND session_date = NEW.session_date
      AND ((NEW.start_time BETWEEN start_time AND end_time)
        OR (NEW.end_time BETWEEN start_time AND end_time))
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overlapping training session detected for athlete';
  END IF;
END;
//
DELIMITER ;

-- 18. View: Total training hours per athlete this month
CREATE VIEW monthly_training_hours AS
SELECT athlete_id, SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time))/60 AS hours_trained
FROM training_sessions
WHERE MONTH(session_date) = MONTH(CURDATE()) AND YEAR(session_date) = YEAR(CURDATE())
GROUP BY athlete_id;

-- 19. CTE: Athletes without sessions in past month
WITH last_month_sessions AS (
  SELECT DISTINCT athlete_id FROM training_sessions
  WHERE session_date >= CURDATE() - INTERVAL 30 DAY
)
SELECT athlete_id FROM athletes
WHERE athlete_id NOT IN (SELECT athlete_id FROM last_month_sessions);

-- 20. Grant UPDATE privilege to head_coach user
GRANT UPDATE ON training_sessions TO 'head_coach'@'localhost';

-- Table 22: Volunteers
-- 1. View: Volunteers available for morning shift
CREATE VIEW Morning_Shift_Volunteers AS
SELECT volunteer_id, full_name, assigned_area
FROM volunteers
WHERE shift_time = 'Morning';

-- 2. View: Volunteers older than 30
CREATE VIEW Senior_Volunteers AS
SELECT volunteer_id, full_name, age
FROM volunteers
WHERE age > 30;

-- 3. View: Volunteers by area
CREATE VIEW Volunteers_By_Area AS
SELECT assigned_area, COUNT(*) AS total_volunteers
FROM volunteers
GROUP BY assigned_area;

-- 4. View: Contact list for volunteers
CREATE VIEW Volunteer_Contacts AS
SELECT full_name, contact_number, email
FROM volunteers;

-- 5. CTE: Volunteers with missing contact info
WITH MissingContact AS (
  SELECT * FROM volunteers
  WHERE contact_number IS NULL OR email IS NULL
)
SELECT * FROM MissingContact;

-- 6. CTE: Volunteers grouped by gender
WITH GenderStats AS (
  SELECT gender, COUNT(*) AS total
  FROM volunteers
  GROUP BY gender
)
SELECT * FROM GenderStats;

-- 7. CTE: Volunteers with roles including 'Coordinator'
WITH Coordinators AS (
  SELECT * FROM volunteers
  WHERE role_description LIKE '%Coordinator%'
)
SELECT full_name, assigned_area FROM Coordinators;

-- 8. CTE: Volunteers working multiple days
WITH MultiDayVolunteers AS (
  SELECT * FROM volunteers
  WHERE LENGTH(availability_days) - LENGTH(REPLACE(availability_days, ',', '')) + 1 > 1
)
SELECT full_name, availability_days FROM MultiDayVolunteers;

-- 9. Stored procedure: Insert new volunteer
DELIMITER //
CREATE PROCEDURE AddVolunteer(
  IN v_name VARCHAR(100),
  IN v_age INT,
  IN v_gender ENUM('Male', 'Female', 'Other'),
  IN v_phone VARCHAR(15),
  IN v_email VARCHAR(100),
  IN v_area VARCHAR(100),
  IN v_role VARCHAR(255),
  IN v_shift ENUM('Morning', 'Afternoon', 'Evening'),
  IN v_days VARCHAR(100)
)
BEGIN
  INSERT INTO volunteers(full_name, age, gender, contact_number, email, assigned_area, role_description, shift_time, availability_days)
  VALUES (v_name, v_age, v_gender, v_phone, v_email, v_area, v_role, v_shift, v_days);
END //
DELIMITER ;

-- 10. Call procedure to add volunteer
CALL AddVolunteer('John Doe', 28, 'Male', '9876543210', 'john@example.com', 'Main Gate', 'Check-in Coordinator', 'Morning', 'Mon,Tue,Wed');

-- 11. Stored procedure: Update volunteer email
DELIMITER //
CREATE PROCEDURE UpdateVolunteerEmail(IN v_id INT, IN new_email VARCHAR(100))
BEGIN
  UPDATE volunteers
  SET email = new_email
  WHERE volunteer_id = v_id;
END //
DELIMITER ;

-- 12. Call procedure to update email
CALL UpdateVolunteerEmail(1, 'updated_email@example.com');

-- 13. Grant SELECT on volunteers to a specific user
GRANT SELECT ON volunteers TO 'report_user'@'localhost';

-- 14. Revoke UPDATE on volunteers from a user
REVOKE UPDATE ON volunteers FROM 'temp_user'@'localhost';

-- 15. Grant all privileges on volunteers to admin
GRANT ALL PRIVILEGES ON volunteers TO 'admin_user'@'localhost';

-- 16. Begin transaction to insert multiple volunteers
START TRANSACTION;
INSERT INTO volunteers (full_name, age, gender, shift_time, availability_days)
VALUES ('Alice Smith', 25, 'Female', 'Afternoon', 'Mon,Wed,Fri');
INSERT INTO volunteers (full_name, age, gender, shift_time, availability_days)
VALUES ('Bob Thomas', 30, 'Male', 'Morning', 'Tue,Thu');
COMMIT;

-- 17. Rollback example
START TRANSACTION;
UPDATE volunteers SET shift_time = 'Evening' WHERE volunteer_id = 2;
ROLLBACK;

-- 18. Savepoint example
START TRANSACTION;
UPDATE volunteers SET shift_time = 'Morning' WHERE volunteer_id = 3;
SAVEPOINT before_email;
UPDATE volunteers SET email = 'error@domain.com' WHERE volunteer_id = 3;
ROLLBACK TO before_email;
COMMIT;

-- 19. Trigger: Log volunteer insert
CREATE TABLE volunteer_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  volunteer_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER AfterVolunteerInsert
AFTER INSERT ON volunteers
FOR EACH ROW
BEGIN
  INSERT INTO volunteer_log(volunteer_id, action)
  VALUES (NEW.volunteer_id, 'INSERT');
END //
DELIMITER ;

-- 20. Trigger: Prevent negative age
DELIMITER //
CREATE TRIGGER PreventNegativeAge
BEFORE INSERT ON volunteers
FOR EACH ROW
BEGIN
  IF NEW.age < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Age cannot be negative';
  END IF;
END //
DELIMITER ;

-- Table 23: 
-- 1. View: Night shift staff
CREATE VIEW Night_Shift_Staff AS
SELECT staff_id, full_name, assigned_location
FROM security_staff
WHERE shift_time = 'Night';

-- 2. View: Staff by duty type
CREATE VIEW Staff_By_Duty AS
SELECT duty_type, COUNT(*) AS total_staff
FROM security_staff
GROUP BY duty_type;

-- 3. View: Staff contact list
CREATE VIEW Security_Contacts AS
SELECT full_name, contact_number, email
FROM security_staff;

-- 4. View: Staff assigned to a specific location (e.g., "Main Gate")
CREATE VIEW Main_Gate_Staff AS
SELECT * FROM security_staff
WHERE assigned_location = 'Main Gate';

-- 5. CTE: Staff with missing contact info
WITH MissingContact AS (
  SELECT * FROM security_staff
  WHERE contact_number IS NULL OR email IS NULL
)
SELECT * FROM MissingContact;

-- 6. CTE: Gender distribution
WITH GenderCount AS (
  SELECT gender, COUNT(*) AS total
  FROM security_staff
  GROUP BY gender
)
SELECT * FROM GenderCount;

-- 7. CTE: Staff supervised by a particular person
WITH SupervisorTeam AS (
  SELECT * FROM security_staff
  WHERE supervisor_name = 'Ravi Kumar'
)
SELECT full_name, shift_time FROM SupervisorTeam;

-- 8. CTE: Staff with "Guard" in duty type
WITH Guards AS (
  SELECT * FROM security_staff
  WHERE duty_type LIKE '%Guard%'
)
SELECT full_name, assigned_location FROM Guards;

-- 9. Procedure: Add a new security staff
DELIMITER //
CREATE PROCEDURE AddSecurityStaff(
  IN name VARCHAR(100),
  IN age_val INT,
  IN gen ENUM('Male', 'Female', 'Other'),
  IN phone VARCHAR(15),
  IN mail VARCHAR(100),
  IN loc VARCHAR(100),
  IN shift ENUM('Morning', 'Afternoon', 'Night'),
  IN duty VARCHAR(100),
  IN supervisor VARCHAR(100)
)
BEGIN
  INSERT INTO security_staff(full_name, age, gender, contact_number, email, assigned_location, shift_time, duty_type, supervisor_name)
  VALUES (name, age_val, gen, phone, mail, loc, shift, duty, supervisor);
END //
DELIMITER ;

-- 10. Call procedure to insert staff
CALL AddSecurityStaff('Arjun Patel', 32, 'Male', '9876543210', 'arjun@example.com', 'Stadium Gate', 'Morning', 'Entry Check', 'Raj Singh');

-- 11. Procedure: Update shift
DELIMITER //
CREATE PROCEDURE UpdateStaffShift(IN sid INT, IN new_shift ENUM('Morning','Afternoon','Night'))
BEGIN
  UPDATE security_staff SET shift_time = new_shift WHERE staff_id = sid;
END //
DELIMITER ;

-- 12. Call procedure to update shift
CALL UpdateStaffShift(3, 'Night');

-- 13. Grant SELECT on security_staff to reports user
GRANT SELECT ON security_staff TO 'reports_user'@'localhost';

-- 14. Revoke INSERT from temp user
REVOKE INSERT ON security_staff FROM 'temp_user'@'localhost';

-- 15. Grant all privileges to supervisor account
GRANT ALL PRIVILEGES ON security_staff TO 'supervisor_user'@'localhost';

-- 16. Insert multiple staff in a transaction
START TRANSACTION;
INSERT INTO security_staff(full_name, age, gender, shift_time, assigned_location, duty_type, supervisor_name)
VALUES ('Seema Shah', 28, 'Female', 'Afternoon', 'VIP Entrance', 'Bag Check', 'Vikram Mehta');
INSERT INTO security_staff(full_name, age, gender, shift_time, assigned_location, duty_type, supervisor_name)
VALUES ('Amit Rathi', 40, 'Male', 'Night', 'Main Gate', 'Surveillance', 'Vikram Mehta');
COMMIT;

-- 17. Rollback sample
START TRANSACTION;
UPDATE security_staff SET assigned_location = 'Invalid' WHERE staff_id = 2;
ROLLBACK;

-- 18. Savepoint example
START TRANSACTION;
UPDATE security_staff SET duty_type = 'VIP Escort' WHERE staff_id = 4;
SAVEPOINT before_contact;
UPDATE security_staff SET contact_number = NULL WHERE staff_id = 4;
ROLLBACK TO before_contact;
COMMIT;

-- 19. Trigger: Log insertions to security staff
CREATE TABLE security_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  staff_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER LogSecurityInsert
AFTER INSERT ON security_staff
FOR EACH ROW
BEGIN
  INSERT INTO security_log(staff_id, action)
  VALUES (NEW.staff_id, 'INSERT');
END //
DELIMITER ;

-- 20. Trigger: Prevent underage staff
DELIMITER //
CREATE TRIGGER PreventUnderageStaff
BEFORE INSERT ON security_staff
FOR EACH ROW
BEGIN
  IF NEW.age < 18 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security staff must be at least 18 years old';
  END IF;
END //
DELIMITER ;

-- Table 24: 
-- 1. View showing only live coverages
CREATE VIEW Live_Coverage AS
SELECT media_house, reporter_name, event_covered
FROM media_coverage
WHERE coverage_type = 'Live';

-- 2. View showing coverage count by country
CREATE VIEW Coverage_By_Country AS
SELECT country, COUNT(*) AS total_coverages
FROM media_coverage
GROUP BY country;

-- 3. View listing media house with channel and type
CREATE VIEW Media_Channel_Info AS
SELECT media_house, broadcast_channel, coverage_type
FROM media_coverage;

-- 4. View of coverages in the last 7 days
CREATE VIEW Recent_Coverages AS
SELECT * FROM media_coverage
WHERE coverage_date >= CURDATE() - INTERVAL 7 DAY;

-- 5. CTE to get all reporters who did 'Written' coverage
WITH Written_Reporters AS (
    SELECT reporter_name, event_covered
    FROM media_coverage
    WHERE coverage_type = 'Written'
)
SELECT * FROM Written_Reporters;

-- 6. CTE to count coverage types
WITH Type_Count AS (
    SELECT coverage_type, COUNT(*) AS total
    FROM media_coverage
    GROUP BY coverage_type
)
SELECT * FROM Type_Count;

-- 7. CTE with total coverages per media house
WITH House_Coverages AS (
    SELECT media_house, COUNT(*) AS total
    FROM media_coverage
    GROUP BY media_house
)
SELECT * FROM House_Coverages
WHERE total > 3;

-- 8. CTE to find reporters by language
WITH English_Reporters AS (
    SELECT reporter_name, event_covered
    FROM media_coverage
    WHERE language = 'English'
)
SELECT * FROM English_Reporters;


-- 9. Procedure to insert a new coverage record
DELIMITER //
CREATE PROCEDURE AddMediaCoverage(
    IN p_media_house VARCHAR(100),
    IN p_reporter_name VARCHAR(100),
    IN p_event_covered VARCHAR(100),
    IN p_coverage_type ENUM('Live', 'Recorded', 'Written'),
    IN p_language VARCHAR(50),
    IN p_country VARCHAR(100),
    IN p_coverage_date DATE,
    IN p_broadcast_channel VARCHAR(100),
    IN p_accreditation_id VARCHAR(50)
)
BEGIN
    INSERT INTO media_coverage (
        media_house, reporter_name, event_covered, coverage_type,
        language, country, coverage_date, broadcast_channel, accreditation_id
    )
    VALUES (
        p_media_house, p_reporter_name, p_event_covered, p_coverage_type,
        p_language, p_country, p_coverage_date, p_broadcast_channel, p_accreditation_id
    );
END //
DELIMITER ;

-- 10. Procedure to get all coverage by a specific media house
DELIMITER //
CREATE PROCEDURE GetCoverageByHouse(IN house_name VARCHAR(100))
BEGIN
    SELECT * FROM media_coverage
    WHERE media_house = house_name;
END //
DELIMITER ;

-- 11. Procedure to update reporter name by coverage ID
DELIMITER //
CREATE PROCEDURE UpdateReporterName(IN id INT, IN new_name VARCHAR(100))
BEGIN
    UPDATE media_coverage
    SET reporter_name = new_name
    WHERE coverage_id = id;
END //
DELIMITER ;

-- 12. Procedure to delete coverage by accreditation ID
DELIMITER //
CREATE PROCEDURE DeleteByAccreditation(IN acc_id VARCHAR(50))
BEGIN
    DELETE FROM media_coverage
    WHERE accreditation_id = acc_id;
END //
DELIMITER ;

-- 13. Grant SELECT and INSERT on media_coverage to user 'report_user'
GRANT SELECT, INSERT ON media_coverage TO 'report_user'@'localhost';

-- 14. Revoke INSERT permission from 'report_user'
REVOKE INSERT ON media_coverage FROM 'report_user'@'localhost';

-- 15. Start transaction to insert two records
START TRANSACTION;
INSERT INTO media_coverage (media_house, reporter_name, event_covered, coverage_type, language, country, coverage_date, broadcast_channel, accreditation_id)
VALUES ('ESPN', 'Alex Ray', 'Swimming Finals', 'Live', 'English', 'USA', CURDATE(), 'ESPN Sports', 'ACC123');
INSERT INTO media_coverage (media_house, reporter_name, event_covered, coverage_type, language, country, coverage_date, broadcast_channel, accreditation_id)
VALUES ('BBC', 'Nina Patel', 'Archery', 'Written', 'English', 'UK', CURDATE(), 'BBC Online', 'ACC124');

-- 16. Commit the transaction
COMMIT;

-- 17. Rollback transaction if something goes wrong
ROLLBACK;

-- 18. Trigger to log insertion into a log table
CREATE TABLE media_coverage_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    coverage_id INT,
    media_house VARCHAR(100),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER AfterInsertCoverage
AFTER INSERT ON media_coverage
FOR EACH ROW
INSERT INTO media_coverage_log (coverage_id, media_house)
VALUES (NEW.coverage_id, NEW.media_house);

-- 19. Trigger to prevent future coverage dates
CREATE TRIGGER PreventFutureCoverageDate
BEFORE INSERT ON media_coverage
FOR EACH ROW
BEGIN
    IF NEW.coverage_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Coverage date cannot be in the future.';
    END IF;
END;

-- 20. Trigger to auto-capitalize media house name
CREATE TRIGGER CapitalizeMediaHouse
BEFORE INSERT ON media_coverage
FOR EACH ROW
SET NEW.media_house = UPPER(NEW.media_house);

-- Table 25: 
-- 1. View of all positive doping cases
CREATE VIEW Positive_Tests AS
SELECT test_id, athlete_id, sport, test_date, substance_found
FROM doping_tests
WHERE result = 'Positive';

-- 2. View showing doping cases grouped by sport
CREATE VIEW Doping_By_Sport AS
SELECT sport, COUNT(*) AS total_cases
FROM doping_tests
GROUP BY sport;

-- 3. View of all tests conducted by WADA
CREATE VIEW WADA_Tests AS
SELECT *
FROM doping_tests
WHERE testing_agency = 'WADA';

-- 4. View of all blood sample tests
CREATE VIEW Blood_Tests AS
SELECT *
FROM doping_tests
WHERE sample_type = 'Blood';

-- 5. CTE listing athletes with positive tests
WITH Positive_Athletes AS (
    SELECT athlete_id, sport, test_date
    FROM doping_tests
    WHERE result = 'Positive'
)
SELECT * FROM Positive_Athletes;

-- 6. CTE to count tests per agency
WITH Agency_Count AS (
    SELECT testing_agency, COUNT(*) AS total_tests
    FROM doping_tests
    GROUP BY testing_agency
)
SELECT * FROM Agency_Count;

-- 7. CTE for recent tests (last 30 days)
WITH Recent_Tests AS (
    SELECT * FROM doping_tests
    WHERE test_date >= CURDATE() - INTERVAL 30 DAY
)
SELECT * FROM Recent_Tests;

-- 8. CTE for tests with a substance found
WITH Substances AS (
    SELECT substance_found, COUNT(*) AS substance_count
    FROM doping_tests
    WHERE substance_found IS NOT NULL
    GROUP BY substance_found
)
SELECT * FROM Substances;

-- 9. Procedure to insert a new doping test
DELIMITER //
CREATE PROCEDURE AddDopingTest(
    IN p_athlete_id INT,
    IN p_sport VARCHAR(100),
    IN p_test_date DATE,
    IN p_result ENUM('Negative', 'Positive'),
    IN p_substance_found VARCHAR(100),
    IN p_testing_agency VARCHAR(100),
    IN p_sample_type ENUM('Urine', 'Blood'),
    IN p_location VARCHAR(100),
    IN p_remarks TEXT
)
BEGIN
    INSERT INTO doping_tests (
        athlete_id, sport, test_date, result,
        substance_found, testing_agency, sample_type,
        location, remarks
    ) VALUES (
        p_athlete_id, p_sport, p_test_date, p_result,
        p_substance_found, p_testing_agency, p_sample_type,
        p_location, p_remarks
    );
END;
//
DELIMITER ;

-- 10. Procedure to get all positive test cases
DELIMITER //
CREATE PROCEDURE GetPositiveTests()
BEGIN
    SELECT * FROM doping_tests
    WHERE result = 'Positive';
END;
//
DELIMITER ;

-- 11. Procedure to update substance found
DELIMITER //
CREATE PROCEDURE UpdateSubstance(
    IN p_test_id INT,
    IN p_substance VARCHAR(100)
)
BEGIN
    UPDATE doping_tests
    SET substance_found = p_substance
    WHERE test_id = p_test_id;
END;
//
DELIMITER ;

-- 12. Procedure to delete a test by ID
DELIMITER //
CREATE PROCEDURE DeleteTest(IN p_test_id INT)
BEGIN
    DELETE FROM doping_tests
    WHERE test_id = p_test_id;
END;
//
DELIMITER ;

-- 15. Start transaction to insert multiple doping tests
START TRANSACTION;
INSERT INTO doping_tests (athlete_id, sport, test_date, result, substance_found, testing_agency, sample_type, location, remarks)
VALUES (101, 'Weightlifting', CURDATE(), 'Positive', 'Stanozolol', 'WADA', 'Urine', 'Tokyo', 'Test taken after event');
INSERT INTO doping_tests (athlete_id, sport, test_date, result, substance_found, testing_agency, sample_type, location, remarks)
VALUES (102, 'Cycling', CURDATE(), 'Negative', NULL, 'NADA', 'Blood', 'Paris', 'Routine test');

-- 16. Commit the transaction
COMMIT;

-- 17. Rollback in case of error
ROLLBACK;

-- 18. Create audit table for doping logs
CREATE TABLE doping_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    test_id INT,
    action_type VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log inserts
CREATE TRIGGER LogDopingInsert
AFTER INSERT ON doping_tests
FOR EACH ROW
INSERT INTO doping_log (test_id, action_type)
VALUES (NEW.test_id, 'INSERT');

-- 19. Prevent inserting test with future date
CREATE TRIGGER PreventFutureTestDate
BEFORE INSERT ON doping_tests
FOR EACH ROW
BEGIN
    IF NEW.test_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Test date cannot be in the future';
    END IF;
END;

-- 20. Automatically set remarks for positive results with no remarks
CREATE TRIGGER SetDefaultPositiveRemark
BEFORE INSERT ON doping_tests
FOR EACH ROW
BEGIN
    IF NEW.result = 'Positive' AND NEW.remarks IS NULL THEN
        SET NEW.remarks = 'Positive result - further review needed';
    END IF;
END;
