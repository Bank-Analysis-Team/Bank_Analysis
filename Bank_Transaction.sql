//*Bank_Management_System Database step by step*//
--------------------------------------------------
//* STEP(1)- Create Database:*//
---------------------------
CREATE DATABASE Bank_Management_System;
use Bank_Management_System;
---------------------------------------------------------------------------------------------------------------------------------------------------------

//* STEP(2)- Create Tables and set constraints:*//
-----------------------------------------------------
-- Create Branches Table
CREATE TABLE Branches (
    Branch_ID       INT             PRIMARY KEY,
    Branch_Name     VARCHAR(100)    Not NULL,     
    Location        VARCHAR(100)    Not NULL,
    PHONE           VARCHAR(20)
);
-- Create Employees Table
CREATE TABLE Employees (
    EMP_ID           INT PRIMARY KEY,
    Name             VARCHAR(100)          NOT NULL,
    Role             VARCHAR(50)           NOT NULL
    CHECK (Role IN ('Teller','Manager','Customer Service')),
    Username         VARCHAR(50)           UNIQUE,
    Branch_ID        INT                   NOT NULL,
    FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON DELETE CASCADE
);
-- Create Customers Table
CREATE TABLE Customers (
    Customer_ID        INT PRIMARY KEY,
    Name               VARCHAR(100)        NOT NULL,
    DOB                 DATE               NOT NULL,
    Address            VARCHAR(150)        NOT NULL,
    Phone              VARCHAR(20)         NOT NULL,
    National_ID        VARCHAR(14)  UNIQUE NOT NULL,
    Email              VARCHAR(100) UNIQUE NOT NULL
);
--create TABLE Services
CREATE TABLE Services (
    Service_ID          INT             PRIMARY KEY,
    Service_Name        VARCHAR(100)    NOT NULL,
    Service_description TEXT
);
-- Create Accounts Table
CREATE TABLE Accounts (
    Account_ID          INT             PRIMARY KEY,
    Customer_ID         INT             NOT NULL,
    Branch_ID           INT             NOT NULL,
    EMP_ID              INT             NOT NULL,
    Account_Type        VARCHAR(20)     NOT NULL
        CHECK (Account_Type IN ('Savings','Current')),
    Balance             DECIMAL(15,2)   NOT NULL
        CHECK (Balance >= 0),
    Status VARCHAR(20) DEFAULT 'Active'
        CHECK (Status IN ('Active','Inactive','Closed')),
    Account_Open_Date   DATE             NOT NULL,

    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID),
    FOREIGN KEY (EMP_ID) REFERENCES Employees(EMP_ID)
);
-- Create Service_Requests Table
CREATE TABLE Service_Requests (
    Request_ID      INT            PRIMARY KEY,
    Customer_ID     INT            NOT NULL,
    Service_ID      INT            NOT NULL,
    EMP_ID          INT            NOT NULL,
    Branch_ID       INT            NOT NULL,
    Request_Date    DATE           NOT NULL,
    Amount          DECIMAL(15,2)  NULL,
    Status          VARCHAR(50)    NOT NULL
        CHECK (Status IN ('Pending','In Progress','Completed','Rejected')),

    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID),
    FOREIGN KEY (EMP_ID) REFERENCES Employees(EMP_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID)
);
-- Create Transactions Table
CREATE TABLE Transactions (
    Transaction_ID            INT           PRIMARY KEY,
    Account_ID                INT           NOT NULL,
    EMP_ID                    INT           NULL,
    Transaction_Type          VARCHAR(30)   NOT NULL
        CHECK (Transaction_Type IN ('Deposit','Withdrawal','Transfer','Balance Inquiry')),
    Transaction_Media         VARCHAR(30)   NOT NULL
        CHECK (Transaction_Media IN ('Cash','Card','Online','Check')),
    Amount                    DECIMAL(15,2) NULL,
    Transaction_Date          DATETIME      NOT NULL,
    Transaction_Status        VARCHAR(20)   NOT NULL
        CHECK (Transaction_Status IN ('Completed','Pending','Rejected')),

    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID),
    FOREIGN KEY (EMP_ID) REFERENCES Employees(EMP_ID),
    CONSTRAINT chk_amount_logic CHECK (
        (Transaction_Type = 'Balance Inquiry' AND Amount IS NULL)
        OR
        (Transaction_Type IN ('Deposit','Withdrawal','Transfer') 
            AND Amount IS NOT NULL AND Amount > 0)
    )
);
//* STEP(3): BULK INSERTIONS TO THE CREATED TABLE*//
//*1*//
BULK INSERT Branches
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Branches 1.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

