CREATE TABLE Us
(
    uName VARCHAR(15) NOT NULL,
    uPhoneNum CHAR(9) NOT NULL PRIMARY KEY ,
    uEmail VARCHAR(15) NOT NULL
);

CREATE TABLE Employee
(
    eName VARCHAR(15) NOT NULL,
    ePhoneNum CHAR(9) NOT NULL PRIMARY KEY ,
    eEmail VARCHAR(15) NOT NULL,
    FOREIGN KEY (ePhoneNum) REFERENCES Us(uPhoneNum)
);


CREATE TABLE Manager
(
    mName VARCHAR(15) NOT NULL,
    mPhoneNum CHAR(9) NOT NULL PRIMARY KEY ,
    mEmail VARCHAR(15) NOT NULL
    FOREIGN KEY (mPhoneNum) REFERENCES Employee(ePhoneNum)
);


CREATE TABLE Station
(
    sMgrPhoneNum CHAR(9) NOT NULL,
    FOREIGN KEY (sMgrPhoneNum) REFERENCES Manager(mPhoneNum),
    sID INT PRIMARY KEY,
    sWard VARCHAR(15) NOT NULL,
    sDistrict VARCHAR(15) NOT NULL,
    sCity VARCHAR(15) NOT NULL,
    sDetails VARCHAR(15) NOT NULL
);

CREATE TABLE Driver
(
    dPhoneNum CHAR(9) NOT NULL PRIMARY KEY,
    dYearOfExp INT NOT NULL CHECK (dYearOfExp >= 2),
    FOREIGN KEY (dPhoneNum) REFERENCES Employee(ePhoneNum)
);

CREATE TABLE License
(
    dPhoneNum CHAR(9) NOT NULL,
    license VARCHAR(15) NOT NULL,
    lType VARCHAR(15) NOT NULL,
    lOutOfDate DATE NOT NULL,
    PRIMARY KEY (dPhoneNum, license),
    FOREIGN KEY (dPhoneNum) REFERENCES Employee(ePhoneNum)
);


CREATE TABLE Vehicle
(
    vDriver CHAR(9) NOT NULL,
    FOREIGN KEY (vDriver) REFERENCES Employee(ePhoneNum),
    vID CHAR(9) PRIMARY KEY,
    vRegState VARCHAR(15) NOT NULL,
);

CREATE TRIGGER check_exp_of_Driver ON License
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE lOutOfDate < GETDATE())
    BEGIN
        RAISERROR('License is out of date', 16, 1);
        ROLLBACK TRANSACTION;
    END

    IF EXISTS (SELECT 1 FROM inserted i
               JOIN Driver d ON i.dPhoneNum = d.dPhoneNum
               WHERE d.dYearOfExp < 2)
    BEGIN
        RAISERROR('Driver must have at least 2 years of experience', 16, 1);
        ROLLBACK TRANSACTION;
    END

    UPDATE Driver
    SET dYearOfExp = dYearOfExp + 1
    FROM Driver d
    JOIN inserted i ON d.dPhoneNum = i.dPhoneNum
    WHERE i.lOutOfDate >= GETDATE();
END;