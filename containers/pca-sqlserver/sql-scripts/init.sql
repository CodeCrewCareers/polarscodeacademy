-- ============================================================
-- Saleshorse Database
-- ============================================================

CREATE DATABASE Saleshorse;
GO

USE Saleshorse;
GO


-- Users table
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    email NVARCHAR(150) UNIQUE
);

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('Diana', 'diana@example.com'),
('Eve', 'eve@example.com');

-- Accounts table (similar to Salesforce Accounts)
CREATE TABLE accounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150),
    industry NVARCHAR(100),
    owner_id INT,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO accounts (name, industry, owner_id) VALUES
('Acme Corp', 'Manufacturing', 1),
('Globex Inc', 'Technology', 2),
('Soylent Co', 'Food & Beverage', 3),
('Initech', 'Software', 4),
('Umbrella Corp', 'Pharmaceuticals', 5);

-- Contacts table
CREATE TABLE contacts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    email NVARCHAR(150) UNIQUE,
    account_id INT,
    owner_id INT,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO contacts (first_name, last_name, email, account_id, owner_id) VALUES
('John', 'Doe', 'john.doe@example.com', 1, 1),
('Jane', 'Smith', 'jane.smith@example.com', 2, 2),
('Mike', 'Johnson', 'mike.johnson@example.com', 3, 3),
('Sara', 'Connor', 'sara.connor@example.com', 4, 4),
('Tom', 'Brown', 'tom.brown@example.com', 5, 5);

-- Opportunities table
CREATE TABLE opportunities (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150),
    amount DECIMAL(12, 2),
    stage NVARCHAR(50),
    account_id INT,
    owner_id INT,
    close_date DATE,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

INSERT INTO opportunities (name, amount, stage, account_id, owner_id, close_date) VALUES
('Acme Deal 1', 50000, 'Prospecting', 1, 1, '2025-12-31'),
('Globex Project X', 120000, 'Negotiation', 2, 2, '2025-11-30'),
('Soylent Supply Contract', 75000, 'Closed Won', 3, 3, '2025-10-15'),
('Initech Software Upgrade', 90000, 'Proposal', 4, 4, '2025-12-15'),
('Umbrella Research Funding', 200000, 'Qualification', 5, 5, '2026-01-20');

-- Tasks table
CREATE TABLE tasks (
    id INT IDENTITY(1,1) PRIMARY KEY,
    subject NVARCHAR(150),
    status NVARCHAR(50),
    priority NVARCHAR(50),
    due_date DATE,
    owner_id INT,
    related_opportunity_id INT,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (related_opportunity_id) REFERENCES opportunities(id)
);

INSERT INTO tasks (subject, status, priority, due_date, owner_id, related_opportunity_id) VALUES
('Follow up with John Doe', 'Not Started', 'High', '2025-11-20', 1, 1),
('Prepare Globex proposal', 'In Progress', 'Medium', '2025-11-25', 2, 2),
('Call Mike about contract', 'Completed', 'High', '2025-11-10', 3, 3),
('Schedule demo with Sara', 'Not Started', 'High', '2025-11-22', 4, 4),
('Send Umbrella funding docs', 'In Progress', 'Medium', '2025-11-30', 5, 5);

-- ============================================================
-- PayBuddy Database
-- ============================================================
CREATE DATABASE PayBuddy;
GO

USE PayBuddy;
GO

-- Users Table
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);

-- Accounts Table (each user has an account)
CREATE TABLE accounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0.00,
    currency CHAR(3) DEFAULT 'USD',
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Transaction Status Lookup Table
CREATE TABLE transaction_statuses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    status_name NVARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO transaction_statuses (status_name) VALUES
('Pending'),
('Completed'),
('Failed'),
('Cancelled');

-- Transactions Table
CREATE TABLE transactions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    sender_account_id INT NOT NULL,
    receiver_account_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    status_id INT NOT NULL,
    initiated_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    cleared_at DATETIME2 NULL,
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

CREATE DATABASE Healthcare;
GO

USE Healthcare;
GO

/* =========================
   TABLES
========================= */

CREATE TABLE Facilities (
    FacilityID INT IDENTITY PRIMARY KEY,
    FacilityName VARCHAR(100),
    FacilityType VARCHAR(50),
    City VARCHAR(50),
    StateCode CHAR(2)
);

CREATE TABLE Patients (
    PatientID INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    City VARCHAR(50),
    StateCode CHAR(2),
    InsuranceProvider VARCHAR(50)
);

