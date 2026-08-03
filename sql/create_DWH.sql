CREATE DATABASE DWH;
GO
USE DWH;
GO

CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    Address VARCHAR(255),
    CityName VARCHAR(100),
    StateName VARCHAR(100),
    Age INT,
    Gender VARCHAR(50),
    Email VARCHAR(255)
);
GO

CREATE TABLE DimBranch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    BranchLocation VARCHAR(255)
);
GO

CREATE TABLE DimAccount (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(50),
    Balance DECIMAL(18,2),
    DateOpened DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
);
GO

CREATE TABLE FactTransaction (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATETIME,
    Amount DECIMAL(18,2),
    TransactionType VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (AccountID) REFERENCES DimAccount(AccountID),
    FOREIGN KEY (BranchID) REFERENCES DimBranch(BranchID)
);
GO
