CREATE TABLE Flights (
  Flight varchar(50),
  Destination VARCHAR(50) NOT NULL,
  Departs TIME NOT NULL,
  Days VARCHAR(50) NOT NULL,
  PRIMARY KEY (Flight)
);

CREATE TABLE Diary (
  Name VARCHAR(50) NOT NULL,
  Day DATE NOT NULL,
  Flight VARCHAR(50) ,
  foreign key (Flight) references Flights(Flight),
  Status VARCHAR(50) NULL,
);

INSERT INTO Flights 
VALUES
('GR123', 'THU', '7:55', '1-4--'),
('YL011', 'ATL', '8:10', '12345-7'),
('BX201', 'SLA', '9:20', '1-3-5-'),
('FL9700', 'SLA', '14:00', '-2-4-6-'),
('GR127', 'THU', '14:55', '-2-5-');

INSERT INTO Diary (Name, Day, Flight, Status)
VALUES
('Alice', '2023-11-07', 'GR123', 'private'),
('Bob', '2023-11-08', 'YL011', 'business'),
('Bob', '2023-11-09', 'BX201', NULL),
('Carol', '2023-11-10', 'BX201', 'business'),
('Alice', '2023-11-11', 'GR127', 'business');


delete  from Flights
delete  from Diary

select * from Flights
select * from Diary

SELECT Name, Status
FROM Diary
WHERE Day = '2023-11-07'

UPDATE Diary
	SET Status = 'private'
	WHERE Day = '2023-11-11'
select * from Diary

DELETE FROM Diary
WHERE Name = 'Alice'
select * from Diary

INSERT INTO Flights (Flight,Destination,Departs,Days)
VALUES ('GR005', 'GOH','14:00', '12-45–')
select * from Flights


-- Create user 'Art' with a password
CREATE LOGIN Art WITH PASSWORD = '123456789';

-- Create a user in the database mapped to the login
CREATE USER Art FOR LOGIN Art;






-- Grant SELECT and UPDATE permissions on Diary table to 'Art'
GRANT SELECT, UPDATE ON Diary(Day, Flight) TO Art;

-- View access permissions for user 'Art' in the current database
EXEC sp_helprotect @username = 'Art';

REVOKE UPDATE
ON Diary
FROM Art

EXEC sp_helprotect @username = 'Art';


-- CREATE VIEW Flights_at_CONFIDENTIAL AS
-- Create a view named Flights_at_CONFIDENTIAL
CREATE VIEW Flights_at_CONFIDENTIAL AS

-- SELECT D.*
-- Select all columns from the Diary table (aliased as D)
SELECT D.*

-- FROM Diary D
-- From the Diary table, aliased as D for use in the query
FROM Diary D

-- JOIN Flights F ON D.Flight = F.Flight
-- Join data from the Flights table (aliased as F) with the Diary table
-- The data is joined based on the condition that the Flight column in both tables is the same
JOIN Flights F ON D.Flight = F.Flight

-- WHERE F.Destination = 'THU' AND D.Status = 'business';
-- Filter the data: include only rows where Destination from the Flights table is 'THU'
-- and Status from the Diary table is 'business'
WHERE F.Destination = 'THU' AND D.Status = 'business';

SELECT *
FROM Flights_at_CONFIDENTIAL;

-- Create a Students table
CREATE TABLE Students (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Sex VARCHAR(10) NOT NULL,
    Programme VARCHAR(50) NOT NULL,
    Units INT NOT NULL,
    GradeAve FLOAT NOT NULL
);

-- Insert data
INSERT INTO Students (Name, Sex, Programme, Units, GradeAve)
VALUES
('Alma', 'F', 'MBA', 8, 63),
('Bil', 'M', 'CS', 15, 58),
('Carol', 'F', 'CS', 16, 70),
('Don', 'M', 'MIS', 22, 75),
('Errol', 'M', 'CS', 8, 66),
('Flora', 'F', 'MIS', 16, 81),
('Gala', 'F', 'MBA', 23, 68),
('Homer', 'M', 'CS', 7, 50),
('Igor', 'M', 'MIS', 21, 70)

Select * from students

SELECT AVG(GradeAve)
FROM Students
WHERE Programme = 'MBA'

--Q1
SELECT COUNT(*)
FROM Students
WHERE Sex = 'F' AND Programme = 'CS'

--Q2
SELECT AVG(GradeAve)
FROM Students
WHERE Sex = 'F' AND Programme = 'CS'

--Q3
SELECT COUNT(*)
FROM Students
WHERE Programme = 'CS'

