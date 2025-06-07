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

-- 10. Call the procedure
CALL add_country('Wakanda', 'WAK', 'Africa', 5000000, 10000000000.00, 'Birnin Zana', 'Xhosa', 'UTC+2', 'https://wakanda.flag');

-- 11. Procedure to update GDP of a country
DELIMITER //
CREATE PROCEDURE update_gdp(IN cid INT, IN new_gdp DECIMAL(20,2))
BEGIN
  UPDATE Countries SET gdp = new_gdp WHERE country_id = cid;
END;
//
DELIMITER ;

-- 12. Call update procedure
CALL update_gdp(1, 1500000000000.00);

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

-- 10. Call procedure to add a sample sport
CALL add_sport('Laser Tag', 'Combat', 1, 2024, 'Laser Gun, Vest', 'Indoor', 30, 'Points', 'World Laser Federation');

-- 11. Procedure to update sport duration
DELIMITER //
CREATE PROCEDURE update_duration(IN sportID INT, IN new_duration INT)
BEGIN
  UPDATE Sports SET typical_duration_minutes = new_duration WHERE sport_id = sportID;
END;
//
DELIMITER ;

-- 12. Call procedure to update duration
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
