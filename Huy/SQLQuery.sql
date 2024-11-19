CREATE DATABASE DELIVERY_SYSTEM

GO 

USE DILIVERY_SYSTEM

GO

CREATE TABLE Customer (
-- In Vietnam, 10 for mobile phone number and 11 for landline number
Tel VARCHAR(11) PRIMARY KEY CHECK (LEN(Tel) BETWEEN 10 AND 11), 
Commune VARCHAR(20) NOT NULL,  
District VARCHAR(20) NOT NULL,
Province VARCHAR(20) NOT NULL,
Detail VARCHAR(30) NOT NULL,

--CONSTRAINT CUSTOMER_TELFK
--FOREIGN KEY (Tel)
--REFERENCES Userr(Tel)
--ON DELETE CASCADE
--ON UPDATE CASCADE

);

GO

CREATE TABLE Bill (
Condition VARCHAR(25) NOT NULL,
MoneyAmmount DECIMAL(11, 2) NOT NULL, 
Bill_ID CHAR(5) PRIMARY KEY
);

GO

CREATE TABLE Transactionn (
Moment DATETIME CHECK (Moment <= GETDATE()),
MoneyAmount DECIMAL(11, 2) NOT NULL,
Condition VARCHAR(25) NOT NULL,
TransactionID CHAR(5) PRIMARY KEY, 
PaymentMethod VARCHAR(20), 
Bill_ID CHAR(5),
CONSTRAINT TRANSACTIONBILLFK 
FOREIGN KEY (Bill_ID) 
REFERENCES Bill (Bill_ID) 
ON DELETE NO ACTION
ON UPDATE NO ACTION
);

GO

CREATE TABLE Friends (
User1 VARCHAR(11), 
User2 VARCHAR(11), 
PRIMARY KEY (User1, User2),

CONSTRAINT FRIEND1FK
FOREIGN KEY (User1)
REFERENCES Customer(Tel)
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT FRIEND2FK
FOREIGN KEY (User2)
REFERENCES Customer(Tel)
ON DELETE NO ACTION
ON UPDATE NO ACTION
);

GO

CREATE TABLE Bill_Order (
Bill_ID CHAR(5),
Order_ID CHAR(5), 
PRIMARY KEY (Bill_ID, Order_ID),

CONSTRAINT BILL_ORDER_1FK
FOREIGN KEY (Bill_ID)
REFERENCES Bill(Bill_ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION

-- CONSTRAINT BILL_ORDER_2FK
-- FOREIGN KEY (Order_ID)
-- REFERENCES Order(Order_ID)
-- ON DELETE NO ACTION
-- ON UPDATE NO ACTION
);

GO

INSERT INTO Customer (Tel, Commune, District, Province, Detail) VALUES
('0912345678', 'Tan My', 'Nam Tu Liem', 'Ha Noi', 'No. 10, Lane 25'),
('0987654321', 'An Khanh', 'Hoai Duc', 'Ha Noi', 'Apartment 15A'),
('0123456789', 'Nghia Lo', 'Nghia Dan', 'Nghe An', 'House No. 12'),
('0911223344', 'Cai Dau', 'Chau Phu', 'An Giang', 'Block B, Room 203'),
('0321456789', 'Ninh Son', 'Ninh Hoa', 'Khanh Hoa', 'Villa 2, Street 9'),
('0823456789', 'Vinh Long', 'Long Ho', 'Vinh Long', 'Lot 18, Block 5'),
('0934567890', 'An Phu Dong', 'District 12', 'Ho Chi Minh City', 'Building C, Floor 3'),
('0915567788', 'Dong Son', 'Thanh Hoa', 'Thanh Hoa', 'Shop 22, Market Street'),
('0876543210', 'Hoa Thanh', 'Hoa Vang', 'Da Nang', 'Room 45, Building A'),
('0771122334', 'Duong Dong', 'Phu Quoc', 'Kien Giang', 'Bungalow 3, Resort Z');

GO 

INSERT INTO Friends (User1, User2) VALUES
('0912345678', '0987654321'), -- User1 and User2 are friends
('0987654321', '0123456789'),
('0123456789', '0911223344'),
('0911223344', '0321456789'),
('0321456789', '0823456789'),
('0823456789', '0934567890'),
('0934567890', '0915567788'),
('0915567788', '0876543210'),
('0876543210', '0771122334'),
('0771122334', '0912345678'); -- Closing the circle of friendships

GO 

INSERT INTO Bill (Condition, MoneyAmmount, Bill_ID) VALUES
('Paid', 1250.00, 'B0001'),
('Pending', 300.50, 'B0002'),
('Unpaid', 750.75, 'B0003'),
('Paid', 2000.00, 'B0004'),
('Cancelled', 450.25, 'B0005'),
('Paid', 100.00, 'B0006'),
('Pending', 600.00, 'B0007'),
('Unpaid', 800.80, 'B0008'),
('Paid', 1500.00, 'B0009'),
('Pending', 250.20, 'B0010');

GO

INSERT INTO Transactionn (Moment, MoneyAmount, Condition, TransactionID, PaymentMethod, Bill_ID) VALUES
('2024-11-01 10:15:30', 1250.00, 'Completed', 'T0001', 'Credit Card', 'B0001'),
('2024-11-01 15:45:00', 300.50, 'Pending', 'T0002', 'Cash', 'B0002'),
('2024-11-02 09:10:15', 300.50, 'Completed', 'T0003', 'Bank Transfer', 'B0002'),
('2024-11-03 14:30:00', 750.75, 'Failed', 'T0004', 'PayPal', 'B0003'),
('2024-11-03 16:00:00', 750.75, 'Completed', 'T0005', 'Credit Card', 'B0003'),
('2024-11-04 08:25:45', 2000.00, 'Completed', 'T0006', 'Cash', 'B0004'),
('2024-11-05 11:00:00', 450.25, 'Cancelled', 'T0007', 'Mobile Payment', 'B0005'),
('2024-11-06 13:45:20', 100.00, 'Pending', 'T0008', 'Credit Card', 'B0006'),
('2024-11-07 18:20:10', 100.00, 'Completed', 'T0009', 'Bank Transfer', 'B0006'),
('2024-11-08 12:00:00', 600.00, 'Pending', 'T0010', 'PayPal', 'B0007'),
('2024-11-08 14:30:30', 600.00, 'Completed', 'T0011', 'Credit Card', 'B0007'),
('2024-11-09 10:10:10', 800.80, 'Completed', 'T0012', 'Cash', 'B0008'),
('2024-11-09 10:15:20', 800.80, 'Refunded', 'T0013', 'Mobile Payment', 'B0008'),
('2024-11-10 09:30:30', 1500.00, 'Completed', 'T0014', 'Credit Card', 'B0009'),
('2024-11-10 11:00:00', 250.20, 'Pending', 'T0015', 'Bank Transfer', 'B0010');

GO

INSERT INTO Bill_Order (Bill_ID, Order_ID) VALUES
('B0001', 'O0001'),
('B0001', 'O0002'),
('B0002', 'O0003'),
('B0003', 'O0004'),
('B0003', 'O0005'),
('B0004', 'O0006'),
('B0005', 'O0007'),
('B0006', 'O0008'),
('B0006', 'O0009'),
('B0007', 'O0010'),
('B0008', 'O0011'),
('B0008', 'O0012'),
('B0009', 'O0013'),
('B0010', 'O0014'),
('B0010', 'O0015');