--Q4
SELECT COUNT(*)
FROM Students
WHERE Programme = 'CS' AND Sex = 'M'

--Q5
SELECT AVG(GradeAve)
FROM Students
WHERE Programme = 'CS'

--Q6
SELECT AVG(GradeAve)
FROM Students
WHERE Programme = 'CS' AND Sex = 'M'

--Q7
SELECT SUM(Units)
FROM Students
WHERE Name = 'Carol' OR Programme = 'MIS'

--Q8
SELECT SUM(Units)
FROM Students
WHERE Name = 'Carol' OR NOT (Programme = 'MIS')

--Q9
SELECT SUM(Units)
FROM Students

--DEMO DATA MASKING
-- Create a dynamic data mask
-- schema to contain user tables
CREATE SCHEMA Data;
GO

-- table with masked columns
CREATE TABLE Data.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL
);

-- inserting sample data
INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40);
GO

-- Create user

CREATE USER MaskingTestUser WITHOUT LOGIN;

GRANT SELECT ON SCHEMA::Data TO MaskingTestUser;
  
-- impersonate for testing:
EXECUTE AS USER = 'MaskingTestUser';

SELECT * FROM Data.Membership;

REVERT;

--Add or editing a mask on an existing column

ALTER TABLE Data.Membership
ALTER COLUMN LastName ADD MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)');

ALTER TABLE Data.Membership
ALTER COLUMN LastName VARCHAR(100) MASKED WITH (FUNCTION = 'default()');

--Granting the UNMASK permission allows MaskingTestUser to see the data unmasked.

GRANT UNMASK TO MaskingTestUser;

EXECUTE AS USER = 'MaskingTestUser';

SELECT * FROM Data.Membership;

REVERT;
  
-- Removing the UNMASK permission
REVOKE UNMASK TO MaskingTestUser;

--Drop a dynamic data mask
ALTER TABLE Data.Membership
ALTER COLUMN LastName DROP MASKED;

--Granular permission examples
--Create schema to contain user tables:
CREATE SCHEMA Data;
GO

--Create table with masked columns:
CREATE TABLE Data.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL,
    BirthDay DATETIME MASKED WITH (FUNCTION = 'default()') NULL
);

--insert data
INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode, BirthDay)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10, '1985-01-25 03:25:05'),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5, '1990-05-14 11:30:00'),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50, '2004-02-29 14:20:10'),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40, '1990-03-01 06:00:00');

--Create schema to contain service tables:
CREATE SCHEMA Service;
GO

--Create service table with masked columns:
CREATE TABLE Service.Feedback (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    Feedback VARCHAR(100) MASKED WITH (FUNCTION = 'default()') NULL,
    Rating INT MASKED WITH (FUNCTION = 'default()'),
    Received_On DATETIME
    );

--Insert sample data:
INSERT INTO Service.Feedback(Feedback, Rating, Received_On)
VALUES
('Good', 4, '2022-01-25 11:25:05'),
('Excellent', 5, '2021-12-22 08:10:07'),
('Average', 3, '2021-09-15 09:00:00');

--Create different users in the database:
CREATE USER ServiceAttendant WITHOUT LOGIN;
GO

CREATE USER ServiceLead WITHOUT LOGIN;
GO

CREATE USER ServiceManager WITHOUT LOGIN;
GO

CREATE USER ServiceHead WITHOUT LOGIN;
GO

--Grant read permissions to the users in the database:
ALTER ROLE db_datareader ADD MEMBER ServiceAttendant;

ALTER ROLE db_datareader ADD MEMBER ServiceLead;

ALTER ROLE db_datareader ADD MEMBER ServiceManager;

ALTER ROLE db_datareader ADD MEMBER ServiceHead;

--Grant different UNMASK permissions to users:
--Grant column level UNMASK permission to ServiceAttendant
GRANT UNMASK ON Data.Membership(FirstName) TO ServiceAttendant;

-- Grant table level UNMASK permission to ServiceLead
GRANT UNMASK ON Data.Membership TO ServiceLead;

-- Grant schema level UNMASK permission to ServiceManager
GRANT UNMASK ON SCHEMA::Data TO ServiceManager;
GRANT UNMASK ON SCHEMA::Service TO ServiceManager;

--Grant database level UNMASK permission to ServiceHead;
GRANT UNMASK TO ServiceHead;

--Query the data under the context of user ServiceAttendant:
EXECUTE AS USER = 'ServiceAttendant';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data.Membership;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;

--Query the data under the context of user ServiceLead:
EXECUTE AS USER = 'ServiceLead';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data.Membership;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;
