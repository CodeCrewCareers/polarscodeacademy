-- ============================================================
-- Saleshorse Database
-- ============================================================

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE
);

INSERT INTO users (name, email)
VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com'),
    ('Diana', 'diana@example.com'),
    ('Eve', 'eve@example.com');

-- Accounts table (similar to Salesforce Accounts)
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150),
    industry VARCHAR(100),
    owner_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO accounts (name, industry, owner_id)
VALUES
    ('Acme Corp', 'Manufacturing', 1),
    ('Globex Inc', 'Technology', 2),
    ('Soylent Co', 'Food & Beverage', 3),
    ('Initech', 'Software', 4),
    ('Umbrella Corp', 'Pharmaceuticals', 5);

-- Contacts table (similar to Salesforce Contacts)
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    account_id INT,
    owner_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO contacts (first_name, last_name, email, account_id, owner_id)
VALUES
    ('John', 'Doe', 'john.doe@example.com', 1, 1),
    ('Jane', 'Smith', 'jane.smith@example.com', 2, 2),
    ('Mike', 'Johnson', 'mike.johnson@example.com', 3, 3),
    ('Sara', 'Connor', 'sara.connor@example.com', 4, 4),
    ('Tom', 'Brown', 'tom.brown@example.com', 5, 5);

-- Opportunities table (Sales deals)
CREATE TABLE opportunities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150),
    amount DECIMAL(12, 2),
    stage VARCHAR(50),
    account_id INT,
    owner_id INT,
    close_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO opportunities (name, amount, stage, account_id, owner_id, close_date)
VALUES
    ('Acme Deal 1', 50000, 'Prospecting', 1, 1, '2025-12-31'),
    ('Globex Project X', 120000, 'Negotiation', 2, 2, '2025-11-30'),
    ('Soylent Supply Contract', 75000, 'Closed Won', 3, 3, '2025-10-15'),
    ('Initech Software Upgrade', 90000, 'Proposal', 4, 4, '2025-12-15'),
    ('Umbrella Research Funding', 200000, 'Qualification', 5, 5, '2026-01-20');

-- Tasks table (Sales activities)
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(150),
    status VARCHAR(50),
    priority VARCHAR(50),
    due_date DATE,
    owner_id INT,
    related_opportunity_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (related_opportunity_id) REFERENCES opportunities(id)
);

INSERT INTO tasks (subject, status, priority, due_date, owner_id, related_opportunity_id)
VALUES
    ('Follow up with John Doe', 'Not Started', 'High', '2025-11-20', 1, 1),
    ('Prepare Globex proposal', 'In Progress', 'Medium', '2025-11-25', 2, 2),
    ('Call Mike about contract', 'Completed', 'High', '2025-11-10', 3, 3),
    ('Schedule demo with Sara', 'Not Started', 'High', '2025-11-22', 4, 4),
    ('Send Umbrella funding docs', 'In Progress', 'Medium', '2025-11-30', 5, 5);

-- ============================================================
-- PayBuddy Database
-- ============================================================
CREATE DATABASE IF NOT EXISTS paybuddy;
USE paybuddy;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Accounts Table (each user has an account)
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0.00,
    currency CHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Transaction Status Lookup Table
CREATE TABLE transaction_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO transaction_statuses (status_name) VALUES
('Pending'),
('Completed'),
('Failed'),
('Cancelled');

-- Transactions Table
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_account_id INT NOT NULL,
    receiver_account_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    status_id INT NOT NULL,
    initiated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cleared_at TIMESTAMP NULL,
    FOREIGN KEY (sender_account_id) REFERENCES accounts(id),
    FOREIGN KEY (receiver_account_id) REFERENCES accounts(id),
    FOREIGN KEY (status_id) REFERENCES transaction_statuses(id)
);

-- Example Users
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

-- Example Accounts
INSERT INTO accounts (user_id, balance) VALUES
(1, 500.00),
(2, 300.00);

-- Example Transaction (Pending)
INSERT INTO transactions (sender_account_id, receiver_account_id, amount, status_id) VALUES
(1, 2, 50.00, 1);

-- ============================================================
-- Healthcare Database
-- ============================================================

CREATE DATABASE IF NOT EXISTS healthcare;
USE healthcare;

CREATE TABLE Facilities (
    FacilityID INT AUTO_INCREMENT PRIMARY KEY,
    FacilityName VARCHAR(100),
    FacilityType VARCHAR(50),
    City VARCHAR(50),
    StateCode CHAR(2)
);

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    City VARCHAR(50),
    StateCode CHAR(2),
    InsuranceProvider VARCHAR(50)
);

