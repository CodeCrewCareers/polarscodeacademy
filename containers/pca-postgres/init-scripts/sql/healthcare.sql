-- ============================================================
-- Healthcare Database
-- ============================================================

CREATE TABLE Facilities (
    FacilityID SERIAL PRIMARY KEY,
    FacilityName VARCHAR(100),
    FacilityType VARCHAR(50),
    City VARCHAR(50),
    StateCode CHAR(2)
);

CREATE TABLE Patients (
    PatientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10),
    City VARCHAR(50),
    StateCode CHAR(2),
    InsuranceProvider VARCHAR(50)
);

CREATE TABLE Providers (
    ProviderID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    FacilityID INT,
    HireDate DATE,
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Encounters (
    EncounterID SERIAL PRIMARY KEY,
    PatientID INT,
    ProviderID INT,
    FacilityID INT,
    EncounterDate TIMESTAMP,
    EncounterType VARCHAR(25),
    DiagnosisCode VARCHAR(10),
    EncounterStatus VARCHAR(25),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES Providers(ProviderID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Claims (
    ClaimID SERIAL PRIMARY KEY,
    EncounterID INT,
    TotalAmount DECIMAL(10,2),
    InsurancePaid DECIMAL(10,2),
    PatientPaid DECIMAL(10,2),
    ClaimStatus VARCHAR(25),
    FOREIGN KEY (EncounterID) REFERENCES Encounters(EncounterID)
);

-- ========================
-- Lookup temp tables
-- ========================

CREATE TEMP TABLE _first_names (id SERIAL PRIMARY KEY, name VARCHAR(50));
INSERT INTO _first_names (name) VALUES
('James'),('Mary'),('Robert'),('Patricia'),('John'),('Jennifer'),
('Michael'),('Linda'),('David'),('Elizabeth'),('William'),('Barbara'),
('Richard'),('Susan'),('Joseph'),('Jessica'),('Thomas'),('Sarah');

CREATE TEMP TABLE _last_names (id SERIAL PRIMARY KEY, name VARCHAR(50));
INSERT INTO _last_names (name) VALUES
('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),
('Garcia'),('Miller'),('Davis'),('Rodriguez'),('Martinez'),
('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson');

CREATE TEMP TABLE _cities (id SERIAL PRIMARY KEY, city VARCHAR(50), state_code CHAR(2));
INSERT INTO _cities (city, state_code) VALUES
('New York','NY'),('Los Angeles','CA'),('Chicago','IL'),('Houston','TX'),('Phoenix','AZ'),
('Philadelphia','PA'),('San Antonio','TX'),('San Diego','CA'),('Dallas','TX'),('San Jose','CA'),
('Austin','TX'),('Jacksonville','FL'),('Columbus','OH'),('Charlotte','NC'),('Denver','CO');

-- ========================
-- Facilities (one per city)
-- ========================

INSERT INTO Facilities (FacilityName, FacilityType, City, StateCode)
SELECT
    'Medical Center ' || id,
    (ARRAY['Hospital', 'Clinic', 'Urgent Care'])[(FLOOR(RANDOM() * 3) + 1)::INT],
    city,
    state_code
FROM _cities;

-- ========================
-- Patients (5,000)
-- ========================

INSERT INTO Patients (FirstName, LastName, DOB, Gender, City, StateCode, InsuranceProvider)
SELECT
    (SELECT name FROM _first_names ORDER BY RANDOM() LIMIT 1),
    (SELECT name FROM _last_names ORDER BY RANDOM() LIMIT 1),
    CURRENT_DATE - (FLOOR(RANDOM() * 30000) || ' days')::INTERVAL,
    (ARRAY['Male', 'Female', 'Other'])[(FLOOR(RANDOM() * 3) + 1)::INT],
    c.city,
    c.state_code,
    (ARRAY['Aetna', 'BlueCross', 'United', 'Cigna', NULL::TEXT])[(FLOOR(RANDOM() * 5) + 1)::INT]
FROM generate_series(1, 5000)
CROSS JOIN LATERAL (SELECT city, state_code FROM _cities ORDER BY RANDOM() LIMIT 1) c;

-- ========================
-- Providers (200)
-- ========================

INSERT INTO Providers (FirstName, LastName, Specialty, FacilityID, HireDate)
SELECT
    (SELECT name FROM _first_names ORDER BY RANDOM() LIMIT 1),
    (SELECT name FROM _last_names ORDER BY RANDOM() LIMIT 1),
    (ARRAY['Primary Care', 'Cardiology', 'Orthopedics', 'Pediatrics', 'Neurology', 'Dermatology'])[(FLOOR(RANDOM() * 6) + 1)::INT],
    (SELECT FacilityID FROM Facilities ORDER BY RANDOM() LIMIT 1),
    CURRENT_DATE - (FLOOR(RANDOM() * 5000) || ' days')::INTERVAL
FROM generate_series(1, 200);

-- ========================
-- Encounters (20,000)
-- ========================

INSERT INTO Encounters (PatientID, ProviderID, FacilityID, EncounterDate, EncounterType, DiagnosisCode, EncounterStatus)
SELECT
    (FLOOR(RANDOM() * 5000) + 1)::INT,
    (FLOOR(RANDOM() * 200) + 1)::INT,
    (FLOOR(RANDOM() * 15) + 1)::INT,
    NOW() - (FLOOR(RANDOM() * 365) || ' days')::INTERVAL,
    (ARRAY['Outpatient', 'Inpatient', 'ER'])[(FLOOR(RANDOM() * 3) + 1)::INT],
    (ARRAY['I10', 'E11', 'J20', 'M54', 'F41', 'K21'])[(FLOOR(RANDOM() * 6) + 1)::INT],
    (ARRAY['Completed', 'Cancelled', 'No-show'])[(FLOOR(RANDOM() * 3) + 1)::INT]
FROM generate_series(1, 20000);

-- ========================
-- Claims (one per encounter)
-- ========================

INSERT INTO Claims (EncounterID, TotalAmount, InsurancePaid, PatientPaid, ClaimStatus)
SELECT
    e.EncounterID,
    t.total_amount,
    ROUND((t.total_amount * (0.5 + RANDOM() * 0.4))::NUMERIC, 2),
    ROUND((t.total_amount * (0.1 + RANDOM() * 0.3))::NUMERIC, 2),
    (ARRAY['Approved', 'Pending', 'Denied'])[(FLOOR(RANDOM() * 3) + 1)::INT]
FROM Encounters e
CROSS JOIN LATERAL (
    SELECT CAST(FLOOR(RANDOM() * 900) + 100 AS DECIMAL(10,2)) AS total_amount
) t;
