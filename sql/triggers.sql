
-- Trigger update giá gói hàng
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