CREATE TABLE Providers (
    ProviderID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    FacilityID INT,
    HireDate DATE,
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Encounters (
    EncounterID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    ProviderID INT,
    FacilityID INT,
    EncounterDate DATETIME,
    EncounterType VARCHAR(25),
    DiagnosisCode VARCHAR(10),
    EncounterStatus VARCHAR(25),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES Providers(ProviderID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Claims (
    ClaimID INT AUTO_INCREMENT PRIMARY KEY,
    EncounterID INT,
    TotalAmount DECIMAL(10,2),
    InsurancePaid DECIMAL(10,2),
    PatientPaid DECIMAL(10,2),
    ClaimStatus VARCHAR(25),
    FOREIGN KEY (EncounterID) REFERENCES Encounters(EncounterID)
);

-- Lookup temp tables
CREATE TEMPORARY TABLE _FirstNames (id INT AUTO_INCREMENT PRIMARY KEY, Name VARCHAR(50));
INSERT INTO _FirstNames (Name) VALUES
('James'),('Mary'),('Robert'),('Patricia'),('John'),('Jennifer'),
('Michael'),('Linda'),('David'),('Elizabeth'),('William'),('Barbara'),
('Richard'),('Susan'),('Joseph'),('Jessica'),('Thomas'),('Sarah');

CREATE TEMPORARY TABLE _LastNames (id INT AUTO_INCREMENT PRIMARY KEY, Name VARCHAR(50));
INSERT INTO _LastNames (Name) VALUES
('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),
('Garcia'),('Miller'),('Davis'),('Rodriguez'),('Martinez'),
('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson');

CREATE TEMPORARY TABLE _Cities (id INT AUTO_INCREMENT PRIMARY KEY, City VARCHAR(50), StateCode CHAR(2));
INSERT INTO _Cities (City, StateCode) VALUES
('New York','NY'),('Los Angeles','CA'),('Chicago','IL'),('Houston','TX'),('Phoenix','AZ'),('Philadelphia','PA'),
('San Antonio','TX'),('San Diego','CA'),('Dallas','TX'),('San Jose','CA'),('Austin','TX'),('Jacksonville','FL'),
('Columbus','OH'),('Charlotte','NC'),('Denver','CO');

-- Numbers helper table (10,000 rows)
CREATE TEMPORARY TABLE _Numbers AS
SELECT (a.n + b.n * 10 + c.n * 100 + d.n * 1000) + 1 AS n
FROM
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
    CROSS JOIN
    (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d;

-- Facilities (15, one per city)
INSERT INTO Facilities (FacilityName, FacilityType, City, StateCode)
SELECT
    CONCAT('Medical Center ', id),
    ELT(FLOOR(RAND() * 3) + 1, 'Hospital', 'Clinic', 'Urgent Care'),
    City,
    StateCode
FROM _Cities;

-- Patients (5,000)
INSERT INTO Patients (FirstName, LastName, DOB, Gender, City, StateCode, InsuranceProvider)
SELECT
    fn.Name,
    ln.Name,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30000) DAY),
    ELT(FLOOR(RAND() * 3) + 1, 'Male', 'Female', 'Other'),
    c.City,
    c.StateCode,
    ELT(FLOOR(RAND() * 5) + 1, 'Aetna', 'BlueCross', 'United', 'Cigna', NULL)
FROM _Numbers
JOIN LATERAL (SELECT Name FROM _FirstNames ORDER BY RAND() LIMIT 1) fn ON TRUE
JOIN LATERAL (SELECT Name FROM _LastNames ORDER BY RAND() LIMIT 1) ln ON TRUE
JOIN LATERAL (SELECT City, StateCode FROM _Cities ORDER BY RAND() LIMIT 1) c ON TRUE
LIMIT 5000;

-- Providers (200)
INSERT INTO Providers (FirstName, LastName, Specialty, FacilityID, HireDate)
SELECT
    fn.Name,
    ln.Name,
    ELT(FLOOR(RAND() * 6) + 1, 'Primary Care', 'Cardiology', 'Orthopedics', 'Pediatrics', 'Neurology', 'Dermatology'),
    FLOOR(RAND() * 15) + 1,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 5000) DAY)
FROM _Numbers
JOIN LATERAL (SELECT Name FROM _FirstNames ORDER BY RAND() LIMIT 1) fn ON TRUE
JOIN LATERAL (SELECT Name FROM _LastNames ORDER BY RAND() LIMIT 1) ln ON TRUE
LIMIT 200;

-- Encounters (20,000)
INSERT INTO Encounters (PatientID, ProviderID, FacilityID, EncounterDate, EncounterType, DiagnosisCode, EncounterStatus)
SELECT
    FLOOR(RAND() * 5000) + 1,
    FLOOR(RAND() * 200) + 1,
    FLOOR(RAND() * 15) + 1,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    ELT(FLOOR(RAND() * 3) + 1, 'Outpatient', 'Inpatient', 'ER'),
    ELT(FLOOR(RAND() * 6) + 1, 'I10', 'E11', 'J20', 'M54', 'F41', 'K21'),
    ELT(FLOOR(RAND() * 3) + 1, 'Completed', 'Cancelled', 'No-show')
FROM (_Numbers n1 CROSS JOIN (SELECT 1 AS x UNION ALL SELECT 2) x2) nums
LIMIT 20000;

-- Claims (one per encounter)
INSERT INTO Claims (EncounterID, TotalAmount, InsurancePaid, PatientPaid, ClaimStatus)
SELECT
    e.EncounterID,
    t.TotalAmount,
    CAST(t.TotalAmount * (0.5 + RAND() * 0.4) AS DECIMAL(10,2)),
    CAST(t.TotalAmount * (0.1 + RAND() * 0.3) AS DECIMAL(10,2)),
    ELT(FLOOR(RAND() * 3) + 1, 'Approved', 'Pending', 'Denied')
FROM Encounters e
CROSS JOIN LATERAL (SELECT CAST((FLOOR(RAND() * 900) + 100) AS DECIMAL(10,2)) AS TotalAmount) t;
