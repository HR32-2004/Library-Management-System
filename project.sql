-- Table: Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    Address TEXT,
    MembershipDate DATE NOT NULL
);

-- Table: Books
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Publisher VARCHAR(255),
    PublicationYear YEAR,
    CopiesAvailable INT DEFAULT 1
);

-- Table: BorrowRecords
CREATE TABLE BorrowRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    BookID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    Status ENUM('Borrowed', 'Returned') DEFAULT 'Borrowed',
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
);

-- Table: Reservations
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    BookID INT NOT NULL,
    ReservationDate DATE NOT NULL,
    Status ENUM('Pending', 'Fulfilled', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
);

-- Table: Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role ENUM('Librarian', 'Assistant') NOT NULL,
    HireDate DATE NOT NULL
);

-- Example Queries
-- 1. Adding a new book
INSERT INTO Books (Title, Author, Genre, ISBN, Publisher, PublicationYear, CopiesAvailable)
VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', '9780743273565', 'Scribner', 1925, 5);

-- 2. Registering a new user
INSERT INTO Users (Name, Email, PhoneNumber, Address, MembershipDate)
VALUES ('John Doe', 'johndoe@example.com', '123-456-7890', '123 Elm Street', CURDATE());

-- 3. Borrowing a book
INSERT INTO BorrowRecords (UserID, BookID, BorrowDate)
VALUES (1, 1, CURDATE());

-- 4. Reserving a book
INSERT INTO Reservations (UserID, BookID, ReservationDate)
VALUES (1, 2, CURDATE());

-- 5. Returning a book
UPDATE BorrowRecords
SET ReturnDate = CURDATE(), Status = 'Returned'
WHERE RecordID = 1;

-- 6. Listing all borrowed books by a user
SELECT b.Title, br.BorrowDate, br.ReturnDate, br.Status
FROM BorrowRecords br
JOIN Books b ON br.BookID = b.BookID
WHERE br.UserID = 1;

-- 7. Listing available copies of a book
SELECT Title, CopiesAvailable
FROM Books
WHERE BookID = 1;
