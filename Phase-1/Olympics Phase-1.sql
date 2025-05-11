-- Create Olympics Database
CREATE DATABASE Olympics;

-- Use Olympics Database
USE Olympics;

-- Table 1: Countries
CREATE TABLE Countries (
    country_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each country
    country_name VARCHAR(100) NOT NULL,        -- Full name of the country
    country_code VARCHAR(3) NOT NULL,          -- Country code
    continent VARCHAR(50),                     -- Continent where the country is located
    population BIGINT,                         -- Population of the country
    gdp DECIMAL(20,2),                         -- Gross Domestic Product
    capital_city VARCHAR(100),                 -- Capital city of the country
    language VARCHAR(50),                      -- Official language
    time_zone VARCHAR(50),                     -- Time zone of the country
    flag_url TEXT                              -- URL to the country's flag image
);

INSERT INTO Countries (country_name, country_code, continent, population, gdp, capital_city, language, time_zone, flag_url)
VALUES
('United States', 'USA', 'North America', 331000000, 21400000000000.00, 'Washington, D.C.', 'English', 'GMT-5', 'https://flags.com/usa.png'),
('China', 'CHN', 'Asia', 1444216107, 14342900000000.00, 'Beijing', 'Mandarin', 'GMT+8', 'https://flags.com/china.png'),
('India', 'IND', 'Asia', 1393409038, 2875140000000.00, 'New Delhi', 'Hindi', 'GMT+5:30', 'https://flags.com/india.png'),
('Russia', 'RUS', 'Europe/Asia', 145912025, 1699870000000.00, 'Moscow', 'Russian', 'GMT+3', 'https://flags.com/russia.png'),
('Germany', 'DEU', 'Europe', 83240525, 3845630000000.00, 'Berlin', 'German', 'GMT+1', 'https://flags.com/germany.png'),
('United Kingdom', 'GBR', 'Europe', 68207116, 2825200000000.00, 'London', 'English', 'GMT+0', 'https://flags.com/uk.png'),
('France', 'FRA', 'Europe', 65273511, 2715510000000.00, 'Paris', 'French', 'GMT+1', 'https://flags.com/france.png'),
('Japan', 'JPN', 'Asia', 125836021, 5081770000000.00, 'Tokyo', 'Japanese', 'GMT+9', 'https://flags.com/japan.png'),
('Brazil', 'BRA', 'South America', 213993437, 1444730000000.00, 'Brasília', 'Portuguese', 'GMT-3', 'https://flags.com/brazil.png'),
('Australia', 'AUS', 'Oceania', 25687041, 1392687000000.00, 'Canberra', 'English', 'GMT+10', 'https://flags.com/australia.png'),
('Canada', 'CAN', 'North America', 38005238, 1647120000000.00, 'Ottawa', 'English/French', 'GMT-5', 'https://flags.com/canada.png'),
('Italy', 'ITA', 'Europe', 60367477, 2001170000000.00, 'Rome', 'Italian', 'GMT+1', 'https://flags.com/italy.png'),
('South Korea', 'KOR', 'Asia', 51269185, 1630500000000.00, 'Seoul', 'Korean', 'GMT+9', 'https://flags.com/southkorea.png'),
('Spain', 'ESP', 'Europe', 46754778, 1393350000000.00, 'Madrid', 'Spanish', 'GMT+1', 'https://flags.com/spain.png'),
('Mexico', 'MEX', 'North America', 128932753, 1074310000000.00, 'Mexico City', 'Spanish', 'GMT-6', 'https://flags.com/mexico.png'),
('Indonesia', 'IDN', 'Asia', 273523615, 1058400000000.00, 'Jakarta', 'Indonesian', 'GMT+7', 'https://flags.com/indonesia.png'),
('Netherlands', 'NLD', 'Europe', 17134872, 902355000000.00, 'Amsterdam', 'Dutch', 'GMT+1', 'https://flags.com/netherlands.png'),
('Saudi Arabia', 'SAU', 'Asia', 34813871, 793000000000.00, 'Riyadh', 'Arabic', 'GMT+3', 'https://flags.com/saudiarabia.png'),
('Turkey', 'TUR', 'Asia/Europe', 84339067, 761425000000.00, 'Ankara', 'Turkish', 'GMT+3', 'https://flags.com/turkey.png'),
('Switzerland', 'CHE', 'Europe', 8654622, 703082000000.00, 'Bern', 'German/French/Italian', 'GMT+1', 'https://flags.com/switzerland.png');

SELECT * FROM Countries;

-- Table 2: Sports
CREATE TABLE Sports (
    sport_id INT PRIMARY KEY AUTO_INCREMENT,           -- Unique ID for each sport
    sport_name VARCHAR(100) NOT NULL,                  -- Name of the sport
    sport_category VARCHAR(50),                        -- Type/category (e.g., Track, Aquatic)
    is_team_sport BOOLEAN,                             -- 1 for team sports, 0 for individual
    olympic_since_year SMALLINT,                       -- Year sport was added to Olympics
    equipment_required TEXT,                           -- Main equipment needed
    indoor_outdoor VARCHAR(20),                        -- Played indoors or outdoors
    typical_duration_minutes INT,                      -- Average match duration
    scoring_type VARCHAR(50),                          -- Points, time, goals, etc.
    governing_body VARCHAR(100)                        -- Global governing authority
);

INSERT INTO Sports (
    sport_name, sport_category, is_team_sport, olympic_since_year, equipment_required,
    indoor_outdoor, typical_duration_minutes, scoring_type, governing_body
) VALUES
('Athletics', 'Track & Field', 0, 1896, 'Spikes, track', 'Outdoor', 60, 'Time/Distance', 'World Athletics'),
('Gymnastics', 'Artistic', 0, 1896, 'Beams, bars, mats', 'Indoor', 90, 'Points', 'FIG'),
('Javelin Throw', 'Field', 0, 1908, 'Javelin', 'Outdoor', 10, 'Distance', 'World Athletics'),
('Swimming', 'Aquatic', 0, 1896, 'Swimsuit, goggles', 'Indoor', 30, 'Time', 'FINA'),
('Figure Skating', 'Ice', 0, 1908, 'Skates, costume', 'Indoor', 5, 'Points', 'ISU'),
('Badminton', 'Racquet', 1, 1992, 'Racquet, shuttlecock', 'Indoor', 40, 'Points', 'BWF'),
('Tennis', 'Racquet', 1, 1896, 'Racquet, tennis balls', 'Outdoor', 120, 'Points', 'ITF'),
('Boxing', 'Combat', 0, 1904, 'Gloves, mouthguard', 'Indoor', 30, 'Points/KO', 'AIBA'),
('Basketball', 'Ball', 1, 1936, 'Basketball, hoop', 'Indoor', 40, 'Points', 'FIBA'),
('Wrestling', 'Combat', 0, 1896, 'Wrestling mat', 'Indoor', 6, 'Points/Pin', 'UWW'),
('Cycling', 'Race', 0, 1896, 'Bicycle, helmet', 'Outdoor', 240, 'Time', 'UCI'),
('Weightlifting', 'Strength', 0, 1896, 'Barbell, weights', 'Indoor', 10, 'Weight Lifted', 'IWF'),
('Fencing', 'Combat', 0, 1896, 'Foil, epee, sabre', 'Indoor', 10, 'Points', 'FIE'),
('Archery', 'Precision', 0, 1900, 'Bow, arrows', 'Outdoor', 30, 'Points', 'WA'),
('Rowing', 'Water', 1, 1900, 'Boat, oars', 'Outdoor', 360, 'Time', 'FISA'),
('Shooting', 'Precision', 0, 1896, 'Rifle, pistol, targets', 'Indoor', 30, 'Points', 'ISSF'),
('Hockey', 'Ball', 1, 1908, 'Stick, ball, pads', 'Outdoor', 60, 'Goals', 'FIH'),
('Table Tennis', 'Racquet', 1, 1988, 'Paddle, ball, table', 'Indoor', 30, 'Points', 'ITTF'),
('Skateboarding', 'Urban', 0, 2020, 'Skateboard, pads', 'Outdoor', 15, 'Points', 'World Skate'),
('Surfing', 'Water', 0, 2020, 'Surfboard, leash', 'Outdoor', 30, 'Points', 'ISA');

SELECT * FROM Sports;

