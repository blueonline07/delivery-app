use Delivery
-- Trigger update giá gói hàng
GO
CREATE OR ALTER TRIGGER trg_UpdateGia
ON DuocGan
AFTER INSERT,  DELETE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE GH
		SET GH.gia = GH.canNang * 1 + ISNULL(TongPhiDichVu, 0)
		FROM GoiHang GH
		INNER JOIN (
			SELECT 
				DG.donHang, 
				DG.GoiHang, 
				SUM(NhanGoiHang.PhiDichVu) AS TongPhiDichVu
			FROM DuocGan DG
			INNER JOIN NhanGoiHang ON DG.maNhan = NhanGoiHang.maNhan
			GROUP BY DG.donHang, DG.GoiHang  
		) DG 
		ON GH.donHang = DG.donHang AND GH.stt = DG.GoiHang; 
	END

	IF EXISTS (SELECT 1 FROM deleted)
	BEGIN 
		UPDATE GH
		SET GH.gia = GH.gia - ISNULL(TongPhiDichVu, 0)
		FROM GoiHang GH
		INNER JOIN (
			SELECT 
				DG.donHang, 
				DG.GoiHang, 
				SUM(NhanGoiHang.PhiDichVu) AS TongPhiDichVu
			FROM deleted DG
			INNER JOIN NhanGoiHang ON DG.maNhan = NhanGoiHang.maNhan
			GROUP BY DG.donHang, DG.GoiHang  
		) DG 
		ON GH.donHang = DG.donHang AND GH.stt = DG.GoiHang; 
	END
END;


-- -- Trigger kiểm tra giao dịch
GO
CREATE OR ALTER TRIGGER trg_CheckGiaoDich
ON GiaoDich
AFTER INSERT, UPDATE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;

    IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		IF EXISTS(
			SELECT 1
			FROM HoaDon H
			JOIN inserted I ON H.maHoaDon = I.hoaDon
			WHERE H.tinhTrang = N'Đã thanh toán' or H.tinhTrang = N'Đã hủy'
		)
		BEGIN
			PRINT N'Bạn không thể giao dịch nữa.';
			ROLLBACK TRANSACTION;
		END
		IF EXISTS (
			SELECT 1
			FROM GiaoDich GD
			JOIN inserted I ON I.hoaDon = GD.hoaDon
			GROUP BY I.hoaDon
			HAVING COUNT(GD.hoaDon) > 3
		)
		BEGIN
			PRINT N'Bạn không thể giao dịch nữa. Đơn hàng đã đạt giới hạn giao dịch.';
			ROLLBACK TRANSACTION;
		END
		
		IF EXISTS(
			SELECT 1
			FROM inserted I
			WHERE I.tinhTrang = N'Thành công'
		)
		BEGIN
			PRINT N'Bạn đã thanh toán thành công';
			UPDATE HD
			SET HD.tinhTrang = N'Đã Thanh Toán'
			FROM HoaDon HD
			JOIN inserted I ON I.hoaDon = HD.maHoaDon
		END
		
		IF EXISTS (
			SELECT 1
			FROM inserted I
			JOIN GiaoDich GD ON I.hoaDon = GD.hoaDon
			WHERE I.tinhTrang = N'Thất bại'
			GROUP BY I.hoaDon
			HAVING COUNT(GD.hoaDon) >= 3
		)
		BEGIN
			PRINT N'Bạn không thể giao dịch nữa. Đơn hàng bị hủy.';
			UPDATE HD
			SET HD.tinhTrang = N'Đã Hủy'
			FROM HoaDon HD
			JOIN inserted I ON I.hoaDon = HD.maHoaDon;

			DELETE GD
			FROM GiaoDich GD
			JOIN inserted I ON GD.hoaDon = I.hoaDon;
		END
		END
	END;


GO

CREATE OR ALTER TRIGGER trg_updateGiaTuyen
on Tuyen
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE DH
		SET DH.gia = DH.gia + ISNULL(TongPhiDichVu, 0)
		FROM DonHang DH
		INNER JOIN (
			SELECT 
				I.donHang,  
				SUM(I.quangDuong*7000) AS TongPhiDichVu
			FROM inserted I
			GROUP BY I.donHang
		) T 
		ON DH.maDonHang = T.donHang;
	END

	IF EXISTS (SELECT 1 FROM deleted)
	BEGIN 
		UPDATE DH
		SET DH.gia = DH.gia - ISNULL(TongPhiDichVu, 0)
		FROM DonHang DH
		INNER JOIN (
			SELECT 
				D.donHang,  
				SUM(D.quangDuong*7000) AS TongPhiDichVu
			FROM deleted D
			GROUP BY D.donHang
		) T 
		ON DH.maDonHang = T.donHang;
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



GO
CREATE OR ALTER TRIGGER trg_UpdateGiaDonHang
ON GoiHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;

    IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE DH
		SET DH.gia = DH.gia + ISNULL(TongPhiDichVu, 0)
		FROM DonHang DH
		INNER JOIN (
			SELECT 
				GH.donHang,  
				SUM(GH.gia) AS TongPhiDichVu
			FROM inserted GH
			GROUP BY GH.donHang
		) GH 
		ON DH.maDonHang = GH.donHang;
		RETURN
	END

	IF EXISTS (SELECT 1 FROM deleted)
	BEGIN 
		UPDATE DH
		SET DH.gia = DH.gia - ISNULL(TongPhiDichVu, 0)
		FROM DonHang DH
		INNER JOIN (
			SELECT 
				GH.donHang,  
				SUM(GH.gia) AS TongPhiDichVu
			FROM inserted GH
			GROUP BY GH.donHang
		) GH 
		ON DH.maDonHang = GH.donHang;
	END
END;

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

		IF NOT EXISTS (SELECT 1 FROM TramLamViec WHERE nhanVien = @sdt AND tram = @tram)
		BEGIN
				PRINT N'Người quản lý không làm việc ở trạm này';
				ROLLBACK TRANSACTION;
		END
END;