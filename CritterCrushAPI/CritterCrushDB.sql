CREATE DATABASE CritterCrushDB;

USE CritterCrushDB;

SET sql_mode='NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE Users(
	UserID INT NOT NULL AUTO_INCREMENT,
    UserName VARCHAR(20) NOT NULL,
    Pass VARCHAR(256),
    Email VARCHAR(100),
	PRIMARY KEY (UserID)
);

CREATE TABLE Reports(
	ReportID INT NOT NULL AUTO_INCREMENT,
    ReportDate datetime,
    UserID int,
    SpeciesID int,
	NumberSpecimens int,
	Latitude double,
	Longitude double,
	Image varchar(256),
    ScoreValid bool,
    PRIMARY KEY (ReportID)
);

CREATE TABLE AuthTokens(
	AuthTokenID INT NOT NULL AUTO_INCREMENT,
	UserID INT,
	Token varchar(256),
	IssuedOn datetime,
	IsValid bool,
	PRIMARY KEY (AuthTokenID)
);

CREATE TABLE ImageRecTokens(
	ImageRecTokenID INT NOT NULL AUTO_INCREMENT,
    Token varchar(16),
    SpeciesID int,
    NumberSpecimens int,
    PRIMARY KEY (ImageRecTokenID)
);

ALTER TABLE Reports ADD CONSTRAINT FK_Reports_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID);
ALTER TABLE AuthTokens ADD CONSTRAINT FK_AuthTokens_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID);

#UserID 0 = deleted user for reports
INSERT INTO Users VALUES (0, "Invalid User", "", "");