//*2*//
BULK INSERT Services
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Services.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);


//*3*//
BULK INSERT Employees
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Employees.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);


//*4*//
BULK INSERT Customers
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Customers2.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);

//*5*//
BULK INSERT Accounts
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Accounts4.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    FIRSTROW = 2
);

//*6*//
BULK INSERT Service_Requests
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Service_Requests.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);

//*7*//
BULK INSERT Transactions
FROM 'C:\Users\ABC\OneDrive\Desktop\Bank_Transaction\Transactions.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK
);



CREATE TABLE #Staging_Accounts (
    Account_ID INT,
    Customer_ID INT,
    Branch_ID INT,
    EMP_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(15,2),
    Account_Open_Date VARCHAR(20)  -- خليه نص مؤقت
);

BULK INSERT #Staging_Accounts
FROM 'C:\Your\Full\Path\Accounts4.csv'
WITH (
    FIELDTERMINATOR = ';',  -- فاصل الأعمدة في CSV
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,           -- لو فيه header
    TABLOCK
);

INSERT INTO Accounts (Account_ID, Customer_ID, Branch_ID, EMP_ID, Account_Type, Balance, Account_Open_Date)
SELECT 
    Account_ID,
    Customer_ID,
    Branch_ID,
    EMP_ID,
    Account_Type,
    Balance,
    CONVERT(DATE, Account_Open_Date, 120)  -- 120 = YYYY-MM-DD
FROM #Staging_Accounts;
--10 SQL Question:
--Q1) Customer Master View
CREATE VIEW vw_CustomerMaster AS
SELECT 
    c.Customer_ID,
    c.Name,
    c.National_ID,
    c.Phone,
    c.Email,
    c.Address,
    COUNT(a.Account_ID) AS TotalAccounts,
    SUM(a.Balance) AS TotalBalance
FROM Customers c
LEFT JOIN Accounts a ON c.Customer_ID = a.Customer_ID
GROUP BY c.Customer_ID, c.Name, c.National_ID, c.Phone, c.Email, c.Address;
SELECT TOP 20 *
FROM vw_CustomerMaster
ORDER BY TotalBalance DESC;
UPDATE Accounts
SET Status = CASE 
    WHEN Account_Open_Date < '2024-01-01' THEN 'Inactive'
    ELSE 'Active'
END;
--Q2) Account Portfolio
CREATE VIEW vw_AccountPortfolio AS
SELECT 
    a.Account_ID,
    c.Name AS CustomerName,
    b.Branch_Name,
    a.Account_Type,
    a.Account_Open_Date,
    a.Status,
    a.Balance
FROM Accounts a
JOIN Customers c ON a.Customer_ID = c.Customer_ID
JOIN Branches b ON a.Branch_ID = b.Branch_ID;
SELECT *
FROM vw_AccountPortfolio
WHERE Status <> 'Active'
ORDER BY Account_Open_Date DESC;
--Q3) Monthly Transaction Summary
SELECT 
    FORMAT(Transaction_Date,'yyyy-MM') AS Month,
    SUM(CASE WHEN Transaction_Type='Deposit' THEN Amount ELSE 0 END) AS Credit,
    SUM(CASE WHEN Transaction_Type='Withdrawal' THEN Amount ELSE 0 END) AS Debit,
    SUM(CASE 
        WHEN Transaction_Type='Deposit' THEN Amount
        WHEN Transaction_Type='Withdrawal' THEN -Amount END) AS NetFlow,
    COUNT(*) AS TotalTransactions
