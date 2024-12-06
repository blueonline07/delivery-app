-- Thêm dữ liệu vào bảng NguoiDung
INSERT INTO NguoiDung VALUES
('0123456789', 'khang.le@gmail.com', N'Lê Duy Khang', '2000-01-12', 'matkhau123', N'Nam'),
('0987654321', 'mai.anh@gmail.com', N'Trần Mai Anh', '1995-07-23', 'matkhau456', N'Nữ'),
('0912345678', 'quang.manager@gmail.com', N'Nguyễn Hữu Quang', '1980-10-05', 'matkhauadmin', N'Nam'),
('0976543210', 'tuan.hoang@gmail.com', N'Hoàng Tuấn', '1993-06-15', 'password789', N'Nam'),
('0908765432', 'lan.nguyen@gmail.com', N'Nguyễn Lan', '1988-09-08', 'securepass123', N'Nữ');

-- Thêm dữ liệu vào bảng KhachHang
INSERT INTO KhachHang VALUES
('0123456789', N'Phường 5', N'Quận 1', N'TP HCM', N'Số 12, Đường A'),
('0987654321', N'Phường 7', N'Quận Bình Thạnh', N'TP HCM', N'Số 45, Đường B'),
('0912345678', N'Phường 3', N'Quận Gò Vấp', N'TP HCM', N'Số 78, Đường C'),
('0976543210', N'Phường 9', N'Quận Tân Bình', N'TP HCM', N'Số 23, Đường D'),
('0908765432', N'Phường 12', N'Quận 5', N'TP HCM', N'Số 67, Đường E');

-- Thêm dữ liệu vào bảng NhanVien
INSERT INTO NhanVien VALUES
('0912345678', 7000000, '2015-08-01'),
('0976543210', 8000000, '2017-05-14'),
('0908765432', 7500000, '2016-11-21'),
('0123456789', 6500000, '2018-03-09'),
('0987654321', 7200000, '2019-06-10');

-- Thêm dữ liệu vào bảng TaiXe
INSERT INTO TaiXe VALUES
('0912345678', 5),
('0976543210', 3),
('0908765432', 7),
('0123456789', 4),
('0987654321', 6);

-- Thêm dữ liệu vào bảng Xe
INSERT INTO Xe VALUES
('59A-12345', '0912345678'),
('59A-54321', '0976543210'),
('59A-67890', '0908765432'),
('59A-11223', '0123456789'),
('59A-33245', '0987654321');

-- Thêm dữ liệu vào bảng BangLai
INSERT INTO BangLai VALUES
('0912345678', 'A2', '2025-12-31'),
('0976543210', 'A1', '2024-11-30'),
('0908765432', 'A2', '2026-02-28'),
('0123456789', 'A1', '2025-01-15'),
('0987654321', 'A2', '2027-06-20');

-- Thêm dữ liệu vào bảng NguoiQuanLy
INSERT INTO NguoiQuanLy VALUES
('0912345678'),
('0976543210'),
('0908765432'),
('0123456789'),
('0987654321');

-- Thêm dữ liệu vào bảng CapBac
INSERT INTO CapBac VALUES
('0912345678', N'Quản lý cấp cao'),
('0976543210', N'Quản lý cấp trung'),
('0908765432', N'Quản lý cấp thấp'),
('0123456789', N'Quản lý cấp cao'),
('0987654321', N'Quản lý cấp trung');

-- Thêm dữ liệu vào bảng Tram
INSERT INTO Tram VALUES
('0912345678', N'Phường 5', N'Quận 1', N'TP HCM', N'Số 12, Đường A'),
('0976543210', N'Phường 7', N'Quận Bình Thạnh', N'TP HCM', N'Số 45, Đường B'),
('0908765432', N'Phường 3', N'Quận Gò Vấp', N'TP HCM', N'Số 78, Đường C'),
('0123456789', N'Phường 9', N'Quận Tân Bình', N'TP HCM', N'Số 23, Đường D'),
('0987654321', N'Phường 12', N'Quận 5', N'TP HCM', N'Số 67, Đường E');

-- Thêm dữ liệu vào bảng TramLamViec
INSERT INTO TramLamViec VALUES
('0912345678', 1),
('0976543210', 2),
('0908765432', 3),
('0123456789', 4),
('0987654321', 5);

-- Thêm dữ liệu vào bảng DonHang
INSERT INTO DonHang VALUES
('DH00000001', '0123456789', '0987654321', N'Trần Mai Anh', N'Đang giao', DEFAULT, N'Phường 9', N'Quận Phú Nhuận', N'TP HCM', N'Số 11, Đường D'),
('DH00000002', '0912345678', '0976543210', N'Hoàng Tuấn', N'Đã giao', DEFAULT, N'Phường 5', N'Quận 1', N'TP HCM', N'Số 12, Đường A'),
('DH00000003', '0987654321', '0908765432', N'Nguyễn Lan', N'Đang giao', DEFAULT, N'Phường 7', N'Quận Bình Thạnh', N'TP HCM', N'Số 45, Đường B'),
('DH00000004', '0976543210', '0912345678', N'Lê Duy Khang', N'Đã huỷ', DEFAULT, N'Phường 3', N'Quận Gò Vấp', N'TP HCM', N'Số 78, Đường C'),
('DH00000005', '0908765432', '0987654321', N'Trần Mai Anh', N'Đang giao', DEFAULT, N'Phường 12', N'Quận 5', N'TP HCM', N'Số 67, Đường E');

