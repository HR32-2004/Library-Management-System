-- Create Library Database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Create Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    ISBN VARCHAR(20),
    PublicationYear INT,
    CopiesAvailable INT
);

-- Create Members Table
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    MembershipDate DATE
);

-- Create Librarians Table
CREATE TABLE Librarians (
    LibrarianID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

-- Create BorrowingRecords Table
CREATE TABLE BorrowingRecords (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Create Fines Table
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    BorrowID INT,
    Amount DECIMAL(10, 2),
    Status VARCHAR(50),
    FOREIGN KEY (BorrowID) REFERENCES BorrowingRecords(BorrowID)
);

-- Create Reservations Table
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    ReservationDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert Sample Data into Books
INSERT INTO Books (Title, Author, Genre, ISBN, PublicationYear, CopiesAvailable)
VALUES 
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', '9780316769488', 1951, 5),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', '9780060935467', 1960, 3),
('1984', 'George Orwell', 'Dystopian', '9780451524935', 1949, 4),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', '9780743273565', 1925, 2);

-- Insert Sample Data into Members
INSERT INTO Members (FirstName, LastName, Email, Phone, MembershipDate)
VALUES 
('Alice', 'Johnson', 'alice.johnson@example.com', '1234567890', '2023-01-15'),
('Bob', 'Smith', 'bob.smith@example.com', '9876543210', '2023-03-10'),
('Charlie', 'Brown', 'charlie.brown@example.com', '5678901234', '2023-05-20');

-- Insert Sample Data into Librarians
INSERT INTO Librarians (Name, Email, Phone)
VALUES 
('Emma Brown', 'emma.brown@example.com', '1122334455'),
('James White', 'james.white@example.com', '5566778899');

-- Insert Sample Data into BorrowingRecords
INSERT INTO BorrowingRecords (MemberID, BookID, BorrowDate, DueDate, ReturnDate)
VALUES 
(1, 1, '2023-12-01', '2023-12-15', NULL),
(2, 2, '2023-11-20', '2023-12-05', '2023-12-04'),
(3, 3, '2023-12-02', '2023-12-16', NULL);

-- Insert Sample Data into Fines
INSERT INTO Fines (BorrowID, Amount, Status)
VALUES 
(1, 20.00, 'Unpaid'),
(2, 0.00, 'Paid');

-- Insert Sample Data into Reservations
INSERT INTO Reservations (MemberID, BookID, ReservationDate, Status)
VALUES 
(1, 3, '2023-12-10', 'Active'),
(2, 4, '2023-12-12', 'Active');

-- Queries

-- 1. List all available books along with their details
SELECT * FROM Books WHERE CopiesAvailable > 0;

-- 2. View all members with their membership information
SELECT MemberID, CONCAT(FirstName, ' ', LastName) AS FullName, Email, Phone, MembershipDate
FROM Members;

-- 3. List borrowing records for a specific member
SELECT b.BorrowID, bk.Title, b.BorrowDate, b.DueDate, b.ReturnDate
FROM BorrowingRecords b
JOIN Books bk ON b.BookID = bk.BookID
WHERE b.MemberID = 1;

-- 4. Identify overdue books
SELECT b.BorrowID, m.FirstName, m.LastName, bk.Title, b.DueDate
FROM BorrowingRecords b
JOIN Members m ON b.MemberID = m.MemberID
JOIN Books bk ON b.BookID = bk.BookID
WHERE b.DueDate < CURDATE() AND b.ReturnDate IS NULL;

-- 5. Calculate total fines for a specific member
SELECT SUM(f.Amount) AS TotalFines
FROM Fines f
JOIN BorrowingRecords br ON f.BorrowID = br.BorrowID
WHERE br.MemberID = 1;

-- 6. Add a returned book and update inventory
UPDATE BorrowingRecords
SET ReturnDate = CURDATE()
WHERE BorrowID = 1;

UPDATE Books
SET CopiesAvailable = CopiesAvailable + 1
WHERE BookID = (SELECT BookID FROM BorrowingRecords WHERE BorrowID = 1);

-- 7. View active reservations
SELECT r.ReservationID, m.FirstName, m.LastName, bk.Title, r.ReservationDate, r.Status
FROM Reservations r
JOIN Members m ON r.MemberID = m.MemberID
JOIN Books bk ON r.BookID = bk.BookID
WHERE r.Status = 'Active';

-- 8. Cancel a reservation
UPDATE Reservations
SET Status = 'Cancelled'
WHERE ReservationID = 1;

-- 9. Generate borrowing history for a member
SELECT br.BorrowID, bk.Title, br.BorrowDate, br.DueDate, br.ReturnDate
FROM BorrowingRecords br
JOIN Books bk ON br.BookID = bk.BookID
WHERE br.MemberID = 1;

-- 10. Add a fine for overdue books
INSERT INTO Fines (BorrowID, Amount, Status)
VALUES 
(3, 15.00, 'Unpaid');
