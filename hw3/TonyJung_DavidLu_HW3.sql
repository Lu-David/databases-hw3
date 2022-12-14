CREATE VIEW TotPoints AS
    SELECT *
    FROM Rawscores
    WHERE SSN="0001";

CREATE VIEW Weights AS
    SELECT *
    FROM Rawscores
    WHERE SSN="0002";

CREATE VIEW WtdPts AS
    SELECT (1/Totpts.HW1)*Weight.HW1 HW1, (1/Totpts.HW2a)*Weight.HW2a HW2a, (1/Totpts.HW2b)*Weight.HW2b HW2b, (1/Totpts.Midterm)*Weight.Midterm Midterm, (1/Totpts.HW3)*Weight.HW3 HW3, (1/Totpts.FExam)*Weight.FExam FExam
    FROM Totpts, Weight;
    
-- a) Print a single student’s raw scores:
DROP PROCEDURE IF EXISTS ShowRawScores;
DELIMITER |
CREATE PROCEDURE ShowRawScores (IN SSN VARCHAR(4))
    BEGIN
        DECLARE rowSSN VARCHAR(4);

        DECLARE get_student CURSOR FOR
            SELECT Rawscores.SSN
            FROM Rawscores
            WHERE Rawscores.SSN=SSN;

        DECLARE EXIT HANDLER FOR NOT FOUND
        SELECT 'STUDENT NOT FOUND' AS 'Error Message';

        OPEN get_student;
        FETCH get_student INTO rowSSN;
        CLOSE get_student;

        SELECT *
        FROM Rawscores
        WHERE Rawscores.SSN=SSN;
    END;
|
DELIMITER ;

--(b) Print a single student’s percentage scores and weighted average:
DROP PROCEDURE IF EXISTS ShowPercentages;
DELIMITER |
CREATE PROCEDURE ShowPercentages (IN SSN VARCHAR(4))
    BEGIN
        DECLARE rowSSN VARCHAR(4);

        DECLARE get_student CURSOR FOR
            SELECT Rawscores.SSN
            FROM Rawscores
            WHERE Rawscores.SSN=SSN;

        DECLARE EXIT HANDLER FOR NOT FOUND
        SELECT 'STUDENT NOT FOUND' AS 'Error Message';

        OPEN get_student;
        FETCH get_student INTO rowSSN;
        CLOSE get_student;

        SELECT CONCAT((Rawscores.HW1/Totpts.HW1)*100, '%') HW1, CONCAT((Rawscores.HW2a/Totpts.HW2a)*100, '%') HW2a, CONCAT((Rawscores.HW2b/Totpts.HW2b)*100, '%') HW2b, CONCAT((Rawscores.Midterm/Totpts.Midterm)*100,'%') Midterm, CONCAT((Rawscores.HW3/Totpts.HW3)*100, '%') HW3, CONCAT((Rawscores.FExam/Totpts.FExam)*100,'%') FExam
        FROM Rawscores, Totpts
        WHERE Rawscores.SSN=SSN;

        SELECT CONCAT('The cumulative course average for ', Rawscores.FName, ' ', Rawscores.LName, ' ',  'is ', (Rawscores.HW1*WtdPts.HW1+Rawscores.HW2a*WtdPts.HW2a+Rawscores.HW2b*WtdPts.HW2b+Rawscores.Midterm*WtdPts.Midterm+Rawscores.HW3*WtdPts.HW3+Rawscores.FExam*WtdPts.FExam)) Weighted_average
        FROM Rawscores, WtdPts
        WHERE Rawscores.SSN=SSN;
    END;
|
DELIMITER ;

--(c) Print a full table of the raw class scores
DROP PROCEDURE IF EXISTS AllRawScores;
DELIMITER |
CREATE PROCEDURE AllRawScores(IN password VARCHAR(4000))
    BEGIN
        DECLARE rowPassword VARCHAR(4000);

        DECLARE get_password CURSOR FOR
            SELECT CurPasswords
            FROM Passwords
            WHERE CurPasswords=password;

        DECLARE EXIT HANDLER FOR NOT FOUND
        SELECT 'INVALID PASSWORD' AS 'Error Message';

        OPEN get_password;
        FETCH get_password INTO rowPassword;
        CLOSE get_password;

        SELECT *
        FROM Rawscores
        WHERE Rawscores.SSN != "0001" AND Rawscores.SSN != "0002"
        ORDER BY Rawscores.Section, Rawscores.LName, Rawscores.FName;
    END;
|
DELIMITER ;

--(d) Print a full table of the percentage scores and weighted total
DROP PROCEDURE IF EXISTS AllPercentages;
DELIMITER |
CREATE PROCEDURE AllPercentages(IN password VARCHAR(4000))
    BEGIN
        DECLARE rowPassword VARCHAR(4000);

        DECLARE get_password CURSOR FOR
            SELECT CurPasswords
            FROM Passwords
            WHERE CurPasswords=password;

        DECLARE EXIT HANDLER FOR NOT FOUND
        SELECT 'INVALID PASSWORD' AS 'Error Message';

        OPEN get_password;
        FETCH get_password INTO rowPassword;
        CLOSE get_password;

        SELECT Rawscores.LName, Rawscores.FName, Rawscores.Section, CONCAT((Rawscores.HW1/Totpts.HW1)*100, '%') HW1, CONCAT((Rawscores.HW2a/Totpts.HW2a)*100, '%') HW2a, CONCAT((Rawscores.HW2b/Totpts.HW2b)*100, '%') HW2b, CONCAT((Rawscores.Midterm/Totpts.Midterm)*100,'%') Midterm, CONCAT((Rawscores.HW3/Totpts.HW3)*100, '%') HW3, CONCAT((Rawscores.FExam/Totpts.FExam)*100,'%') FExam, cum_avg.Weighted_average
        FROM Rawscores, Totpts, (SELECT Rawscores.SSN, CONCAT('The cumulative course average for ', Rawscores.FName, ' ', Rawscores.LName, ' ',  'is ', (Rawscores.HW1*WtdPts.HW1+Rawscores.HW2a*WtdPts.HW2a+Rawscores.HW2b*WtdPts.HW2b+Rawscores.Midterm*WtdPts.Midterm+Rawscores.HW3*WtdPts.HW3+Rawscores.FExam*WtdPts.FExam)) Weighted_average
                                FROM Rawscores, WtdPts
                                WHERE Rawscores.SSN=SSN) cum_avg 
        WHERE Rawscores.SSN!="0001" AND Rawscores.SSN!="0002" AND Rawscores.SSN=cum_avg.SSN
        ORDER BY Rawscores.Section, cum_avg.Weighted_average;
    END;
|
DELIMITER ;
