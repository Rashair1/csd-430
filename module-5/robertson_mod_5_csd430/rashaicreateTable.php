<?php
$servername = "localhost";
$username = "student1";
$password = "pass";
$dbname = "CSD430";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "CREATE TABLE IF NOT EXISTS rashaistatesdata (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(2) NOT NULL,
    capital VARCHAR(50) NOT NULL,
    population INT NOT NULL,
    region VARCHAR(50) NOT NULL
)";

if ($conn->query($sql) === TRUE) {
    echo "Table created successfully.";
} else {
    echo "Error creating table: " . $conn->error;
}

$conn->close();
?>