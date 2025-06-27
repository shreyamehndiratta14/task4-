-- Create Database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;
-- Drop tables if they exist to avoid duplication
DROP TABLE IF EXISTS BorrowRecords;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Authors;

-- Create Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(50)
);

-- Create Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Genre VARCHAR(50),
    ISBN VARCHAR(20),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    JoinDate DATE
);

-- Create BorrowRecords Table
CREATE TABLE BorrowRecords (
    RecordID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert into Authors (avoid duplicates)
INSERT INTO Authors (AuthorID, Name, Country) VALUES
(1, 'J.K. Rowling', 'UK'),
(2, 'George Orwell', 'UK'),
(3, 'Haruki Murakami', 'Japan')
ON DUPLICATE KEY UPDATE Name = VALUES(Name), Country = VALUES(Country);

-- Insert into Books
INSERT INTO Books (BookID, Title, Genre, ISBN, AuthorID) VALUES
(101, 'Harry Potter and the Sorcerer''s Stone', 'Fantasy', '9780747532699', 1),
(102, '1984', 'Dystopian', '9780451524935', 2),
(103, 'Kafka on the Shore', 'Magical Realism', NULL, 3)
ON DUPLICATE KEY UPDATE Title = VALUES(Title), Genre = VALUES(Genre), ISBN = VALUES(ISBN), AuthorID = VALUES(AuthorID);

-- Insert into Members
INSERT INTO Members (MemberID, Name, JoinDate) VALUES
(201, 'Alice Johnson', '2023-08-01'),
(202, 'Bob Smith', '2023-09-15')
ON DUPLICATE KEY UPDATE Name = VALUES(Name), JoinDate = VALUES(JoinDate);

-- Insert into BorrowRecords
INSERT INTO BorrowRecords (RecordID, MemberID, BookID, BorrowDate, ReturnDate) VALUES
(301, 201, 101, '2023-08-05', '2023-08-20'),
(302, 202, 102, '2023-09-20', NULL)
ON DUPLICATE KEY UPDATE MemberID = VALUES(MemberID), BookID = VALUES(BookID), BorrowDate = VALUES(BorrowDate), ReturnDate = VALUES(ReturnDate);

-- Update Examples
UPDATE Members
SET Name = 'Alice M. Johnson'
WHERE MemberID = 201;

UPDATE Books
SET ISBN = '9781400079278'
WHERE BookID = 103;

-- Delete Examples
DELETE FROM BorrowRecords
WHERE RecordID = 302;

DELETE FROM Members
WHERE MemberID = 202;

-- Select Queries
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM BorrowRecords;

SELECT Name, Country FROM Authors;
SELECT Title, Genre FROM Books;
SELECT Name, JoinDate FROM Members;

SELECT * FROM Books WHERE Genre = 'Fantasy';
SELECT * FROM Authors WHERE Country = 'UK' OR Country = 'Japan';
SELECT * FROM Members WHERE JoinDate > '2023-08-01';
SELECT * FROM Books WHERE Title LIKE '%Harry%';
SELECT * FROM BorrowRecords WHERE BorrowDate BETWEEN '2023-08-01' AND '2023-09-30';

SELECT * FROM Books ORDER BY Title ASC;
SELECT * FROM Members ORDER BY JoinDate DESC;
SELECT * FROM BorrowRecords ORDER BY BorrowDate DESC LIMIT 2;
-- 1. Count of books in each genre
SELECT Genre, COUNT(*) AS TotalBooks
FROM Books
GROUP BY Genre;

-- 2. Total fine collected from all borrow records
ALTER TABLE BorrowRecords
ADD COLUMN Fine DECIMAL(6,2) DEFAULT 0;
SELECT SUM(Fine) AS TotalFineCollected
FROM BorrowRecords;

-- 3. Average price of books by each author
SELECT a.Name AS AuthorName, AVG(b.Price) AS AvgBookPrice
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
GROUP BY a.Name;

-- 4. Number of books borrowed by each borrower
SELECT br.Name AS BorrowerName, COUNT(r.RecordID) AS BooksBorrowed
FROM BorrowRecords r
JOIN Borrowers br ON r.BorrowerID = br.BorrowerID
GROUP BY br.Name;

-- 5. Average age of borrowers who have borrowed books
SELECT AVG(b.Age) AS AverageBorrowerAge
FROM Borrowers b
JOIN BorrowRecords r ON b.BorrowerID = r.BorrowerID;

-- 6. Total number of borrowings for each book
SELECT b.Title AS BookTitle, COUNT(r.RecordID) AS TimesBorrowed
FROM BorrowRecords r
JOIN Books b ON r.BookID = b.BookID
GROUP BY b.Title;