-- Table 3: Athletes
CREATE TABLE Athletes (
    athlete_id INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each athlete
    first_name VARCHAR(50) NOT NULL,                   -- Athlete's first name
    last_name VARCHAR(50) NOT NULL,                    -- Athlete's last name
    gender ENUM('Male', 'Female', 'Other') NOT NULL,   -- Gender of the athlete
    date_of_birth DATE,                                -- Birthdate
    country_id INT,                                    -- Foreign key to Countries
    sport_id INT,                                      -- Foreign key to Sports
    height_cm INT,                                     -- Height in centimeters
    weight_kg INT,                                     -- Weight in kilograms
    bio TEXT,                                          -- Short biography
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

INSERT INTO Athletes (first_name, last_name, gender, date_of_birth, country_id, sport_id, height_cm, weight_kg, bio)
VALUES
('Usain', 'Bolt', 'Male', '1986-08-21', 1, 1, 195, 94, 'Legendary Jamaican sprinter, 8-time Olympic gold medalist.'),
('Simone', 'Biles', 'Female', '1997-03-14', 2, 2, 142, 47, 'American gymnast with the most world championship medals.'),
('Neeraj', 'Chopra', 'Male', '1997-12-24', 3, 3, 182, 86, 'Indian javelin thrower, Olympic gold medalist in Tokyo 2020.'),
('Katie', 'Ledecky', 'Female', '1997-03-17', 2, 4, 183, 70, 'American swimmer with multiple Olympic gold medals.'),
('Yuzuru', 'Hanyu', 'Male', '1994-12-07', 4, 5, 172, 57, 'Japanese figure skater and two-time Olympic champion.'),
('P. V.', 'Sindhu', 'Female', '1995-07-05', 3, 6, 179, 65, 'Indian badminton star and Olympic silver medalist.'),
('Novak', 'Djokovic', 'Male', '1987-05-22', 5, 7, 188, 80, 'Serbian tennis champion and world number one.'),
('Mary', 'Kom', 'Female', '1982-11-24', 3, 8, 158, 48, 'Indian boxer and six-time world champion.'),
('LeBron', 'James', 'Male', '1984-12-30', 2, 9, 206, 113, 'American basketball icon and Olympic gold medalist.'),
('Bajrang', 'Punia', 'Male', '1994-02-26', 3, 10, 165, 65, 'Indian wrestler and Asian Games gold medalist.'),
('Shelly-Ann', 'Fraser-Pryce', 'Female', '1986-12-27', 1, 1, 152, 52, 'Jamaican sprinter and Olympic gold medalist.'),
('Dina', 'Asher-Smith', 'Female', '1995-12-04', 6, 1, 164, 58, 'British sprinter and world champion.'),
('Federica', 'Pellegrini', 'Female', '1988-08-05', 12, 4, 179, 65, 'Italian freestyle swimmer and Olympic champion.'),
('Andy', 'Murray', 'Male', '1987-05-15', 6, 7, 190, 84, 'British tennis player and two-time Olympic gold medalist.'),
('Sun', 'Yang', 'Male', '1991-12-01', 2, 4, 198, 89, 'Chinese swimmer with multiple Olympic medals.'),
('Kento', 'Momota', 'Male', '1994-09-01', 4, 6, 175, 68, 'Japanese badminton world champion.'),
('Hidilyn', 'Diaz', 'Female', '1991-02-20', 17, 10, 158, 55, 'Filipino weightlifter and Olympic gold medalist.'),
('Carolina', 'Marín', 'Female', '1993-06-15', 14, 6, 172, 60, 'Spanish badminton Olympic champion.'),
('Nikola', 'Jokić', 'Male', '1995-02-19', 5, 9, 211, 129, 'Serbian basketball MVP and Olympic silver medalist.'),
('Caeleb', 'Dressel', 'Male', '1996-08-16', 2, 4, 191, 88, 'American swimmer with 5 gold medals at Tokyo 2020.');

SELECT * FROM Athletes;

-- Table 4: Olympics
CREATE TABLE Olympics (
    olympic_id INT PRIMARY KEY AUTO_INCREMENT,       -- Unique ID for each Olympic Games edition
    year INT NOT NULL,                               -- Year of the Olympic Games
    season ENUM('Summer', 'Winter') NOT NULL,        -- Season of the games
    city VARCHAR(100) NOT NULL,                      -- Host city
    country_id INT,                                  -- Host country
    opening_date DATE,                               -- Opening ceremony date
    closing_date DATE,                               -- Closing ceremony date
    number_of_sports INT,                            -- Total sports included
    number_of_athletes INT,                          -- Total participating athletes
    slogan VARCHAR(100),                             -- Official slogan or theme
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

INSERT INTO Olympics (year, season, city, country_id, opening_date, closing_date, number_of_sports, number_of_athletes, slogan) 
VALUES
(2000, 'Summer', 'Sydney', 7, '2000-09-15', '2000-10-01', 28, 10651, 'Share the Spirit'),
(2004, 'Summer', 'Athens', 8, '2004-08-13', '2004-08-29', 28, 10625, 'Welcome Home'),
(2008, 'Summer', 'Beijing', 2, '2008-08-08', '2008-08-24', 28, 10942, 'One World One Dream'),
(2012, 'Summer', 'London', 6, '2012-07-27', '2012-08-12', 26, 10568, 'Inspire a Generation'),
(2016, 'Summer', 'Rio de Janeiro', 9, '2016-08-05', '2016-08-21', 28, 11238, 'A New World'),
(2020, 'Summer', 'Tokyo', 4, '2021-07-23', '2021-08-08', 33, 11300, 'United by Emotion'),
(2024, 'Summer', 'Paris', 6, '2024-07-26', '2024-08-11', 32, 10500, 'Games Wide Open'),
(2026, 'Winter', 'Milan-Cortina', 12, '2026-02-06', '2026-02-22', 15, 2900, 'Together We Shine'),
(1996, 'Summer', 'Atlanta', 2, '1996-07-19', '1996-08-04', 26, 10318, 'The Celebration of the Century'),
(1988, 'Summer', 'Seoul', 13, '1988-09-17', '1988-10-02', 23, 8391, 'Harmony and Progress'),
(1980, 'Summer', 'Moscow', 15, '1980-07-19', '1980-08-03', 21, 5179, 'Olympics for Peace and Friendship'),
(1972, 'Summer', 'Munich', 14, '1972-08-26', '1972-09-11', 21, 7134, 'The Cheerful Games'),
(1964, 'Summer', 'Tokyo', 4, '1964-10-10', '1964-10-24', 19, 5151, 'World Peace through Sport'),
(1956, 'Summer', 'Melbourne', 7, '1956-11-22', '1956-12-08', 17, 3314, 'Sports and Brotherhood'),
(1936, 'Summer', 'Berlin', 14, '1936-08-01', '1936-08-16', 19, 3963, 'The Games of the XI Olympiad'),
(1984, 'Summer', 'Los Angeles', 2, '1984-07-28', '1984-08-12', 23, 6829, 'Play a Part in History'),
(2002, 'Winter', 'Salt Lake City', 2, '2002-02-08', '2002-02-24', 7, 2399, 'Light the Fire Within'),
(2010, 'Winter', 'Vancouver', 2, '2010-02-12', '2010-02-28', 7, 2566, 'With Glowing Hearts'),
(2014, 'Winter', 'Sochi', 15, '2014-02-07', '2014-02-23', 7, 2780, 'Hot. Cool. Yours.'),
(2018, 'Winter', 'PyeongChang', 13, '2018-02-09', '2018-02-25', 7, 2922, 'Passion. Connected.');

SELECT * FROM Olympics;

-- Table 5: Events
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each event
    event_name VARCHAR(100) NOT NULL,                -- Name of the event
    sport_id INT NOT NULL,                           -- Linked sport
    gender_category ENUM('Men', 'Women', 'Mixed'),   -- Gender category
    event_type VARCHAR(50),                          -- Type (e.g., Final, Heats)
    distance_or_weight VARCHAR(50),                  -- For measurable events (e.g., 100m, 75kg)
    number_of_rounds INT,                            -- Total rounds (e.g., heats + finals)
    scoring_method VARCHAR(50),                      -- Points, Time, Goals etc.
    olympic_id INT,                                  -- Linked Olympic Games edition
    venue_name VARCHAR(100),                         -- Venue/stadium where event is held
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id)
);

INSERT INTO Events (
    event_name, sport_id, gender_category, event_type, distance_or_weight,
    number_of_rounds, scoring_method, olympic_id, venue_name
) VALUES
('100m Sprint – Men', 1, 'Men', 'Final', '100m', 3, 'Time', 1, 'Olympic Stadium'),
('100m Sprint – Women', 1, 'Women', 'Final', '100m', 3, 'Time', 1, 'Olympic Stadium'),
('Gymnastics Vault – Women', 2, 'Women', 'Final', 'N/A', 2, 'Points', 1, 'Gymnastics Arena'),
('Javelin Throw – Men', 3, 'Men', 'Final', '800g', 2, 'Distance', 1, 'Athletics Field'),
('Freestyle 100m – Men', 4, 'Men', 'Final', '100m', 3, 'Time', 1, 'Aquatic Center'),
('Figure Skating Singles – Men', 5, 'Men', 'Final', 'N/A', 1, 'Points', 1, 'Ice Palace'),
('Badminton Singles – Women', 6, 'Women', 'Final', 'N/A', 4, 'Points', 1, 'Indoor Arena'),
('Tennis Doubles – Mixed', 7, 'Mixed', 'Final', 'N/A', 5, 'Points', 1, 'Tennis Court 1'),
('Boxing Flyweight – Women', 8, 'Women', 'Final', '51kg', 3, 'Points/KO', 1, 'Boxing Hall'),
('Basketball – Men', 9, 'Men', 'Final', 'N/A', 5, 'Points', 1, 'Main Court'),
('Wrestling Freestyle – Men', 10, 'Men', 'Final', '65kg', 2, 'Points/Pin', 1, 'Combat Arena'),
('Cycling Road Race – Men', 11, 'Men', 'Final', '234km', 1, 'Time', 1, 'Road Circuit'),
('Weightlifting – Women', 12, 'Women', 'Final', '59kg', 1, 'Weight Lifted', 1, 'Lifting Hall'),
('Fencing Epee – Men', 13, 'Men', 'Final', 'N/A', 2, 'Points', 1, 'Fencing Arena'),
('Archery Team – Mixed', 14, 'Mixed', 'Final', '70m', 3, 'Points', 1, 'Archery Field'),
('Rowing Double Sculls – Women', 15, 'Women', 'Final', '2km', 1, 'Time', 1, 'Rowing Lake'),
('Shooting Air Rifle – Men', 16, 'Men', 'Final', '10m', 2, 'Points', 1, 'Shooting Range'),
('Hockey – Women', 17, 'Women', 'Final', 'N/A', 5, 'Goals', 1, 'Hockey Stadium'),
('Table Tennis Singles – Men', 18, 'Men', 'Final', 'N/A', 4, 'Points', 1, 'Table Arena'),
('Surfing – Men', 20, 'Men', 'Final', 'Waves', 1, 'Points', 1, 'Surfing Beach');

SELECT * FROM Events;

-- Table 6: Venues
CREATE TABLE Venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each venue
    venue_name VARCHAR(100) NOT NULL,                -- Name of the venue
    location VARCHAR(100),                           -- City or area where venue is located
    capacity INT,                                     -- Seating/viewing capacity
    venue_type VARCHAR(50),                          -- Indoor, Outdoor, Aquatic, etc.
    surface_type VARCHAR(50),                        -- Grass, synthetic, ice, water, etc.
    construction_year INT,                           -- Year venue was built
    renovated_year INT,                              -- Year last renovated
    olympic_id INT,                                  -- Associated Olympic Games edition
    country_id INT,                                   -- Host country
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id),
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

INSERT INTO Venues (venue_name, location, capacity, venue_type, surface_type, construction_year, renovated_year, olympic_id, country_id) 
VALUES
('Olympic Stadium', 'Tokyo', 68000, 'Outdoor', 'Synthetic', 2019, 2020, 6, 4),
('Aquatics Centre', 'London', 17500, 'Indoor', 'Water', 2011, 2012, 4, 6),
('Maracanã Stadium', 'Rio de Janeiro', 78838, 'Outdoor', 'Grass', 1950, 2013, 5, 9),
('Fencing Arena', 'Paris', 8500, 'Indoor', 'Wood', 2023, 2024, 7, 6),
('Boxing Hall', 'Beijing', 12000, 'Indoor', 'Mat', 2007, 2008, 3, 2),
('Wrestling Pavilion', 'Athens', 8000, 'Indoor', 'Mat', 2002, 2004, 2, 8),
('Rowing Lake', 'Munich', 10000, 'Outdoor', 'Water', 1971, 1972, 12, 14),
('Ice Palace', 'Sochi', 12000, 'Indoor', 'Ice', 2012, 2013, 19, 15),
('Gymnastics Arena', 'Seoul', 14000, 'Indoor', 'Sprung Floor', 1986, 1988, 10, 13),
('Surfing Beach', 'Chiba', 5000, 'Outdoor', 'Sand/Water', 2019, 2020, 6, 4),
('Shooting Range', 'Salt Lake City', 5000, 'Outdoor', 'Concrete', 2001, 2002, 17, 2),
('Table Arena', 'PyeongChang', 6000, 'Indoor', 'Wood', 2017, 2018, 20, 13),
('Tennis Court 1', 'London', 15000, 'Outdoor', 'Grass', 1922, 2011, 4, 6),
('Indoor Arena', 'Paris', 10000, 'Indoor', 'Hard Court', 2023, 2024, 7, 6),
('Combat Arena', 'Athens', 9000, 'Indoor', 'Mat', 2003, 2004, 2, 8),
('Main Court', 'Atlanta', 18000, 'Indoor', 'Hardwood', 1994, 1996, 9, 2),
('Archery Field', 'Tokyo', 5500, 'Outdoor', 'Grass', 2018, 2020, 6, 4),
('Lifting Hall', 'Beijing', 7500, 'Indoor', 'Platform', 2006, 2008, 3, 2),
('Road Circuit', 'London', 0, 'Outdoor', 'Tarmac', 2010, 2012, 4, 6),
('Hockey Stadium', 'Rio de Janeiro', 12000, 'Outdoor', 'Synthetic Turf', 2015, 2016, 5, 9);

SELECT * FROM Venues;

-- Table 7: Teams
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,         -- Unique ID for each team
    team_name VARCHAR(100) NOT NULL,                -- Name of the team
    country_id INT NOT NULL,                        -- Country of the team
    olympic_id INT NOT NULL,                        -- Associated Olympic Games edition
    sport_id INT NOT NULL,                          -- Linked sport
    total_athletes INT,                             -- Total athletes in the team
    total_medals INT,                               -- Total medals won by the team
    team_captain VARCHAR(100),                      -- Name of the team captain (if applicable)
    team_coach VARCHAR(100),                        -- Name of the coach (if applicable)
    formation_year INT,                             -- Year when the team was formed
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

