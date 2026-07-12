CREATE DATABASE IF NOT EXISTS CSD430;
USE CSD430;

CREATE USER IF NOT EXISTS 'student1'@'localhost' IDENTIFIED BY 'pass';
GRANT ALL PRIVILEGES ON CSD430.* TO 'student1'@'localhost';
FLUSH PRIVILEGES;

DROP TABLE IF EXISTS rashaistatesdata;

CREATE TABLE rashaistatesdata (
    state_id INT PRIMARY KEY AUTO_INCREMENT,
    state_name VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(2) NOT NULL,
    capital VARCHAR(50) NOT NULL,
    population INT NOT NULL,
    region VARCHAR(50) NOT NULL
);

INSERT INTO rashaistatesdata
(state_name, abbreviation, capital, population, region)
VALUES
('Texas', 'TX', 'Austin', 30503301, 'South'),
('Pennsylvania', 'PA', 'Harrisburg', 12961683, 'Northeast'),
('California', 'CA', 'Sacramento', 38965193, 'West'),
('Florida', 'FL', 'Tallahassee', 22610726, 'South'),
('New York', 'NY', 'Albany', 19571216, 'Northeast'),
('Illinois', 'IL', 'Springfield', 12549689, 'Midwest'),
('Ohio', 'OH', 'Columbus', 11785935, 'Midwest'),
('Georgia', 'GA', 'Atlanta', 11029227, 'South'),
('Arizona', 'AZ', 'Phoenix', 7431344, 'West'),
('Nevada', 'NV', 'Carson City', 3194176, 'West');

SELECT * FROM rashaistatesdata;