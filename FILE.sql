-- Create Hotels Table
create database yoyo;
CREATE TABLE Hotelss (
    HotelID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(200),
    StarRating INT CHECK (StarRating BETWEEN 1 AND 5)
);

-- Create Rooms Table
CREATE TABLE Roomss (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    HotelID INT,
    RoomType ENUM('Single', 'Double', 'Suite') NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    AvailabilityStatus ENUM('Available', 'Booked') DEFAULT 'Available',
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);

-- Create Customers Table
CREATE TABLE Customerss (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address TEXT
);

-- Create Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    RoomID INT,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Status ENUM('Confirmed', 'Cancelled', 'Completed') DEFAULT 'Confirmed',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- Create Payments Table
CREATE TABLE Paymentss (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Net Banking'),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);
-- Insert Hotels
INSERT INTO Hotels (Name, Location, StarRating) VALUES 
('Grand Hotel', 'New York', 5),
('Cozy Stay', 'Los Angeles', 3);

-- Insert Rooms
INSERT INTO Rooms (HotelID, RoomType, Price, AvailabilityStatus) VALUES 
(1, 'Single', 100.00, 'Available'),
(1, 'Double', 150.00, 'Booked'),
(2, 'Suite', 250.00, 'Available');

-- Insert Customers
INSERT INTO Customerss (Name, Email, Phone, Address) VALUES 
('Alice Johnson', 'alice@example.com', '1234567890', '123 Elm Street'),
('Bob Smith', 'bob@example.com', '9876543210', '456 Oak Street');

-- Insert Bookings
INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, Status) VALUES 
(1, 2, '2025-04-01', '2025-04-05', 'Confirmed'),
(2, 3, '2025-04-10', '2025-04-15', 'Confirmed');

-- Insert Payments
INSERT INTO Paymentss (BookingID, Amount, PaymentMethod) VALUES 
(1, 600.00, 'Credit Card'),
(2, 1250.00, 'PayPal');
SELECT * FROM Rooms WHERE AvailabilityStatus = 'Available';
SELECT Bookings.BookingID, Hotels.Name AS HotelName, Rooms.RoomType, 
       Bookings.CheckInDate, Bookings.CheckOutDate, Bookings.Status
FROM Bookings
JOIN Rooms ON Bookings.RoomID = Rooms.RoomID
JOIN Hotels ON Rooms.HotelID = Hotels.HotelID
WHERE Bookings.CustomerID = (SELECT CustomerID FROM Customers WHERE Email = 'alice@example.com');
SELECT Hotels.Name, SUM(Payments.Amount) AS TotalRevenue
FROM Payments
JOIN Bookings ON Payments.BookingID = Bookings.BookingID
JOIN Rooms ON Bookings.RoomID = Rooms.RoomID
JOIN Hotels ON Rooms.HotelID = Hotels.HotelID
GROUP BY Hotels.Name;
SELECT Hotels.Name, COUNT(Bookings.BookingID) AS TotalBookings
FROM Bookings
JOIN Rooms ON Bookings.RoomID = Rooms.RoomID
JOIN Hotels ON Rooms.HotelID = Hotels.HotelID
GROUP BY Hotels.Name
ORDER BY TotalBookings DESC
LIMIT 1;
SELECT Customers.Name, Customers.Email, Bookings.CheckInDate, Bookings.CheckOutDate 
FROM Customers
JOIN Bookings ON Customers.CustomerID = Bookings.CustomerID
WHERE Bookings.CheckInDate >= CURDATE();