INSERT INTO Teams (
    team_name, country_id, olympic_id, sport_id, total_athletes,
    total_medals, team_captain, team_coach, formation_year
) VALUES
('USA', 2, 1, 1, 200, 120, 'John Doe', 'Coach A', 1896),
('China', 3, 1, 2, 180, 110, 'Li Wei', 'Coach B', 1949),
('Germany', 4, 1, 3, 150, 85, 'Hans Muller', 'Coach C', 1871),
('France', 5, 1, 4, 140, 75, 'Pierre Dupont', 'Coach D', 1892),
('Brazil', 6, 5, 5, 100, 60, 'Carlos Silva', 'Coach E', 1932),
('Australia', 7, 4, 6, 110, 65, 'Mark Smith', 'Coach F', 1905),
('Canada', 8, 1, 7, 95, 55, 'Ryan Lee', 'Coach G', 1967),
('India', 9, 1, 8, 120, 50, 'Ravi Kumar', 'Coach H', 1947),
('Italy', 10, 1, 9, 130, 55, 'Giovanni Rossi', 'Coach I', 1861),
('Japan', 11, 1, 10, 115, 45, 'Taro Yamada', 'Coach J', 1890),
('South Korea', 12, 1, 11, 125, 50, 'Kim Jae-Hyun', 'Coach K', 1948),
('Great Britain', 6, 1, 12, 110, 40, 'Sarah Jones', 'Coach L', 1603),
('Mexico', 13, 1, 13, 90, 35, 'Juan Hernandez', 'Coach M', 1821),
('Spain', 14, 1, 14, 80, 30, 'Carlos Martin', 'Coach N', 1492),
('Argentina', 15, 1, 15, 95, 38, 'Marcos Gomez', 'Coach O', 1912),
('Russia', 16, 1, 16, 160, 70, 'Igor Ivanov', 'Coach P', 1721),
('Netherlands', 17, 1, 17, 105, 45, 'Anna van der Meer', 'Coach Q', 1579),
('South Africa', 18, 1, 18, 100, 48, 'Thabo Nkosi', 'Coach R', 1910),
('Kenya', 19, 1, 19, 50, 25, 'Joseph Kiprotich', 'Coach S', 1963),
('Sweden', 20, 1, 20, 60, 20, 'Erik Johansson', 'Coach T', 1900);

SELECT * FROM Teams;

-- Table 8: Medals
CREATE TABLE Medals (
    medal_id INT PRIMARY KEY AUTO_INCREMENT,           -- Unique ID for each medal entry
    athlete_id INT NOT NULL,                           -- Athlete who won the medal
    event_id INT NOT NULL,                             -- Event in which the medal was won
    medal_type ENUM('Gold', 'Silver', 'Bronze') NOT NULL, -- Type of medal
    team_id INT,                                       -- Team associated with the medal (if any)
    country_id INT NOT NULL,                           -- Country of the athlete/team
    olympic_id INT NOT NULL,                           -- Olympics edition
    medal_date DATE NOT NULL,                          -- Date of the medal win
    event_category VARCHAR(100),                       -- Category like "Men's 100m"
    venue_id INT,                                      -- Venue where the medal was awarded
    FOREIGN KEY (athlete_id) REFERENCES Athletes(athlete_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id)
);
drop table Medals;

INSERT INTO Medals (athlete_id, event_id, medal_type, team_id, country_id, olympic_id, medal_date, event_category, venue_id
) VALUES
(1, 1, 'Gold', NULL, 2, 1, '2000-09-25', 'Men\'s 100m', 1),
(2, 2, 'Silver', NULL, 3, 1, '2004-08-16', 'Women\'s 200m', 2),
(3, 3, 'Bronze', 1, 4, 1, '2008-08-12', 'Men\'s Relay', 3),
(4, 4, 'Gold', NULL, 5, 1, '2012-07-30', 'Women\'s High Jump', 4),
(5, 5, 'Gold', 2, 6, 1, '2016-08-11', 'Men\'s Football', 5),
(6, 6, 'Silver', 3, 7, 1, '2020-08-03', 'Men\'s Swimming', 6),
(7, 7, 'Bronze', NULL, 8, 1, '2016-08-16', 'Women\'s Shot Put', 7),
(8, 8, 'Gold', 4, 9, 1, '2020-08-05', 'Women\'s Gymnastics', 8),
(9, 9, 'Silver', NULL, 10, 1, '2012-08-02', 'Men\'s Judo', 9),
(10, 10, 'Bronze', NULL, 11, 1, '2008-08-09', 'Men\'s Archery', 10),
(11, 11, 'Gold', NULL, 12, 1, '2012-08-12', 'Women\'s Diving', 1),
(12, 12, 'Silver', NULL, 13, 1, '2000-09-23', 'Men\'s Tennis', 2),
(13, 13, 'Gold', 5, 14, 1, '2004-08-22', 'Women\'s Hockey', 3),
(14, 14, 'Bronze', NULL, 15, 1, '2008-08-07', 'Men\'s Weightlifting', 4),
(15, 15, 'Gold', NULL, 16, 1, '2016-08-21', 'Women\'s Basketball', 5),
(16, 16, 'Silver', NULL, 17, 1, '2020-08-10', 'Men\'s Table Tennis', 6),
(17, 17, 'Bronze', NULL, 18, 1, '2016-08-13', 'Women\'s Marathon', 7),
(18, 18, 'Gold', NULL, 19, 1, '2004-08-25', 'Men\'s Boxing', 8),
(19, 19, 'Silver', NULL, 20, 1, '2012-08-08', 'Women\'s Long Jump', 9),
(20, 20, 'Bronze', NULL, 6, 1, '2008-08-04', 'Men\'s Wrestling', 10);

SELECT * FROM Medals;

-- Table 9: 
CREATE TABLE Coaches (
    coach_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique ID for each coach
    first_name VARCHAR(50) NOT NULL,                      -- Coach's first name
    last_name VARCHAR(50) NOT NULL,                       -- Coach's last name
    gender ENUM('Male', 'Female', 'Other') NOT NULL,      -- Gender
    date_of_birth DATE NOT NULL,                          -- Date of birth
    country_id INT NOT NULL,                              -- Country the coach represents
    sport_id INT NOT NULL,                                -- Sport they specialize in
    team_id INT,                                          -- Team they are assigned to (nullable)
    years_of_experience INT NOT NULL,                     -- Coaching experience in years
    certification_level VARCHAR(50),                      -- Certification level (e.g., "Level A")
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

INSERT INTO Coaches (
    first_name, last_name, gender, date_of_birth, country_id, 
    sport_id, team_id, years_of_experience, certification_level
) VALUES
('John', 'Smith', 'Male', '1975-05-10', 1, 1, 1, 20, 'Level A'),
('Maria', 'Garcia', 'Female', '1980-02-14', 2, 2, 2, 18, 'Level B'),
('Liam', 'Nguyen', 'Male', '1968-11-30', 3, 3, 3, 25, 'Level A'),
('Chen', 'Wei', 'Female', '1979-03-22', 4, 4, NULL, 19, 'Level C'),
('Fatima', 'Ali', 'Female', '1985-08-12', 5, 5, 4, 12, 'Level B'),
('Mark', 'Johnson', 'Male', '1972-07-03', 6, 6, 5, 22, 'Level A'),
('Sofia', 'Petrova', 'Female', '1983-12-18', 7, 7, NULL, 15, 'Level B'),
('Carlos', 'Diaz', 'Male', '1970-10-05', 8, 8, 6, 30, 'Level A'),
('Emily', 'Brown', 'Female', '1990-04-09', 9, 9, 7, 8, 'Level C'),
('Tom', 'Wilson', 'Male', '1988-06-17', 10, 10, NULL, 10, 'Level B'),
('Olga', 'Ivanova', 'Female', '1974-01-29', 11, 1, 8, 27, 'Level A'),
('Raj', 'Verma', 'Male', '1982-03-03', 12, 2, 9, 14, 'Level C'),
('Anna', 'Schmidt', 'Female', '1977-09-19', 13, 3, 10, 20, 'Level B'),
('Ali', 'Khan', 'Male', '1986-05-06', 14, 4, 1, 9, 'Level C'),
('Julia', 'Lopez', 'Female', '1991-11-11', 15, 5, NULL, 7, 'Level B'),
('Robert', 'Kim', 'Male', '1984-08-25', 16, 6, 2, 11, 'Level A'),
('Isabella', 'Rossi', 'Female', '1989-10-30', 17, 7, NULL, 10, 'Level C'),
('Yuki', 'Takahashi', 'Male', '1971-06-14', 18, 8, 3, 26, 'Level A'),
('Sara', 'Andersson', 'Female', '1992-12-03', 19, 9, 4, 6, 'Level B'),
('David', 'Green', 'Male', '1987-01-20', 20, 10, 5, 13, 'Level B');

SELECT * FROM Coaches;

-- Table 10: Stadiums
CREATE TABLE Stadiums (
    stadium_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique ID for each stadium
    stadium_name VARCHAR(100) NOT NULL,                     -- Name of the stadium
    city VARCHAR(50) NOT NULL,                              -- City where the stadium is located
    country_id INT NOT NULL,                                -- Country where the stadium is located
    capacity INT NOT NULL,                                  -- Number of seats
    year_built INT NOT NULL,                                -- Year the stadium was built
    stadium_type VARCHAR(50),                               -- Type (e.g., Outdoor, Indoor, Dome)
    is_main_stadium BOOLEAN DEFAULT FALSE,                  -- Whether it was the main Olympic stadium
    surface_type VARCHAR(50),                               -- Type of surface (e.g., Grass, Synthetic)
    olympic_id INT NOT NULL,                                -- Olympic edition associated
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id)
);

INSERT INTO Stadiums (
    stadium_name, city, country_id, capacity, year_built,
    stadium_type, is_main_stadium, surface_type, olympic_id
) VALUES
('Olympic Stadium', 'Athens', 1, 75000, 1982, 'Outdoor', TRUE, 'Synthetic', 1),
('Bird\'s Nest', 'Beijing', 2, 91000, 2008, 'Outdoor', TRUE, 'Synthetic', 2),
('Maracanã Stadium', 'Rio de Janeiro', 3, 78838, 1950, 'Outdoor', TRUE, 'Grass', 3),
('Olympiastadion', 'Berlin', 4, 74475, 1936, 'Outdoor', FALSE, 'Grass', 4),
('Tokyo Olympic Stadium', 'Tokyo', 5, 68000, 2019, 'Outdoor', TRUE, 'Synthetic', 5),
('Stade de France', 'Paris', 6, 81338, 1998, 'Outdoor', FALSE, 'Grass', 6),
('Wembley Stadium', 'London', 7, 90000, 2007, 'Outdoor', TRUE, 'Grass', 7),
('Stadio Olimpico', 'Rome', 8, 70634, 1953, 'Outdoor', FALSE, 'Grass', 8),
('Estadio Azteca', 'Mexico City', 9, 87000, 1966, 'Outdoor', FALSE, 'Grass', 9),
('ANZ Stadium', 'Sydney', 10, 83500, 1999, 'Outdoor', TRUE, 'Synthetic', 10),
('National Arena', 'Bucharest', 11, 55634, 2011, 'Outdoor', FALSE, 'Grass', 11),
('Arena Corinthians', 'São Paulo', 3, 49205, 2014, 'Outdoor', FALSE, 'Grass', 3),
('Friends Arena', 'Stockholm', 12, 50000, 2012, 'Dome', FALSE, 'Synthetic', 12),
('Luzhniki Stadium', 'Moscow', 13, 81000, 1956, 'Outdoor', TRUE, 'Grass', 13),
('BC Place', 'Vancouver', 14, 54320, 1983, 'Dome', TRUE, 'Synthetic', 14),
('Mercedes-Benz Stadium', 'Atlanta', 15, 71000, 2017, 'Dome', FALSE, 'Synthetic', 15),
('Estadi Olímpic Lluís Companys', 'Barcelona', 16, 60000, 1927, 'Outdoor', TRUE, 'Synthetic', 16),
('Aviva Stadium', 'Dublin', 17, 51700, 2010, 'Outdoor', FALSE, 'Grass', 17),
('FNB Stadium', 'Johannesburg', 18, 94736, 1989, 'Outdoor', FALSE, 'Grass', 18),
('Gelora Bung Karno', 'Jakarta', 19, 77600, 1962, 'Outdoor', FALSE, 'Synthetic', 19);