-- Thêm dữ liệu vào bảng GoiHang
INSERT INTO GoiHang VALUES
('DH00000001', 1, 5, 200000, N'Hộp quà nhỏ'),
('DH00000002', 1, 3, 150000, N'Túi xách thời trang'),
('DH00000003', 1, 10, 500000, N'Máy tính xách tay'),
('DH00000004', 1, 8, 300000, N'Điện thoại di động'),
('DH00000005', 1, 4, 100000, N'Sách vở học sinh');

-- Thêm dữ liệu vào bảng Tuyen
INSERT INTO Tuyen VALUES
('DH00000001', 1, N'Hoàn thành', N'Phường 1', N'Quận 3', N'TP HCM', N'Số 5, Đường E', N'Phường 9', N'Quận Phú Nhuận', N'TP HCM', N'Số 11, Đường D'),
('DH00000002', 1, N'Chưa hoàn thành', N'Phường 5', N'Quận 1', N'TP HCM', N'Số 12, Đường A', N'Phường 5', N'Quận 1', N'TP HCM', N'Số 12, Đường A'),
('DH00000003', 1, N'Hoàn thành', N'Phường 7', N'Quận Bình Thạnh', N'TP HCM', N'Số 45, Đường B', N'Phường 7', N'Quận Bình Thạnh', N'TP HCM', N'Số 45, Đường B'),
('DH00000004', 1, N'Chưa hoàn thành', N'Phường 3', N'Quận Gò Vấp', N'TP HCM', N'Số 78, Đường C', N'Phường 3', N'Quận Gò Vấp', N'TP HCM', N'Số 78, Đường C'),
('DH00000005', 1, N'Hoàn thành', N'Phường 12', N'Quận 5', N'TP HCM', N'Số 67, Đường E', N'Phường 12', N'Quận 5', N'TP HCM', N'Số 67, Đường E');

-- Thêm dữ liệu vào bảng DamNhan
INSERT INTO DamNhan VALUES
('DH00000001', 1, 1, '0912345678'),
('DH00000002', 1, 2, '0976543210'),
('DH00000003', 1, 3, '0908765432'),
('DH00000004', 1, 4, '0123456789'),
('DH00000005', 1, 5, '0987654321');

-- Thêm dữ liệu vào bảng NhanGoiHang
INSERT INTO NhanGoiHang VALUES
('A01', N'Hàng dễ vỡ', 50000),
('A02', N'Hàng hóa cao cấp', 80000),
('A03', N'Sản phẩm điện tử', 120000),
('A04', N'Thuốc men', 30000),
('A05', N'Thực phẩm', 60000);

-- Thêm dữ liệu vào bảng DuocGan
INSERT INTO DuocGan VALUES
('DH00000001', 1, 'A01'),
('DH00000002', 1, 'A02'),
('DH00000003', 1, 'A03'),
('DH00000004', 1, 'A04'),
('DH00000005', 1, 'A05');

-- Thêm dữ liệu vào bảng HoaDon
INSERT INTO HoaDon VALUES
('HD00000001', 250000, N'Chưa thanh toán'),
('HD00000002', 450000, N'Chưa thanh toán'),
('HD00000003', 350000, N'Đã thanh toán'),
('HD00000004', 200000, N'Chưa thanh toán'),
('HD00000005', 500000, N'Đã thanh toán');

-- Thêm dữ liệu vào bảng GiaoDich
INSERT INTO GiaoDich VALUES
('GD00000001', 'HD00000001', 250000, '2024-12-01 14:30:00', N'Tiền mặt', N'Thành công'),
('GD00000002', 'HD00000002', 450000, '2024-12-02 10:00:00', N'Chuyển khoản', N'Thành công'),
('GD00000003', 'HD00000003', 350000, '2024-12-03 16:15:00', N'Tiền mặt', N'Thành công'),
('GD00000004', 'HD00000004', 200000, '2024-12-04 11:45:00', N'Tiền mặt', N'Thất bại'),
('GD00000005', 'HD00000005', 500000, '2024-12-05 13:20:00', N'Chuyển khoản', N'Thành công');

-- Thêm dữ liệu vào bảng ThanhToan
INSERT INTO ThanhToan VALUES
('HD00000001', 'DH00000001'),
('HD00000002', 'DH00000002'),
('HD00000003', 'DH00000003'),
('HD00000004', 'DH00000004'),
('HD00000005', 'DH00000005');