CREATE TABLE Providers (
    ProviderID INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    FacilityID INT,
    HireDate DATE,
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Encounters (
    EncounterID INT IDENTITY PRIMARY KEY,
    PatientID INT,
    ProviderID INT,
    FacilityID INT,
    EncounterDate DATETIME2,
    EncounterType VARCHAR(25),
    DiagnosisCode VARCHAR(10),
    EncounterStatus VARCHAR(25),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES Providers(ProviderID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Claims (
    ClaimID INT IDENTITY PRIMARY KEY,
    EncounterID INT,
    TotalAmount DECIMAL(10,2),
    InsurancePaid DECIMAL(10,2),
    PatientPaid DECIMAL(10,2),
    ClaimStatus VARCHAR(25),
    FOREIGN KEY (EncounterID) REFERENCES Encounters(EncounterID)
);

GO

/* =========================
   LOOKUP TABLES (REALISM BOOST)
========================= */

CREATE TABLE #FirstNames (Name VARCHAR(50));
INSERT INTO #FirstNames VALUES
('James'),('Mary'),('Robert'),('Patricia'),('John'),('Jennifer'),
('Michael'),('Linda'),('David'),('Elizabeth'),('William'),('Barbara'),
('Richard'),('Susan'),('Joseph'),('Jessica'),('Thomas'),('Sarah');

CREATE TABLE #LastNames (Name VARCHAR(50));
INSERT INTO #LastNames VALUES
('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),
('Garcia'),('Miller'),('Davis'),('Rodriguez'),('Martinez'),
('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson');

CREATE TABLE #Cities (City VARCHAR(50), StateCode CHAR(2));
INSERT INTO #Cities VALUES
('New York','NY'),('Los Angeles','CA'),('Chicago','IL'),
('Houston','TX'),('Phoenix','AZ'),('Philadelphia','PA'),
('San Antonio','TX'),('San Diego','CA'),('Dallas','TX'),
('San Jose','CA'),('Austin','TX'),('Jacksonville','FL'),
('Columbus','OH'),('Charlotte','NC'),('Denver','CO');

GO

/* =========================
   FACILITIES
========================= */

INSERT INTO Facilities (FacilityName, FacilityType, City, StateCode)
SELECT
    CONCAT('Medical Center ', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Hospital', 'Clinic', 'Urgent Care'),
    c.City,
    c.StateCode
FROM #Cities c;

GO

/* =========================
   PATIENTS (5,000)
========================= */

WITH Numbers AS (
    SELECT TOP 5000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO Patients (FirstName, LastName, DOB, Gender, City, StateCode, InsuranceProvider)
SELECT
    (SELECT TOP 1 Name FROM #FirstNames ORDER BY NEWID()),
    (SELECT TOP 1 Name FROM #LastNames ORDER BY NEWID()),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 30000, GETDATE()),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1, 'Male', 'Female', 'Other'),
    c.City,
    c.StateCode,
    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1,
        'Aetna','BlueCross','United','Cigna',NULL)
FROM Numbers
CROSS APPLY (SELECT TOP 1 * FROM #Cities ORDER BY NEWID()) c;

GO

/* =========================
   PROVIDERS (200)
========================= */

WITH Numbers AS (
    SELECT TOP 200 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO Providers (FirstName, LastName, Specialty, FacilityID, HireDate)
SELECT
    (SELECT TOP 1 Name FROM #FirstNames ORDER BY NEWID()),
    (SELECT TOP 1 Name FROM #LastNames ORDER BY NEWID()),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 6 + 1,
        'Primary Care','Cardiology','Orthopedics','Pediatrics','Neurology','Dermatology'),
    (SELECT TOP 1 FacilityID FROM Facilities ORDER BY NEWID()),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 5000, GETDATE())
FROM Numbers;

GO

/* =========================
   ENCOUNTERS (20,000)
========================= */

WITH Numbers AS (
    SELECT TOP 20000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO Encounters
(PatientID, ProviderID, FacilityID, EncounterDate, EncounterType, DiagnosisCode, EncounterStatus)
SELECT
    (SELECT TOP 1 PatientID FROM Patients ORDER BY NEWID()),
    (SELECT TOP 1 ProviderID FROM Providers ORDER BY NEWID()),
    (SELECT TOP 1 FacilityID FROM Facilities ORDER BY NEWID()),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1,
        'Outpatient','Inpatient','ER'),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 6 + 1,
        'I10','E11','J20','M54','F41','K21'),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1,
        'Completed','Cancelled','No-show')
FROM Numbers;

GO

/* =========================
   CLAIMS
========================= */

INSERT INTO Claims (EncounterID, TotalAmount, InsurancePaid, PatientPaid, ClaimStatus)
SELECT
    e.EncounterID,
    cost.TotalAmount,
    cost.TotalAmount * (0.5 + RAND(CHECKSUM(NEWID())) * 0.4),
    cost.TotalAmount * (0.1 + RAND(CHECKSUM(NEWID())) * 0.3),
    CHOOSE(ABS(CHECKSUM(NEWID())) % 3 + 1,
        'Approved','Pending','Denied')
FROM Encounters e
CROSS APPLY (
    SELECT CAST((ABS(CHECKSUM(NEWID())) % 900) + 100 AS DECIMAL(10,2)) AS TotalAmount
) cost;

GO