SELECT * FROM Stadiums;

-- Table 11: Sponsors
CREATE TABLE Sponsors (
    sponsor_id INT PRIMARY KEY AUTO_INCREMENT,                -- Unique ID for each sponsor
    sponsor_name VARCHAR(100) NOT NULL,                       -- Name of the sponsor company
    sponsor_type VARCHAR(50) NOT NULL,                        -- Type (e.g., 'Global', 'National', 'Event')
    country_id INT NOT NULL,                                  -- Country of the sponsor (FK)
    contact_email VARCHAR(100),                               -- Contact email of sponsor
    contact_phone VARCHAR(20),                                -- Contact phone number
    amount_sponsored DECIMAL(15, 2) NOT NULL,                 -- Total amount sponsored
    olympic_id INT NOT NULL,                                  -- Linked Olympic edition (FK)
    sponsored_entity_type ENUM('Team', 'Athlete', 'Event'),  -- What they are sponsoring
    sponsored_entity_id INT NOT NULL,                         -- ID of the entity they are sponsoring
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    FOREIGN KEY (olympic_id) REFERENCES Olympics(olympic_id)
);

INSERT INTO Sponsors (sponsor_name, sponsor_type, country_id, contact_email, contact_phone, amount_sponsored, olympic_id, sponsored_entity_type, sponsored_entity_id) 
VALUES
('Coca-Cola', 'Global', 1, 'contact@coca-cola.com', '+1-800-123-4567', 50000000.00, 1, 'Event', 101),
('Samsung', 'Global', 2, 'info@samsung.com', '+82-2-1234-5678', 30000000.00, 2, 'Team', 5),
('Toyota', 'Global', 3, 'support@toyota.com', '+81-3-1234-5678', 45000000.00, 3, 'Athlete', 21),
('Visa', 'Global', 4, 'sponsors@visa.com', '+1-800-321-6543', 40000000.00, 4, 'Event', 102),
('Omega', 'Global', 5, 'omega@watches.com', '+41-21-345-6789', 35000000.00, 5, 'Event', 103),
('Panasonic', 'Global', 6, 'global@panasonic.com', '+81-6-7890-1234', 28000000.00, 6, 'Athlete', 25),
('Alibaba Group', 'Global', 7, 'contact@alibaba.com', '+86-571-8502-2088', 38000000.00, 7, 'Team', 7),
('Procter & Gamble', 'Global', 8, 'pgsupport@pg.com', '+1-888-888-8888', 32000000.00, 8, 'Event', 104),
('Intel', 'Global', 9, 'sponsorship@intel.com', '+1-800-456-7890', 36000000.00, 9, 'Team', 8),
('Bridgestone', 'Global', 10, 'global@bridgestone.com', '+81-3-4567-8901', 31000000.00, 10, 'Athlete', 30),
('Airbnb', 'Global', 11, 'partnerships@airbnb.com', '+1-800-555-5555', 25000000.00, 11, 'Event', 105),
('Lindt', 'National', 12, 'sponsor@lindt.com', '+41-44-567-1234', 8000000.00, 12, 'Team', 10),
('Asics', 'National', 13, 'info@asics.com', '+81-6-7890-2345', 9500000.00, 13, 'Athlete', 32),
('Red Bull', 'Event', 14, 'sponsor@redbull.com', '+43-662-6582-0', 12000000.00, 14, 'Event', 106),
('Nike', 'Global', 15, 'nikecontact@nike.com', '+1-503-671-6453', 47000000.00, 15, 'Athlete', 33),
('PepsiCo', 'National', 16, 'media@pepsico.com', '+1-914-253-2000', 10000000.00, 16, 'Team', 12),
('Sony', 'National', 17, 'sponsor@sony.com', '+81-3-6748-2111', 8700000.00, 17, 'Team', 13),
('Under Armour', 'National', 18, 'support@underarmour.com', '+1-888-727-6687', 6000000.00, 18, 'Athlete', 35),
('Rolex', 'Event', 19, 'sponsor@rolex.com', '+41-22-302-2200', 15000000.00, 19, 'Event', 107),
('Heineken', 'National', 20, 'contact@heineken.com', '+31-20-523-9239', 9000000.00, 20, 'Team', 14);

SELECT * FROM Sponsors;

-- Table 12: Matches
CREATE TABLE Matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,               -- Unique ID for each match
    event_id INT NOT NULL,                                 -- Linked event (FK)
    team1_id INT NOT NULL,                                 -- First team (FK)
    team2_id INT NOT NULL,                                 -- Second team (FK)
    match_date DATE NOT NULL,                              -- Date of the match
    start_time TIME,                                       -- Match start time
    end_time TIME,                                         -- Match end time
    venue_id INT NOT NULL,                                 -- Venue where match was held (FK)
    winner_team_id INT,                                    -- Winning team (FK, nullable)
    match_status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',  -- Status of match
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id),
    FOREIGN KEY (winner_team_id) REFERENCES Teams(team_id)
);

INSERT INTO Matches (event_id, team1_id, team2_id, match_date, start_time, end_time, venue_id, winner_team_id, match_status
) VALUES
(1, 1, 2, '2024-07-21', '14:00:00', '15:45:00', 1, 2, 'Completed'),
(2, 3, 4, '2024-07-22', '10:00:00', '11:30:00', 2, 3, 'Completed'),
(3, 5, 6, '2024-07-23', '18:00:00', '19:45:00', 3, 6, 'Completed'),
(4, 7, 8, '2024-07-24', '09:00:00', '10:30:00', 4, 7, 'Completed'),
(5, 9, 10, '2024-07-25', '16:00:00', '17:30:00', 5, 10, 'Completed'),
(6, 11, 12, '2024-07-26', '13:00:00', '14:45:00', 6, 12, 'Completed'),
(7, 13, 14, '2024-07-27', '11:00:00', '12:45:00', 7, 13, 'Completed'),
(8, 15, 16, '2024-07-28', '17:00:00', '18:30:00', 8, 15, 'Completed'),
(9, 17, 18, '2024-07-29', '08:00:00', '09:45:00', 9, 17, 'Completed'),
(10, 19, 20, '2024-07-30', '12:00:00', '13:30:00', 10, 20, 'Completed'),
(1, 1, 3, '2024-08-01', '15:00:00', '16:30:00', 1, 3, 'Completed'),
(2, 4, 5, '2024-08-02', '09:30:00', '11:00:00', 2, 5, 'Completed'),
(3, 6, 7, '2024-08-03', '10:30:00', '12:00:00', 3, 6, 'Completed'),
(4, 8, 9, '2024-08-04', '13:00:00', '14:30:00', 4, 8, 'Completed'),
(5, 10, 11, '2024-08-05', '14:30:00', '16:00:00', 5, 10, 'Completed'),
(6, 12, 13, '2024-08-06', '17:00:00', '18:30:00', 6, 12, 'Completed'),
(7, 14, 15, '2024-08-07', '11:30:00', '13:00:00', 7, 15, 'Completed'),
(8, 16, 17, '2024-08-08', '16:15:00', '17:45:00', 8, 17, 'Completed'),
(9, 18, 19, '2024-08-09', '10:00:00', '11:30:00', 9, 18, 'Completed'),
(10, 20, 1, '2024-08-10', '12:30:00', '14:00:00', 10, 1, 'Completed');

SELECT * FROM Matches;

