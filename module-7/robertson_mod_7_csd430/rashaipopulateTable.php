<?php
$servername = "localhost";
$username = "student1";
$password = "pass";
$dbname = "CSD430";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO rashaistatesdata
(state_name, abbreviation, capital, population, region)
VALUES
('Texas','TX','Austin',30503301,'South'),
('Pennsylvania','PA','Harrisburg',12961683,'Northeast'),
('California','CA','Sacramento',38965193,'West'),
('Florida','FL','Tallahassee',22610726,'South'),
('New York','NY','Albany',19571216,'Northeast'),
('Illinois','IL','Springfield',12549689,'Midwest'),
('Ohio','OH','Columbus',11785935,'Midwest'),
('Georgia','GA','Atlanta',11029227,'South'),
('Arizona','AZ','Phoenix',7431344,'West'),
('Nevada','NV','Carson City',3194176,'West')";

if ($conn->query($sql) === TRUE) {
    echo "Records inserted successfully.";
} else {
    echo "Error inserting records: " . $conn->error;
}

$conn->close();
?>