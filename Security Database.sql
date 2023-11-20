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