USE CritterCrushDB;

CREATE TABLE Users(
	UserID INT NOT NULL AUTO_INCREMENT,
    UserName VARCHAR(20) NOT NULL,
    Pass VARCHAR(100),
    Email VARCHAR(100),
	PRIMARY KEY (UserID)
);

CREATE TABLE Reports(
	ReportID INT NOT NULL AUTO_INCREMENT,
    ReportDate datetime,
    UserID int,
    Species VARCHAR(100),
    PRIMARY KEY (ReportID)
);

ALTER TABLE Reports ADD CONSTRAINT FK_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID);