
USE DELIVERY;

CREATE TABLE DonHang (
    DonHangID INT IDENTITY(1,1) PRIMARY KEY,
    NAME NVARCHAR(10)
);

CREATE TABLE GOI_HANG (
	GoiHangID INT NOT NULL, 
    DonHang INT NOT NULL,  
    Mota NVARCHAR(100),         
	CanNang FLOAT CHECK (CanNang > 0),
	Gia FLOAT  ,
	PRIMARY KEY (DonHang,GoiHangID),
	FOREIGN KEY (DonHang) REFERENCES DonHang(DonHangID) ON DELETE CASCADE,
);


Go
CREATE TRIGGER trg_GoiHang_Insert
ON GOI_HANG
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO GOI_HANG (GoiHangID, DonHang, Mota, CanNang, Gia)
    SELECT 
        ISNULL(MAX(GH.GoiHangID), 0) + 1 AS GoiHangID, 
        I.DonHang, 
        I.Mota, 
        I.CanNang, 
        I.CanNang
    FROM INSERTED I
    LEFT JOIN GOI_HANG GH
    ON GH.DonHang = I.DonHang
    GROUP BY I.DonHang, I.Mota, I.CanNang, I.Gia;
END;
GO

ALTER TABLE GOI_HANG
ADD CONSTRAINT chk_GoiHang_Gia CHECK (Gia >= 0);
ALTER TABLE GOI_HANG
ADD CONSTRAINT chk_GoiHang_Gia_vs_CanNang CHECK (Gia >= CanNang * 1);



CREATE TABLE NhanGoiHang(
	MaNhan INT PRIMARY KEY IDENTITY(1,1), 
    TenNhan NVARCHAR(100),
	PhiDichVu Float CHECK (PhiDichVu > 0),
)


CREATE TABLE DUOCGAN(
	MaNhan INT NOT NULL,
	GoiHang INT NOT NULL,
	DonHang INT NOT NULL,

	PRIMARY KEY (MaNhan,GoiHang,DonHang),
	FOREIGN KEY (DonHang,GoiHang) REFERENCES GOI_HANG(DonHang,GoiHangID) ON DELETE CASCADE,
	FOREIGN KEY (MaNhan) REFERENCES NhanGoiHang(MaNhan) ON DELETE CASCADE,
);



-- PROCEDURE thêm đơn hàng
GO

CREATE PROCEDURE sp_AddDonHang 
    @NAME NVARCHAR(10)
AS
BEGIN
    INSERT INTO DonHang (NAME)
    VALUES (@NAME);
END;



GO
CREATE PROCEDURE sp_AddGoiHang
	@DonHang Int,
    @Mota NVARCHAR(100),
    @CanNang FLOAT
AS
	BEGIN
		INSERT INTO GOI_HANG (DonHang,Mota, CanNang)
		VALUES (@DonHang,@Mota, @CanNang);
	END


GO
CREATE PROCEDURE sp_UpdateGoiHang
    @GoiHangID INT,
    @DonHang INT,
    @Mota NVARCHAR(100),
    @CanNang FLOAT
AS
BEGIN
    UPDATE GOI_HANG
    SET DonHang = @DonHang,
        Mota = @Mota,
        CanNang = @CanNang
    WHERE GoiHangID = @GoiHangID;
END;


Go
CREATE PROCEDURE sp_DeleteGoiHang
    @GoiHangID INT
AS
BEGIN
    DELETE FROM GOI_HANG
    WHERE GoiHangID = @GoiHangID;
END;


--NHÃN GÓI HÀNG
GO
CREATE PROCEDURE sp_AddNhan
	@Name NVARCHAR(100),
	@PhiDichVu FLOAT
AS
BEGIN
	 IF @PhiDichVu < 0
    BEGIN
        RAISERROR (N'Phí dịch vụ không thể âm', 16, 1);
        RETURN;
    END
	INSERT INTO	NhanGoiHang(TenNhan,PhiDichVu)
	VALUES (@Name,@PhiDichVu)
END;


-- Update giá

GO 
CREATE TRIGGER UpdateGia
ON DUOCGAN
AFTER INSERT, UPDATE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
    UPDATE GH
    SET GH.Gia = GH.CanNang * 1 + ISNULL(TongPhiDichVu, 0)
    FROM GOI_HANG GH
    INNER JOIN (
        SELECT 
            DG.GoiHang, 
            SUM(NhanGoiHang.PhiDichVu) AS TongPhiDichVu
        FROM DUOCGAN DG
        INNER JOIN NhanGoiHang ON DG.MaNhan = NhanGoiHang.MaNhan
        GROUP BY DG.GoiHang
    ) DG ON GH.GoiHangID = DG.GoiHang;
END;
GO



-- ADD DATA Nhãn
EXEC sp_AddNhan 
    @NAME = N'Dễ vỡ', 
    @PhiDichVu = 3000;

EXEC sp_AddNhan 
    @NAME = N'Hàng lạnh', 
    @PhiDichVu = 5000;

EXEC sp_AddNhan 
    @NAME = N'Hàng hóa nguy hiểm', 
    @PhiDichVu = 10000;
	
EXEC sp_AddNhan 
    @NAME = N'Hàng nhạy cảm', 
    @PhiDichVu = 4000;

EXEC sp_AddNhan 
    @NAME = N'Hàng dễ cháy', 
    @PhiDichVu = 8000;

EXEC sp_AddNhan 
    @NAME = N'Hàng giá trị cao', 
    @PhiDichVu = 5000;

EXEC sp_AddNhan 
    @NAME = N'Hàng điện tử', 
    @PhiDichVu = 2500;
EXEC sp_AddNhan 
    @NAME = N'Giấy tờ', 
    @PhiDichVu = 1500;

-- Đơn Hàng, Gói hàng
EXEC sp_AddDonHang
	@NAME = N'Test2'

EXEC sp_AddGoiHang @DonHang = 1,@Mota = N'Hàng lạnh và có giá trị', @CanNang = 5000
EXEC sp_AddGoiHang @DonHang = 1,@Mota = N'Thư từ', @CanNang = 500
EXEC sp_AddGoiHang @DonHang = 2,@Mota = N'Lọ thí nghiệm hóa học', @CanNang =6867

Insert into DUOCGAN(GoiHang,DonHang,MaNhan)
Values (2,1,7)
select * from DUOCGAN