FROM Transactions
WHERE Transaction_Date >= DATEADD(MONTH,-12,GETDATE())
GROUP BY FORMAT(Transaction_Date,'yyyy-MM');
--Q4) Customer Statement View
CREATE VIEW vw_CustomerStatement AS
SELECT 
    c.Customer_ID,
    c.Name,
    a.Account_ID,
    t.Transaction_Date,
    t.Transaction_Type,
    t.Amount
FROM Transactions t
JOIN Accounts a ON t.Account_ID = a.Account_ID
JOIN Customers c ON a.Customer_ID = c.Customer_ID;
--Q5) Top Customers by Activity
SELECT TOP 10
    c.Name,
    COUNT(*) AS TransactionsCount
FROM Customers c
JOIN Accounts a ON c.Customer_ID = a.Customer_ID
JOIN Transactions t ON a.Account_ID = t.Account_ID
WHERE t.Transaction_Date >= DATEADD(DAY,-90,GETDATE())
GROUP BY c.Name
ORDER BY TransactionsCount DESC;
--Q6) Branch Performance
SELECT 
    b.Branch_Name,
    COUNT(DISTINCT a.Customer_ID) AS Customers,
    COUNT(t.Transaction_ID) AS Transactions,
    SUM(t.Amount) AS TotalValue
FROM Branches b
JOIN Accounts a ON b.Branch_ID = a.Branch_ID
JOIN Transactions t ON a.Account_ID = t.Account_ID
WHERE t.Transaction_Date >= DATEADD(DAY,-30,GETDATE())
GROUP BY b.Branch_Name;
--Q7) Employee Activity Report
SELECT TOP 10
    e.Name AS EmployeeName,
    e.Role,
    b.Branch_Name,
    COUNT(t.Transaction_ID) AS TransactionsHandled,
    SUM(t.Amount) AS TotalValueHandled
FROM Employees e
JOIN Branches b ON e.Branch_ID = b.Branch_ID
JOIN Transactions t ON e.EMP_ID = t.EMP_ID
WHERE t.Transaction_Date >= DATEADD(DAY, -30, GETDATE())
GROUP BY e.Name, e.Role, b.Branch_Name
ORDER BY TransactionsHandled DESC;
--Q8) Service Adoption View
CREATE VIEW vw_ServiceAdoption AS
SELECT 
    c.Customer_ID,
    c.Name,
    COUNT(sr.Service_ID) AS ActiveServicesCount
FROM Customers c
LEFT JOIN Service_Requests sr 
    ON c.Customer_ID = sr.Customer_ID
WHERE sr.Status = 'Completed'
GROUP BY c.Customer_ID, c.Name;
SELECT *
FROM vw_ServiceAdoption
WHERE ActiveServicesCount >= 2;
--Q9) Inactive Accounts
SELECT 
    a.Account_ID,
    MAX(t.Transaction_Date) AS LastTxn,
    DATEDIFF(DAY, MAX(t.Transaction_Date), GETDATE()) AS DaysInactive
FROM Accounts a
LEFT JOIN Transactions t ON a.Account_ID = t.Account_ID
GROUP BY a.Account_ID
HAVING MAX(t.Transaction_Date) < DATEADD(DAY,-60,GETDATE());
--Q10) Suspicious Transactions
SELECT 
    t.Transaction_ID AS TxnID,
    a.Account_ID AS AccountNo,
    c.Name AS CustomerName,
    b.Branch_Name AS BranchName,
    t.Transaction_Type AS TxnType,
    t.Amount,
    t.Transaction_Date AS TxnDateTime,
    'Large Withdrawal (>80% Balance)' AS FlagReason

FROM Transactions t
JOIN Accounts a ON t.Account_ID = a.Account_ID
JOIN Customers c ON a.Customer_ID = c.Customer_ID
JOIN Branches b ON a.Branch_ID = b.Branch_ID

WHERE 
    t.Transaction_Type = 'Withdrawal'
    AND t.Amount IS NOT NULL
    AND t.Amount > 0.8 * a.Balance;
  