
-- Insert data into NguoiDung
INSERT INTO NguoiDung VALUES 
('0123456789', 'khang@gmail.com', N'Lê Duy Khang', '2004-01-12', '123', N'Nam'),
('0123456788', 'minh@gmail.com', N'Nguyễn Văn Minh', '1990-05-20', '123', N'Nam'),
('0123456787', 'hoa@gmail.com', N'Phạm Thị Hoa', '1985-03-15', '123', N'Nữ'),
('0123456786', 'linh@gmail.com', N'Trần Thị Linh', '1995-07-22', '123', N'Nữ'),
('0123456785', 'son@gmail.com', N'Hoàng Văn Sơn', '2000-11-30', '123', N'Nam');

-- Insert data into BanBe
INSERT INTO BanBe VALUES 
('0123456789', '0123456788'),
('0123456789', '0123456787'),
('0123456788', '0123456787'),
('0123456786', '0123456785'),
('0123456785', '0123456789');

-- Insert data into KhachHang
INSERT INTO KhachHang VALUES 
('0123456789', N'Phường 1', N'Quận 1', N'TP HCM', N'123 Đường ABC'),
('0123456788', N'Phường 2', N'Quận 2', N'TP HCM', N'456 Đường DEF'),
('0123456787', N'Phường 3', N'Quận 3', N'TP HCM', N'789 Đường GHI'),
('0123456786', N'Phường 4', N'Quận 4', N'TP HCM', N'101 Đường JKL'),
('0123456785', N'Phường 5', N'Quận 5', N'TP HCM', N'112 Đường MNO');

-- Insert data into NhanVien
INSERT INTO NhanVien VALUES 
('0123456789', 5000000, '2020-01-01'),
('0123456788', 4000000, '2019-05-15'),
('0123456787', 6000000, '2018-03-10'),
('0123456786', 7000000, '2021-07-20'),
('0123456785', 8000000, '2022-11-30');

-- Insert data into TaiXe
INSERT INTO TaiXe VALUES 
('0123456789', 2),
('0123456788', 3),
('0123456787', 1),
('0123456786', 5),
('0123456785', 4);

-- Insert data into Xe
INSERT INTO Xe VALUES 
('79A-12345', '0123456789'),
('79A-67890', '0123456788'),
('79A-11111', '0123456787'),
('79A-22222', '0123456786'),
('79A-33333', '0123456785');

-- Insert data into BangLai
INSERT INTO BangLai VALUES 
('0123456789', 'A1', '2025-01-01'),
('0123456788', 'A2', '2024-05-15'),
('0123456787', 'A1', '2023-03-10'),
('0123456786', 'A2', '2026-07-20'),
('0123456785', 'A1', '2027-11-30');

-- Insert data into NguoiQuanLy
INSERT INTO NguoiQuanLy VALUES 
('0123456789'),
('0123456788'),
('0123456787'),
('0123456786'),
('0123456785');

-- Insert data into CapBac
INSERT INTO CapBac VALUES 
('0123456789', N'Quản lý cấp cao'),
('0123456788', N'Quản lý trung cấp'),
('0123456787', N'Quản lý cấp thấp'),
('0123456786', N'Quản lý cấp cao'),
('0123456785', N'Quản lý trung cấp');

-- Insert data into Tram
INSERT INTO Tram VALUES 
('0123456789', N'Phường 1', N'Quận 1', N'TP HCM', N'123 Đường ABC'),
('0123456788', N'Phường 2', N'Quận 2', N'TP HCM', N'456 Đường DEF'),
('0123456787', N'Phường 3', N'Quận 3', N'TP HCM', N'789 Đường GHI'),
('0123456786', N'Phường 4', N'Quận 4', N'TP HCM', N'101 Đường JKL'),
('0123456785', N'Phường 5', N'Quận 5', N'TP HCM', N'112 Đường MNO');

-- Insert data into TramLamViec
INSERT INTO TramLamViec VALUES 
('0123456789', 1),
('0123456788', 2),
('0123456787', 3),
('0123456786', 4),
('0123456785', 5);

