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
