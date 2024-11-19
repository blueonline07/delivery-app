CREATE TABLE DonHang (
    MaDonHang INT PRIMARY KEY,        
    NguoiTaoDon NVARCHAR(100),        
    Gia DECIMAL(10, 2),               
    SoDienThoaiNguoiNhan NVARCHAR(15),
    HoTenNguoiNhan NVARCHAR(100),     
    TinhTrang NVARCHAR(50),          
    QuangDuong DECIMAL(10, 2),        
    NgayTao DATE,                     
    XaPhuong NVARCHAR(100),           
    Huyen NVARCHAR(100),             
    Tinh NVARCHAR(100),              
    ChiTiet NVARCHAR(MAX)            
);

CREATE TABLE Tuyen (
    STT INT PRIMARY KEY,             
    MaDonHang INT,                    
    XaPhuongBD NVARCHAR(100),         
    HuyenBD NVARCHAR(100),          
    TinhBD NVARCHAR(100),            
    ChiTietBD NVARCHAR(MAX),        
    XaPhuongKT NVARCHAR(100),        
    HuyenKT NVARCHAR(100),           
    TinhKT NVARCHAR(100),            
    ChiTietKT NVARCHAR(MAX),          
    TinhTrang NVARCHAR(50),        
    CONSTRAINT FK_Tuyen_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
);

CREATE TABLE DamNhan (
    MaDonHang INT,                    
    Tram NVARCHAR(100),              
    TaiXe NVARCHAR(100),              
    Tuyen NVARCHAR(100),              
    PRIMARY KEY (MaDonHang, Tram),    
    CONSTRAINT FK_DamNhan_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
);

SELECT * FROM sys.tables;

INSERT INTO DonHang (MaDonHang, NguoiTaoDon, Gia, SoDienThoaiNguoiNhan, HoTenNguoiNhan, TinhTrang, QuangDuong, NgayTao, XaPhuong, Huyen, Tinh, ChiTiet)
VALUES
(1, N'Nguyen Van A', 1000000.00, N'0987654321', N'Tran Van B', N'Đang xử lý', 10.5, '2024-11-01', N'Phường 1', N'Quận 1', N'TP HCM', N'Giao hàng nhanh'),
(2, N'Tran Thi C', 1500000.00, N'0976543210', N'Lê Thị D', N'Hoàn thành', 20.0, '2024-11-02', N'Phường 2', N'Quận 3', N'TP HCM', N'Giao hàng hỏa tốc'),
(3, N'Hoang Van E', 500000.00, N'0965432109', N'Phạm Văn F', N'Đang xử lý', 5.2, '2024-11-03', N'Phường 5', N'Quận 5', N'TP HCM', N'Không cần ký nhận'),
(4, N'Nguyen Thi G', 2000000.00, N'0954321098', N'Nguyen Van H', N'Hủy đơn', 15.0, '2024-11-04', N'Phường 3', N'Quận 7', N'TP HCM', N'Khách yêu cầu hủy đơn'),
(5, N'Lê Văn I', 1200000.00, N'0943210987', N'Đỗ Thị J', N'Đang giao', 12.0, '2024-11-05', N'Phường 4', N'Quận 9', N'TP HCM', N'Giao hàng nội thành');

INSERT INTO Tuyen (STT, MaDonHang, XaPhuongBD, HuyenBD, TinhBD, ChiTietBD, XaPhuongKT, HuyenKT, TinhKT, ChiTietKT, TinhTrang)
VALUES
(1, 1, N'Phường 1', N'Quận 1', N'TP HCM', N'Kho tổng quận 1', N'Phường 1', N'Quận 1', N'TP HCM', N'Nhà riêng', N'Đang vận chuyển'),
(2, 2, N'Phường 2', N'Quận 3', N'TP HCM', N'Kho tổng quận 3', N'Phường 2', N'Quận 3', N'TP HCM', N'Công ty ABC', N'Hoàn thành'),
(3, 3, N'Phường 5', N'Quận 5', N'TP HCM', N'Kho trung chuyển quận 5', N'Phường 5', N'Quận 5', N'TP HCM', N'Nhà riêng', N'Đang xử lý'),
(4, 4, N'Phường 3', N'Quận 7', N'TP HCM', N'Kho tổng quận 7', N'Phường 3', N'Quận 7', N'TP HCM', N'Khách hủy nhận', N'Hủy đơn'),
(5, 5, N'Phường 4', N'Quận 9', N'TP HCM', N'Kho tổng quận 9', N'Phường 4', N'Quận 9', N'TP HCM', N'Nhà riêng', N'Đang vận chuyển');


INSERT INTO DamNhan (MaDonHang, Tram, TaiXe, Tuyen)
VALUES
(1, 'Tram Quan 1', 'Nguyen Van X', 'Tuyen 1'),
(2, 'Tram Quan 3', 'Tran Thi Y', 'Tuyen 2'),
(3, 'Tram Quan 5', 'Le Van Z', 'Tuyen 3'),
(4, 'Tram Quan 7', 'Pham Van M', 'Tuyen 4'),
(5, 'Tram Quan 9', 'Do Thi N', 'Tuyen 5');


SELECT * FROM DonHang;
SELECT * FROM Tuyen;
SELECT * FROM DamNhan;

DELETE FROM DonHang;
DELETE FROM Tuyen;
DELETE FROM DamNhan;