-- Insert data into DonHang
INSERT INTO DonHang VALUES 
('DH001', '0123456789', '0123456788', N'Nguyễn Văn A', N'Đã giao', '2023-01-01', N'Phường 1', N'Quận 1', N'TP HCM', N'123 Đường ABC'),
('DH002', '0123456788', '0123456787', N'Nguyễn Văn B', N'Đang giao', '2023-02-01', N'Phường 2', N'Quận 2', N'TP HCM', N'456 Đường DEF'),
('DH003', '0123456787', '0123456786', N'Nguyễn Văn C', N'Đã huỷ', '2023-03-01', N'Phường 3', N'Quận 3', N'TP HCM', N'789 Đường GHI'),
('DH004', '0123456786', '0123456785', N'Nguyễn Văn D', N'Đã giao', '2023-04-01', N'Phường 4', N'Quận 4', N'TP HCM', N'101 Đường JKL'),
('DH005', '0123456785', '0123456789', N'Nguyễn Văn E', N'Đang giao', '2023-05-01', N'Phường 5', N'Quận 5', N'TP HCM', N'112 Đường MNO');

-- Insert data into GoiHang
INSERT INTO GoiHang VALUES 
('DH001', 1, 2.5, 50000, N'Hàng dễ vỡ'),
('DH002', 1, 1.0, 20000, N'Hàng nhẹ'),
('DH003', 1, 3.0, 70000, N'Hàng nặng'),
('DH004', 1, 4.5, 100000, N'Hàng cồng kềnh'),
('DH005', 1, 2.0, 40000, N'Hàng dễ vỡ');

-- Insert data into Tuyen
INSERT INTO Tuyen VALUES 
('DH001', 1, N'Hoàn thành', N'Phường 1', N'Quận 1', N'TP HCM', N'123 Đường ABC', N'Phường 2', N'Quận 2', N'TP HCM', N'456 Đường DEF'),
('DH002', 1, N'Chưa hoàn thành', N'Phường 2', N'Quận 2', N'TP HCM', N'456 Đường DEF', N'Phường 3', N'Quận 3', N'TP HCM', N'789 Đường GHI'),
('DH003', 1, N'Hoàn thành', N'Phường 3', N'Quận 3', N'TP HCM', N'789 Đường GHI', N'Phường 4', N'Quận 4', N'TP HCM', N'101 Đường JKL'),
('DH004', 1, N'Chưa hoàn thành', N'Phường 4', N'Quận 4', N'TP HCM', N'101 Đường JKL', N'Phường 5', N'Quận 5', N'TP HCM', N'112 Đường MNO'),
('DH005', 1, N'Hoàn thành', N'Phường 5', N'Quận 5', N'TP HCM', N'112 Đường MNO', N'Phường 1', N'Quận 1', N'TP HCM', N'123 Đường ABC');

-- Insert data into DamNhan
INSERT INTO DamNhan VALUES 
('DH001', 1, 1, '0123456789'),
('DH002', 1, 2, '0123456788'),
('DH003', 1, 3, '0123456787'),
('DH004', 1, 4, '0123456786'),
('DH005', 1, 5, '0123456785');

-- Insert data into NhanGoiHang
INSERT INTO NhanGoiHang VALUES 
('N01', N'Hàng dễ vỡ'),
('N02', N'Hàng nhẹ'),
('N03', N'Hàng nặng'),
('N04', N'Hàng cồng kềnh'),
('N05', N'Hàng dễ vỡ');

-- Insert data into DuocGan
INSERT INTO DuocGan VALUES 
('DH001', 1, 'N01'),
('DH002', 1, 'N02'),
('DH003', 1, 'N03'),
('DH004', 1, 'N04'),
('DH005', 1, 'N05');

-- Insert data into HoaDon
INSERT INTO HoaDon VALUES 
('HD001', 50000, N'Đã thanh toán'),
('HD002', 20000, N'Chưa thanh toán'),
('HD003', 70000, N'Đã thanh toán'),
('HD004', 100000, N'Chưa thanh toán'),
('HD005', 40000, N'Đã thanh toán');

-- Insert data into GiaoDich
INSERT INTO GiaoDich VALUES 
('GD001', 'HD001', 50000, '2023-01-01 10:00:00', N'Tiền mặt', N'Thành công'),
('GD002', 'HD002', 20000, '2023-02-01 11:00:00', N'Thẻ', N'Thất bại'),
('GD003', 'HD003', 70000, '2023-03-01 12:00:00', N'Chuyển khoản NH', N'Thành công'),
('GD004', 'HD004', 100000, '2023-04-01 13:00:00', N'Tiền mặt', N'Thất bại'),
('GD005', 'HD005', 40000, '2023-05-01 14:00:00', N'Thẻ', N'Thành công');

-- Insert data into ThanhToan
INSERT INTO ThanhToan VALUES 
('HD001', 'DH001'),
('HD002', 'DH002'),
('HD003', 'DH003'),
('HD004', 'DH004'),
('HD005', 'DH005');