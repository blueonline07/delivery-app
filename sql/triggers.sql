CREATE OR ALTER TRIGGER trg_UpdateGia
ON DuocGan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE GH
		SET GH.gia = GH.gia  + ISNULL(TongPhiDichVu, 0)
		FROM GoiHang GH
		INNER JOIN (
			SELECT 
				DG.donHang, 
				DG.GoiHang, 
				SUM(NhanGoiHang.PhiDichVu) AS TongPhiDichVu
			FROM inserted DG
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
CREATE OR ALTER TRIGGER trg_updateGiaHoaDon
on DonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		UPDATE HD
		SET HD.tongTien = HD.tongTien + ISNULL(TongPhiDichVu, 0)
		FROM HoaDon HD
		INNER JOIN (
			SELECT 
				DH.hoaDon,  
				SUM(DH.gia) AS TongPhiDichVu
			FROM inserted DH
			GROUP BY DH.hoaDon
		) DH 
		ON DH.hoaDon = HD.maHoaDon;
	END

	IF EXISTS (SELECT 1 FROM deleted)
	BEGIN 
		UPDATE HD
		SET HD.tongTien = HD.tongTien - ISNULL(TongPhiDichVu, 0)
		FROM HoaDon HD
		INNER JOIN (
			SELECT 
				DH.hoaDon,  
				SUM(DH.gia) AS TongPhiDichVu
			FROM deleted DH
			GROUP BY DH.hoaDon
		) DH 
		ON DH.hoaDon = HD.maHoaDon;
	END
END;



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
			WHERE H.tinhTrang = N'Đã thanh toán' or H.tinhTrang = N'Đã huỷ'
		)
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 50002, N'Bạn không thể thực hiện giao dịch trên đơn hàng đã thanh toán hoặc đã hủy', 1;
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
			UPDATE HD
			SET HD.tinhTrang = N'Đã huỷ'
			FROM HoaDon HD
			JOIN inserted I ON I.hoaDon = HD.maHoaDon;

			DELETE GD
			FROM GiaoDich GD
			JOIN inserted I ON GD.hoaDon = I.hoaDon;
			THROW 50002, N'Bạn không thể giao dịch nữa. Đơn hàng bị hủy.', 1;
		END
    END
END;