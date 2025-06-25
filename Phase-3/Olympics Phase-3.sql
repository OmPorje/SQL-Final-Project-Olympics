use Olympics;
-- Joins<SQ<Fun<B&UD {20 Queries}

-- Table 1: Countries
-- 1. Find countries with population greater than the average population
SELECT country_name, population
FROM Countries
WHERE population > (
    SELECT AVG(population) FROM Countries
);

-- 2. List countries whose GDP is higher than the GDP of 'India'
SELECT country_name, gdp
FROM Countries
WHERE gdp > (
    SELECT gdp FROM Countries WHERE country_name = 'India'
);

-- 3. Get countries located in the same continent as 'Brazil'
SELECT country_name, continent
FROM Countries
WHERE continent = (
    SELECT continent FROM Countries WHERE country_name = 'Brazil'
);

-- 4. Find countries whose official language is the most common language
SELECT country_name, language
FROM Countries
WHERE language = (
    SELECT language
    FROM Countries
    GROUP BY language
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 5. List countries whose population is in the top 3 highest populations
SELECT country_name, population
FROM Countries
WHERE population >= (
    SELECT population
    FROM Countries
    ORDER BY population DESC
    LIMIT 1 OFFSET 2
);

-- 6. Count total countries
SELECT COUNT(*) FROM Countries;

-- 7. Average population of all countries
SELECT AVG(population) FROM Countries;

-- 8. Convert country names to uppercase
SELECT UPPER(country_name) FROM Countries;

-- 9. Get current date and time
SELECT NOW();

-- 10. Length of each country name
SELECT LENGTH(country_name) FROM Countries;

-- 11. Function to calculate population in millions
DELIMITER //
CREATE FUNCTION population_in_millions(pop BIGINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN pop / 1000000;
END;
// DELIMITER ;

SELECT country_name, population_in_millions(population) AS pop_million FROM Countries;

-- 12. Function to check if GDP is high (> 1 trillion)
DELIMITER //
CREATE FUNCTION is_gdp_high(gdp_value DECIMAL(20,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF gdp_value > 1000000000000 THEN
        RETURN 'High';
    ELSE
        RETURN 'Low';
    END IF;
END;
// DELIMITER ;

SELECT country_name, is_gdp_high(gdp) FROM Countries;

-- 13. Function to get first 3 letters of a country code
DELIMITER //
CREATE FUNCTION first_three_letters(code VARCHAR(3))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    RETURN LEFT(code, 3);
END;
// DELIMITER ;

SELECT country_name, first_three_letters(country_code) FROM Countries;

-- 14. Function to calculate GDP per capita
DELIMITER //
CREATE FUNCTION gdp_per_capita(gdp DECIMAL(20,2), pop BIGINT)
RETURNS DECIMAL(20,2)
DETERMINISTIC
BEGIN
    IF pop = 0 THEN
        RETURN 0;
    ELSE
        RETURN gdp / pop;
    END IF;
END;
//  DELIMITER ;

SELECT country_name, gdp_per_capita(gdp, population) AS gdp_capita FROM Countries;

-- 15. Function to convert language to lowercase
DELIMITER //
CREATE FUNCTION to_lowercase(lang VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN LOWER(lang);
END;
// DELIMITER ;

SELECT country_name, to_lowercase(language) FROM Countries;

-- 16. INNER JOIN: Athletes with their Country and Sport
SELECT a.athlete_id, CONCAT(a.first_name, ' ', a.last_name) AS full_name, c.country_name, s.sport_name
FROM Athletes a
INNER JOIN Countries c ON a.country_id = c.country_id
INNER JOIN Sports s ON a.sport_id = s.sport_id;

-- 17. LEFT JOIN: All Athletes and their Sports (even if sport is missing)
SELECT a.athlete_id,a.first_name,a.last_name,s.sport_name
FROM Athletes a
LEFT JOIN Sports s ON a.sport_id = s.sport_id;

-- 18. RIGHT JOIN: All Sports and any Athletes who play them
SELECT s.sport_name, a.athlete_id, a.first_name, a.last_name
FROM Athletes a
RIGHT JOIN Sports s ON a.sport_id = s.sport_id;

-- 19. FULL OUTER JOIN (Simulated using UNION in MySQL)
SELECT a.athlete_id, a.first_name, a.last_name, s.sport_name
FROM Athletes a
LEFT JOIN Sports s ON a.sport_id = s.sport_id
UNION
SELECT a.athlete_id,a.first_name,a.last_name,s.sport_name
FROM Athletes a
RIGHT JOIN Sports s ON a.sport_id = s.sport_id;

-- 20. SELF JOIN: Find athletes from the same country
SELECT a1.athlete_id AS athlete1_id,CONCAT(a1.first_name, ' ', a1.last_name) AS athlete1_name,
a2.athlete_id AS athlete2_id, CONCAT(a2.first_name, ' ', a2.last_name) AS athlete2_name, c.country_name
FROM Athletes a1
JOIN Athletes a2 ON a1.country_id = a2.country_id AND a1.athlete_id <> a2.athlete_id
JOIN Countries c ON a1.country_id = c.country_id;

-- Table 2: Sports
-- 1. Sports with longer than average match duration
SELECT sport_name, typical_duration_minutes
FROM Sports
WHERE typical_duration_minutes > (
    SELECT AVG(typical_duration_minutes) FROM Sports
);

-- 2. Sports introduced before the earliest team sport
SELECT sport_name, olympic_since_year
FROM Sports
WHERE olympic_since_year < (
    SELECT MIN(olympic_since_year) FROM Sports WHERE is_team_sport = 1
);

-- 3. Find sports using the same scoring_type as 'Football'
SELECT sport_name, scoring_type
FROM Sports
WHERE scoring_type = (
    SELECT scoring_type FROM Sports WHERE sport_name = 'Football'
);

-- 4. Sports in the same category as 'Swimming'
SELECT sport_name, sport_category
FROM Sports
WHERE sport_category = (
    SELECT sport_category FROM Sports WHERE sport_name = 'Swimming'
);

-- 5. Sports with match duration equal to the max duration
SELECT sport_name, typical_duration_minutes
FROM Sports
WHERE typical_duration_minutes = (
    SELECT MAX(typical_duration_minutes) FROM Sports
);

-- 6. Count total number of sports
SELECT COUNT(*) FROM Sports;

-- 7. Find average match duration
SELECT AVG(typical_duration_minutes) AS avg_duration FROM Sports;

-- 8. Convert sport names to uppercase
SELECT UPPER(sport_name) FROM Sports;

-- 9. Get current date and time (just to demo built-in function)
SELECT NOW();

-- 10. Get length of governing body name
SELECT sport_name, LENGTH(governing_body) AS body_name_length FROM Sports;

-- 11. Convert minutes to hours
DELIMITER //
CREATE FUNCTION duration_in_hours(mins INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN mins / 60;
END;
// DELIMITER ;

SELECT sport_name, typical_duration_minutes, duration_in_hours(typical_duration_minutes) AS duration_in_hours
FROM Sports;

-- 12. Check if sport is recent (added after year 2000)
DELIMITER //
CREATE FUNCTION is_recent_sport(year_added SMALLINT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF year_added > 2000 THEN
        RETURN 'Recent';
    ELSE
        RETURN 'Classic';
    END IF;
END;
// DELIMITER ;

SELECT sport_name, olympic_since_year, is_recent_sport(olympic_since_year) AS type_of_sport
FROM Sports;

-- 13. Return short version of category (first 3 letters)
DELIMITER //
CREATE FUNCTION short_category(cat VARCHAR(50))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    RETURN LEFT(cat, 3);
END; 
// DELIMITER ;

SELECT sport_name,sport_category, short_category(sport_category) AS category_code
FROM Sports;

-- 14. Return scoring type in uppercase
DELIMITER //
CREATE FUNCTION to_lower_score(score VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(score);
END;
// DELIMITER ;

SELECT sport_name, scoring_type, to_lower_score(scoring_type) AS score_format
FROM Sports;

-- 15. Add label to duration like '90 mins'
DELIMITER //
CREATE FUNCTION duration_label(mins INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CONCAT(mins, ' mins');
END;
// DELIMITER ;

SELECT sport_name, duration_label(typical_duration_minutes) AS match_duration_label
FROM Sports;

-- 16. Inner join athletes with their sports
SELECT 
    a.athlete_id,
    CONCAT(a.first_name, ' ', a.last_name) AS athlete_name,
    s.sport_name
FROM Athletes a
INNER JOIN Sports s ON a.sport_id = s.sport_id;

-- 17. Left join all sports with athletes (show all sports)
SELECT 
    s.sport_name,
    a.athlete_id,
    CONCAT(a.first_name, ' ', a.last_name) AS athlete_name
FROM Sports s
LEFT JOIN Athletes a ON s.sport_id = a.sport_id;

-- 18. Right join all athletes with sports (show all athletes)
SELECT 
    a.athlete_id,
    CONCAT(a.first_name, ' ', a.last_name) AS athlete_name,
    s.sport_name
FROM Sports s
RIGHT JOIN Athletes a ON s.sport_id = a.sport_id;

-- 19. Join athletes with their countries and sports
SELECT 
    a.athlete_id,
    CONCAT(a.first_name, ' ', a.last_name) AS athlete_name,
    c.country_name,
    s.sport_name
FROM Athletes a
JOIN Countries c ON a.country_id = c.country_id
JOIN Sports s ON a.sport_id = s.sport_id;

-- 20. Self join sports having the same category
SELECT 
    s1.sport_name AS sport_1,
    s2.sport_name AS sport_2,
    s1.sport_category
FROM Sports s1
JOIN Sports s2 
    ON s1.sport_category = s2.sport_category 
   AND s1.sport_id <> s2.sport_id;

-- Table 3: Athletes

-- 1. Athletes taller than the average height
SELECT first_name, last_name, height_cm
FROM Athletes
WHERE height_cm > (SELECT AVG(height_cm) FROM Athletes);

-- 2. Athletes from the most represented country
SELECT first_name, last_name
FROM Athletes
WHERE country_id = (
    SELECT country_id FROM Athletes GROUP BY country_id ORDER BY COUNT(*) DESC LIMIT 1
);

-- 3. Athletes playing the same sport as a specific athlete
SELECT first_name, last_name
FROM Athletes
WHERE sport_id = (
    SELECT sport_id FROM Athletes WHERE first_name = 'Usain' AND last_name = 'Bolt'
);

-- 4. Youngest athlete
SELECT * FROM Athletes
WHERE date_of_birth = (SELECT MAX(date_of_birth) FROM Athletes);

-- 5. Oldest athlete from a specific country
SELECT * FROM Athletes
WHERE country_id = 1 AND date_of_birth = (
    SELECT MIN(date_of_birth) FROM Athletes WHERE country_id = 1
);

-- 6. Count total athletes
SELECT COUNT(*) AS total_athletes FROM Athletes;

-- 7. Find average height
SELECT AVG(height_cm) AS avg_height FROM Athletes;

-- 8. Display full name in uppercase
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS full_name FROM Athletes;

-- 9. Get birth year from DOB
SELECT first_name, YEAR(date_of_birth) AS birth_year FROM Athletes;

-- 10. Get length of athlete's bio
SELECT first_name, LENGTH(bio) AS bio_length FROM Athletes;



-- 11. Calculate BMI
DELIMITER //
CREATE FUNCTION calc_bmi(height_cm INT, weight_kg INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  RETURN (weight_kg / POWER(height_cm/100, 2));
END;
// DELIMITER ;

SELECT athlete_id, first_name, height_cm, weight_kg, calc_bmi(height_cm, weight_kg) AS bmi
FROM Athletes;

-- 12. Return age from DOB
DELIMITER //
CREATE FUNCTION get_age(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END;
// DELIMITER ;

SELECT athlete_id, first_name, date_of_birth, get_age(date_of_birth) AS age
FROM Athletes;

-- 13. Format full name
DELIMITER //
CREATE FUNCTION full_name(first VARCHAR(50), last VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  RETURN CONCAT(first, ' ', last);
END;
// DELIMITER ; 

SELECT athlete_id, full_name(first_name, last_name) AS athlete_full_name
FROM Athletes;

-- 14. Check if athlete is tall
DELIMITER //
CREATE FUNCTION is_tall(height INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  IF height > 185 THEN RETURN 'Tall';
  ELSE RETURN 'Average';
  END IF;
END;
// DELIMITER ;

SELECT athlete_id,first_name,height_cm, is_tall(height_cm) AS height_category
FROM Athletes;

-- 15. Return weight class
DELIMITER //
CREATE FUNCTION weight_class(weight INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  IF weight < 60 THEN RETURN 'Lightweight';
  ELSEIF weight <= 90 THEN RETURN 'Middleweight';
  ELSE RETURN 'Heavyweight';
  END IF;
END;
// DELIMITER ;

SELECT athlete_id, first_name, weight_kg, weight_class(weight_kg) AS weight_category
FROM Athletes;

-- 16. Inner join with Countries to get country name
SELECT a.athlete_id, a.first_name, c.country_name
FROM Athletes a
JOIN Countries c ON a.country_id = c.country_id;

-- 17. Left join to show all athletes and their sports
SELECT a.athlete_id, a.first_name, s.sport_name
FROM Athletes a
LEFT JOIN Sports s ON a.sport_id = s.sport_id;

-- 18. Right join to show all sports and their athletes
SELECT s.sport_name, a.first_name
FROM Sports s
RIGHT JOIN Athletes a ON a.sport_id = s.sport_id;

-- 19. Join athletes, countries, and sports
SELECT a.first_name, c.country_name, s.sport_name
FROM Athletes a
JOIN Countries c ON a.country_id = c.country_id
JOIN Sports s ON a.sport_id = s.sport_id;

-- 20. Self join to find pairs of athletes from same country
SELECT a1.first_name AS athlete1, a2.first_name AS athlete2, c.country_name
FROM Athletes a1
JOIN Athletes a2 ON a1.country_id = a2.country_id AND a1.athlete_id <> a2.athlete_id
JOIN Countries c ON a1.country_id = c.country_id;

-- Table 4: Olympics
-- 1. Olympic year with most athletes
SELECT * FROM Olympics
WHERE number_of_athletes = (SELECT MAX(number_of_athletes) FROM Olympics);

-- 2. Olympics hosted in the same country as a specific year
SELECT * FROM Olympics
WHERE country_id = (
    SELECT country_id FROM Olympics WHERE year = 2012
);

-- 3. Latest Summer Olympics
SELECT * FROM Olympics
WHERE season = 'Summer' AND year = (
    SELECT MAX(year) FROM Olympics WHERE season = 'Summer'
);

-- 4. Olympics with more than average sports
SELECT * FROM Olympics
WHERE number_of_sports > (SELECT AVG(number_of_sports) FROM Olympics);

-- 5. Countries that hosted more than one Olympics
SELECT * FROM Olympics
WHERE country_id IN (
    SELECT country_id FROM Olympics GROUP BY country_id HAVING COUNT(*) > 1
);

-- 6. Count total Olympic events
SELECT COUNT(*) AS total_olympics FROM Olympics;

-- 7. Find average number of athletes
SELECT AVG(number_of_athletes) AS avg_athletes FROM Olympics;

-- 8. Get length of city names
SELECT city, LENGTH(city) AS city_name_length FROM Olympics;

-- 9. Extract year from opening date
SELECT year, opening_date, YEAR(opening_date) AS opening_year FROM Olympics;

-- 10. Days between opening and closing
SELECT year, DATEDIFF(closing_date, opening_date) AS total_days FROM Olympics;



-- 11. Days between open and close
DELIMITER //
CREATE FUNCTION olympic_duration(start DATE, end DATE)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN DATEDIFF(end, start);
END;
// DELIMITER ;

SELECT year, OLYMPIC_DURATION(opening_date, closing_date) AS duration_days
FROM Olympics;

-- 12. Is it a modern Olympic? (year >= 2000)
DELIMITER //
CREATE FUNCTION is_modern(year INT)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  IF year >= 2000 THEN RETURN 'Modern';
  ELSE RETURN 'Classic';
  END IF;
END;
// DELIMITER ;

SELECT year, is_modern(year) AS olympic_type
FROM Olympics;

-- 13. Format full host location
DELIMITER //
CREATE FUNCTION host_location(city VARCHAR(100), country VARCHAR(100))
RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
  RETURN CONCAT(city, ', ', country);
END;
// DELIMITER ;

SELECT year, host_location(city, c.country_name) AS location
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id;

-- 14. Average athletes per sport
DELIMITER //
CREATE FUNCTION avg_athletes_per_sport(athletes INT, sports INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  RETURN athletes / sports;
END;
// DELIMITER ;

SELECT year, number_of_athletes, number_of_sports, avg_athletes_per_sport(number_of_athletes, number_of_sports) AS avg_per_sport
FROM Olympics;

-- 15. Olympic slogan length category
DELIMITER //
CREATE FUNCTION slogan_type(slogan VARCHAR(100))
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  IF LENGTH(slogan) >= 50 THEN RETURN 'Long';
  ELSE RETURN 'Short';
  END IF;
END;
// 
DELIMITER ;

SELECT year, slogan, slogan_type(slogan) AS slogan_length_category
FROM Olympics;

-- 16. Join Olympics with Countries to show host country name
SELECT o.year, c.country_name FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id;

-- 17. List Olympics and total sports grouped by continent
SELECT c.continent, COUNT(o.olympic_id) AS total_olympics
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
GROUP BY c.continent;

-- 18. Olympics where host city and capital match (if any)
SELECT o.year, o.city, c.capital_city
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
WHERE o.city = c.capital_city;

-- 19. Join Olympics and Countries, filter Summer games
SELECT o.year, o.city, c.country_name
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
WHERE o.season = 'Summer';

-- 20. Olympics and countries with more than 100 million population
SELECT o.year, c.country_name, c.population
FROM Olympics o
JOIN Countries c ON o.country_id = c.country_id
WHERE c.population > 100000000;

-- Table 5: Events

-- 1. Events with the most rounds
SELECT * FROM Events
WHERE number_of_rounds = (SELECT MAX(number_of_rounds) FROM Events);

-- 2. Events in the same sport as '100m Sprint'
SELECT * FROM Events
WHERE sport_id = (SELECT sport_id FROM Events WHERE event_name = '100m Sprint');

-- 3. Latest Olympic edition that hosted an event
SELECT * FROM Events
WHERE olympic_id = (SELECT MAX(olympic_id) FROM Events);

-- 4. Events with more rounds than average
SELECT * FROM Events
WHERE number_of_rounds > (SELECT AVG(number_of_rounds) FROM Events);

-- 5. Events using most common scoring method
SELECT * FROM Events
WHERE scoring_method = (
  SELECT scoring_method FROM Events GROUP BY scoring_method ORDER BY COUNT(*) DESC LIMIT 1
);

-- 6. Total number of events
SELECT COUNT(*) AS total_events FROM Events;

-- 7. Average number of rounds per event
SELECT AVG(number_of_rounds) AS avg_rounds FROM Events;

-- 8. Length of each event name
SELECT event_name, LENGTH(event_name) AS name_length FROM Events;

-- 9. Uppercase gender category
SELECT event_name, UPPER(gender_category) AS gender_caps FROM Events;

-- 10. Group events by scoring method
SELECT scoring_method, COUNT(*) AS method_count FROM Events GROUP BY scoring_method;

-- 11. Classify rounds into Short/Medium/Long
DELIMITER //
CREATE FUNCTION round_type(rounds INT)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  IF rounds <= 2 THEN RETURN 'Short';
  ELSEIF rounds <= 4 THEN RETURN 'Medium';
  ELSE RETURN 'Long';
  END IF;
END;
// DELIMITER ;

-- 12. Format event title with gender
DELIMITER //
CREATE FUNCTION event_title(name VARCHAR(100), gender VARCHAR(10))
RETURNS VARCHAR(120) DETERMINISTIC
BEGIN
  RETURN CONCAT(name, ' [', gender, ']');
END;
// DELIMITER ;;

-- 13. Check if event is a final
DELIMITER //
CREATE FUNCTION is_final(type VARCHAR(50))
RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
  IF LOWER(type) = 'final' THEN RETURN 'Yes';
  ELSE RETURN 'No';
  END IF;
END;
//

-- 14. Clean distance unit (remove 'm' or 'kg')
DELIMITER //
CREATE FUNCTION clean_unit(dist VARCHAR(50))
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  RETURN TRIM(TRAILING 'mkg' FROM dist);
END;
// DELIMITER ;

-- 15. Is event mixed gender?
DELIMITER //
CREATE FUNCTION is_mixed(gender VARCHAR(10))
RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
  IF gender = 'Mixed' THEN RETURN 'Yes';
  ELSE RETURN 'No';
  END IF;
END;
// DELIMITER ;

-- 16. Join Events with Sports to show sport name
SELECT e.event_name, s.sport_name FROM Events e
JOIN Sports s ON e.sport_id = s.sport_id;

-- 17. Join Events with Olympics to get year and host city
SELECT e.event_name, o.year, o.city FROM Events e
JOIN Olympics o ON e.olympic_id = o.olympic_id;

-- 18. Show Events with sport category and gender
SELECT e.event_name, s.sport_category, e.gender_category
FROM Events e
JOIN Sports s ON e.sport_id = s.sport_id;

-- 19. Events hosted in Olympics after 2010
SELECT e.event_name, o.year FROM Events e
JOIN Olympics o ON e.olympic_id = o.olympic_id
WHERE o.year > 2010;

-- 20. Events along with venue and number of rounds
SELECT e.event_name, e.venue_name, e.number_of_rounds, s.sport_name
FROM Events e
JOIN Sports s ON e.sport_id = s.sport_id;

-- Table 6: Venues

-- 1. Venue with the highest capacity
SELECT * FROM Venues
WHERE capacity = (SELECT MAX(capacity) FROM Venues);

-- 2. Venues constructed in same year as the oldest venue
SELECT * FROM Venues
WHERE construction_year = (SELECT MIN(construction_year) FROM Venues);

-- 3. Venues associated with latest Olympic edition
SELECT * FROM Venues
WHERE olympic_id = (SELECT MAX(olympic_id) FROM Venues);

-- 4. Venues with capacity above average
SELECT * FROM Venues
WHERE capacity > (SELECT AVG(capacity) FROM Venues);

-- 5. Venues located in cities that have more than 1 venue
SELECT * FROM Venues
WHERE location IN (
  SELECT location FROM Venues GROUP BY location HAVING COUNT(*) > 1
);

-- 6. Count total number of venues
SELECT COUNT(*) AS total_venues FROM Venues;

-- 7. Find average venue capacity
SELECT AVG(capacity) AS average_capacity FROM Venues;

-- 8. Return the length of each venue name
SELECT venue_name, LENGTH(venue_name) AS name_length FROM Venues;

-- 9. Difference between renovation and construction year
SELECT venue_name, renovated_year - construction_year AS years_between
FROM Venues;

-- 10. Group venues by surface type
SELECT surface_type, COUNT(*) AS total FROM Venues GROUP BY surface_type;

-- 11. Calculate age of venue
DELIMITER //
CREATE FUNCTION venue_age(built_year INT)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN YEAR(CURDATE()) - built_year;
END;
// DELIMITER ;

SELECT venue_name, venue_age(construction_year) AS age FROM Venues;

-- 12. Check if venue is recently renovated
DELIMITER //
CREATE FUNCTION is_recently_renovated(renovated INT)
RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
  IF renovated >= YEAR(CURDATE()) - 5 THEN RETURN 'Yes';
  ELSE RETURN 'No';
  END IF;
END;
// DELIMITER ;

SELECT venue_name, is_recently_renovated(renovated_year) AS recently_renovated FROM Venues;

-- 13. Format venue title with location
DELIMITER //
CREATE FUNCTION full_venue_title(name VARCHAR(100), loc VARCHAR(100))
RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
  RETURN CONCAT(name, ' (', loc, ')');
END;
// DELIMITER ;

SELECT full_venue_title(venue_name, location) AS full_title FROM Venues;

-- 14. Capacity category (Small, Medium, Large)
DELIMITER //
CREATE FUNCTION capacity_range(cap INT)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  IF cap < 10000 THEN RETURN 'Small';
  ELSEIF cap <= 40000 THEN RETURN 'Medium';
  ELSE RETURN 'Large';
  END IF;
END;
// DELIMITER ;

SELECT venue_name, capacity_range(capacity) AS cap_category FROM Venues;

-- 15. Venue type short code
DELIMITER //
CREATE FUNCTION venue_type_code(type VARCHAR(50))
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
  RETURN UPPER(LEFT(type, 3));
END;
// DELIMITER ;

SELECT venue_name, venue_type_code(venue_type) AS type_code FROM Venues;

-- 16. Join with Olympics to show venue and host year
SELECT v.venue_name, o.year FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id;

-- 17. Join with Countries to show venue and country name
SELECT v.venue_name, c.country_name FROM Venues v
JOIN Countries c ON v.country_id = c.country_id;

-- 18. Venues with Olympic slogan
SELECT v.venue_name, o.slogan FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id;

-- 19. Venues in countries with population > 50 million
SELECT v.venue_name, c.country_name, c.population
FROM Venues v
JOIN Countries c ON v.country_id = c.country_id
WHERE c.population > 50000000;

-- 20. Venues and city where Olympic is hosted
SELECT v.venue_name, o.city FROM Venues v
JOIN Olympics o ON v.olympic_id = o.olympic_id;

-- Table 7: Teams
-- 1. Team with the highest number of medals
SELECT * FROM Teams
WHERE total_medals = (SELECT MAX(total_medals) FROM Teams);

-- 2. Teams with more athletes than average
SELECT * FROM Teams
WHERE total_athletes > (SELECT AVG(total_athletes) FROM Teams);

-- 3. Teams from countries with population > 100 million
SELECT * FROM Teams
WHERE country_id IN (
  SELECT country_id FROM Countries WHERE population > 100000000
);

-- 4. Teams formed in the same year as the oldest team
SELECT * FROM Teams
WHERE formation_year = (SELECT MIN(formation_year) FROM Teams);

-- 5. Teams linked to the latest Olympic edition
SELECT * FROM Teams
WHERE olympic_id = (SELECT MAX(olympic_id) FROM Olympics);

-- 6. Count total teams
SELECT COUNT(*) AS total_teams FROM Teams;

-- 7. Average medals won per team
SELECT AVG(total_medals) AS avg_medals FROM Teams;

-- 8. Maximum athletes in a team
SELECT MAX(total_athletes) AS max_athletes FROM Teams;

-- 9. Difference in medals and athletes per team
SELECT team_name, total_athletes - total_medals AS diff FROM Teams;

-- 10. Group teams by formation decade
SELECT (formation_year DIV 10) * 10 AS decade, COUNT(*) AS teams_count
FROM Teams GROUP BY decade;

DELIMITER //

-- 11. Calculate team age
CREATE FUNCTION team_age(form_year INT)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN YEAR(CURDATE()) - form_year;
END;
//

SELECT team_name, team_age(formation_year) AS team_age FROM Teams;

-- 12. Medal status (Gold, Silver, Bronze, None)
CREATE FUNCTION medal_status(medals INT)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  IF medals >= 10 THEN RETURN 'Gold';
  ELSEIF medals >= 5 THEN RETURN 'Silver';
  ELSEIF medals >= 1 THEN RETURN 'Bronze';
  ELSE RETURN 'None';
  END IF;
END;
//

SELECT team_name, medal_status(total_medals) AS status FROM Teams;

-- 13. Is team large based on athlete count
CREATE FUNCTION is_large_team(count INT)
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
  IF count >= 20 THEN RETURN 'Yes';
  ELSE RETURN 'No';
  END IF;
END;
//

SELECT team_name, is_large_team(total_athletes) AS large_team FROM Teams;

-- 14. Format team title
CREATE FUNCTION format_team_title(name VARCHAR(100), coach VARCHAR(100))
RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
  RETURN CONCAT(name, ' (Coached by ', coach, ')');
END;
//

SELECT format_team_title(team_name, team_coach) AS titled_team FROM Teams;

-- 15. Return medal-to-athlete ratio
CREATE FUNCTION medal_ratio(medals INT, athletes INT)
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
  IF athletes = 0 THEN RETURN 0;
  RETURN medals / athletes;
  END IF;
END;
// DELIMITER ;

SELECT team_name, medal_ratio(total_medals, total_athletes) AS ratio FROM Teams;


-- 16. Show team with country name
SELECT t.team_name, c.country_name FROM Teams t
JOIN Countries c ON t.country_id = c.country_id;

-- 17. Show team with sport name
SELECT t.team_name, s.sport_name FROM Teams t
JOIN Sports s ON t.sport_id = s.sport_id;

-- 18. Show team and Olympic year
SELECT t.team_name, o.year FROM Teams t
JOIN Olympics o ON t.olympic_id = o.olympic_id;

-- 19. Teams from countries on the same continent
SELECT t.team_name, c.continent FROM Teams t
JOIN Countries c ON t.country_id = c.country_id;

-- 20. Teams and Olympic slogan
SELECT t.team_name, o.slogan FROM Teams t
JOIN Olympics o ON t.olympic_id = o.olympic_id;

-- Table 8: Medals
-- 1. Athletes who won the most medals
SELECT athlete_id FROM Medals
GROUP BY athlete_id
HAVING COUNT(*) = (
  SELECT MAX(medal_count) FROM (
    SELECT COUNT(*) AS medal_count FROM Medals GROUP BY athlete_id
  ) AS sub
);

-- 2. Countries with medals in more than 3 Olympics
SELECT country_id FROM Medals
GROUP BY country_id
HAVING COUNT(DISTINCT olympic_id) > 3;

-- 3. Events where gold was awarded
SELECT event_id FROM Medals
WHERE medal_type = 'Gold'
AND event_id IN (SELECT event_id FROM Events);

-- 4. Medals awarded in the same venue as maximum events
SELECT * FROM Medals
WHERE venue_id = (
  SELECT venue_id FROM Events
  GROUP BY venue_id
  ORDER BY COUNT(*) DESC LIMIT 1
);

-- 5. Medals for athletes who belong to youngest age group
SELECT * FROM Medals
WHERE athlete_id IN (
  SELECT athlete_id FROM Athletes
  WHERE date_of_birth = (SELECT MAX(date_of_birth) FROM Athletes)
);

-- 6. Count total medals
SELECT COUNT(*) AS total_medals FROM Medals;

-- 7. Most recent medal date
SELECT MAX(medal_date) AS latest_medal FROM Medals;

-- 8. Earliest medal date
SELECT MIN(medal_date) AS first_medal FROM Medals;

-- 9. Average medals per team
SELECT AVG(medal_count) AS avg_per_team FROM (
  SELECT team_id, COUNT(*) AS medal_count FROM Medals
  WHERE team_id IS NOT NULL GROUP BY team_id
) AS team_medals;

-- 10. Number of medals by type
SELECT medal_type, COUNT(*) AS count FROM Medals GROUP BY medal_type;

DELIMITER //

-- 11. Calculate days since medal was awarded
CREATE FUNCTION days_since_medal(date DATE)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN DATEDIFF(CURDATE(), date);
END;
//

-- 12. Format full medal title
CREATE FUNCTION format_medal(type VARCHAR(10), category VARCHAR(100))
RETURNS VARCHAR(150) DETERMINISTIC
BEGIN
  RETURN CONCAT(type, ' - ', category);
END;
//

-- 13. Check if medal is from current year
CREATE FUNCTION is_current_year(date DATE)
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
  IF YEAR(date) = YEAR(CURDATE()) THEN RETURN 'Yes';
  RETURN 'No';
  END IF;
END;
//

-- 14. Medal score system
CREATE FUNCTION medal_points(type VARCHAR(10))
RETURNS INT DETERMINISTIC
BEGIN
  IF type = 'Gold' THEN RETURN 3;
  ELSEIF type = 'Silver' THEN RETURN 2;
  ELSEIF type = 'Bronze' THEN RETURN 1;
  RETURN 0;
  END IF;
END;
//

-- 15. Olympic Edition Label
CREATE FUNCTION olympic_label(year INT, season VARCHAR(10))
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  RETURN CONCAT(season, ' ', year);
END;
//

DELIMITER ;

-- 16. INNER JOIN to show medals with athlete names
SELECT m.medal_id, a.first_name, a.last_name, m.medal_type
FROM Medals m
INNER JOIN Athletes a ON m.athlete_id = a.athlete_id;

-- 17. LEFT JOIN to show all medals and their team names (if any)
SELECT m.medal_id, t.team_name
FROM Medals m
LEFT JOIN Teams t ON m.team_id = t.team_id;

-- 18. RIGHT JOIN to show all teams and their medals (if any)
SELECT t.team_name, m.medal_type
FROM Teams t
RIGHT JOIN Medals m ON t.team_id = m.team_id;

-- 19. FULL JOIN simulation using UNION (not native in MySQL)
SELECT m.medal_id, v.venue_name
FROM Medals m
LEFT JOIN Venues v ON m.venue_id = v.venue_id
UNION
SELECT m.medal_id, v.venue_name
FROM Medals m
RIGHT JOIN Venues v ON m.venue_id = v.venue_id;

-- 20. SELF JOIN to find pairs of medals won on same day
SELECT m1.medal_id AS medal1, m2.medal_id AS medal2, m1.medal_date
FROM Medals m1
JOIN Medals m2 ON m1.medal_date = m2.medal_date AND m1.medal_id < m2.medal_id;

-- Table 9: Coaches
-- 1. Coaches older than average coach
SELECT * FROM Coaches
WHERE date_of_birth < (
  SELECT AVG(date_of_birth) FROM Coaches
);

-- 2. Coaches with max experience
SELECT * FROM Coaches
WHERE years_of_experience = (
  SELECT MAX(years_of_experience) FROM Coaches
);

-- 3. Coaches assigned to most common team
SELECT * FROM Coaches
WHERE team_id = (
  SELECT team_id FROM Coaches
  GROUP BY team_id ORDER BY COUNT(*) DESC LIMIT 1
);

-- 4. Coaches with least experience in each sport
SELECT * FROM Coaches
WHERE years_of_experience IN (
  SELECT MIN(years_of_experience) FROM Coaches GROUP BY sport_id
);

-- 5. Coaches from countries with >5 coaches
SELECT * FROM Coaches
WHERE country_id IN (
  SELECT country_id FROM Coaches GROUP BY country_id HAVING COUNT(*) > 5
);

-- 6. Total coaches
SELECT COUNT(*) AS total_coaches FROM Coaches;

-- 7. Average experience
SELECT AVG(years_of_experience) AS avg_exp FROM Coaches;

-- 8. Youngest coach
SELECT MIN(date_of_birth) AS youngest FROM Coaches;

-- 9. Group by certification
SELECT certification_level, COUNT(*) FROM Coaches GROUP BY certification_level;

-- 10. Round average experience
SELECT ROUND(AVG(years_of_experience), 1) AS rounded_avg FROM Coaches;

DELIMITER //

-- 11. Full name
CREATE FUNCTION coach_fullname(fn VARCHAR(50), ln VARCHAR(50))
RETURNS VARCHAR(101) DETERMINISTIC
BEGIN
  RETURN CONCAT(fn, ' ', ln);
END;
//

-- 12. Age calculation
CREATE FUNCTION coach_age(dob DATE)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END;
//

-- 13. Experience level
CREATE FUNCTION exp_level(yrs INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  IF yrs >= 15 THEN RETURN 'Senior';
  ELSEIF yrs >= 5 THEN RETURN 'Intermediate';
  RETURN 'Junior';
  END IF;
END;
//

-- 14. Initials
CREATE FUNCTION coach_initials(fn VARCHAR(50), ln VARCHAR(50))
RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
  RETURN CONCAT(LEFT(fn, 1), '.', LEFT(ln, 1), '.');
END;
//

-- 15. Is certified
CREATE FUNCTION is_certified(cert VARCHAR(50))
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
  IF cert IS NULL OR cert = '' THEN RETURN 'No';
  RETURN 'Yes';
  END IF;
END;
//

DELIMITER ;

-- 16. INNER JOIN with countries to get coach nationality
SELECT c.coach_id, co.country_name
FROM Coaches c
INNER JOIN Countries co ON c.country_id = co.country_id;

-- 17. LEFT JOIN with teams to get team names (nullable)
SELECT c.coach_id, t.team_name
FROM Coaches c
LEFT JOIN Teams t ON c.team_id = t.team_id;

-- 18. RIGHT JOIN with sports to get sports even if no coaches
SELECT s.sport_name, c.first_name
FROM Sports s
RIGHT JOIN Coaches c ON s.sport_id = c.sport_id;

-- 19. FULL JOIN simulation with countries
SELECT c.coach_id, co.country_name
FROM Coaches c
LEFT JOIN Countries co ON c.country_id = co.country_id
UNION
SELECT c.coach_id, co.country_name
FROM Coaches c
RIGHT JOIN Countries co ON c.country_id = co.country_id;

-- 20. SELF JOIN to compare two coaches from same country
SELECT c1.coach_id, c2.coach_id
FROM Coaches c1
JOIN Coaches c2 ON c1.country_id = c2.country_id AND c1.coach_id < c2.coach_id;

-- Table 10: Stadiums
-- 1. Stadiums with capacity more than average
SELECT * FROM Stadiums
WHERE capacity > (SELECT AVG(capacity) FROM Stadiums);

-- 2. Oldest stadium(s)
SELECT * FROM Stadiums
WHERE year_built = (SELECT MIN(year_built) FROM Stadiums);

-- 3. Stadiums in countries with more than 2 stadiums
SELECT * FROM Stadiums
WHERE country_id IN (
  SELECT country_id FROM Stadiums GROUP BY country_id HAVING COUNT(*) > 2
);

-- 4. Stadiums used in latest Olympics
SELECT * FROM Stadiums
WHERE olympic_id = (SELECT MAX(olympic_id) FROM Olympics);

-- 5. Main stadiums only
SELECT * FROM Stadiums
WHERE is_main_stadium = TRUE AND capacity = (
  SELECT MAX(capacity) FROM Stadiums WHERE is_main_stadium = TRUE
);

-- 6. Total number of stadiums
SELECT COUNT(*) AS total_stadiums FROM Stadiums;

-- 7. Average stadium capacity
SELECT AVG(capacity) AS avg_capacity FROM Stadiums;

-- 8. Earliest year a stadium was built
SELECT MIN(year_built) AS oldest_year FROM Stadiums;

-- 9. Number of stadiums per type
SELECT stadium_type, COUNT(*) AS count FROM Stadiums GROUP BY stadium_type;

-- 10. Total capacity of main stadiums
SELECT SUM(capacity) AS total_main_capacity FROM Stadiums WHERE is_main_stadium = TRUE;

DELIMITER //

-- 11. Full stadium name with city
CREATE FUNCTION full_stadium_name(name VARCHAR(100), city VARCHAR(50))
RETURNS VARCHAR(160) DETERMINISTIC
BEGIN
  RETURN CONCAT(name, ' (', city, ')');
END;
//

-- 12. Stadium age
CREATE FUNCTION stadium_age(built_year INT)
RETURNS INT DETERMINISTIC
BEGIN
  RETURN YEAR(CURDATE()) - built_year;
END;
//

-- 13. Is high capacity
CREATE FUNCTION is_high_capacity(cap INT)
RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
  IF cap > 70000 THEN RETURN 'Yes';
  RETURN 'No';
  END IF;
END;
//

-- 14. Surface summary
CREATE FUNCTION surface_summary(surface VARCHAR(50))
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  RETURN CONCAT('Surface: ', surface);
END;
//

-- 15. Stadium type shortform
CREATE FUNCTION type_shortform(stype VARCHAR(50))
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  RETURN UPPER(LEFT(stype, 3));
END;
//

DELIMITER ;

-- 16. INNER JOIN with Countries to get country name
SELECT s.stadium_name, c.country_name
FROM Stadiums s
INNER JOIN Countries c ON s.country_id = c.country_id;

-- 17. LEFT JOIN with Olympics to get Olympic year
SELECT s.stadium_name, o.year
FROM Stadiums s
LEFT JOIN Olympics o ON s.olympic_id = o.olympic_id;

-- 18. RIGHT JOIN with Olympics to show all Olympic editions with or without stadiums
SELECT o.year, s.stadium_name
FROM Olympics o
RIGHT JOIN Stadiums s ON o.olympic_id = s.olympic_id;

-- 19. FULL JOIN simulation with Countries
SELECT s.stadium_name, c.country_name
FROM Stadiums s
LEFT JOIN Countries c ON s.country_id = c.country_id
UNION
SELECT s.stadium_name, c.country_name
FROM Stadiums s
RIGHT JOIN Countries c ON s.country_id = c.country_id;

-- 20. SELF JOIN to find stadiums in same city
SELECT s1.stadium_name AS stadium1, s2.stadium_name AS stadium2
FROM Stadiums s1
JOIN Stadiums s2 ON s1.city = s2.city AND s1.stadium_id < s2.stadium_id;

-- Table 11: Sponsors
-- 1. Find sponsors who sponsored more than the average amount
SELECT sponsor_name, amount_sponsored
FROM Sponsors
WHERE amount_sponsored > (SELECT AVG(amount_sponsored) FROM Sponsors);

-- 2. List sponsors from countries that have hosted Olympics
SELECT sponsor_name, country_id
FROM Sponsors
WHERE country_id IN (SELECT host_country_id FROM Olympics);

-- 3. Sponsors who sponsor entities involved in the 2020 Olympics
SELECT sponsor_name
FROM Sponsors
WHERE olympic_id = (SELECT olympic_id FROM Olympics WHERE year = 2020);

-- 4. Find sponsors who sponsor athletes whose country is 'USA'
SELECT sponsor_name
FROM Sponsors
WHERE sponsored_entity_type = 'Athlete'
AND sponsored_entity_id IN (SELECT athlete_id FROM Athletes WHERE country_id = (SELECT country_id FROM Countries WHERE country_name = 'USA'));

-- 5. Sponsors with amounts less than the highest sponsored amount for 'Global' type sponsors
SELECT sponsor_name, amount_sponsored
FROM Sponsors
WHERE amount_sponsored < (SELECT MAX(amount_sponsored) FROM Sponsors WHERE sponsor_type = 'Global');

-- 6. Get sponsors with sponsor_name in uppercase
SELECT UPPER(sponsor_name) AS sponsor_upper FROM Sponsors;

-- 7. Get the length of each sponsor's name
SELECT sponsor_name, LENGTH(sponsor_name) AS name_length FROM Sponsors;

-- 8. Format amount_sponsored with comma separators
SELECT sponsor_name, FORMAT(amount_sponsored, 2) AS formatted_amount FROM Sponsors;

-- 9. Extract the year from linked Olympics year column (joining Olympics)
SELECT s.sponsor_name, YEAR(o.year) AS olympic_year
FROM Sponsors s
JOIN Olympics o ON s.olympic_id = o.olympic_id;

-- 10. Get the first 5 characters of sponsor email
SELECT sponsor_name, LEFT(contact_email, 5) AS email_start FROM Sponsors WHERE contact_email IS NOT NULL;

-- 11. Create UDF to get sponsor type in lowercase
DELIMITER //
CREATE FUNCTION lowerSponsorType(s_type VARCHAR(50)) RETURNS VARCHAR(50)
BEGIN
  RETURN LOWER(s_type);
END //
DELIMITER ;

-- Usage:
SELECT sponsor_name, lowerSponsorType(sponsor_type) AS sponsor_type_lower FROM Sponsors;

-- 12. UDF to calculate sponsorship tax (5% of amount_sponsored)
DELIMITER //
CREATE FUNCTION sponsorshipTax(amount DECIMAL(15,2)) RETURNS DECIMAL(15,2)
BEGIN
  RETURN amount * 0.05;
END //
DELIMITER ;

-- Usage:
SELECT sponsor_name, amount_sponsored, sponsorshipTax(amount_sponsored) AS tax_amount FROM Sponsors;

-- 13. UDF to mask email by showing only domain part
DELIMITER //
CREATE FUNCTION maskEmail(email VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN
  RETURN SUBSTRING(email, LOCATE('@', email));
END //
DELIMITER ;

-- Usage:
SELECT sponsor_name, contact_email, maskEmail(contact_email) AS masked_email FROM Sponsors WHERE contact_email IS NOT NULL;

-- 14. UDF to check if amount_sponsored is above 1 million (returns 'Yes' or 'No')
DELIMITER //
CREATE FUNCTION isBigSponsor(amount DECIMAL(15,2)) RETURNS VARCHAR(3)
BEGIN
  IF amount > 1000000 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT sponsor_name, amount_sponsored, isBigSponsor(amount_sponsored) AS big_sponsor FROM Sponsors;

-- 15. UDF to return entity type abbreviation ('Team' -> 'T', 'Athlete' -> 'A', 'Event' -> 'E')
DELIMITER //
CREATE FUNCTION entityAbbr(entity_type ENUM('Team', 'Athlete', 'Event')) RETURNS CHAR(1)
BEGIN
  RETURN CASE entity_type
    WHEN 'Team' THEN 'T'
    WHEN 'Athlete' THEN 'A'
    WHEN 'Event' THEN 'E'
    ELSE 'U'
  END;
END //
DELIMITER ;

-- Usage:
SELECT sponsor_name, sponsored_entity_type, entityAbbr(sponsored_entity_type) AS entity_abbr FROM Sponsors;

-- 16. INNER JOIN: Sponsors with their country names
SELECT s.sponsor_name, c.country_name
FROM Sponsors s
INNER JOIN Countries c ON s.country_id = c.country_id;

-- 17. LEFT JOIN: Sponsors with Olympics info, including those with no Olympics linked
SELECT s.sponsor_name, o.year, o.city
FROM Sponsors s
LEFT JOIN Olympics o ON s.olympic_id = o.olympic_id;

-- 18. RIGHT JOIN: Show all Olympics and any sponsors linked to them (if any)
SELECT o.year, s.sponsor_name
FROM Olympics o
RIGHT JOIN Sponsors s ON o.olympic_id = s.olympic_id;

-- 19. FULL OUTER JOIN (emulated in MySQL with UNION): All sponsors and Olympics, matching where possible
SELECT s.sponsor_name, o.year
FROM Sponsors s
LEFT JOIN Olympics o ON s.olympic_id = o.olympic_id
UNION
SELECT s.sponsor_name, o.year
FROM Olympics o
LEFT JOIN Sponsors s ON o.olympic_id = s.olympic_id;

-- 20. SELF JOIN: Sponsors who sponsored the same entity as another sponsor
SELECT s1.sponsor_name AS sponsor1, s2.sponsor_name AS sponsor2, s1.sponsored_entity_id
FROM Sponsors s1
JOIN Sponsors s2 ON s1.sponsored_entity_id = s2.sponsored_entity_id
AND s1.sponsor_id <> s2.sponsor_id;

-- Table 12: Matches
-- 1. Find matches scheduled after the latest completed match date
SELECT match_id, match_date
FROM Matches
WHERE match_date > (SELECT MAX(match_date) FROM Matches WHERE match_status = 'Completed');

-- 2. List matches where the winning team belongs to the same city as the venue
SELECT match_id, winner_team_id
FROM Matches
WHERE winner_team_id IN (
    SELECT team_id FROM Teams t
    JOIN Venues v ON v.city = (SELECT city FROM Venues WHERE venue_id = Matches.venue_id)
    WHERE t.team_id = Matches.winner_team_id
);

-- 3. Matches where teams participated in more than 5 matches
SELECT match_id, team1_id, team2_id
FROM Matches
WHERE team1_id IN (
    SELECT team_id FROM (
        SELECT team1_id AS team_id FROM Matches
        UNION ALL
        SELECT team2_id FROM Matches
    ) AS all_teams
    GROUP BY team_id
    HAVING COUNT(*) > 5
)
OR team2_id IN (
    SELECT team_id FROM (
        SELECT team1_id AS team_id FROM Matches
        UNION ALL
        SELECT team2_id FROM Matches
    ) AS all_teams
    GROUP BY team_id
    HAVING COUNT(*) > 5
);

-- 4. Matches held in venues located in countries that hosted Olympics in 2020
SELECT match_id FROM Matches
WHERE venue_id IN (
    SELECT venue_id FROM Venues v
    JOIN Countries c ON v.country_id = c.country_id
    WHERE c.country_id IN (
        SELECT country_id FROM Olympics WHERE year = 2020
    )
);

-- 5. Matches where the winner team has won more than 3 matches
SELECT match_id, winner_team_id FROM Matches
WHERE winner_team_id IN (
    SELECT winner_team_id FROM Matches
    WHERE winner_team_id IS NOT NULL
    GROUP BY winner_team_id
    HAVING COUNT(*) > 1
);

-- 6. Get the weekday name of the match_date
SELECT match_id, DAYNAME(match_date) AS weekday FROM Matches;

-- 7. Calculate match duration in minutes (end_time - start_time)
SELECT match_id, TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes
FROM Matches
WHERE end_time IS NOT NULL AND start_time IS NOT NULL;

-- 8. Format match_date as 'DD-MM-YYYY'
SELECT match_id, DATE_FORMAT(match_date, '%d-%m-%Y') AS formatted_date FROM Matches;

-- 9. Get substring of match_status (first 3 letters)
SELECT match_id, SUBSTRING(match_status, 1, 3) AS status_short FROM Matches;

-- 10. Check if match is completed or not using IF function
SELECT match_id, IF(match_status = 'Completed', 'Done', 'Pending') AS match_state FROM Matches;

-- 11. UDF to calculate if a match lasted longer than 90 minutes ('Yes'/'No')
DELIMITER //
CREATE FUNCTION isLongMatch(start_time TIME, end_time TIME) RETURNS VARCHAR(3)
BEGIN
  IF TIMESTAMPDIFF(MINUTE, start_time, end_time) > 90 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT match_id, isLongMatch(start_time, end_time) AS long_match FROM Matches WHERE start_time IS NOT NULL AND end_time IS NOT NULL;

-- 12. UDF to get the match status color code ('Scheduled' = 'Yellow', 'Completed' = 'Green', 'Cancelled' = 'Red')
DELIMITER //
CREATE FUNCTION statusColor(status ENUM('Scheduled', 'Completed', 'Cancelled')) RETURNS VARCHAR(10)
BEGIN
  RETURN CASE status
    WHEN 'Scheduled' THEN 'Yellow'
    WHEN 'Completed' THEN 'Green'
    WHEN 'Cancelled' THEN 'Red'
    ELSE 'Unknown'
  END;
END //
DELIMITER ;

-- Usage:
SELECT match_id, match_status, statusColor(match_status) AS color_code FROM Matches;

-- 13. UDF to return 'Even' or 'Odd' based on match_id
DELIMITER //
CREATE FUNCTION matchIdParity(m_id INT) RETURNS VARCHAR(4)
BEGIN
  IF MOD(m_id, 2) = 0 THEN
    RETURN 'Even';
  ELSE
    RETURN 'Odd';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT match_id, matchIdParity(match_id) AS parity FROM Matches;

-- 14. UDF to get abbreviated match status (first letter uppercase)
DELIMITER //
CREATE FUNCTION abbrevStatus(status ENUM('Scheduled', 'Completed', 'Cancelled')) RETURNS CHAR(1)
BEGIN
  RETURN LEFT(status, 1);
END //
DELIMITER ;

-- Usage:
SELECT match_id, match_status, abbrevStatus(match_status) AS abbrev FROM Matches;

-- 15. UDF to check if match date is in the past ('Yes'/'No')
DELIMITER //
CREATE FUNCTION isPastMatch(m_date DATE) RETURNS VARCHAR(3)
BEGIN
  IF m_date < CURDATE() THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT match_id, match_date, isPastMatch(match_date) AS past_match FROM Matches;

-- 16. INNER JOIN: Match info with event name and venue city
SELECT m.match_id, e.event_name, v.city AS venue_city
FROM Matches m
INNER JOIN Events e ON m.event_id = e.event_id
INNER JOIN Venues v ON m.venue_id = v.venue_id;

-- 17. LEFT JOIN: Matches with winner team name (if completed)
SELECT m.match_id, m.match_status, t.team_name AS winner_team
FROM Matches m
LEFT JOIN Teams t ON m.winner_team_id = t.team_id;

-- 18. RIGHT JOIN: All teams and the matches where they played as team1 (if any)
SELECT t.team_name, m.match_id
FROM Teams t
RIGHT JOIN Matches m ON t.team_id = m.team1_id;

-- 19. FULL OUTER JOIN emulated with UNION: All matches and all teams who played (either team1 or team2)
SELECT m.match_id, t.team_name
FROM Matches m
JOIN Teams t ON m.team1_id = t.team_id
UNION
SELECT m.match_id, t.team_name
FROM Matches m
JOIN Teams t ON m.team2_id = t.team_id;

-- 20. SELF JOIN: Matches where team1 in one match is team2 in another match (matches with common teams)
SELECT m1.match_id AS match1, m2.match_id AS match2, m1.team1_id
FROM Matches m1
JOIN Matches m2 ON m1.team1_id = m2.team2_id
WHERE m1.match_id <> m2.match_id;

-- Table 13: Broadcasts
-- 1. Broadcasts with viewership above average
SELECT broadcast_id, broadcaster_name, viewership_estimate
FROM Broadcasts
WHERE viewership_estimate > (SELECT AVG(viewership_estimate) FROM Broadcasts);

-- 2. Broadcasts from countries that have hosted Olympics
SELECT broadcast_id, broadcaster_name, country_id
FROM Broadcasts
WHERE country_id IN (SELECT host_country_id FROM Olympics);

-- 3. Broadcasts for events held in 2024
SELECT broadcast_id, event_id
FROM Broadcasts
WHERE event_id IN (SELECT event_id FROM Events WHERE olympic_id = (SELECT olympic_id FROM Olympics WHERE year = 2024));

-- 4. Broadcasts that started before 6 PM
SELECT broadcast_id, start_time
FROM Broadcasts
WHERE start_time < '18:00:00';

-- 5. Broadcasts where estimated viewers are less than the maximum for the platform 'Online'
SELECT broadcast_id, viewership_estimate
FROM Broadcasts
WHERE viewership_estimate < (
    SELECT MAX(viewership_estimate) FROM Broadcasts WHERE platform = 'Online'
);

-- 6. Uppercase broadcaster names
SELECT broadcast_id, UPPER(broadcaster_name) AS broadcaster_upper FROM Broadcasts;

-- 7. Length of broadcaster names
SELECT broadcast_id, LENGTH(broadcaster_name) AS name_length FROM Broadcasts;

-- 8. Format broadcast_date as 'DD-MM-YYYY'
SELECT broadcast_id, DATE_FORMAT(broadcast_date, '%d-%m-%Y') AS formatted_date FROM Broadcasts;

-- 9. Calculate broadcast duration in minutes
SELECT broadcast_id, TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes FROM Broadcasts WHERE start_time IS NOT NULL AND end_time IS NOT NULL;

-- 10. Extract first 3 characters of platform
SELECT broadcast_id, LEFT(platform, 3) AS platform_short FROM Broadcasts;

-- 11. UDF to get platform color code ('TV'='Blue', 'Online'='Green', 'Radio'='Orange')
DELIMITER //
CREATE FUNCTION platformColor(p ENUM('TV', 'Online', 'Radio')) RETURNS VARCHAR(10)
BEGIN
  RETURN CASE p
    WHEN 'TV' THEN 'Blue'
    WHEN 'Online' THEN 'Green'
    WHEN 'Radio' THEN 'Orange'
    ELSE 'Unknown'
  END;
END //
DELIMITER ;

-- Usage:
SELECT broadcast_id, platform, platformColor(platform) AS color_code FROM Broadcasts;

-- 12. UDF to check if broadcast duration is over 2 hours ('Yes'/'No')
DELIMITER //
CREATE FUNCTION isLongBroadcast(start_time TIME, end_time TIME) RETURNS VARCHAR(3)
BEGIN
  IF TIMESTAMPDIFF(MINUTE, start_time, end_time) > 120 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT broadcast_id, isLongBroadcast(start_time, end_time) AS long_broadcast FROM Broadcasts WHERE start_time IS NOT NULL AND end_time IS NOT NULL;

-- 13. UDF to mask broadcaster email domain (if there was an email column, here example with broadcaster_name)
DELIMITER //
CREATE FUNCTION maskBroadcasterName(name VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN
  RETURN CONCAT(LEFT(name, 3), '***');
END //
DELIMITER ;

-- Usage:
SELECT broadcast_id, broadcaster_name, maskBroadcasterName(broadcaster_name) AS masked_name FROM Broadcasts;

-- 14. UDF to abbreviate platform to single letter ('TV'->'T', 'Online'->'O', 'Radio'->'R')
DELIMITER //
CREATE FUNCTION abbrevPlatform(p ENUM('TV', 'Online', 'Radio')) RETURNS CHAR(1)
BEGIN
  RETURN CASE p
    WHEN 'TV' THEN 'T'
    WHEN 'Online' THEN 'O'
    WHEN 'Radio' THEN 'R'
    ELSE 'U'
  END;
END //
DELIMITER ;

-- Usage:
SELECT broadcast_id, platform, abbrevPlatform(platform) AS abbrev FROM Broadcasts;

-- 15. UDF to determine if broadcast is in the past ('Yes'/'No')
DELIMITER //
CREATE FUNCTION isPastBroadcast(b_date DATE) RETURNS VARCHAR(3)
BEGIN
  IF b_date < CURDATE() THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT broadcast_id, broadcast_date, isPastBroadcast(broadcast_date) AS past_broadcast FROM Broadcasts;

-- 16. INNER JOIN: Broadcast with event name and country name
SELECT b.broadcast_id, e.event_name, c.country_name
FROM Broadcasts b
INNER JOIN Events e ON b.event_id = e.event_id
INNER JOIN Countries c ON b.country_id = c.country_id;

-- 17. LEFT JOIN: Broadcast with event info, including broadcasts with missing event (if any)
SELECT b.broadcast_id, b.broadcaster_name, e.event_name
FROM Broadcasts b
LEFT JOIN Events e ON b.event_id = e.event_id;

-- 18. RIGHT JOIN: All countries and broadcasts originating from them (if any)
SELECT c.country_name, b.broadcast_id
FROM Countries c
RIGHT JOIN Broadcasts b ON c.country_id = b.country_id;

-- 19. FULL OUTER JOIN emulated via UNION: All broadcasts and all events, matched where possible
SELECT b.broadcast_id, e.event_name
FROM Broadcasts b
LEFT JOIN Events e ON b.event_id = e.event_id
UNION
SELECT b.broadcast_id, e.event_name
FROM Events e
LEFT JOIN Broadcasts b ON e.event_id = b.event_id;

-- 20. SELF JOIN: Broadcasts from the same country on the same date but different broadcasters
SELECT b1.broadcast_id AS broadcast1, b2.broadcast_id AS broadcast2, b1.country_id, b1.broadcast_date
FROM Broadcasts b1
JOIN Broadcasts b2 ON b1.country_id = b2.country_id 
AND b1.broadcast_date = b2.broadcast_date
AND b1.broadcaster_name <> b2.broadcaster_name;

-- Table 14: Referees

-- 1. Referees with experience greater than average
SELECT referee_id, full_name, experience_years
FROM Referees
WHERE experience_years > (SELECT AVG(experience_years) FROM Referees);

-- 2. Referees assigned to events held in 2024
SELECT referee_id, full_name, assigned_event_id
FROM Referees
WHERE assigned_event_id IN (SELECT event_id FROM Events WHERE olympic_id = (SELECT olympic_id FROM Olympics WHERE year = 2024));

-- 3. Referees from countries with population over 50 million
SELECT referee_id, full_name, nationality_id
FROM Referees
WHERE nationality_id IN (SELECT country_id FROM Countries WHERE population > 50000000);

-- 4. Referees who are certified and have been assigned to any event
SELECT referee_id, full_name
FROM Referees
WHERE certified = TRUE AND assigned_event_id IS NOT NULL;

-- 5. Referees with less experience than the max experience in their sport
SELECT referee_id, full_name, experience_years, sport_id
FROM Referees r1
WHERE experience_years < (
    SELECT MAX(experience_years) FROM Referees r2 WHERE r1.sport_id = r2.sport_id
);

-- 6. Uppercase referee names
SELECT referee_id, UPPER(full_name) AS upper_name FROM Referees;

-- 7. Length of referee's full name
SELECT referee_id, LENGTH(full_name) AS name_length FROM Referees;

-- 8. Get first 3 characters of status
SELECT referee_id, status, LEFT(status, 3) AS status_short FROM Referees;

-- 9. Check if contact_email contains '@' (simple check using LOCATE)
SELECT referee_id, contact_email, LOCATE('@', contact_email) AS has_at_symbol FROM Referees;

-- 10. Calculate years left until 40 years experience (assuming 40 is max)
SELECT referee_id, experience_years, GREATEST(40 - experience_years, 0) AS years_to_max FROM Referees;

-- 11. UDF to classify experience ('Novice', 'Intermediate', 'Expert')
DELIMITER //
CREATE FUNCTION experienceLevel(years INT) RETURNS VARCHAR(20)
BEGIN
  RETURN CASE
    WHEN years < 3 THEN 'Novice'
    WHEN years BETWEEN 3 AND 7 THEN 'Intermediate'
    ELSE 'Expert'
  END;
END //
DELIMITER ;

-- Usage:
SELECT referee_id, full_name, experience_years, experienceLevel(experience_years) AS experience_level FROM Referees;

-- 12. UDF to mask email domain (show part before '@' and '***')
DELIMITER //
CREATE FUNCTION maskEmail(email VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN
  RETURN CONCAT(SUBSTRING_INDEX(email, '@', 1), '@***');
END //
DELIMITER ;

-- Usage:
SELECT referee_id, contact_email, maskEmail(contact_email) AS masked_email FROM Referees;

-- 13. UDF to return gender abbreviation ('M', 'F', 'O')
DELIMITER //
CREATE FUNCTION genderAbbrev(g ENUM('Male', 'Female', 'Other')) RETURNS CHAR(1)
BEGIN
  RETURN CASE g
    WHEN 'Male' THEN 'M'
    WHEN 'Female' THEN 'F'
    WHEN 'Other' THEN 'O'
    ELSE 'U'
  END;
END //
DELIMITER ;

-- Usage:
SELECT referee_id, gender, genderAbbrev(gender) AS gender_short FROM Referees;

-- 14. UDF to check if referee is active and certified ('Yes'/'No')
DELIMITER //
CREATE FUNCTION isActiveCertified(stat ENUM('Active', 'Retired', 'Suspended'), cert BOOLEAN) RETURNS VARCHAR(3)
BEGIN
  IF stat = 'Active' AND cert = TRUE THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT referee_id, status, certified, isActiveCertified(status, certified) AS active_certified FROM Referees;

-- 15. UDF to check if assigned to an event ('Yes'/'No')
DELIMITER //
CREATE FUNCTION assignedToEvent(event_id INT) RETURNS VARCHAR(3)
BEGIN
  IF event_id IS NULL THEN
    RETURN 'No';
  ELSE
    RETURN 'Yes';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT referee_id, assigned_event_id, assignedToEvent(assigned_event_id) AS assigned FROM Referees;

-- 16. INNER JOIN: Referees with country and sport names
SELECT r.referee_id, r.full_name, c.country_name, s.sport_name
FROM Referees r
INNER JOIN Countries c ON r.nationality_id = c.country_id
INNER JOIN Sports s ON r.sport_id = s.sport_id;

-- 17. LEFT JOIN: Referees with assigned event name (including those not assigned)
SELECT r.referee_id, r.full_name, e.event_name
FROM Referees r
LEFT JOIN Events e ON r.assigned_event_id = e.event_id;

-- 18. RIGHT JOIN: All sports with referees (if any)
SELECT s.sport_name, r.referee_id
FROM Sports s
RIGHT JOIN Referees r ON s.sport_id = r.sport_id;

-- 19. FULL OUTER JOIN emulated with UNION: All referees and all events they might be assigned to
SELECT r.referee_id, r.full_name, e.event_name
FROM Referees r
LEFT JOIN Events e ON r.assigned_event_id = e.event_id
UNION
SELECT r.referee_id, r.full_name, e.event_name
FROM Events e
LEFT JOIN Referees r ON e.event_id = r.assigned_event_id;

-- 20. SELF JOIN: Referees in same sport with different status
SELECT r1.referee_id AS ref1_id, r2.referee_id AS ref2_id, r1.sport_id, r1.status, r2.status
FROM Referees r1
JOIN Referees r2 ON r1.sport_id = r2.sport_id AND r1.status <> r2.status;

-- Table 15: Schedules
-- 1. Schedules for sports held in a specific venue
SELECT * FROM Schedules
WHERE venue_id = (SELECT venue_id FROM Venues WHERE venue_name = 'Olympic Stadium');

-- 2. Events scheduled after the average scheduled date
SELECT * FROM Schedules
WHERE scheduled_date > (SELECT AVG(DATEDIFF(scheduled_date, '2000-01-01')) FROM Schedules);

-- 3. Schedules for events with status 'Scheduled' but no end_time set
SELECT * FROM Schedules
WHERE status = 'Scheduled' AND end_time IS NULL;

-- 4. Schedules for sports that have more than 5 sessions scheduled
SELECT * FROM Schedules
WHERE sport_id IN (
    SELECT sport_id FROM Schedules
    GROUP BY sport_id
    HAVING COUNT(*) > 5
);

-- 5. Schedules not updated in the last 7 days
SELECT * FROM Schedules
WHERE last_updated < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 7 DAY);

-- 6. Get the day name of the scheduled date
SELECT schedule_id, DAYNAME(scheduled_date) AS day_name FROM Schedules;

-- 7. Extract hour from start_time
SELECT schedule_id, HOUR(start_time) AS start_hour FROM Schedules;

-- 8. Format scheduled_date as 'DD-MM-YYYY'
SELECT schedule_id, DATE_FORMAT(scheduled_date, '%d-%m-%Y') AS formatted_date FROM Schedules;

-- 9. Calculate duration in minutes between start_time and end_time
SELECT schedule_id, TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duration_minutes FROM Schedules;

-- 10. Check if the schedule status is 'Completed' (1 if true, 0 if false)
SELECT schedule_id, IF(status = 'Completed', 1, 0) AS is_completed FROM Schedules;

-- 11. UDF to classify session time of day
DELIMITER //
CREATE FUNCTION sessionType(session_time VARCHAR(50)) RETURNS VARCHAR(20)
BEGIN
  RETURN CASE
    WHEN session_time LIKE '%Morning%' THEN 'Morning Session'
    WHEN session_time LIKE '%Afternoon%' THEN 'Afternoon Session'
    WHEN session_time LIKE '%Evening%' THEN 'Evening Session'
    ELSE 'Other Session'
  END;
END //
DELIMITER ;

-- Usage:
SELECT schedule_id, session, sessionType(session) AS session_description FROM Schedules;

-- 12. UDF to check if schedule is upcoming or past
DELIMITER //
CREATE FUNCTION isUpcoming(scheduled DATE) RETURNS VARCHAR(10)
BEGIN
  IF scheduled > CURDATE() THEN
    RETURN 'Upcoming';
  ELSE
    RETURN 'Past';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT schedule_id, scheduled_date, isUpcoming(scheduled_date) AS event_status FROM Schedules;

-- 13. UDF to return shortened status (first 3 letters uppercase)
DELIMITER //
CREATE FUNCTION shortStatus(stat ENUM('Scheduled', 'Completed', 'Cancelled')) RETURNS VARCHAR(3)
BEGIN
  RETURN UPPER(LEFT(stat, 3));
END //
DELIMITER ;

-- Usage:
SELECT schedule_id, status, shortStatus(status) AS short_status FROM Schedules;

-- 14. UDF to check if schedule is running longer than 2 hours (returns 'Yes'/'No')
DELIMITER //
CREATE FUNCTION longDuration(start_time TIME, end_time TIME) RETURNS VARCHAR(3)
BEGIN
  IF TIMESTAMPDIFF(MINUTE, start_time, end_time) > 120 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT schedule_id, start_time, end_time, longDuration(start_time, end_time) AS is_long FROM Schedules;

-- 15. UDF to display if schedule is in the evening session
DELIMITER //
CREATE FUNCTION isEvening(session_time VARCHAR(50)) RETURNS VARCHAR(3)
BEGIN
  IF session_time LIKE '%Evening%' THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT schedule_id, session, isEvening(session) AS evening_session FROM Schedules;

-- 16. INNER JOIN: Schedule details with event and sport names
SELECT s.schedule_id, e.event_name, sp.sport_name, s.scheduled_date, s.status
FROM Schedules s
INNER JOIN Events e ON s.event_id = e.event_id
INNER JOIN Sports sp ON s.sport_id = sp.sport_id;

-- 17. LEFT JOIN: All schedules with venue names (even if venue missing)
SELECT s.schedule_id, s.scheduled_date, v.venue_name
FROM Schedules s
LEFT JOIN Venues v ON s.venue_id = v.venue_id;

-- 18. RIGHT JOIN: Venues with their scheduled events (including venues with no schedules)
SELECT v.venue_name, s.schedule_id, s.scheduled_date
FROM Venues v
RIGHT JOIN Schedules s ON v.venue_id = s.venue_id;

-- 19. SELF JOIN: Schedules on same day for the same sport
SELECT s1.schedule_id AS schedule_1, s2.schedule_id AS schedule_2, s1.scheduled_date, s1.sport_id
FROM Schedules s1
JOIN Schedules s2 ON s1.sport_id = s2.sport_id 
    AND s1.scheduled_date = s2.scheduled_date 
    AND s1.schedule_id <> s2.schedule_id;

-- 20. FULL OUTER JOIN emulated by UNION: All schedules and all events (even if no schedule exists)
SELECT s.schedule_id, e.event_name
FROM Schedules s
LEFT JOIN Events e ON s.event_id = e.event_id
UNION
SELECT s.schedule_id, e.event_name
FROM Events e
LEFT JOIN Schedules s ON e.event_id = s.event_id;

-- Table 16: Judges
-- 1. Subquery: Judges assigned to events held in 'Tokyo'
SELECT * FROM Judges
WHERE assigned_event_id IN (
    SELECT event_id FROM Events WHERE city = 'Tokyo'
);

-- 2. Subquery: Judges with experience greater than average experience
SELECT * FROM Judges
WHERE years_of_experience > (
    SELECT AVG(years_of_experience) FROM Judges
);

-- 3. Subquery: Judges who are chief judges
SELECT * FROM Judges
WHERE judge_id IN (
    SELECT judge_id FROM Judges WHERE is_chief_judge = TRUE
);

-- 4. Subquery: Judges judging sports that have more than 3 judges
SELECT * FROM Judges
WHERE sport_id IN (
    SELECT sport_id FROM Judges GROUP BY sport_id HAVING COUNT(*) > 3
);

-- 5. Subquery: Judges whose nationality is in countries with population over 100 million
SELECT * FROM Judges
WHERE nationality_id IN (
    SELECT country_id FROM Countries WHERE population > 100000000
);

-- 6. Built-in function: Get length of judge full name
SELECT judge_id, full_name, LENGTH(full_name) AS name_length FROM Judges;

-- 7. Built-in function: Uppercase judge status
SELECT judge_id, status, UPPER(status) AS status_upper FROM Judges;

-- 8. Built-in function: Get year from event date they are assigned to
SELECT j.judge_id, j.full_name, YEAR(e.start_date) AS event_year
FROM Judges j
JOIN Events e ON j.assigned_event_id = e.event_id;

-- 9. Built-in function: Get current date and show days of experience as difference from current year
SELECT judge_id, years_of_experience, YEAR(CURDATE()) - years_of_experience AS approx_start_year FROM Judges;

-- 10. Built-in function: Format certification_level to title case (using CONCAT and UPPER)
SELECT judge_id, certification_level,
       CONCAT(UPPER(LEFT(certification_level,1)),LOWER(SUBSTRING(certification_level,2))) AS formatted_certification
FROM Judges;

-- 11. UDF: Return 'Senior' if experience > 10 else 'Junior'
DELIMITER //
CREATE FUNCTION judgeLevel(exp INT) RETURNS VARCHAR(10)
BEGIN
  IF exp > 10 THEN
    RETURN 'Senior';
  ELSE
    RETURN 'Junior';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT judge_id, years_of_experience, judgeLevel(years_of_experience) AS experience_level FROM Judges;

-- 12. UDF: Returns 'Chief Judge' or 'Judge' based on is_chief_judge boolean
DELIMITER //
CREATE FUNCTION judgeRole(chief BOOLEAN) RETURNS VARCHAR(15)
BEGIN
  IF chief THEN
    RETURN 'Chief Judge';
  ELSE
    RETURN 'Judge';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT judge_id, is_chief_judge, judgeRole(is_chief_judge) AS role FROM Judges;

-- 13. UDF: Returns short gender label (M/F/O)
DELIMITER //
CREATE FUNCTION shortGender(g ENUM('Male','Female','Other')) RETURNS CHAR(1)
BEGIN
  RETURN CASE g
    WHEN 'Male' THEN 'M'
    WHEN 'Female' THEN 'F'
    ELSE 'O'
  END;
END //
DELIMITER ;

-- Usage:
SELECT judge_id, gender, shortGender(gender) AS gender_short FROM Judges;

-- 14. UDF: Return active status as Yes/No
DELIMITER //
CREATE FUNCTION isActive(stat ENUM('Active','Retired','Suspended')) RETURNS VARCHAR(3)
BEGIN
  IF stat = 'Active' THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT judge_id, status, isActive(status) AS active_status FROM Judges;

-- 15. UDF: Format full name as "Last, First" assuming full_name is "First Last"
DELIMITER //
CREATE FUNCTION formatName(fullname VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN
  DECLARE first VARCHAR(50);
  DECLARE last VARCHAR(50);
  SET first = SUBSTRING_INDEX(fullname, ' ', 1);
  SET last = SUBSTRING_INDEX(fullname, ' ', -1);
  RETURN CONCAT(last, ', ', first);
END //
DELIMITER ;

-- Usage:
SELECT judge_id, full_name, formatName(full_name) AS formatted_name FROM Judges;

-- 16. INNER JOIN: Judges with their sport names
SELECT j.judge_id, j.full_name, s.sport_name
FROM Judges j
INNER JOIN Sports s ON j.sport_id = s.sport_id;

-- 17. LEFT JOIN: Judges with nationality country names (include judges even if nationality missing)
SELECT j.judge_id, j.full_name, c.country_name
FROM Judges j
LEFT JOIN Countries c ON j.nationality_id = c.country_id;

-- 18. RIGHT JOIN: Countries with judges (shows countries even if no judge assigned)
SELECT c.country_name, j.judge_id, j.full_name
FROM Countries c
RIGHT JOIN Judges j ON c.country_id = j.nationality_id;

-- 19. SELF JOIN: Judges who judge the same sport
SELECT j1.judge_id AS judge1, j2.judge_id AS judge2, j1.sport_id
FROM Judges j1
JOIN Judges j2 ON j1.sport_id = j2.sport_id AND j1.judge_id <> j2.judge_id;

-- 20. FULL OUTER JOIN emulated by UNION: Judges and their assigned events (including judges without events and events without judges)
SELECT j.judge_id, j.full_name, e.event_name
FROM Judges j
LEFT JOIN Events e ON j.assigned_event_id = e.event_id
UNION
SELECT j.judge_id, j.full_name, e.event_name
FROM Events e
LEFT JOIN Judges j ON e.event_id = j.assigned_event_id;

-- Table 17: Scores
-- 1. Subquery: Scores given by judges with >5 years experience
SELECT * FROM Scores
WHERE judge_id IN (
    SELECT judge_id FROM Judges WHERE years_of_experience > 5
);

-- 2. Subquery: Scores for athletes who participated in event held in 'Tokyo'
SELECT * FROM Scores
WHERE athlete_id IN (
    SELECT athlete_id FROM Participations WHERE event_id IN (
        SELECT event_id FROM Events WHERE city = 'Tokyo'
    )
);

-- 3. Subquery: Scores with score greater than average score in the event
SELECT * FROM Scores s1
WHERE score > (
    SELECT AVG(score) FROM Scores s2 WHERE s2.event_id = s1.event_id
);

-- 4. Subquery: Scores for events in which judge assigned as chief judge
SELECT * FROM Scores
WHERE event_id IN (
    SELECT assigned_event_id FROM Judges WHERE is_chief_judge = TRUE
);

-- 5. Subquery: Scores for athletes from countries with population > 100 million
SELECT * FROM Scores
WHERE athlete_id IN (
    SELECT athlete_id FROM Athletes WHERE country_id IN (
        SELECT country_id FROM Countries WHERE population > 100000000
    )
);

-- 6. Built-in function: Format score_date as 'YYYY-MM-DD'
SELECT score_id, DATE_FORMAT(score_date, '%Y-%m-%d') AS formatted_date FROM Scores;

-- 7. Built-in function: Round score to nearest whole number
SELECT score_id, score, ROUND(score) AS rounded_score FROM Scores;

-- 8. Built-in function: Get length of remarks column
SELECT score_id, remarks, LENGTH(remarks) AS remarks_length FROM Scores;

-- 9. Built-in function: Extract year from score_date
SELECT score_id, YEAR(score_date) AS score_year FROM Scores;

-- 10. Built-in function: Calculate time difference (hours) between score_date and now
SELECT score_id, TIMESTAMPDIFF(HOUR, score_date, NOW()) AS hours_since_score FROM Scores;

-- 11. UDF: Returns 'High' if score >= 9 else 'Low'
DELIMITER //
CREATE FUNCTION scoreLevel(sc DECIMAL(5,2)) RETURNS VARCHAR(10)
BEGIN
  IF sc >= 9 THEN
    RETURN 'High';
  ELSE
    RETURN 'Low';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT score_id, score, scoreLevel(score) AS score_level FROM Scores;

-- 12. UDF: Returns short score type code (T, A, P)
DELIMITER //
CREATE FUNCTION shortScoreType(st ENUM('Technical','Artistic','Performance')) RETURNS CHAR(1)
BEGIN
  RETURN CASE st
    WHEN 'Technical' THEN 'T'
    WHEN 'Artistic' THEN 'A'
    ELSE 'P'
  END;
END //
DELIMITER ;

-- Usage:
SELECT score_id, score_type, shortScoreType(score_type) AS score_code FROM Scores;

-- 13. UDF: Returns status description
DELIMITER //
CREATE FUNCTION statusDesc(st ENUM('Submitted','Reviewed','Final')) RETURNS VARCHAR(20)
BEGIN
  IF st = 'Final' THEN
    RETURN 'Finalized score';
  ELSEIF st = 'Reviewed' THEN
    RETURN 'Under review';
  ELSE
    RETURN 'Just submitted';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT score_id, status, statusDesc(status) AS status_description FROM Scores;

-- 14. UDF: Returns remarks length category
DELIMITER //
CREATE FUNCTION remarksLengthCategory(r VARCHAR(255)) RETURNS VARCHAR(10)
BEGIN
  IF LENGTH(r) > 50 THEN
    RETURN 'Long';
  ELSE
    RETURN 'Short';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT score_id, remarks, remarksLengthCategory(remarks) AS remarks_length_category FROM Scores;

-- 15. UDF: Format score and remarks in one string
DELIMITER //
CREATE FUNCTION scoreSummary(sc DECIMAL(5,2), r VARCHAR(255)) RETURNS VARCHAR(300)
BEGIN
  RETURN CONCAT('Score: ', sc, ', Remarks: ', IFNULL(r, 'None'));
END //
DELIMITER ;

-- Usage:
SELECT score_id, score, remarks, scoreSummary(score, remarks) AS summary FROM Scores;

-- 16. INNER JOIN: Scores with athlete and judge names
SELECT s.score_id, a.full_name AS athlete_name, j.full_name AS judge_name, s.score
FROM Scores s
INNER JOIN Athletes a ON s.athlete_id = a.athlete_id
INNER JOIN Judges j ON s.judge_id = j.judge_id;

-- 17. LEFT JOIN: Scores with event details (show all scores even if event missing)
SELECT s.score_id, s.score, e.event_name, e.city
FROM Scores s
LEFT JOIN Events e ON s.event_id = e.event_id;

-- 18. RIGHT JOIN: Judges with scores (show judges even if no score given)
SELECT j.full_name, s.score
FROM Judges j
RIGHT JOIN Scores s ON j.judge_id = s.judge_id;

-- 19. SELF JOIN: Compare scores given by two different judges for same athlete and event
SELECT s1.score_id AS score1_id, s1.judge_id AS judge1, s2.score_id AS score2_id, s2.judge_id AS judge2, s1.score, s2.score
FROM Scores s1
JOIN Scores s2 ON s1.athlete_id = s2.athlete_id AND s1.event_id = s2.event_id AND s1.judge_id <> s2.judge_id;

-- 20. FULL OUTER JOIN emulated by UNION: Scores and Judges (all scores and judges including unmatched)
SELECT s.score_id, j.full_name, s.score
FROM Scores s
LEFT JOIN Judges j ON s.judge_id = j.judge_id
UNION
SELECT s.score_id, j.full_name, s.score
FROM Judges j
LEFT JOIN Scores s ON j.judge_id = s.judge_id;

-- Table 18: Ticket Sales
-- 1. Subquery: Tickets for events held in 'Tokyo'
SELECT * FROM ticket_sales
WHERE event_id IN (SELECT event_id FROM Events WHERE city = 'Tokyo');

-- 2. Subquery: Tickets bought by buyers who purchased VIP tickets before 2024-01-01
SELECT * FROM ticket_sales
WHERE buyer_email IN (
    SELECT buyer_email FROM ticket_sales
    WHERE ticket_type = 'VIP' AND purchase_date < '2024-01-01'
);

-- 3. Subquery: Tickets with price higher than average ticket price for that event
SELECT * FROM ticket_sales ts1
WHERE price > (
    SELECT AVG(price) FROM ticket_sales ts2 WHERE ts1.event_id = ts2.event_id
);

-- 4. Subquery: Tickets for events where total tickets sold exceed 1000
SELECT * FROM ticket_sales
WHERE event_id IN (
    SELECT event_id FROM ticket_sales
    GROUP BY event_id
    HAVING COUNT(ticket_id) > 1000
);

-- 5. Subquery: Tickets bought by buyers who have more than 3 tickets in total
SELECT * FROM ticket_sales
WHERE buyer_email IN (
    SELECT buyer_email FROM ticket_sales
    GROUP BY buyer_email
    HAVING COUNT(ticket_id) > 3
);

-- 6. Built-in function: Format purchase_date as 'DD-MM-YYYY'
SELECT ticket_id, DATE_FORMAT(purchase_date, '%d-%m-%Y') AS formatted_date FROM ticket_sales;

-- 7. Built-in function: Calculate days since purchase
SELECT ticket_id, purchase_date, DATEDIFF(CURDATE(), purchase_date) AS days_since_purchase FROM ticket_sales;

-- 8. Built-in function: Convert buyer_name to uppercase
SELECT ticket_id, UPPER(buyer_name) AS buyer_upper FROM ticket_sales;

-- 9. Built-in function: Get length of seat_number string
SELECT ticket_id, seat_number, LENGTH(seat_number) AS seat_length FROM ticket_sales;

-- 10. Built-in function: Check if payment_status is 'Paid' and return boolean
SELECT ticket_id, payment_status, (payment_status = 'Paid') AS is_paid FROM ticket_sales;

-- 11. UDF: Return ticket category based on price
DELIMITER //
CREATE FUNCTION ticketCategory(p DECIMAL(8,2)) RETURNS VARCHAR(20)
BEGIN
  IF p >= 100 THEN
    RETURN 'Expensive';
  ELSEIF p >= 50 THEN
    RETURN 'Moderate';
  ELSE
    RETURN 'Cheap';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT ticket_id, price, ticketCategory(price) AS category FROM ticket_sales;

-- 12. UDF: Return shortened payment status (P, Pe, C)
DELIMITER //
CREATE FUNCTION shortPaymentStatus(s ENUM('Paid', 'Pending', 'Cancelled')) RETURNS VARCHAR(3)
BEGIN
  RETURN CASE s
    WHEN 'Paid' THEN 'P'
    WHEN 'Pending' THEN 'Pe'
    ELSE 'C'
  END;
END //
DELIMITER ;

-- Usage:
SELECT ticket_id, payment_status, shortPaymentStatus(payment_status) AS short_status FROM ticket_sales;

-- 13. UDF: Returns 'Yes' if ticket is VIP and paid, else 'No'
DELIMITER //
CREATE FUNCTION isVipPaid(tt ENUM('Regular', 'VIP', 'Student'), ps ENUM('Paid', 'Pending', 'Cancelled')) RETURNS VARCHAR(3)
BEGIN
  IF tt = 'VIP' AND ps = 'Paid' THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT ticket_id, ticket_type, payment_status, isVipPaid(ticket_type, payment_status) AS vip_paid FROM ticket_sales;

-- 14. UDF: Returns sale channel description
DELIMITER //
CREATE FUNCTION saleChannelDesc(sc ENUM('Online', 'Onsite')) RETURNS VARCHAR(20)
BEGIN
  IF sc = 'Online' THEN
    RETURN 'Internet Sale';
  ELSE
    RETURN 'At Venue';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT ticket_id, sale_channel, saleChannelDesc(sale_channel) AS channel_desc FROM ticket_sales;

-- 15. UDF: Combines buyer and seat info in one string
DELIMITER //
CREATE FUNCTION buyerSeatInfo(b VARCHAR(100), s VARCHAR(20)) RETURNS VARCHAR(130)
BEGIN
  RETURN CONCAT('Buyer: ', b, ', Seat: ', s);
END //
DELIMITER ;

-- Usage:
SELECT ticket_id, buyer_name, seat_number, buyerSeatInfo(buyer_name, seat_number) AS info FROM ticket_sales;

-- 16. INNER JOIN: Tickets with event names
SELECT ts.ticket_id, ts.buyer_name, e.event_name, ts.price
FROM ticket_sales ts
INNER JOIN Events e ON ts.event_id = e.event_id;

-- 17. LEFT JOIN: Tickets with event city (show all tickets)
SELECT ts.ticket_id, ts.buyer_name, e.city
FROM ticket_sales ts
LEFT JOIN Events e ON ts.event_id = e.event_id;

-- 18. RIGHT JOIN: Events with tickets sold (shows all events even without tickets)
SELECT e.event_name, ts.ticket_id
FROM Events e
RIGHT JOIN ticket_sales ts ON e.event_id = ts.event_id;

-- 19. SELF JOIN: Buyers with multiple ticket purchases
SELECT t1.buyer_name, t1.ticket_id AS ticket1, t2.ticket_id AS ticket2
FROM ticket_sales t1
JOIN ticket_sales t2 ON t1.buyer_email = t2.buyer_email AND t1.ticket_id <> t2.ticket_id;

-- 20. FULL OUTER JOIN emulated: Tickets and Events with all records
SELECT ts.ticket_id, e.event_name
FROM ticket_sales ts
LEFT JOIN Events e ON ts.event_id = e.event_id
UNION
SELECT ts.ticket_id, e.event_name
FROM Events e
LEFT JOIN ticket_sales ts ON e.event_id = ts.event_id;

-- Table 19: Ceremonies
-- 1. Subquery: Ceremonies held at venues in 'Tokyo'
SELECT * FROM ceremonies
WHERE venue_id IN (SELECT venue_id FROM venues WHERE city = 'Tokyo');

-- 2. Subquery: Ceremonies for Olympics held in 2021
SELECT * FROM ceremonies
WHERE olympic_id IN (
    SELECT olympic_id FROM olympics WHERE year = 2021
);

-- 3. Subquery: Ceremonies with duration longer than average duration
SELECT * FROM ceremonies c1
WHERE TIMEDIFF(end_time, start_time) > (
    SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(TIMEDIFF(end_time, start_time)))) FROM ceremonies
);

-- 4. Subquery: Ceremonies where main performer performed in venues in 'Japan'
SELECT * FROM ceremonies
WHERE venue_id IN (
    SELECT venue_id FROM venues WHERE country = 'Japan'
) AND main_performer IS NOT NULL;

-- 5. Subquery: Ceremonies with the most recent date per olympic_id
SELECT * FROM ceremonies c1
WHERE ceremony_date = (
    SELECT MAX(ceremony_date) FROM ceremonies c2 WHERE c1.olympic_id = c2.olympic_id
);

-- 6. Built-in function: Format ceremony_date as 'Day, Month DD, YYYY'
SELECT ceremony_id, DATE_FORMAT(ceremony_date, '%W, %M %d, %Y') AS formatted_date FROM ceremonies;

-- 7. Built-in function: Calculate duration in minutes
SELECT ceremony_id, TIME_TO_SEC(TIMEDIFF(end_time, start_time))/60 AS duration_minutes FROM ceremonies;

-- 8. Built-in function: Uppercase ceremony type
SELECT ceremony_id, UPPER(ceremony_type) AS ceremony_type_upper FROM ceremonies;

-- 9. Built-in function: Length of theme text
SELECT ceremony_id, LENGTH(theme) AS theme_length FROM ceremonies;

-- 10. Built-in function: Extract year from ceremony_date
SELECT ceremony_id, YEAR(ceremony_date) AS ceremony_year FROM ceremonies;

-- 11. UDF: Return 'Long' or 'Short' based on ceremony duration (> 2 hours)
DELIMITER //
CREATE FUNCTION ceremonyLengthFlag(start_time TIME, end_time TIME) RETURNS VARCHAR(10)
BEGIN
  IF TIME_TO_SEC(TIMEDIFF(end_time, start_time)) > 7200 THEN
    RETURN 'Long';
  ELSE
    RETURN 'Short';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT ceremony_id, ceremonyLengthFlag(start_time, end_time) AS length_flag FROM ceremonies;

-- 12. UDF: Returns a greeting message for the ceremony type
DELIMITER //
CREATE FUNCTION ceremonyGreeting(c_type ENUM('Opening', 'Closing', 'Medal')) RETURNS VARCHAR(100)
BEGIN
  RETURN CONCAT('Welcome to the ', c_type, ' Ceremony!');
END //
DELIMITER ;

-- Usage:
SELECT ceremony_id, ceremonyGreeting(ceremony_type) AS greeting FROM ceremonies;

-- 13. UDF: Return trimmed theme (limit to 50 characters)
DELIMITER //
CREATE FUNCTION shortTheme(t VARCHAR(255)) RETURNS VARCHAR(50)
BEGIN
  RETURN LEFT(t, 50);
END //
DELIMITER ;

-- Usage:
SELECT ceremony_id, shortTheme(theme) AS short_theme FROM ceremonies;

-- 14. UDF: Return TRUE if host_country is 'Japan'
DELIMITER //
CREATE FUNCTION isHostJapan(host VARCHAR(100)) RETURNS BOOLEAN
BEGIN
  RETURN host = 'Japan';
END //
DELIMITER ;

-- Usage:
SELECT ceremony_id, isHostJapan(host_country) AS host_is_japan FROM ceremonies;

-- 15. UDF: Combine main performer and theme info
DELIMITER //
CREATE FUNCTION performerThemeInfo(performer VARCHAR(100), theme VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
  RETURN CONCAT('Performer: ', performer, ', Theme: ', theme);
END //
DELIMITER ;

-- Usage:
SELECT ceremony_id, performerThemeInfo(main_performer, theme) AS info FROM ceremonies;

-- 16. INNER JOIN: Ceremonies with Olympic year and city
SELECT c.ceremony_id, c.ceremony_type, o.year, o.city
FROM ceremonies c
INNER JOIN olympics o ON c.olympic_id = o.olympic_id;

-- 17. LEFT JOIN: Ceremonies with venue details
SELECT c.ceremony_id, c.ceremony_type, v.venue_name, v.city, v.country
FROM ceremonies c
LEFT JOIN venues v ON c.venue_id = v.venue_id;

-- 18. RIGHT JOIN: Olympics with ceremonies info (shows all olympics)
SELECT o.olympic_id, o.year, c.ceremony_type, c.ceremony_date
FROM olympics o
RIGHT JOIN ceremonies c ON o.olympic_id = c.olympic_id;

-- 19. SELF JOIN: Ceremonies on the same date but different type
SELECT c1.ceremony_id AS c1_id, c1.ceremony_type AS c1_type,
       c2.ceremony_id AS c2_id, c2.ceremony_type AS c2_type, c1.ceremony_date
FROM ceremonies c1
JOIN ceremonies c2 ON c1.ceremony_date = c2.ceremony_date AND c1.ceremony_id <> c2.ceremony_id;

-- 20. FULL OUTER JOIN emulated: All ceremonies and venues
SELECT c.ceremony_id, c.ceremony_type, v.venue_name
FROM ceremonies c
LEFT JOIN venues v ON c.venue_id = v.venue_id
UNION
SELECT c.ceremony_id, c.ceremony_type, v.venue_name
FROM venues v
LEFT JOIN ceremonies c ON v.venue_id = c.venue_id;

-- Table 20: Medical Records
-- 1. Subquery: Records of athletes who had checkup after '2024-01-01'
SELECT * FROM medical_records
WHERE athlete_id IN (
    SELECT athlete_id FROM athletes WHERE athlete_id IN (
        SELECT athlete_id FROM medical_records WHERE checkup_date > '2024-01-01'
    )
);

-- 2. Subquery: Medical records with pending fitness clearance
SELECT * FROM medical_records
WHERE fitness_clearance = 'Pending';

-- 3. Subquery: Records where doctor treated athletes from a specific hospital
SELECT * FROM medical_records
WHERE doctor_name IN (
    SELECT doctor_name FROM medical_records WHERE hospital_name = 'City Hospital'
);

-- 4. Subquery: Records with injuries matching athletes in 'USA'
SELECT * FROM medical_records
WHERE athlete_id IN (
    SELECT athlete_id FROM athletes WHERE country_id = (
        SELECT country_id FROM countries WHERE country_name = 'USA'
    )
);

-- 5. Subquery: Latest checkup date for each athlete
SELECT * FROM medical_records mr1
WHERE checkup_date = (
    SELECT MAX(checkup_date) FROM medical_records mr2 WHERE mr1.athlete_id = mr2.athlete_id
);

-- 6. Built-in function: Format checkup_date as 'DD-Mon-YYYY'
SELECT record_id, DATE_FORMAT(checkup_date, '%d-%b-%Y') AS formatted_checkup_date FROM medical_records;

-- 7. Built-in function: Length of injury description
SELECT record_id, LENGTH(injury_description) AS injury_desc_length FROM medical_records;

-- 8. Built-in function: Uppercase doctor name
SELECT record_id, UPPER(doctor_name) AS doctor_upper FROM medical_records;

-- 9. Built-in function: If follow-up required, return 'Yes', else 'No'
SELECT record_id, IF(follow_up_required, 'Yes', 'No') AS follow_up_status FROM medical_records;

-- 10. Built-in function: Current timestamp with record_id
SELECT record_id, NOW() AS current_time FROM medical_records;

-- 11. UDF: Returns 'Fit' if fitness_clearance is 'Yes', else 'Not Fit'
DELIMITER //
CREATE FUNCTION fitnessStatus(fitness ENUM('Yes','No','Pending')) RETURNS VARCHAR(10)
BEGIN
  IF fitness = 'Yes' THEN
    RETURN 'Fit';
  ELSE
    RETURN 'Not Fit';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT record_id, fitnessStatus(fitness_clearance) AS status FROM medical_records;

-- 12. UDF: Shorten injury description to 40 characters
DELIMITER //
CREATE FUNCTION shortInjuryDesc(desc VARCHAR(255)) RETURNS VARCHAR(40)
BEGIN
  RETURN LEFT(desc, 40);
END //
DELIMITER ;

-- Usage:
SELECT record_id, shortInjuryDesc(injury_description) AS short_injury FROM medical_records;

-- 13. UDF: Check if notes contain a keyword (returns TRUE/FALSE)
DELIMITER //
CREATE FUNCTION notesHasKeyword(note TEXT, keyword VARCHAR(50)) RETURNS BOOLEAN
BEGIN
  RETURN LOCATE(keyword, note) > 0;
END //
DELIMITER ;

-- Usage:
SELECT record_id, notesHasKeyword(notes, 'recovery') AS has_recovery FROM medical_records;

-- 14. UDF: Returns hospital name with "Clinic:" prefix
DELIMITER //
CREATE FUNCTION hospitalClinic(hospital VARCHAR(100)) RETURNS VARCHAR(120)
BEGIN
  RETURN CONCAT('Clinic: ', hospital);
END //
DELIMITER ;

-- Usage:
SELECT record_id, hospitalClinic(hospital_name) AS hospital_info FROM medical_records;

-- 15. UDF: Returns notes length
DELIMITER //
CREATE FUNCTION notesLength(note TEXT) RETURNS INT
BEGIN
  RETURN LENGTH(note);
END //
DELIMITER ;

-- Usage:
SELECT record_id, notesLength(notes) AS notes_len FROM medical_records;

-- 16. INNER JOIN: Medical records with athlete name
SELECT mr.record_id, a.full_name, mr.checkup_date, mr.injury_description
FROM medical_records mr
INNER JOIN athletes a ON mr.athlete_id = a.athlete_id;

-- 17. LEFT JOIN: Medical records with athlete and country name
SELECT mr.record_id, a.full_name, c.country_name, mr.fitness_clearance
FROM medical_records mr
LEFT JOIN athletes a ON mr.athlete_id = a.athlete_id
LEFT JOIN countries c ON a.country_id = c.country_id;

-- 18. RIGHT JOIN: List all athletes with their latest medical record (if any)
SELECT a.athlete_id, a.full_name, mr.checkup_date, mr.injury_description
FROM athletes a
RIGHT JOIN medical_records mr ON a.athlete_id = mr.athlete_id;

-- 19. SELF JOIN: Compare medical records with same injury description for same athlete
SELECT mr1.record_id AS rec1, mr2.record_id AS rec2, mr1.injury_description
FROM medical_records mr1
JOIN medical_records mr2 ON mr1.athlete_id = mr2.athlete_id 
    AND mr1.injury_description = mr2.injury_description
    AND mr1.record_id <> mr2.record_id;

-- 20. FULL OUTER JOIN emulated: All medical records and athletes (showing records even if no athlete)
SELECT mr.record_id, a.full_name, mr.injury_description
FROM medical_records mr
LEFT JOIN athletes a ON mr.athlete_id = a.athlete_id
UNION
SELECT mr.record_id, a.full_name, mr.injury_description
FROM athletes a
LEFT JOIN medical_records mr ON a.athlete_id = mr.athlete_id;

-- Table 21: Training Sessions
-- 1. Subquery: Sessions of athletes coached by a specific coach (coach_id = 5)
SELECT * FROM training_sessions
WHERE athlete_id IN (
    SELECT athlete_id FROM training_sessions WHERE coach_id = 5
);

-- 2. Subquery: Sessions on dates after '2024-01-01'
SELECT * FROM training_sessions
WHERE session_date > '2024-01-01';

-- 3. Subquery: Athletes who had high intensity sessions
SELECT * FROM training_sessions
WHERE athlete_id IN (
    SELECT athlete_id FROM training_sessions WHERE intensity_level = 'High'
);

-- 4. Subquery: Sessions in locations used by coach with id 3
SELECT * FROM training_sessions
WHERE location IN (
    SELECT location FROM training_sessions WHERE coach_id = 3
);

-- 5. Subquery: Latest session date for each athlete
SELECT * FROM training_sessions ts1
WHERE session_date = (
    SELECT MAX(session_date) FROM training_sessions ts2 WHERE ts1.athlete_id = ts2.athlete_id
);

-- 6. Built-in function: Format session_date as 'DD-MM-YYYY'
SELECT session_id, DATE_FORMAT(session_date, '%d-%m-%Y') AS formatted_date FROM training_sessions;

-- 7. Built-in function: Duration in minutes (end_time - start_time)
SELECT session_id, TIME_TO_SEC(TIMEDIFF(end_time, start_time))/60 AS duration_minutes FROM training_sessions;

-- 8. Built-in function: Convert location to uppercase
SELECT session_id, UPPER(location) AS location_upper FROM training_sessions;

-- 9. Built-in function: Check if notes is NULL or not
SELECT session_id, IF(notes IS NULL, 'No Notes', 'Has Notes') AS notes_status FROM training_sessions;

-- 10. Built-in function: Current timestamp with session_id
SELECT session_id, NOW() AS current_time FROM training_sessions;

-- 11. UDF: Returns 1 if intensity is High, else 0
DELIMITER //
CREATE FUNCTION isHighIntensity(level ENUM('Low', 'Medium', 'High')) RETURNS INT
BEGIN
  IF level = 'High' THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT session_id, isHighIntensity(intensity_level) AS high_intensity_flag FROM training_sessions;

-- 12. UDF: Returns shortened notes (first 50 chars)
DELIMITER //
CREATE FUNCTION shortNotes(text TEXT) RETURNS VARCHAR(50)
BEGIN
  RETURN LEFT(text, 50);
END //
DELIMITER ;

-- Usage:
SELECT session_id, shortNotes(notes) AS short_notes FROM training_sessions;

-- 13. UDF: Checks if location contains keyword (TRUE/FALSE)
DELIMITER //
CREATE FUNCTION locationHasKeyword(loc VARCHAR(100), keyword VARCHAR(50)) RETURNS BOOLEAN
BEGIN
  RETURN LOCATE(keyword, loc) > 0;
END //
DELIMITER ;

-- Usage:
SELECT session_id, locationHasKeyword(location, 'Stadium') AS has_stadium FROM training_sessions;

-- 14. UDF: Returns formatted session period 'start_time - end_time'
DELIMITER //
CREATE FUNCTION sessionPeriod(start_time TIME, end_time TIME) RETURNS VARCHAR(20)
BEGIN
  RETURN CONCAT(TIME_FORMAT(start_time, '%H:%i'), ' - ', TIME_FORMAT(end_time, '%H:%i'));
END //
DELIMITER ;

-- Usage:
SELECT session_id, sessionPeriod(start_time, end_time) AS session_period FROM training_sessions;

-- 15. UDF: Returns 'Yes' if notes is not empty, else 'No'
DELIMITER //
CREATE FUNCTION hasNotes(text TEXT) RETURNS VARCHAR(3)
BEGIN
  IF text IS NULL OR text = '' THEN
    RETURN 'No';
  ELSE
    RETURN 'Yes';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT session_id, hasNotes(notes) AS notes_exist FROM training_sessions;

-- 16. INNER JOIN: Sessions with athlete and coach names
SELECT ts.session_id, a.full_name AS athlete_name, c.full_name AS coach_name, ts.session_date
FROM training_sessions ts
INNER JOIN athletes a ON ts.athlete_id = a.athlete_id
INNER JOIN coaches c ON ts.coach_id = c.coach_id;

-- 17. LEFT JOIN: Sessions with sport name (show all sessions)
SELECT ts.session_id, s.sport_name, ts.intensity_level
FROM training_sessions ts
LEFT JOIN sports s ON ts.sport_id = s.sport_id;

-- 18. RIGHT JOIN: All athletes with their training sessions (if any)
SELECT a.athlete_id, a.full_name, ts.session_date, ts.intensity_level
FROM athletes a
RIGHT JOIN training_sessions ts ON a.athlete_id = ts.athlete_id;

-- 19. SELF JOIN: Sessions on the same day by the same athlete
SELECT ts1.session_id AS session1, ts2.session_id AS session2, ts1.session_date
FROM training_sessions ts1
JOIN training_sessions ts2 ON ts1.athlete_id = ts2.athlete_id 
    AND ts1.session_date = ts2.session_date 
    AND ts1.session_id <> ts2.session_id;

-- 20. FULL OUTER JOIN emulated: All athletes and their sessions
SELECT ts.session_id, a.full_name, ts.session_date
FROM training_sessions ts
LEFT JOIN athletes a ON ts.athlete_id = a.athlete_id
UNION
SELECT ts.session_id, a.full_name, ts.session_date
FROM athletes a
LEFT JOIN training_sessions ts ON a.athlete_id = ts.athlete_id;

-- Table 22: Volunteers
-- 1. Subquery: Volunteers assigned to areas where at least one volunteer is over 50 years old
SELECT * FROM volunteers
WHERE assigned_area IN (
    SELECT assigned_area FROM volunteers WHERE age > 50
);

-- 2. Subquery: Volunteers available in 'Morning' shift with age > 30
SELECT * FROM volunteers
WHERE shift_time = 'Morning' AND age > 30;

-- 3. Subquery: Volunteers whose assigned area is the same as a volunteer named 'John Doe'
SELECT * FROM volunteers
WHERE assigned_area = (
    SELECT assigned_area FROM volunteers WHERE full_name = 'John Doe' LIMIT 1
);

-- 4. Subquery: Volunteers with email domain 'gmail.com'
SELECT * FROM volunteers
WHERE email IN (
    SELECT email FROM volunteers WHERE email LIKE '%@gmail.com'
);

-- 5. Subquery: Volunteers available on 'Saturday' (search in availability_days string)
SELECT * FROM volunteers
WHERE availability_days LIKE '%Saturday%';

-- 6. Built-in function: Get length of role_description
SELECT volunteer_id, LENGTH(role_description) AS role_length FROM volunteers;

-- 7. Built-in function: Convert full_name to uppercase
SELECT volunteer_id, UPPER(full_name) AS upper_name FROM volunteers;

-- 8. Built-in function: Extract domain from email
SELECT volunteer_id, SUBSTRING_INDEX(email, '@', -1) AS email_domain FROM volunteers;

-- 9. Built-in function: Get current date and volunteer name
SELECT volunteer_id, full_name, CURDATE() AS today_date FROM volunteers;

-- 10. Built-in function: Check if contact_number contains '123'
SELECT volunteer_id, IF(LOCATE('123', contact_number) > 0, 'Contains 123', 'No 123') AS contact_check FROM volunteers;

-- 11. UDF: Returns 'Adult' if age >= 18, else 'Minor'
DELIMITER //
CREATE FUNCTION ageGroup(age INT) RETURNS VARCHAR(10)
BEGIN
  IF age >= 18 THEN
    RETURN 'Adult';
  ELSE
    RETURN 'Minor';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT volunteer_id, full_name, ageGroup(age) AS age_group FROM volunteers;

-- 12. UDF: Returns first word of full_name
DELIMITER //
CREATE FUNCTION firstName(fullName VARCHAR(100)) RETURNS VARCHAR(50)
BEGIN
  RETURN SUBSTRING_INDEX(fullName, ' ', 1);
END //
DELIMITER ;

-- Usage:
SELECT volunteer_id, full_name, firstName(full_name) AS first_name FROM volunteers;

-- 13. UDF: Checks if volunteer is available on a given day (returns TRUE/FALSE)
DELIMITER //
CREATE FUNCTION isAvailableOn(day VARCHAR(20), availDays VARCHAR(100)) RETURNS BOOLEAN
BEGIN
  RETURN LOCATE(day, availDays) > 0;
END //
DELIMITER ;

-- Usage: Check if volunteer is available on 'Sunday'
SELECT volunteer_id, full_name, isAvailableOn('Sunday', availability_days) AS available_on_sunday FROM volunteers;

-- 14. UDF: Returns shift time abbreviation (Morning->M, Afternoon->A, Evening->E)
DELIMITER //
CREATE FUNCTION shiftAbbrev(shift ENUM('Morning', 'Afternoon', 'Evening')) RETURNS CHAR(1)
BEGIN
  IF shift = 'Morning' THEN
    RETURN 'M';
  ELSEIF shift = 'Afternoon' THEN
    RETURN 'A';
  ELSE
    RETURN 'E';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT volunteer_id, full_name, shiftAbbrev(shift_time) AS shift_code FROM volunteers;

-- 15. UDF: Returns length of assigned_area string
DELIMITER //
CREATE FUNCTION areaLength(area VARCHAR(100)) RETURNS INT
BEGIN
  RETURN LENGTH(area);
END //
DELIMITER ;

-- Usage:
SELECT volunteer_id, assigned_area, areaLength(assigned_area) AS area_len FROM volunteers;

-- 16. INNER JOIN: Volunteers with assigned area's venue details (assuming venues table)
SELECT v.volunteer_id, v.full_name, v.assigned_area, ve.venue_name
FROM volunteers v
INNER JOIN venues ve ON v.assigned_area = ve.venue_location;

-- 17. LEFT JOIN: Volunteers with shifts and volunteer event assignments (assuming volunteer_events table)
SELECT v.volunteer_id, v.full_name, ve.event_id, v.shift_time
FROM volunteers v
LEFT JOIN volunteer_events ve ON v.volunteer_id = ve.volunteer_id;

-- 18. RIGHT JOIN: All events with volunteers assigned (assuming volunteer_events table)
SELECT ve.event_id, v.volunteer_id, v.full_name
FROM volunteer_events ve
RIGHT JOIN volunteers v ON ve.volunteer_id = v.volunteer_id;

-- 19. SELF JOIN: Volunteers sharing same assigned_area
SELECT v1.volunteer_id AS vol1, v1.full_name AS name1, v2.volunteer_id AS vol2, v2.full_name AS name2, v1.assigned_area
FROM volunteers v1
JOIN volunteers v2 ON v1.assigned_area = v2.assigned_area AND v1.volunteer_id <> v2.volunteer_id;

-- 20. FULL OUTER JOIN emulated: All volunteers and their events (if any)
SELECT v.volunteer_id, v.full_name, ve.event_id
FROM volunteers v
LEFT JOIN volunteer_events ve ON v.volunteer_id = ve.volunteer_id
UNION
SELECT v.volunteer_id, v.full_name, ve.event_id
FROM volunteer_events ve
LEFT JOIN volunteers v ON ve.volunteer_id = v.volunteer_id;

-- Table 23: Security Staff
-- 1. Subquery: Security staff assigned to locations where staff age is above 45
SELECT * FROM security_staff
WHERE assigned_location IN (
    SELECT assigned_location FROM security_staff WHERE age > 45
);

-- 2. Subquery: Staff working 'Night' shift and younger than 30
SELECT * FROM security_staff
WHERE shift_time = 'Night' AND age < 30;

-- 3. Subquery: Staff supervised by 'John Smith'
SELECT * FROM security_staff
WHERE supervisor_name = 'John Smith';

-- 4. Subquery: Staff whose email domain is 'yahoo.com'
SELECT * FROM security_staff
WHERE email LIKE '%@yahoo.com';

-- 5. Subquery: Staff assigned to same location as staff with duty_type 'Crowd Control'
SELECT * FROM security_staff
WHERE assigned_location IN (
    SELECT assigned_location FROM security_staff WHERE duty_type = 'Crowd Control'
);

-- 6. Built-in function: Length of duty_type string
SELECT staff_id, LENGTH(duty_type) AS duty_length FROM security_staff;

-- 7. Built-in function: Convert full_name to lowercase
SELECT staff_id, LOWER(full_name) AS lower_name FROM security_staff;

-- 8. Built-in function: Extract domain from email
SELECT staff_id, SUBSTRING_INDEX(email, '@', -1) AS email_domain FROM security_staff;

-- 9. Built-in function: Current date and staff name
SELECT staff_id, full_name, CURDATE() AS today_date FROM security_staff;

-- 10. Built-in function: Check if contact_number contains '999'
SELECT staff_id, IF(LOCATE('999', contact_number) > 0, 'Contains 999', 'No 999') AS contact_check FROM security_staff;

-- 11. UDF: Returns 'Senior' if age >= 50, else 'Junior'
DELIMITER //
CREATE FUNCTION staffLevel(age INT) RETURNS VARCHAR(10)
BEGIN
  IF age >= 50 THEN
    RETURN 'Senior';
  ELSE
    RETURN 'Junior';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT staff_id, full_name, staffLevel(age) AS staff_level FROM security_staff;

-- 12. UDF: Returns first name from full_name
DELIMITER //
CREATE FUNCTION firstName(fullName VARCHAR(100)) RETURNS VARCHAR(50)
BEGIN
  RETURN SUBSTRING_INDEX(fullName, ' ', 1);
END //
DELIMITER ;

-- Usage:
SELECT staff_id, full_name, firstName(full_name) AS first_name FROM security_staff;

-- 13. UDF: Checks if staff works in given shift (returns TRUE/FALSE)
DELIMITER //
CREATE FUNCTION worksShift(shift ENUM('Morning', 'Afternoon', 'Night'), givenShift VARCHAR(10)) RETURNS BOOLEAN
BEGIN
  RETURN shift = givenShift;
END //
DELIMITER ;

-- Usage: Check if staff works 'Afternoon' shift
SELECT staff_id, full_name, worksShift(shift_time, 'Afternoon') AS works_afternoon FROM security_staff;

-- 14. UDF: Returns abbreviation of shift ('Morning'->'M', 'Afternoon'->'A', 'Night'->'N')
DELIMITER //
CREATE FUNCTION shiftAbbrev(shift ENUM('Morning', 'Afternoon', 'Night')) RETURNS CHAR(1)
BEGIN
  IF shift = 'Morning' THEN
    RETURN 'M';
  ELSEIF shift = 'Afternoon' THEN
    RETURN 'A';
  ELSE
    RETURN 'N';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT staff_id, full_name, shiftAbbrev(shift_time) AS shift_code FROM security_staff;

-- 15. UDF: Returns length of assigned_location string
DELIMITER //
CREATE FUNCTION locationLength(loc VARCHAR(100)) RETURNS INT
BEGIN
  RETURN LENGTH(loc);
END //
DELIMITER ;

-- Usage:
SELECT staff_id, assigned_location, locationLength(assigned_location) AS location_len FROM security_staff;

-- 16. INNER JOIN: Staff with assigned locations matched to venues (assuming venues table)
SELECT ss.staff_id, ss.full_name, ss.assigned_location, v.venue_name
FROM security_staff ss
INNER JOIN venues v ON ss.assigned_location = v.venue_location;

-- 17. LEFT JOIN: Staff with assigned shifts and supervisor details (assuming supervisors table)
SELECT ss.staff_id, ss.full_name, ss.shift_time, sp.supervisor_name
FROM security_staff ss
LEFT JOIN supervisors sp ON ss.supervisor_name = sp.supervisor_name;

-- 18. RIGHT JOIN: All supervisors with their staff (assuming supervisors table)
SELECT sp.supervisor_name, ss.staff_id, ss.full_name
FROM supervisors sp
RIGHT JOIN security_staff ss ON sp.supervisor_name = ss.supervisor_name;

-- 19. SELF JOIN: Staff sharing same assigned location
SELECT s1.staff_id AS staff1, s1.full_name AS name1, s2.staff_id AS staff2, s2.full_name AS name2, s1.assigned_location
FROM security_staff s1
JOIN security_staff s2 ON s1.assigned_location = s2.assigned_location AND s1.staff_id <> s2.staff_id;

-- 20. FULL OUTER JOIN emulated: All staff and supervisors (assuming supervisors table)
SELECT ss.staff_id, ss.full_name, sp.supervisor_name
FROM security_staff ss
LEFT JOIN supervisors sp ON ss.supervisor_name = sp.supervisor_name
UNION
SELECT ss.staff_id, ss.full_name, sp.supervisor_name
FROM supervisors sp
LEFT JOIN security_staff ss ON sp.supervisor_name = ss.supervisor_name;

-- Table 25: Doping Test
-- 1. Subquery: Tests with positive results
SELECT * FROM doping_tests
WHERE result = 'Positive';

-- 2. Subquery: Tests done on the most recent date
SELECT * FROM doping_tests
WHERE test_date = (SELECT MAX(test_date) FROM doping_tests);

-- 3. Subquery: Athletes who have tested positive at least once
SELECT DISTINCT athlete_id FROM doping_tests
WHERE result = 'Positive';

-- 4. Subquery: Tests conducted by 'WADA' agency
SELECT * FROM doping_tests
WHERE testing_agency = 'WADA';

-- 5. Subquery: Tests where the substance_found is not null
SELECT * FROM doping_tests
WHERE substance_found IS NOT NULL;

-- 6. Built-in function: Length of substance_found field
SELECT test_id, LENGTH(substance_found) AS substance_length FROM doping_tests;

-- 7. Built-in function: Extract year from test_date
SELECT test_id, YEAR(test_date) AS test_year FROM doping_tests;

-- 8. Built-in function: Count total tests per sample type
SELECT sample_type, COUNT(*) AS total_tests FROM doping_tests GROUP BY sample_type;

-- 9. Built-in function: Uppercase testing agency names
SELECT test_id, UPPER(testing_agency) AS agency_upper FROM doping_tests;

-- 10. Built-in function: Check if remarks contain word 'retested'
SELECT test_id, IF(LOCATE('retested', remarks) > 0, 'Yes', 'No') AS retested_flag FROM doping_tests;

-- 11. UDF: Return 'Positive' or 'Negative' as 1 or 0
DELIMITER //
CREATE FUNCTION resultToBit(res ENUM('Negative', 'Positive')) RETURNS TINYINT
BEGIN
  IF res = 'Positive' THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT test_id, result, resultToBit(result) AS result_bit FROM doping_tests;

-- 12. UDF: Return 'Urine' or 'Blood' as short codes 'U' or 'B'
DELIMITER //
CREATE FUNCTION sampleCode(s ENUM('Urine', 'Blood')) RETURNS CHAR(1)
BEGIN
  IF s = 'Urine' THEN
    RETURN 'U';
  ELSE
    RETURN 'B';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT test_id, sample_type, sampleCode(sample_type) AS sample_code FROM doping_tests;

-- 13. UDF: Return length category of substance_found
DELIMITER //
CREATE FUNCTION substanceLengthCat(substance VARCHAR(100)) RETURNS VARCHAR(10)
BEGIN
  IF substance IS NULL THEN
    RETURN 'None';
  ELSEIF LENGTH(substance) > 10 THEN
    RETURN 'Long';
  ELSE
    RETURN 'Short';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT test_id, substance_found, substanceLengthCat(substance_found) AS length_category FROM doping_tests;

-- 14. UDF: Returns agency initials (first 3 letters uppercase)
DELIMITER //
CREATE FUNCTION agencyInitials(agency VARCHAR(100)) RETURNS VARCHAR(3)
BEGIN
  RETURN UPPER(LEFT(agency,3));
END //
DELIMITER ;

-- Usage:
SELECT test_id, testing_agency, agencyInitials(testing_agency) AS agency_code FROM doping_tests;

-- 15. UDF: Returns 'High Risk' if result positive and substance_found not null
DELIMITER //
CREATE FUNCTION riskLevel(res ENUM('Negative','Positive'), substance VARCHAR(100)) RETURNS VARCHAR(10)
BEGIN
  IF res = 'Positive' AND substance IS NOT NULL THEN
    RETURN 'High Risk';
  ELSE
    RETURN 'Low Risk';
  END IF;
END //
DELIMITER ;

-- Usage:
SELECT test_id, result, substance_found, riskLevel(result, substance_found) AS risk FROM doping_tests;

-- 16. INNER JOIN: Join doping_tests with athletes table (assumed)
SELECT dt.test_id, a.athlete_name, dt.result, dt.test_date
FROM doping_tests dt
INNER JOIN athletes a ON dt.athlete_id = a.athlete_id;

-- 17. LEFT JOIN: All doping tests with athlete info, even if missing athlete
SELECT dt.test_id, a.athlete_name, dt.result
FROM doping_tests dt
LEFT JOIN athletes a ON dt.athlete_id = a.athlete_id;

-- 18. INNER JOIN: Join with sports table by sport name (assumed)
SELECT dt.test_id, s.sport_name, dt.result
FROM doping_tests dt
INNER JOIN sports s ON dt.sport = s.sport_name;

-- 19. JOIN: Tests with athletes and testing agency details (assuming testing_agencies table)
SELECT dt.test_id, a.athlete_name, ta.agency_contact, dt.result
FROM doping_tests dt
JOIN athletes a ON dt.athlete_id = a.athlete_id
JOIN testing_agencies ta ON dt.testing_agency = ta.agency_name;

-- 20. SELF JOIN: Tests by same athlete on same date but different sample types
SELECT dt1.test_id, dt2.test_id, dt1.athlete_id, dt1.test_date, dt1.sample_type AS sample1, dt2.sample_type AS sample2
FROM doping_tests dt1
JOIN doping_tests dt2 ON dt1.athlete_id = dt2.athlete_id AND dt1.test_date = dt2.test_date AND dt1.sample_type <> dt2.sample_type;


-- Table 25: Training Sessions
