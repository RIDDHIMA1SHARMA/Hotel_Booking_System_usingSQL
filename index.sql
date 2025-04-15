-- Create Database
CREATE DATABASE yoyo;
GO
USE yoyo;
GO

-- Create Hotels Table
CREATE TABLE Hotels (
    HotelID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(200),
    StarRating INT,
    CONSTRAINT CHK_StarRating CHECK (StarRating BETWEEN 1 AND 5)
);
GO

-- Create Rooms Table
CREATE TABLE Rooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    HotelID INT,
    RoomType VARCHAR(20) NOT NULL,  -- No ENUM, using VARCHAR
    Price DECIMAL(10,2) NOT NULL,
    AvailabilityStatus VARCHAR(10) DEFAULT 'Available',
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);
GO

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address TEXT
);
GO

-- Create Bookings Table
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    RoomID INT,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Confirmed',  -- ENUM replaced with VARCHAR
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);
GO

-- Create Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(20),  -- ENUM replaced with VARCHAR
    PaymentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);
GO

-- Insert Hotels
INSERT INTO Hotels (Name, Location, StarRating) VALUES 
('Grand Hotel', 'New York', 5),
('Cozy Stay', 'Los Angeles', 3);
GO

-- Insert Rooms
INSERT INTO Rooms (HotelID, RoomType, Price, AvailabilityStatus) VALUES 
(1, 'Single', 100.00, 'Available'),
(1, 'Double', 150.00, 'Booked'),
(2, 'Suite', 250.00, 'Available');
GO

-- Insert Customers
INSERT INTO Customers (Name, Email, Phone, Address) VALUES 
('Alice Johnson', 'alice@example.com', '1234567890', '123 Elm Street'),
('Bob Smith', 'bob@example.com', '9876543210', '456 Oak Street');
GO

-- Insert Bookings
INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, Status) VALUES 
(1, 2, '2025-04-01', '2025-04-05', 'Confirmed'),
(2, 3, '2025-04-10', '2025-04-15', 'Confirmed');
GO

-- Insert Payments
INSERT INTO Payments (BookingID, Amount, PaymentMethod) VALUES 
(1, 600.00, 'Credit Card'),
(2, 1250.00, 'PayPal');
GO

-- Query 1: Get Available Rooms
SELECT * FROM Rooms WHERE AvailabilityStatus = 'Available';
GO

-- Query 2: Get Bookings for Alice Johnson
SELECT 
    B.BookingID, H.Name AS HotelName, R.RoomType, 
    B.CheckInDate, B.CheckOutDate, B.Status
FROM Bookings B
JOIN Rooms R ON B.RoomID = R.RoomID
JOIN Hotels H ON R.HotelID = H.HotelID
WHERE B.CustomerID = (SELECT CustomerID FROM Customers WHERE Email = 'alice@example.com');
GO

-- Query 3: Get Total Revenue per Hotel
SELECT 
    H.Name, SUM(P.Amount) AS TotalRevenue
FROM Payments P
JOIN Bookings B ON P.BookingID = B.BookingID
JOIN Rooms R ON B.RoomID = R.RoomID
JOIN Hotels H ON R.HotelID = H.HotelID
GROUP BY H.Name;
GO

-- Query 4: Get Hotel with Most Bookings
SELECT TOP 1 H.Name, COUNT(B.BookingID) AS TotalBookings
FROM Bookings B
JOIN Rooms R ON B.RoomID = R.RoomID
JOIN Hotels H ON R.HotelID = H.HotelID
GROUP BY H.Name
ORDER BY TotalBookings DESC;
GO

-- Query 5: Get Upcoming Bookings for Customers
SELECT 
    C.Name, C.Email, B.CheckInDate, B.CheckOutDate 
FROM Customers C
JOIN Bookings B ON C.CustomerID = B.CustomerID
WHERE B.CheckInDate >= GETDATE();
GO
