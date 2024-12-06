
-- Trigger update giá gói hàng
CREATE TRIGGER trg_UpdateGia
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


-- Trigger kiểm tra giao dịch
GO
CREATE TRIGGER trg_CheckGiaoDich
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
			FROM inserted I
			JOIN GiaoDich GD ON I.hoaDon = GD.hoaDon
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