-- Table 13: Broadcasts
CREATE TABLE Broadcasts (
    broadcast_id INT PRIMARY KEY AUTO_INCREMENT,           -- Unique ID for each broadcast
    event_id INT NOT NULL,                                 -- Linked event (FK)
    broadcaster_name VARCHAR(100) NOT NULL,                -- Name of the broadcaster (e.g., NBC, BBC)
    country_id INT NOT NULL,                               -- Country broadcasting from (FK)
    language VARCHAR(50),                                  -- Language of the broadcast
    broadcast_date DATE NOT NULL,                          -- Date of the broadcast
    start_time TIME,                                       -- Start time
    end_time TIME,                                         -- End time
    platform ENUM('TV', 'Online', 'Radio') DEFAULT 'TV',   -- Broadcast platform
    viewership_estimate INT,                               -- Estimated number of viewers
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

INSERT INTO Broadcasts (event_id, broadcaster_name, country_id, language, broadcast_date, start_time, end_time, platform, viewership_estimate) 
VALUES
(1, 'NBC', 1, 'English', '2024-07-21', '14:00:00', '16:00:00', 'TV', 25000000),
(2, 'BBC Sport', 2, 'English', '2024-07-22', '10:00:00', '12:00:00', 'TV', 18000000),
(3, 'Eurosport', 3, 'French', '2024-07-23', '18:00:00', '20:00:00', 'TV', 16000000),
(4, 'Sony Sports', 4, 'Hindi', '2024-07-24', '09:00:00', '11:00:00', 'TV', 12000000),
(5, 'NHK', 5, 'Japanese', '2024-07-25', '16:00:00', '18:00:00', 'TV', 14000000),
(6, 'CCTV', 6, 'Mandarin', '2024-07-26', '13:00:00', '15:00:00', 'TV', 20000000),
(7, 'RAI', 7, 'Italian', '2024-07-27', '11:00:00', '13:00:00', 'TV', 9000000),
(8, 'ARD', 8, 'German', '2024-07-28', '17:00:00', '19:00:00', 'TV', 13000000),
(9, 'TSN', 9, 'English', '2024-07-29', '08:00:00', '10:00:00', 'TV', 8000000),
(10, 'ABC Australia', 10, 'English', '2024-07-30', '12:00:00', '14:00:00', 'TV', 7500000),
(11, 'NBC', 1, 'English', '2024-08-01', '15:00:00', '17:00:00', 'Online', 21000000),
(12, 'BBC Radio 5', 2, 'English', '2024-08-02', '09:30:00', '11:30:00', 'Radio', 5000000),
(13, 'France Télévisions', 3, 'French', '2024-08-03', '10:30:00', '12:30:00', 'TV', 13500000),
(14, 'Doordarshan', 4, 'Hindi', '2024-08-04', '13:00:00', '15:00:00', 'TV', 10000000),
(15, 'TV Asahi', 5, 'Japanese', '2024-08-05', '14:30:00', '16:30:00', 'Online', 11500000),
(16, 'Tencent Sports', 6, 'Mandarin', '2024-08-06', '17:00:00', '19:00:00', 'Online', 19500000),
(17, 'Mediaset', 7, 'Italian', '2024-08-07', '11:30:00', '13:30:00', 'TV', 8200000),
(18, 'ZDF', 8, 'German', '2024-08-08', '16:15:00', '18:15:00', 'TV', 9900000),
(19, 'CBC', 9, 'English', '2024-08-09', '10:00:00', '12:00:00', 'Online', 8800000),
(20, 'SBS', 10, 'English', '2024-08-10', '12:30:00', '14:30:00', 'Radio', 4300000);

SELECT * FROM Broadcasts;

-- Table 14: Referees
CREATE TABLE Referees (
    referee_id INT PRIMARY KEY AUTO_INCREMENT,            -- Unique ID for referee
    full_name VARCHAR(100) NOT NULL,                      -- Referee's full name
    gender ENUM('Male', 'Female', 'Other'),               -- Gender
    nationality_id INT NOT NULL,                          -- Referee's nationality (FK to Countries)
    experience_years INT,                                 -- Years of experience
    sport_id INT NOT NULL,                                -- Sport they officiate (FK to Sports)
    certified BOOLEAN DEFAULT TRUE,                       -- Whether referee is certified
    contact_email VARCHAR(100),                           -- Contact email
    assigned_event_id INT,                                -- Event referee is assigned to (FK)
    status ENUM('Active', 'Retired', 'Suspended') DEFAULT 'Active',  -- Current status
    FOREIGN KEY (nationality_id) REFERENCES Countries(country_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (assigned_event_id) REFERENCES Events(event_id)
);

INSERT INTO Referees (full_name, gender, nationality_id, experience_years, sport_id, certified, contact_email, assigned_event_id, status
) VALUES
('John Smith', 'Male', 1, 10, 1, TRUE, 'john.smith@example.com', 1, 'Active'),
('Emily Davis', 'Female', 2, 12, 2, TRUE, 'emily.davis@example.com', 2, 'Active'),
('Carlos Ruiz', 'Male', 3, 8, 3, TRUE, 'carlos.ruiz@example.com', 3, 'Active'),
('Anna Müller', 'Female', 4, 15, 4, TRUE, 'anna.mueller@example.com', 4, 'Active'),
('Takeshi Yamamoto', 'Male', 5, 20, 5, TRUE, 'takeshi.yamamoto@example.com', 5, 'Active'),
('Wei Zhang', 'Male', 6, 7, 6, TRUE, 'wei.zhang@example.com', 6, 'Active'),
('Giulia Bianchi', 'Female', 7, 9, 7, TRUE, 'giulia.bianchi@example.com', 7, 'Active'),
('Lars Becker', 'Male', 8, 6, 8, TRUE, 'lars.becker@example.com', 8, 'Active'),
('Olivia Brown', 'Female', 9, 11, 9, TRUE, 'olivia.brown@example.com', 9, 'Active'),
('Nathan White', 'Male', 10, 13, 10, TRUE, 'nathan.white@example.com', 10, 'Active'),
('Isabelle Dupont', 'Female', 3, 14, 1, TRUE, 'isabelle.dupont@example.com', 11, 'Active'),
('Rajiv Mehta', 'Male', 4, 18, 2, TRUE, 'rajiv.mehta@example.com', 12, 'Retired'),
('Sophia Kim', 'Female', 5, 5, 3, TRUE, 'sophia.kim@example.com', 13, 'Active'),
('David Chen', 'Male', 6, 10, 4, TRUE, 'david.chen@example.com', 14, 'Active'),
('Laura Rossi', 'Female', 7, 8, 5, TRUE, 'laura.rossi@example.com', 15, 'Suspended'),
('Andreas Vogel', 'Male', 8, 9, 6, TRUE, 'andreas.vogel@example.com', 16, 'Active'),
('Jasmine Singh', 'Female', 4, 6, 7, TRUE, 'jasmine.singh@example.com', 17, 'Active'),
('Chen Liu', 'Male', 6, 7, 8, TRUE, 'chen.liu@example.com', 18, 'Active'),
('Mia Thompson', 'Female', 9, 4, 9, TRUE, 'mia.thompson@example.com', 19, 'Retired'),
('Lucas Taylor', 'Male', 10, 3, 10, TRUE, 'lucas.taylor@example.com', 20, 'Active');

SELECT * FROM Referees;

-- Table 15: Schedules
CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique schedule ID
    event_id INT NOT NULL,                                   -- Linked event (FK)
    sport_id INT NOT NULL,                                   -- Related sport (FK)
    venue_id INT NOT NULL,                                   -- Venue where event is held (FK)
    scheduled_date DATE NOT NULL,                            -- Date of the event
    start_time TIME,                                         -- Event start time
    end_time TIME,                                           -- Event end time
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled', -- Status
    session VARCHAR(50),                                     -- Morning / Afternoon / Evening
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last updated
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id)
);

INSERT INTO Schedules (event_id, sport_id, venue_id, scheduled_date,start_time, end_time, status, session) 
VALUES
(1, 1, 1, '2024-07-21', '10:00:00', '12:00:00', 'Scheduled', 'Morning'),
(2, 2, 2, '2024-07-22', '14:00:00', '16:00:00', 'Scheduled', 'Afternoon'),
(3, 3, 3, '2024-07-23', '09:00:00', '11:00:00', 'Scheduled', 'Morning'),
(4, 4, 4, '2024-07-24', '15:00:00', '17:00:00', 'Scheduled', 'Afternoon'),
(5, 5, 5, '2024-07-25', '11:00:00', '13:00:00', 'Scheduled', 'Morning'),
(6, 6, 6, '2024-07-26', '13:00:00', '15:00:00', 'Scheduled', 'Afternoon'),
(7, 7, 7, '2024-07-27', '16:00:00', '18:00:00', 'Scheduled', 'Evening'),
(8, 8, 8, '2024-07-28', '17:00:00', '19:00:00', 'Scheduled', 'Evening'),
(9, 9, 9, '2024-07-29', '08:00:00', '10:00:00', 'Scheduled', 'Morning'),
(10, 10, 10, '2024-07-30', '10:30:00', '12:30:00', 'Scheduled', 'Morning'),
(11, 1, 1, '2024-08-01', '13:00:00', '15:00:00', 'Scheduled', 'Afternoon'),
(12, 2, 2, '2024-08-02', '14:30:00', '16:30:00', 'Completed', 'Afternoon'),
(13, 3, 3, '2024-08-03', '09:30:00', '11:30:00', 'Completed', 'Morning'),
(14, 4, 4, '2024-08-04', '15:30:00', '17:30:00', 'Scheduled', 'Evening'),
(15, 5, 5, '2024-08-05', '11:30:00', '13:30:00', 'Cancelled', 'Morning'),
(16, 6, 6, '2024-08-06', '13:30:00', '15:30:00', 'Scheduled', 'Afternoon'),
(17, 7, 7, '2024-08-07', '16:30:00', '18:30:00', 'Scheduled', 'Evening'),
(18, 8, 8, '2024-08-08', '17:30:00', '19:30:00', 'Scheduled', 'Evening'),
(19, 9, 9, '2024-08-09', '08:30:00', '10:30:00', 'Scheduled', 'Morning'),
(20, 10, 10, '2024-08-10', '10:00:00', '12:00:00', 'Scheduled', 'Morning');

SELECT * FROM Schedules;

