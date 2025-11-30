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

-- Insert some common statuses
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
(1, 2, 50.00, 1); -- Pending
