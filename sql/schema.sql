--function

GO
CREATE FUNCTION calc_age
(
    @bday DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @age INT;
    SET @age = DATEDIFF(YEAR, @bday, GETDATE());
    IF (MONTH(@bday) > MONTH(GETDATE())) 
        OR (MONTH(@bday) = MONTH(GETDATE()) AND DAY(@bday) > DAY(GETDATE()))
    BEGIN
        SET @age = @age - 1;
    END;
    RETURN @age
END;
GO


--schema

CREATE TABLE NguoiDung (
	sdt CHAR(10) PRIMARY KEY, ---mobilephone only
  	email NVARCHAR(255) UNIQUE,
    CONSTRAINT email_check CHECK (email LIKE '%_@__%.__%'), 
 	hoTen NVARCHAR(MAX),
 	namSinh DATE,
    CONSTRAINT age_check CHECK (dbo.calc_age(namSinh) >= 16 AND dbo.calc_age(namSinh) <= 100), 
 	matKhau VARCHAR(64),
	gioiTinh NCHAR(3),
    CONSTRAINT sex_check CHECK (gioiTinh = N'Nam' OR gioiTinh = N'Nữ')
);

CREATE TABLE BanBe(
    ngDung1 CHAR(10) NOT NULL,
    ngDung2 CHAR(10) NOT NULL,
    -- Viet trigger delete 
    CONSTRAINT fr_check CHECK (ngDung1 != ngDung2),
    CONSTRAINT fr1_fk FOREIGN KEY(ngDung1) REFERENCES NguoiDung(sdt),
    CONSTRAINT fr2_fk FOREIGN KEY(ngDung2) REFERENCES NguoiDung(sdt),
    PRIMARY KEY(ngDung1, ngDung2)
);

-- DROP TABLE NguoiDung;
-- INSERT INTO NguoiDung VALUES ('0123456789', 'khang@gmail.com', 'Lê Duy Khang', '2004-01-12', '123', 'Nam');


CREATE TABLE KhachHang (
    sdt CHAR(10) PRIMARY KEY,
    CONSTRAINT customerPhone_fk FOREIGN KEY(sdt) REFERENCES NguoiDung(sdt) ON DELETE CASCADE,
    xa NVARCHAR(MAX),
    huyen NVARCHAR(MAX),
    tinh NVARCHAR(MAX),
    chiTiet NVARCHAR(MAX)
);

CREATE TABLE NhanVien (
    sdt CHAR(10) PRIMARY KEY,
    CONSTRAINT employeePhone_fk FOREIGN KEY(sdt) REFERENCES NguoiDung(sdt) ON DELETE CASCADE,
    luong INT,
    CONSTRAINT salary_check CHECK (luong >= 3000000), --min 3tr
    ngayBatDau DATE
);

CREATE TABLE TaiXe (
    sdt CHAR(10) PRIMARY KEY,
    kinhNghiem INT,
    CONSTRAINT driverExp_check CHECK (kinhNghiem >= 0),
    CONSTRAINT phoneDriver_fk FOREIGN KEY(sdt) REFERENCES NhanVien(sdt) ON DELETE CASCADE,
);

CREATE TABLE Xe (
    bienSo VARCHAR(10) PRIMARY KEY,
    taiXe CHAR(10) NOT NULL,
    CONSTRAINT vehDriver_fk FOREIGN KEY(taiXe) REFERENCES TaiXe(sdt) ON DELETE CASCADE,
);

CREATE TABLE BangLai (
    taiXe CHAR(10) NOT NULL,
    loaiBang CHAR(2),
    ngayHetHan DATE,
    CONSTRAINT license_check CHECK (loaiBang IN('A1','A2','B1','B2','C1')), --con nua
    PRIMARY KEY(taiXe, loaiBang)
);

CREATE TABLE NguoiQuanLy (
    sdt CHAR(10) PRIMARY KEY,
    CONSTRAINT managerPhone_fk FOREIGN KEY(sdt) REFERENCES NhanVien(sdt) ON DELETE CASCADE
);

CREATE TABLE CapBac (
    nguoiQuanLy CHAR(10),
    capBac NVARCHAR(255),
    CONSTRAINT mgrLevel_fk FOREIGN KEY(nguoiQuanLy) REFERENCES NguoiQuanLy(sdt) ON DELETE CASCADE,
    PRIMARY KEY(nguoiQuanLy, capBac)
);

CREATE TABLE Tram (
    stt INT IDENTITY(1,1) PRIMARY KEY,
    nguoiQuanLy CHAR(10), 
    CONSTRAINT stationManger_fk FOREIGN KEY(nguoiQuanLy) REFERENCES NguoiQuanLy(sdt),
    xa NVARCHAR(MAX),
    huyen NVARCHAR(MAX),
    tinh NVARCHAR(MAX),
    chiTiet NVARCHAR(MAX)
);

-- DROP TABLE Tram;

CREATE TABLE TramLamViec(
    nhanVien CHAR(10) PRIMARY KEY,
    tram INT NOT NULL,
    CONSTRAINT empWorkAt_fk FOREIGN KEY(nhanVien) REFERENCES NhanVien(sdt) ON DELETE CASCADE,
    CONSTRAINT stationWorkAt_fk FOREIGN KEY(tram) REFERENCES Tram(stt) ON DELETE CASCADE
);

---- cac bang lien quan den business logic (don hang, hoa don, ...)
CREATE TABLE HoaDon (
    maHoaDon CHAR(10) PRIMARY KEY,
    tongTien INT DEFAULT 0,
    CONSTRAINT totalCheck CHECK (tongTien >= 0),
    tinhTrang NVARCHAR(MAX) DEFAULT N'Chưa thanh toán',
    CONSTRAINT billStt_check CHECK (tinhTrang = N'Đã thanh toán' OR tinhTrang = N'Chưa thanh toán' OR tinhTrang = N'Đã huỷ')
);

CREATE TABLE DonHang (
    maDonHang CHAR(10) PRIMARY KEY,        
    nguoiTaoDon CHAR(10),
    CONSTRAINT cusOrder_fk FOREIGN KEY(nguoiTaoDon) REFERENCES KhachHang(sdt) ON DELETE CASCADE,           
    sdtNguoiNhan CHAR(10) NOT NULL,
    hoTenNguoiNhan NVARCHAR(MAX) NOT NULL,     
    tinhTrang NVARCHAR(MAX) DEFAULT N'Đang giao', 
    CONSTRAINT ordStt_check CHECK (tinhTrang = N'Đã giao' OR tinhTrang = N'Đang giao' OR tinhTrang = N'Đã huỷ') ,
    ngayTao DATE DEFAULT GETDATE(),     
    gia INT DEFAULT 0,               
    xa NVARCHAR(MAX) NOT NULL,           
    huyen NVARCHAR(MAX) NOT NULL,             
    tinh NVARCHAR(MAX) NOT NULL,              
    chiTiet NVARCHAR(MAX),
    hoaDon CHAR(10),
    CONSTRAINT bill_fk FOREIGN KEY(hoaDon) REFERENCES HoaDon(maHoaDon) ON DELETE SET NULL
);

-- SELECT * FROM DonHang;

CREATE TABLE GoiHang (
    donHang CHAR(10) NOT NULL,
    stt INT NOT NULL,
    canNang INT NOT NULL,
    gia INT DEFAULT 0,
    CONSTRAINT m_check CHECK (canNang > 0),
    moTa NVARCHAR(MAX),
    CONSTRAINT pkgOrd_fk FOREIGN KEY(donHang) REFERENCES DonHang(maDonHang) ON DELETE CASCADE,
    PRIMARY KEY (donHang, stt)
);


CREATE TABLE Tuyen(
    donHang CHAR(10),
    CONSTRAINT routeOrd_fk FOREIGN KEY (donHang) REFERENCES DonHang(maDonHang) ON DELETE CASCADE,
    stt INT,
    PRIMARY KEY(donHang, stt),
    tinhTrang NVARCHAR(MAX),
    CONSTRAINT routeStt_check CHECK (tinhTrang = N'Hoàn thành' OR tinhTrang = N'Chưa hoàn thành'),
    quangDuong INT,
    xaBD NVARCHAR(MAX),
    huyenBD NVARCHAR(MAX),
    tinhBD NVARCHAR(MAX),
    chiTietBD NVARCHAR(MAX),
    xaKT NVARCHAR(MAX),
    huyenKT NVARCHAR(MAX),
    tinhKT NVARCHAR(MAX),
    chiTietKT NVARCHAR(MAX)
);

CREATE TABLE DamNhan(
    donHang CHAR(10) NOT NULL,
    tuyen INT NOT NULL,
    tram INT NOT NULL,
    taiXe CHAR(10),
    
    CONSTRAINT stationM_fk FOREIGN KEY (tram) REFERENCES Tram(stt) ON DELETE CASCADE,
    -- on delete driver set null
    CONSTRAINT driverM_fk FOREIGN KEY (taiXe) REFERENCES TaiXe(sdt),
    CONSTRAINT routeM_fk FOREIGN KEY (donHang, tuyen) REFERENCES Tuyen(donHang, stt) ON DELETE CASCADE,
    PRIMARY KEY (donHang, tuyen)
);


CREATE TABLE NhanGoiHang(
    maNhan CHAR(3) PRIMARY KEY,
    loaiHang NVARCHAR(MAX) NOT NULL,
    phiDichVu INT NOT NULL,
    CONSTRAINT phi_check CHECK (phiDichVu > 0)
);

CREATE TABLE DuocGan(
    donHang CHAR(10) NOT NULL,
    goiHang INT NOT NULL,
	maNhan CHAR(3) NOT NULL,
	
	PRIMARY KEY (donHang, goiHang, maNhan),
	CONSTRAINT ordPkg_fk FOREIGN KEY (donHang, goiHang) REFERENCES GoiHang(donHang, stt) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT label_fk FOREIGN KEY (maNhan) REFERENCES NhanGoiHang(maNhan) ON DELETE CASCADE,
);


CREATE TABLE GiaoDich(
    maGiaoDich CHAR(10) PRIMARY KEY,
    hoaDon CHAR(10) NOT NULL,
    CONSTRAINT transBill_fk FOREIGN KEY(hoaDon) REFERENCES HoaDon(maHoaDon) ON DELETE CASCADE,
    soTien INT NOT NULL,
    thoiDiem DATETIME DEFAULT GETDATE(),
    phuongThuc NVARCHAR(MAX),
    CONSTRAINT transMethod_check CHECK (phuongThuc = N'Tiền mặt' OR phuongThuc = N'Thẻ' OR phuongThuc = N'Chuyển khoản'),
    tinhTrang NVARCHAR(MAX),
    CONSTRAINT transStt_check CHECK (tinhTrang = N'Thành công' OR tinhTrang = N'Thất bại')
);


-- trigger

GO
CREATE OR ALTER TRIGGER friend_check
ON BanBe
AFTER INSERT
AS
BEGIN
		IF TRIGGER_NESTLEVEL() > 1
				RETURN;
		DECLARE @ngDung1 CHAR(10), @ngDung2 CHAR(10);
		SELECT @ngDung1 = ngDung1, @ngDung2 = ngDung2 FROM inserted;
		IF @ngDung1 = @ngDung2
		BEGIN
				PRINT N'Không thể kết bạn với chính mình';
				ROLLBACK TRANSACTION;
		END
END;


GO 
CREATE OR ALTER TRIGGER manager_check
ON Tram
AFTER INSERT
AS
BEGIN
		IF TRIGGER_NESTLEVEL() > 1
				RETURN;
		DECLARE @sdt CHAR(10);
		DECLARE @tram INT;
		SELECT @sdt = nguoiQuanLy, @tram = stt FROM inserted;
        IF @sdt != NULL
            IF NOT EXISTS (SELECT 1 FROM TramLamViec WHERE nhanVien = @sdt AND tram = @tram)
            BEGIN
                    PRINT N'Người quản lý không làm việc ở trạm này';
                    ROLLBACK TRANSACTION;
            END
END;

GO
CREATE OR ALTER TRIGGER route_check
ON Tuyen
AFTER INSERT
AS
BEGIN
    -- Avoid nested trigger execution
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;

    -- Check for duplicates in all rows in the inserted table
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE tinhBD = tinhKT
          AND huyenBD = huyenKT
          AND xaBD = xaKT
          AND chiTietBD = chiTietKT
    )
    BEGIN
        PRINT N'Điểm đầu và điểm cuối không thể trùng nhau';
        ROLLBACK TRANSACTION;
    END