-- Table 16: Judges
CREATE TABLE Judges (
    judge_id INT PRIMARY KEY AUTO_INCREMENT,               -- Unique ID for each judge
    full_name VARCHAR(100) NOT NULL,                       -- Judge's full name
    gender ENUM('Male', 'Female', 'Other'),                -- Gender
    nationality_id INT NOT NULL,                           -- Nationality (FK to Countries)
    sport_id INT NOT NULL,                                 -- Sport they judge (FK to Sports)
    certification_level VARCHAR(50),                       -- Level of judging certification
    years_of_experience INT,                               -- Experience in years
    is_chief_judge BOOLEAN DEFAULT FALSE,                  -- Whether the judge is a chief judge
    assigned_event_id INT,                                 -- Event they are judging (FK to Events)
    status ENUM('Active', 'Retired', 'Suspended') DEFAULT 'Active', -- Current status
    FOREIGN KEY (nationality_id) REFERENCES Countries(country_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (assigned_event_id) REFERENCES Events(event_id)
);

INSERT INTO Judges (
    full_name, gender, nationality_id, sport_id, certification_level,
    years_of_experience, is_chief_judge, assigned_event_id, status
) VALUES
('Lisa Turner', 'Female', 1, 1, 'International', 12, TRUE, 1, 'Active'),
('Miguel Fernandez', 'Male', 2, 2, 'National', 8, FALSE, 2, 'Active'),
('Akira Tanaka', 'Male', 3, 3, 'Continental', 10, FALSE, 3, 'Active'),
('Natalie Schmidt', 'Female', 4, 4, 'International', 15, TRUE, 4, 'Active'),
('Chen Wei', 'Male', 5, 5, 'National', 7, FALSE, 5, 'Active'),
('Isabella Conti', 'Female', 6, 6, 'International', 13, TRUE, 6, 'Active'),
('Omar Khalid', 'Male', 7, 7, 'Continental', 9, FALSE, 7, 'Active'),
('Emma Johansson', 'Female', 8, 8, 'National', 11, FALSE, 8, 'Active'),
('George Carter', 'Male', 9, 9, 'International', 14, TRUE, 9, 'Active'),
('Yu Min', 'Female', 10, 10, 'Continental', 6, FALSE, 10, 'Active'),
('Carlos Silva', 'Male', 2, 1, 'National', 5, FALSE, 11, 'Retired'),
('Kavita Iyer', 'Female', 4, 2, 'International', 12, TRUE, 12, 'Active'),
('Liu Feng', 'Male', 5, 3, 'International', 10, FALSE, 13, 'Suspended'),
('Elena Petrova', 'Female', 6, 4, 'National', 7, FALSE, 14, 'Active'),
('Ahmed Said', 'Male', 7, 5, 'International', 13, TRUE, 15, 'Active'),
('Anna Larsson', 'Female', 8, 6, 'Continental', 6, FALSE, 16, 'Active'),
('James Brown', 'Male', 9, 7, 'National', 8, FALSE, 17, 'Retired'),
('Mina Nakamura', 'Female', 10, 8, 'International', 9, TRUE, 18, 'Active'),
('Stefan Novak', 'Male', 3, 9, 'National', 11, FALSE, 19, 'Active'),
('Sara Lopez', 'Female', 1, 10, 'Continental', 10, TRUE, 20, 'Active');

SELECT * FROM Judges;

-- Table 17: Scores

CREATE TABLE Scores (
    score_id INT PRIMARY KEY AUTO_INCREMENT,               -- Unique score ID
    athlete_id INT NOT NULL,                               -- Athlete being scored (FK to Athletes)
    judge_id INT NOT NULL,                                 -- Judge awarding the score (FK to Judges)
    event_id INT NOT NULL,                                 -- Event the score belongs to (FK to Events)
    score DECIMAL(5,2) NOT NULL,                           -- Score given by the judge
    score_type ENUM('Technical', 'Artistic', 'Performance') NOT NULL, -- Type of score
    score_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,        -- Timestamp when score was given
    remarks VARCHAR(255),                                  -- Remarks from the judge
    status ENUM('Submitted', 'Reviewed', 'Final') DEFAULT 'Submitted', -- Score status
    FOREIGN KEY (athlete_id) REFERENCES Athletes(athlete_id),
    FOREIGN KEY (judge_id) REFERENCES Judges(judge_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

INSERT INTO Scores (athlete_id, judge_id, event_id, score, score_type, remarks, status) 
VALUES
(1, 1, 1, 9.75, 'Technical', 'Excellent technique.', 'Final'),
(2, 2, 2, 8.50, 'Artistic', 'Good execution but room for improvement.', 'Final'),
(3, 3, 3, 7.80, 'Performance', 'Missed a few key points.', 'Reviewed'),
(4, 4, 4, 9.00, 'Technical', 'Strong performance overall.', 'Submitted'),
(5, 5, 5, 8.20, 'Artistic', 'Very creative, but lacked precision.', 'Final'),
(6, 6, 6, 7.50, 'Performance', 'Performance was underwhelming.', 'Reviewed'),
(7, 7, 7, 9.40, 'Technical', 'Excellent control throughout.', 'Final'),
(8, 8, 8, 9.00, 'Artistic', 'Impressive form and flow.', 'Final'),
(9, 9, 9, 8.60, 'Performance', 'Lacked synchronization at times.', 'Reviewed'),
(10, 10, 10, 8.90, 'Technical', 'Great technique but missed a few details.', 'Final'),
(11, 1, 11, 9.30, 'Artistic', 'Strong artistic expression.', 'Final'),
(12, 2, 12, 8.70, 'Performance', 'Some missed moments, but good execution.', 'Submitted'),
(13, 3, 13, 7.40, 'Technical', 'Inconsistent performance.', 'Final'),
(14, 4, 14, 8.10, 'Performance', 'Decent execution, but lacking some finesse.', 'Reviewed'),
(15, 5, 15, 8.50, 'Artistic', 'Beautiful execution with minor flaws.', 'Final'),
(16, 6, 16, 9.00, 'Technical', 'Very precise and strong performance.', 'Final'),
(17, 7, 17, 9.60, 'Performance', 'Outstanding performance overall.', 'Final'),
(18, 8, 18, 7.90, 'Artistic', 'Good form but missed some key moments.', 'Reviewed'),
(19, 9, 19, 8.80, 'Performance', 'Solid effort but lacked impact.', 'Reviewed'),
(20, 10, 20, 9.20, 'Technical', 'Clean and impressive technique.', 'Final');

SELECT * FROM Scores;

-- Table 18: Ticket Sales
CREATE TABLE ticket_sales (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,            -- Unique ticket ID
    event_id INT NOT NULL,                               -- Linked event (FK)
    buyer_name VARCHAR(100),                             -- Name of the ticket buyer
    buyer_email VARCHAR(100),                            -- Email of the buyer
    ticket_type ENUM('Regular', 'VIP', 'Student'),       -- Type of ticket
    purchase_date DATE,                                  -- Date of purchase
    seat_number VARCHAR(20),                             -- Assigned seat
    price DECIMAL(8,2),                                  -- Price of the ticket
    payment_status ENUM('Paid', 'Pending', 'Cancelled'),-- Payment status
    sale_channel ENUM('Online', 'Onsite'),               -- Where the ticket was sold
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);

INSERT INTO ticket_sales (event_id, buyer_name, buyer_email, ticket_type, purchase_date, seat_number, price, payment_status, sale_channel) 
VALUES
(1, 'Alice Smith', 'alice@example.com', 'Regular', '2024-06-01', 'A101', 50.00, 'Paid', 'Online'),
(2, 'Bob Jones', 'bob@example.com', 'VIP', '2024-06-02', 'V10', 150.00, 'Paid', 'Onsite'),
(3, 'Cara White', 'cara@example.com', 'Student', '2024-06-03', 'S23', 30.00, 'Paid', 'Online'),
(4, 'David Green', 'david@example.com', 'Regular', '2024-06-01', 'B12', 50.00, 'Pending', 'Online'),
(5, 'Eva Brown', 'eva@example.com', 'VIP', '2024-06-04', 'V11', 150.00, 'Paid', 'Onsite'),
(6, 'Frank Black', 'frank@example.com', 'Regular', '2024-06-05', 'C9', 50.00, 'Cancelled', 'Online'),
(7, 'Grace Grey', 'grace@example.com', 'Student', '2024-06-02', 'S11', 30.00, 'Paid', 'Online'),
(8, 'Henry Adams', 'henry@example.com', 'Regular', '2024-06-03', 'D15', 50.00, 'Paid', 'Onsite'),
(9, 'Ivy Johnson', 'ivy@example.com', 'VIP', '2024-06-01', 'V12', 150.00, 'Paid', 'Online'),
(10, 'Jake Clark', 'jake@example.com', 'Regular', '2024-06-02', 'E10', 50.00, 'Paid', 'Onsite'),
(11, 'Kelly Reed', 'kelly@example.com', 'Student', '2024-06-03', 'S13', 30.00, 'Paid', 'Online'),
(12, 'Leo Hill', 'leo@example.com', 'Regular', '2024-06-04', 'F8', 50.00, 'Pending', 'Online'),
(13, 'Mia Lewis', 'mia@example.com', 'VIP', '2024-06-05', 'V13', 150.00, 'Paid', 'Onsite'),
(14, 'Nick King', 'nick@example.com', 'Regular', '2024-06-06', 'G7', 50.00, 'Cancelled', 'Online'),
(15, 'Olivia Scott', 'olivia@example.com', 'Student', '2024-06-07', 'S14', 30.00, 'Paid', 'Online'),
(16, 'Paul Young', 'paul@example.com', 'Regular', '2024-06-08', 'H6', 50.00, 'Paid', 'Onsite'),
(17, 'Quinn Wright', 'quinn@example.com', 'VIP', '2024-06-09', 'V14', 150.00, 'Paid', 'Online'),
(18, 'Ruby Evans', 'ruby@example.com', 'Regular', '2024-06-10', 'I5', 50.00, 'Paid', 'Onsite'),
(19, 'Sam Lee', 'sam@example.com', 'Student', '2024-06-11', 'S15', 30.00, 'Pending', 'Online'),
(20, 'Tina Walker', 'tina@example.com', 'Regular', '2024-06-12', 'J4', 50.00, 'Paid', 'Online');

SELECT * FROM Ticket_sales;

-- Table 19: Ceremonies
CREATE TABLE ceremonies (
    ceremony_id INT PRIMARY KEY AUTO_INCREMENT,               -- Unique ID
    olympic_id INT NOT NULL,                                  -- Linked Olympics (FK)
    ceremony_type ENUM('Opening', 'Closing', 'Medal'),        -- Type of ceremony
    ceremony_date DATE,                                       -- Date of the ceremony
    start_time TIME,                                          -- Start time
    end_time TIME,                                            -- End time
    venue_id INT NOT NULL,                                    -- Venue where it was held (FK)
    host_country VARCHAR(100),                                -- Host country
    main_performer VARCHAR(100),                              -- Chief performer
    theme VARCHAR(255),                                       -- Ceremony theme
    FOREIGN KEY (olympic_id) REFERENCES olympics(olympic_id),
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
);

INSERT INTO ceremonies (olympic_id, ceremony_type, ceremony_date, start_time, end_time, venue_id, host_country, main_performer, theme) 
VALUES
(1, 'Opening', '2024-07-23', '18:00:00', '21:00:00', 1, 'France', 'Dua Lipa', 'Unity in Diversity'),
(1, 'Closing', '2024-08-08', '19:00:00', '22:00:00', 1, 'France', 'Coldplay', 'A New Beginning'),
(1, 'Medal', '2024-07-24', '14:00:00', '15:00:00', 2, 'France', 'Local Orchestra', 'Celebrating Champions'),
(1, 'Medal', '2024-07-25', '14:00:00', '15:00:00', 2, 'France', 'Choir Kids', 'Hope and Honor'),
(1, 'Medal', '2024-07-26', '14:00:00', '15:00:00', 3, 'France', 'DJ Snake', 'Be Bold'),
(1, 'Medal', '2024-07-27', '14:00:00', '15:00:00', 3, 'France', 'Cello Group', 'Dream Big'),
(1, 'Medal', '2024-07-28', '14:00:00', '15:00:00', 2, 'France', 'Paris Symphony', 'Honor & Courage'),
(1, 'Medal', '2024-07-29', '14:00:00', '15:00:00', 1, 'France', 'Dance Crew', 'Energy Unleashed'),
(1, 'Medal', '2024-07-30', '14:00:00', '15:00:00', 2, 'France', 'Youth Band', 'Tomorrow’s Heroes'),
(1, 'Medal', '2024-07-31', '14:00:00', '15:00:00', 1, 'France', 'Folk Dancers', 'Heritage'),
(1, 'Medal', '2024-08-01', '14:00:00', '15:00:00', 3, 'France', 'Solo Violinist', 'Triumph'),
(1, 'Medal', '2024-08-02', '14:00:00', '15:00:00', 1, 'France', 'Jazz Band', 'Celebration'),
(1, 'Medal', '2024-08-03', '14:00:00', '15:00:00', 2, 'France', 'Hip-Hop Group', 'Rise Together'),
(1, 'Medal', '2024-08-04', '14:00:00', '15:00:00', 1, 'France', 'Opera Singer', 'Dream to Win'),
(1, 'Medal', '2024-08-05', '14:00:00', '15:00:00', 3, 'France', 'Rock Band', 'Spirit of Sports'),
(1, 'Medal', '2024-08-06', '14:00:00', '15:00:00', 2, 'France', 'Piano Solo', 'Glory'),
(1, 'Medal', '2024-08-07', '14:00:00', '15:00:00', 3, 'France', 'Acrobat Group', 'Balance & Grace'),
(1, 'Medal', '2024-08-08', '14:00:00', '15:00:00', 1, 'France', 'Marching Band', 'The Final Countdown'),
(1, 'Medal', '2024-08-09', '14:00:00', '15:00:00', 2, 'France', 'Children’s Choir', 'Inspire the World'),
(1, 'Medal', '2024-08-10', '14:00:00', '15:00:00', 3, 'France', 'National Ensemble', 'Victory and Peace');

SELECT * FROM Ceremonies;

-- Table 20: Medical Records
CREATE TABLE medical_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,                -- Unique record ID
    athlete_id INT NOT NULL,                                 -- Linked athlete (FK)
    checkup_date DATE,                                       -- Date of medical checkup
    injury_description VARCHAR(255),                         -- Injury or condition
    treatment_given VARCHAR(255),                            -- Treatment details
    doctor_name VARCHAR(100),                                -- Attending doctor
    hospital_name VARCHAR(100),                              -- Hospital or clinic
    fitness_clearance ENUM('Yes', 'No', 'Pending'),          -- Is athlete fit?
    follow_up_required BOOLEAN,                              -- Follow-up needed?
    notes TEXT,                                              -- Additional notes
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id)
);

INSERT INTO medical_records (athlete_id, checkup_date, injury_description, treatment_given,doctor_name, hospital_name, fitness_clearance, follow_up_required, notes) 
VALUES
(1, '2024-06-01', 'Sprained ankle', 'Rest and physiotherapy', 'Dr. Paul Kent', 'Olympic Clinic A', 'Yes', FALSE, 'Healing well. No restrictions.'),
(2, '2024-06-02', 'Back strain', 'Massage therapy', 'Dr. Linda Ray', 'MedCare Center', 'Yes', FALSE, 'Can resume light training.'),
(3, '2024-06-03', 'Fractured finger', 'Casting', 'Dr. Mike Nolan', 'Elite Sports Hospital', 'No', TRUE, 'Needs 2-week rest.'),
(4, '2024-06-04', 'Muscle soreness', 'Ice packs and rest', 'Dr. Susan Grey', 'City Sports Med', 'Yes', FALSE, 'Cleared for participation.'),
(5, '2024-06-05', 'Mild concussion', 'Observation and rest', 'Dr. Allen Kim', 'NeuroCare Unit', 'Pending', TRUE, 'Review after 3 days.'),
(6, '2024-06-06', 'Torn ligament', 'Surgery scheduled', 'Dr. Nina Rao', 'OrthoMed Facility', 'No', TRUE, 'Will miss current season.'),
(7, '2024-06-07', 'Dehydration', 'IV fluids', 'Dr. Jason Wu', 'Olympic Clinic A', 'Yes', FALSE, 'Advised hydration protocol.'),
(8, '2024-06-08', 'Shin splints', 'Rest and taping', 'Dr. Karen Singh', 'Runner’s Relief Clinic', 'Yes', FALSE, 'No long runs for a week.'),
(9, '2024-06-09', 'Knee inflammation', 'Anti-inflammatory meds', 'Dr. Omar Patel', 'MedCare Center', 'Pending', TRUE, 'Re-evaluate in 48 hours.'),
(10, '2024-06-10', 'Shoulder pain', 'Physio and ultrasound', 'Dr. Lisa Chow', 'SportsWell Hospital', 'Yes', FALSE, 'No overhead activity.'),
(11, '2024-06-11', 'Fever and fatigue', 'Paracetamol', 'Dr. Ken Moses', 'Olympic Clinic B', 'Yes', FALSE, 'Monitor closely for 24 hours.'),
(12, '2024-06-12', 'Twisted wrist', 'Bandaging', 'Dr. Priya Malhotra', 'Elite Sports Hospital', 'Yes', FALSE, 'Allowed with wrist guard.'),
(13, '2024-06-13', 'Blisters on feet', 'Cleaning and dressing', 'Dr. Jo Tan', 'MedCare Center', 'Yes', FALSE, 'Wear padded socks.'),
(14, '2024-06-14', 'Lower back pain', 'Stretching and rest', 'Dr. Megan Hill', 'Olympic Clinic A', 'Yes', FALSE, 'Avoid weightlifting.'),
(15, '2024-06-15', 'Dislocated toe', 'Manual adjustment', 'Dr. Rishi Kumar', 'City Sports Med', 'Yes', FALSE, 'Tape toe during training.'),
(16, '2024-06-16', 'Skin rash', 'Topical ointment', 'Dr. Sara Noor', 'Sports Derm Care', 'Yes', FALSE, 'Keep area clean and dry.'),
(17, '2024-06-17', 'Tight hamstring', 'Stretching & massage', 'Dr. John Lee', 'PhysioFlex Clinic', 'Yes', FALSE, 'Daily warm-up routine.'),
(18, '2024-06-18', 'Nosebleed', 'Nasal cauterization', 'Dr. Tina Wong', 'Olympic Clinic A', 'Yes', FALSE, 'Avoid heavy pressure workouts.'),
(19, '2024-06-19', 'Wrist fracture', 'Plaster cast applied', 'Dr. Harish Pillai', 'Bone & Joint Clinic', 'No', TRUE, '6-week recovery expected.'),
(20, '2024-06-20', 'Chest pain', 'Cardiac tests ordered', 'Dr. Grace Nair', 'HeartCare Center', 'Pending', TRUE, 'Awaiting reports.');

SELECT * FROM medical_records;

-- Table 21: Training Sessions
CREATE TABLE training_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique ID
    athlete_id INT NOT NULL,                                -- Athlete participating (FK)
    coach_id INT NOT NULL,                                  -- Coach supervising (FK)
    sport_id INT NOT NULL,                                  -- Sport type (FK)
    session_date DATE,                                      -- Date of training
    start_time TIME,                                        -- Start time
    end_time TIME,                                          -- End time
    location VARCHAR(100),                                  -- Training location
    intensity_level ENUM('Low', 'Medium', 'High'),          -- Session intensity
    notes TEXT,                                             -- Additional notes
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id),
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id),
    FOREIGN KEY (sport_id) REFERENCES sports(sport_id)
);

