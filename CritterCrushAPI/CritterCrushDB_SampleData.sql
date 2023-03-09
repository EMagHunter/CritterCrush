USE CritterCrushDB;

INSERT INTO Users (UserName, Pass, Email) VALUES ("EMagHunter", "not a valid password hash", "elyas.maggouh70@myhunter.cuny.edu");
INSERT INTO Reports (ReportDate, UserID, SpeciesID, NumberSpecimens, Latitude, Longitude, VerifyTrueCount, VerifyFalseCount) VALUES (current_timestamp, 1, 1, 1, 0, 0, 0, 0);
