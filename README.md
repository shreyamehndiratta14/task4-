#  Task 4: Aggregate Functions and Grouping

##  Objective
The goal of this task is to apply **SQL aggregate functions** such as `SUM`, `COUNT`, and `AVG` along with `GROUP BY` clauses to summarize and analyze data from the Library Management System.

##  Tools Used
- MySQL Workbench / DB Browser for SQLite

##  Assumed Schema
The following tables are assumed to be already created and populated from Task 3:

- **Books(BookID, Title, AuthorID, Genre, Price)**
- **Authors(AuthorID, Name, Country)**
- **Borrowers(BorrowerID, Name, Age)**
- **BorrowRecords(RecordID, BorrowerID, BookID, BorrowDate, ReturnDate, Fine)**  
  > Note: If `Fine` column doesn't exist, you can add it using:
  ```sql
  ALTER TABLE BorrowRecords ADD COLUMN Fine DECIMAL(6,2) DEFAULT 0;