INSERT INTO training_sessions (athlete_id, coach_id, sport_id, session_date,start_time, end_time, location, intensity_level, notes) 
VALUES
(1, 1, 1, '2024-07-10', '08:00:00', '09:30:00', 'Training Hall A', 'High', 'Focus on sprint speed.'),
(2, 2, 2, '2024-07-10', '09:00:00', '10:00:00', 'Swimming Pool 1', 'Medium', 'Improved lap times.'),
(3, 1, 1, '2024-07-11', '08:00:00', '09:15:00', 'Track B', 'High', 'Strength training.'),
(4, 3, 3, '2024-07-11', '07:30:00', '08:30:00', 'Gym Area C', 'Low', 'Recovery workout.'),
(5, 4, 4, '2024-07-12', '10:00:00', '11:00:00', 'Court 2', 'High', 'Footwork drills.'),
(6, 2, 2, '2024-07-12', '08:00:00', '09:00:00', 'Swimming Pool 1', 'Medium', 'Backstroke technique.'),
(7, 5, 5, '2024-07-13', '07:00:00', '08:00:00', 'Field A', 'High', 'Tactical session.'),
(8, 3, 3, '2024-07-13', '09:00:00', '10:00:00', 'Gym Area D', 'Low', 'Rehabilitation training.'),
(9, 4, 4, '2024-07-14', '10:00:00', '11:30:00', 'Court 3', 'Medium', 'Serve accuracy.'),
(10, 5, 5, '2024-07-14', '06:30:00', '07:30:00', 'Field A', 'High', 'Pre-match prep.'),
(1, 1, 1, '2024-07-15', '08:00:00', '09:30:00', 'Track A', 'Medium', 'Endurance run.'),
(2, 2, 2, '2024-07-15', '09:00:00', '10:00:00', 'Swimming Pool 2', 'High', 'Butterfly technique.'),
(3, 3, 3, '2024-07-16', '08:00:00', '09:00:00', 'Gym Area B', 'Low', 'Stretching and mobility.'),
(4, 4, 4, '2024-07-16', '07:30:00', '08:30:00', 'Court 1', 'Medium', 'Drill repetition.'),
(5, 5, 5, '2024-07-17', '10:00:00', '11:00:00', 'Field B', 'High', 'Game simulation.'),
(6, 1, 1, '2024-07-17', '07:30:00', '08:30:00', 'Track B', 'Medium', 'Speed training.'),
(7, 2, 2, '2024-07-18', '09:00:00', '10:00:00', 'Poolside Gym', 'Low', 'Core strengthening.'),
(8, 3, 3, '2024-07-18', '08:30:00', '09:30:00', 'Recovery Zone', 'Low', 'Massage and stretch.'),
(9, 4, 4, '2024-07-19', '10:00:00', '11:30:00', 'Court 4', 'High', 'Match practice.'),
(10, 5, 5, '2024-07-19', '06:00:00', '07:00:00', 'Field A', 'Medium', 'Tactical drills.');

SELECT * FROM training_sessions;

-- Table 22: Volunteers
CREATE TABLE volunteers (
    volunteer_id INT PRIMARY KEY AUTO_INCREMENT,        -- Unique volunteer ID
    full_name VARCHAR(100),                             -- Volunteer’s full name
    age INT,                                             -- Age of the volunteer
    gender ENUM('Male', 'Female', 'Other'),              -- Gender
    contact_number VARCHAR(15),                          -- Contact info
    email VARCHAR(100),                                  -- Email address
    assigned_area VARCHAR(100),                          -- Assigned location or area
    role_description VARCHAR(255),                       -- Description of the role
    shift_time ENUM('Morning', 'Afternoon', 'Evening'),  -- Shift assigned
    availability_days VARCHAR(100)                       -- Days available
);

INSERT INTO volunteers (full_name, age, gender, contact_number, email, assigned_area, role_description, shift_time, availability_days) 
VALUES
('Rahul Desai', 24, 'Male', '9123456789', 'rahul.desai@example.com', 'Stadium Gate 1', 'Visitor Guide', 'Morning', 'Mon, Wed, Fri'),
('Sara Khan', 28, 'Female', '9876543210', 'sara.khan@example.com', 'Media Center', 'Media Assistance', 'Afternoon', 'Tue, Thu'),
('David Lee', 30, 'Male', '9988776655', 'david.lee@example.com', 'Athlete Village', 'Logistics Support', 'Evening', 'Mon to Sat'),
('Meera Joshi', 22, 'Female', '9911223344', 'meera.joshi@example.com', 'Event Arena A', 'Seating Assistance', 'Morning', 'Weekends'),
('Alex Carter', 26, 'Other', '9001122334', 'alex.carter@example.com', 'Info Desk 2', 'Information Desk', 'Afternoon', 'All days'),
('Priya Nair', 25, 'Female', '9876540098', 'priya.nair@example.com', 'Training Hall', 'Equipment Handler', 'Morning', 'Mon, Wed, Fri'),
('John Mathew', 29, 'Male', '9823412341', 'john.mathew@example.com', 'Court 4', 'Crowd Control', 'Evening', 'Tue, Thu, Sat'),
('Lina Gomes', 23, 'Female', '9988123456', 'lina.gomes@example.com', 'Stadium Gate 2', 'Entry Check', 'Afternoon', 'Weekends'),
('Akash Shah', 21, 'Male', '9112233445', 'akash.shah@example.com', 'Medical Booth A', 'First Aid Support', 'Morning', 'Mon to Fri'),
('Emily Zhang', 27, 'Female', '9900112233', 'emily.zhang@example.com', 'Olympic Park', 'Event Coordination', 'Evening', 'Mon, Wed, Fri'),
('Harsh Mehta', 24, 'Male', '9090909090', 'harsh.mehta@example.com', 'Cafeteria Zone', 'Food Distribution', 'Afternoon', 'Tue, Thu'),
('Aisha Patel', 26, 'Female', '9123984756', 'aisha.patel@example.com', 'Gym Area', 'Athlete Support', 'Morning', 'Weekdays'),
('Tom Walker', 31, 'Male', '9009009001', 'tom.walker@example.com', 'Control Room', 'Tech Support', 'Evening', 'Mon to Sat'),
('Nina Dsouza', 22, 'Female', '9011223344', 'nina.dsouza@example.com', 'Court 1', 'Scoreboard Handling', 'Afternoon', 'Mon, Wed, Fri'),
('Ravi Kapoor', 28, 'Male', '9876123456', 'ravi.kapoor@example.com', 'Transport Bay', 'Transport Coordination', 'Morning', 'All days'),
('Zara Ali', 25, 'Female', '9098123456', 'zara.ali@example.com', 'Helpdesk Zone', 'General Assistance', 'Afternoon', 'Tue, Wed, Sat'),
('Mark Diaz', 29, 'Male', '9023456789', 'mark.diaz@example.com', 'Locker Room', 'Security Check', 'Evening', 'Weekends'),
('Sneha Rane', 27, 'Female', '9877001122', 'sneha.rane@example.com', 'Control Center', 'Reporting Assistant', 'Morning', 'Mon, Thu, Fri'),
('Omar Farouk', 30, 'Male', '9334455667', 'omar.farouk@example.com', 'Main Arena', 'Equipment Setup', 'Afternoon', 'All weekdays'),
('Elena Kaur', 24, 'Female', '9888776655', 'elena.kaur@example.com', 'Event Booth', 'Registration Help', 'Evening', 'Fri, Sat, Sun');

SELECT * FROM Volunteers;

-- Table 23: Security Staff
CREATE TABLE security_staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique staff ID
    full_name VARCHAR(100),                               -- Name of security staff
    age INT,                                               -- Age
    gender ENUM('Male', 'Female', 'Other'),                -- Gender
    contact_number VARCHAR(15),                            -- Contact info
    email VARCHAR(100),                                    -- Email address
    assigned_location VARCHAR(100),                        -- Area of assignment
    shift_time ENUM('Morning', 'Afternoon', 'Night'),      -- Assigned shift
    duty_type VARCHAR(100),                                -- Type of duty
    supervisor_name VARCHAR(100)                           -- Supervisor’s name
);

