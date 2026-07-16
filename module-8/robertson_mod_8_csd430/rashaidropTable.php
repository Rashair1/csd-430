<?php
$servername = "localhost";
$username = "student1";
$password = "pass";
$dbname = "CSD430";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "DROP TABLE IF EXISTS rashaistatesdata";

if ($conn->query($sql) === TRUE) {
    echo "Table dropped successfully.";
} else {
    echo "Error dropping table: " . $conn->error;
}

$conn->close();
?>