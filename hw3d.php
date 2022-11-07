<head>
  <title>Course Scores</title>
</head>
<body>

<?php
$dbhost = 'dbase.cs.jhu.edu';
$dbuser = 'YOUR_SQL_USERNAME';
$dbpass = 'YOUR_SQL_PASSWORD';
$dbname = 'YOUR_SQL_DATABASE';
$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
if (mysqli_connect_errno()) {
    printf("Connect failed: %s<br>", mysqli_connect_error());
    exit();
}
$pword = $_GET["pword"];
if ($mysqli->multi_query("CALL AllPercentages('".$pword."');")) {
    printf("LName | FName | Section | HW1 | HW2a | HW2b | Midterm | HW3 | FExam | Weighted Average<br>");
    printf("---------------------------------------------------------------------------------------------------------------------<br>");
    do {
        if ($result = $mysqli->store_result()) {
            while ($row = $result->fetch_row()) {
                if (count($row) == 1) {
                    printf("%s", $row[0]);
                } else {
                    printf("%s | %s | %s | %s | %s | %s | %s | %s | %s | %s<br>", $row[0], $row[1], $row[2], $row[3], $row[4], $row[5], $row[6], $row[7], $row[8], $row[9]);
                }
            }
            $result->close();
        }
    } while ($mysqli->next_result());
} else {
    printf("<br>Error: %s\n", $mysqli->error);
}
?>
</body>