INSERT INTO security_staff (
    full_name, age, gender, contact_number, email,
    assigned_location, shift_time, duty_type, supervisor_name
) VALUES
('Rohan Kulkarni', 35, 'Male', '9123456780', 'rohan.kulkarni@example.com', 'Main Stadium', 'Morning', 'Crowd Management', 'Inspector Mehta'),
('Leena Thomas', 30, 'Female', '9876543219', 'leena.thomas@example.com', 'Athlete Village', 'Afternoon', 'Access Control', 'Inspector Mehta'),
('Siddharth Rao', 32, 'Male', '9988776654', 'siddharth.rao@example.com', 'Gate 3', 'Night', 'Patrolling', 'Supervisor Sharma'),
('Nikita Jain', 28, 'Female', '9011223344', 'nikita.jain@example.com', 'Media Center', 'Morning', 'Entry Check', 'Inspector Mehta'),
('Amit Solanki', 40, 'Male', '9001234567', 'amit.solanki@example.com', 'Training Area', 'Afternoon', 'Surveillance', 'Supervisor Sharma'),
('Karishma Naik', 27, 'Female', '9911223345', 'karishma.naik@example.com', 'Swimming Arena', 'Night', 'Gate Security', 'Inspector Mehta'),
('Vikram Sethi', 31, 'Male', '9022334455', 'vikram.sethi@example.com', 'Court 1', 'Morning', 'Player Escort', 'Supervisor Sharma'),
('Anjali Ghosh', 29, 'Female', '9887766554', 'anjali.ghosh@example.com', 'Event Entrance', 'Afternoon', 'Crowd Monitoring', 'Inspector Mehta'),
('Karan Oberoi', 34, 'Male', '9101234567', 'karan.oberoi@example.com', 'Media Booth', 'Night', 'Access Check', 'Supervisor Sharma'),
('Ritika Patil', 26, 'Female', '9090909090', 'ritika.patil@example.com', 'Locker Room', 'Morning', 'Equipment Security', 'Inspector Mehta'),
('Neeraj Malhotra', 33, 'Male', '9876543200', 'neeraj.malhotra@example.com', 'Court 3', 'Afternoon', 'Player Safety', 'Supervisor Sharma'),
('Smita Desai', 30, 'Female', '9112233445', 'smita.desai@example.com', 'Transport Bay', 'Night', 'Vehicle Check', 'Inspector Mehta'),
('Ashok Pillai', 36, 'Male', '9034567890', 'ashok.pillai@example.com', 'Control Room', 'Morning', 'Camera Monitor', 'Supervisor Sharma'),
('Tina D’Souza', 29, 'Female', '9009876543', 'tina.dsouza@example.com', 'VIP Entrance', 'Afternoon', 'VIP Escort', 'Inspector Mehta'),
('Zaid Shaikh', 37, 'Male', '9871112233', 'zaid.shaikh@example.com', 'Practice Area', 'Night', 'Night Patrol', 'Supervisor Sharma'),
('Alisha Mehra', 27, 'Female', '9123450098', 'alisha.mehra@example.com', 'Food Court', 'Morning', 'Queue Management', 'Inspector Mehta'),
('Deepak Verma', 38, 'Male', '9098123456', 'deepak.verma@example.com', 'Medical Zone', 'Afternoon', 'Access Control', 'Supervisor Sharma'),
('Snehal More', 31, 'Female', '9888776655', 'snehal.more@example.com', 'Olympic Park', 'Night', 'Gate Patrol', 'Inspector Mehta'),
('Yusuf Khan', 29, 'Male', '9112345678', 'yusuf.khan@example.com', 'Stadium Exit', 'Morning', 'Exit Scanning', 'Supervisor Sharma'),
('Preeti Rawal', 32, 'Female', '9011223345', 'preeti.rawal@example.com', 'Court 4', 'Afternoon', 'Player Escort', 'Inspector Mehta');

SELECT * FROM security_staff;

-- Table 24: Media Coverage
CREATE TABLE media_coverage (
    coverage_id INT PRIMARY KEY AUTO_INCREMENT,              -- Unique ID for media coverage
    media_house VARCHAR(100),                                -- Name of the media house
    reporter_name VARCHAR(100),                              -- Name of the reporter
    event_covered VARCHAR(100),                              -- Event being covered
    coverage_type ENUM('Live', 'Recorded', 'Written'),       -- Type of media coverage
    language VARCHAR(50),                                     -- Language of coverage
    country VARCHAR(100),                                     -- Country of origin
    coverage_date DATE,                                       -- Date of the coverage
    broadcast_channel VARCHAR(100),                           -- Channel or platform
    accreditation_id VARCHAR(50)                              -- Media accreditation reference
);

INSERT INTO media_coverage (media_house, reporter_name, event_covered, coverage_type, language, country, coverage_date, broadcast_channel, accreditation_id) 
VALUES
('BBC Sports', 'Oliver Smith', '100m Sprint', 'Live', 'English', 'UK', '2024-07-21', 'BBC One', 'ACC1001'),
('ESPN', 'Jessica Lee', 'Swimming Finals', 'Recorded', 'English', 'USA', '2024-07-22', 'ESPN2', 'ACC1002'),
('Zee Sports', 'Rohit Sharma', 'Hockey Match', 'Live', 'Hindi', 'India', '2024-07-20', 'Zee Sports HD', 'ACC1003'),
('NHK', 'Yuki Tanaka', 'Judo Finals', 'Written', 'Japanese', 'Japan', '2024-07-19', 'NHK Online', 'ACC1004'),
('Sky Sports', 'Emma Clark', 'Tennis Semi-Finals', 'Live', 'English', 'UK', '2024-07-23', 'Sky Sports 1', 'ACC1005'),
('Al Jazeera', 'Khalid Omar', 'Opening Ceremony', 'Live', 'Arabic', 'Qatar', '2024-07-18', 'Al Jazeera Sports', 'ACC1006'),
('Doordarshan', 'Meena Iyer', 'Archery Event', 'Recorded', 'Hindi', 'India', '2024-07-20', 'DD Sports', 'ACC1007'),
('RT France', 'Camille Dupont', 'Cycling Time Trial', 'Live', 'French', 'France', '2024-07-22', 'RT Info', 'ACC1008'),
('ABC News', 'Brian Walker', 'Gymnastics Finals', 'Written', 'English', 'Australia', '2024-07-21', 'ABC Online', 'ACC1009'),
('CCTV', 'Wei Liu', 'Table Tennis Finals', 'Live', 'Mandarin', 'China', '2024-07-19', 'CCTV-5', 'ACC1010'),
('NBC Sports', 'Samantha Green', 'Basketball Match', 'Live', 'English', 'USA', '2024-07-21', 'NBCSN', 'ACC1011'),
('ESPN Brazil', 'Carlos Silva', 'Football Match', 'Recorded', 'Portuguese', 'Brazil', '2024-07-20', 'ESPN BR', 'ACC1012'),
('KBS', 'Hyun Woo', 'Taekwondo Finals', 'Live', 'Korean', 'South Korea', '2024-07-22', 'KBS World', 'ACC1013'),
('RAI Sport', 'Giulia Conti', 'Fencing Event', 'Written', 'Italian', 'Italy', '2024-07-20', 'RAI Web', 'ACC1014'),
('NOS', 'Daan Visser', 'Rowing Finals', 'Recorded', 'Dutch', 'Netherlands', '2024-07-21', 'NOS Sport', 'ACC1015'),
('CBC', 'Laura Hill', 'Diving Event', 'Live', 'English', 'Canada', '2024-07-23', 'CBC Sports', 'ACC1016'),
('TRT Spor', 'Elif Demir', 'Wrestling Match', 'Live', 'Turkish', 'Turkey', '2024-07-21', 'TRT1', 'ACC1017'),
('NTV Kenya', 'James Otieno', 'Marathon', 'Recorded', 'Swahili', 'Kenya', '2024-07-22', 'NTV', 'ACC1018'),
('ARD', 'Lena Müller', 'Handball Match', 'Written', 'German', 'Germany', '2024-07-20', 'ARD Online', 'ACC1019'),
('TVE', 'Pablo Martín', 'Basketball Semi-Final', 'Live', 'Spanish', 'Spain', '2024-07-23', 'TVE Deportes', 'ACC1020');

SELECT * FROM media_coverage;

-- Table 25: Doping Tests
CREATE TABLE doping_tests (
    test_id INT PRIMARY KEY AUTO_INCREMENT,                -- Unique ID for each test
    athlete_id INT,                                        -- References athlete tested
    sport VARCHAR(100),                                    -- Sport the athlete is in
    test_date DATE,                                        -- Date of the test
    result ENUM('Negative', 'Positive'),                  -- Test result
    substance_found VARCHAR(100),                         -- Substance (if any)
    testing_agency VARCHAR(100),                          -- Agency conducting test
    sample_type ENUM('Urine', 'Blood'),                   -- Sample collected
    location VARCHAR(100),                                -- Where test was conducted
    remarks TEXT                                           -- Additional remarks
);

INSERT INTO doping_tests (athlete_id, sport, test_date, result, substance_found, testing_agency, sample_type, location, remarks) 
VALUES
(1, 'Weightlifting', '2024-07-20', 'Negative', '', 'WADA', 'Urine', 'Testing Center A', 'No banned substances detected.'),
(2, 'Athletics', '2024-07-21', 'Negative', '', 'WADA', 'Blood', 'Olympic Village', 'Routine check.'),
(3, 'Swimming', '2024-07-22', 'Positive', 'Anabolic Steroids', 'WADA', 'Urine', 'Venue B', 'Further investigation needed.'),
(4, 'Cycling', '2024-07-20', 'Negative', '', 'USADA', 'Blood', 'Testing Zone 1', 'Cleared for competition.'),
(5, 'Boxing', '2024-07-19', 'Negative', '', 'WADA', 'Urine', 'Medical Bay', 'All good.'),
(6, 'Wrestling', '2024-07-21', 'Positive', 'EPO', 'WADA', 'Blood', 'Testing Center C', 'Temporary suspension issued.'),
(7, 'Gymnastics', '2024-07-22', 'Negative', '', 'USADA', 'Urine', 'Olympic Arena', 'Clean result.'),
(8, 'Judo', '2024-07-20', 'Negative', '', 'NADA', 'Urine', 'Event Zone', 'No irregularities.'),
(9, 'Football', '2024-07-21', 'Negative', '', 'FIFA', 'Urine', 'Stadium Lab', 'Standard test.'),
(10, 'Tennis', '2024-07-19', 'Positive', 'Stimulants', 'WADA', 'Urine', 'Player Zone', 'Case reported to committee.'),
(11, 'Archery', '2024-07-22', 'Negative', '', 'WADA', 'Blood', 'Practice Zone', 'Routine sample collection.'),
(12, 'Taekwondo', '2024-07-20', 'Negative', '', 'WADA', 'Urine', 'Testing Center A', 'Clean result.'),
(13, 'Badminton', '2024-07-21', 'Negative', '', 'NADA', 'Blood', 'Court Lab', 'Approved to continue.'),
(14, 'Rowing', '2024-07-22', 'Negative', '', 'WADA', 'Urine', 'Dockside Lab', 'Cleared after check.'),
(15, 'Shooting', '2024-07-21', 'Negative', '', 'WADA', 'Blood', 'Event Control Room', 'All good.'),
(16, 'Fencing', '2024-07-20', 'Positive', 'Beta-2 Agonists', 'WADA', 'Urine', 'Testing Center B', 'Violation reported.'),
(17, 'Table Tennis', '2024-07-19', 'Negative', '', 'WADA', 'Urine', 'Olympic Village', 'Routine sample.'),
(18, 'Hockey', '2024-07-21', 'Negative', '', 'WADA', 'Blood', 'Field Testing Lab', 'Clean result.'),
(19, 'Diving', '2024-07-22', 'Negative', '', 'WADA', 'Urine', 'Swimming Arena', 'No banned substances.'),
(20, 'Skateboarding', '2024-07-20', 'Positive', 'THC', 'WADA', 'Urine', 'Extreme Park', 'Athlete warned.');

SELECT * FROM doping_tests;



