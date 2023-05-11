USE CritterCrushDB;

LOAD DATA INFILE "SampleData/crittercrush_users.csv" INTO TABLE Users FIELDS TERMINATED BY "," LINES TERMINATED BY "|";
LOAD DATA INFILE "SampleData/crittercrush_reports.csv" INTO TABLE Reports FIELDS TERMINATED BY "," LINES TERMINATED BY "|" IGNORE 1 LINES (longitude,latitude,speciesID,userID,numberSpecimens,reportDate,image);
UPDATE Reports SET ScoreValid = True;