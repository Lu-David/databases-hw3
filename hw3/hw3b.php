<head>
  <title>Student's Raw Score</title>
</head>
<body>

<?php
$dbhost = 'dbase.cs.jhu.edu';
$dbuser = 'YOUR_SQL_USERNAME';
$dbpass = 'YOUR_SQL_PASSWORD';
$dbname = 'YOUR_DATABASE';
$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
if (mysqli_connect_errno()) {
    printf("Connect failed: %s<br>", mysqli_connect_error());
    exit();
}
$ssn = $_GET["ssn"];
if ($mysqli->multi_query("CALL ShowRawScores('".$ssn."');")) {
    if ($result = $mysqli->store_result()) {
        $row = $result->fetch_row();
        if (count($row) == 1) {
            printf("%s", $row[0]);
        } else {
            printf("Name: %s %s<br>", $row[1], $row[2]);
            printf("Section: %s<br>", $row[3]);
            printf("HW1: %s<br>", $row[4]);
            printf("HW2a: %s<br>", $row[5]);
            printf("HW2b: %s<br>", $row[6]);
            printf("Midterm: %s<br>", $row[7]);
            printf("HW3 %s<br>", $row[8]);
            printf("FExam: %s<br>", $row[9]);
            $mysqli->next_result();
            $result = $mysqli->store_result();
            $row = $result->fetch_row();
        }
        $result->close();
    }
} else {
    printf("<br>Error: %s\n", $mysqli->error);
}
?>
</body>