END;


GO
CREATE OR ALTER TRIGGER trg_HashNguoiDungPassword
ON NguoiDung
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the hashed password, ensuring UTF-8 encoding
    UPDATE N
    SET N.matKhau = CONVERT(VARCHAR(64), 
        HASHBYTES('SHA2_256', CAST(I.matKhau AS VARBINARY(MAX))), 2)
    FROM NguoiDung N
    INNER JOIN inserted I
    ON N.sdt = I.sdt;
END;
GO

CREATE OR ALTER TRIGGER phone_check
ON DonHang
AFTER INSERT
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
    DECLARE @sdt CHAR(10);
    DECLARE @nguoiTao CHAR(10);
    SELECT @sdt = sdtNguoiNhan, @nguoiTao = nguoiTaoDon FROM inserted;
    IF @sdt = @nguoiTao
    BEGIN
        PRINT N'Không thể giao hàng cho chính mình';
        ROLLBACK TRANSACTION;
    END
END;



    -- USE master;
    -- DECLARE @sql NVARCHAR(MAX) = N'';

    -- SELECT @sql += 'KILL ' + CAST(session_id AS NVARCHAR(10)) + ';' + CHAR(13)
    -- FROM sys.dm_exec_sessions
    -- WHERE database_id = DB_ID('delivery');

    -- EXEC sp_executesql @sql;

    -- DROP DATABASE delivery;
