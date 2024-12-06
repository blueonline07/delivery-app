CREATE OR ALTER PROC insert_order
    @user CHAR(10), @rcv_phone CHAR(10), @rcv_name NVARCHAR(MAX),
    @xa NVARCHAR(MAX), @huyen NVARCHAR(MAX), @tinh NVARCHAR(MAX), @chiTiet NVARCHAR(MAX)
AS
BEGIN TRY
    -- Validate phone number: must be 10 digits and only numeric
    IF LEN(@rcv_phone) != 10 OR @rcv_phone NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        THROW 50001, N'Số điện thoại người nhận không hợp lệ (SĐT phải có 10 chữ số)', 1

    -- Validate receiver's name: should contain only alphabetic characters and spaces
    IF @rcv_name = '' OR @rcv_name NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Tên người nhận không hợp lệ', 1

    -- Validate the location fields (xa, huyen, tinh): should contain alphabetic characters and spaces
    IF @xa = '' OR @xa NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Xã không hợp lệ', 1
    IF @huyen = '' OR @huyen NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Huyện không hợp lệ', 1
    IF @tinh = '' OR @tinh NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Tỉnh không hợp lệ', 1
    -- Validate the details field: should not be empty
    IF @chiTiet = ''
        THROW 50001, N'Chi tiết không hợp lệ', 1

    DECLARE @nextID INT;
    DECLARE @id CHAR(10);
    DECLARE @prefix CHAR(2) = 'DH';

    SELECT @nextID = ISNULL(MAX(CAST(SUBSTRING(maDonHang, 3, LEN(maDonHang)) AS INT)), 0) + 1 FROM DonHang;
    SET @id = @prefix + RIGHT('00000000' + CAST(@NextID AS NVARCHAR), 8);

    -- Insert into DonHang table
    INSERT INTO DonHang (maDonHang, nguoiTaoDon, sdtNguoiNhan, hoTenNguoiNhan, xa, huyen, tinh, chiTiet)
    VALUES (@id, @user, @rcv_phone, @rcv_name, @xa, @huyen, @tinh, @chiTiet);
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- EXEC insert_order '0123456789','0123941245', N'Chào',  N'Xã gì đó', N'Huyện gì dods', N'hâh',N'hêh'

-- SELECT * FROM DonHang;
-- DELETE FROM DonHang WHERE maDonHang = 'DH00000013';

GO
CREATE OR ALTER PROCEDURE update_order
    @id CHAR(10), @rcv_phone CHAR(10), @rcv_name NVARCHAR(MAX), @xa NVARCHAR(MAX), @huyen NVARCHAR(MAX), @tinh NVARCHAR(MAX), @chiTiet NVARCHAR(MAX)
AS
BEGIN TRY
    IF LEN(@rcv_phone) != 10 OR @rcv_phone NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        THROW 50001, N'Số điện thoại người nhận không hợp lệ (SĐT phải có 10 chữ số)', 1

    -- Validate receiver's name: should contain only alphabetic characters and spaces
    IF @rcv_name = '' OR @rcv_name NOT LIKE '%[a-zA-Z ]%' 
        THROW 50001, N'Tên người nhận không hợp lệ', 1

    -- Validate the location fields (xa, huyen, tinh): should contain alphabetic characters and spaces
    IF @xa = '' OR @xa NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Xã không hợp lệ', 1
    IF @huyen = '' OR @huyen NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Huyện không hợp lệ', 1
    IF @tinh = '' OR @tinh NOT LIKE '%[a-zA-Z ]%'
        THROW 50001, N'Tỉnh không hợp lệ', 1

    -- Validate the details field: should not be empty
    IF @chiTiet = ''
        THROW 50001, N'Chi tiết không hợp lệ', 1

    UPDATE DonHang
    SET
        sdtNguoiNhan = @rcv_phone,
        hoTenNguoiNhan = @rcv_name,
        xa = @xa,
        huyen = @huyen,
        tinh = @tinh,
        chiTiet = @chiTiet
    WHERE maDonHang = @id;
    IF @@ROWCOUNT = 0
        THROW 50000, N'Mã đơn hàng không tồn tại', 1;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE()
END CATCH

-- SELECT * FROM DonHang;

-- EXEC update_order 'DH0001', '0123456789', 'HA HA HA', 'xaha', 'hueynha', 'tinhha', 'chitietha'


GO
CREATE OR ALTER PROCEDURE create_bill
    @orders NVARCHAR(MAX)
AS
BEGIN
    DECLARE @nextID INT;
    DECLARE @id CHAR(10);
    DECLARE @prefix CHAR(2) = 'HD';

    SELECT @nextID = ISNULL(MAX(CAST(SUBSTRING(maDonHang, 3, LEN(maDonHang)) AS INT)), 0) + 1 FROM DonHang;
    SET @id = @prefix + RIGHT('00000000' + CAST(@NextID AS NVARCHAR), 8);
    DECLARE @total INT;

    DECLARE @ord NVARCHAR(MAX)
    DECLARE cur CURSOR FOR SELECT value FROM string_split(@orders, ',');

    OPEN cur;
    FETCH NEXT FROM cur INTO @ord;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- call function total += calc_ord_price(ord)
        FETCH NEXT FROM cur INTO @ord;
    END

    CLOSE cur;
    DEALLOCATE cur;

    INSERT INTO HoaDon (maHoaDon, tongTien) VALUES (@id, @total);
END

-- EXEC create_bill '01', '01,02,03,04'



GO
CREATE OR ALTER PROCEDURE add_pkg
    @order CHAR(10), @description NVARCHAR(MAX), @weight INT, @labels VARCHAR(MAX)
AS
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM DonHang WHERE maDonHang = @order)
        THROW 50000, N'Mã đơn hàng không tồn tại', 1
    IF TRY_CAST(@weight AS INT) IS NULL
        THROW 50001, N'Cân nặng không hợp lệ', 1
    IF @weight <= 0
        THROW 50001, N'Cân nặng phải lớn hơn 0', 1

    DECLARE @id INT;
    SELECT @id = ISNULL(MAX(stt), 0) + 1 FROM GoiHang WHERE donHang = @order;

    INSERT INTO GoiHang(donHang, stt, moTa,  canNang, gia) VALUES (@order, @id,@description , @weight, @weight);
    -- Tinh tien
    DECLARE @price INT;
    DECLARE @val CHAR(3);
    DECLARE label_cur CURSOR FOR SELECT value FROM string_split(@labels, ',');
    OPEN label_cur;

    FETCH NEXT FROM label_cur INTO @val;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO DuocGan VALUES (@order, @id, @val) 
        FETCH NEXT FROM label_cur INTO @val;
    END

    CLOSE label_cur;
    DEALLOCATE label_cur;

END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE()
END CATCH

EXEC add_pkg 'DH00000001', N'Hâhhaa', 10000, 'A01,A02'
-- SELECT * FROM GoiHang;

-- DELETE FROM GoiHang WHERE donHang = 'DH00000001' AND stt = 2

GO
CREATE OR ALTER PROCEDURE rm_pkg
    @order CHAR(10), @stt INT
AS
BEGIN TRY
    DELETE FROM GoiHang WHERE stt = @stt AND donHang = @order;
    IF @@ROWCOUNT = 0
        THROW 50000, N'Gói hàng không tồn tại', 1
    ELSE
        UPDATE goiHang
		SET stt = stt - 1
		WHERE stt > @STT AND donHang = @order;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH


-- 1.2.3: DonHang and GoiHang
CREATE OR ALTER PROCEDURE getDonHang @sdt CHAR (10), @minCanNang DECIMAL(10,2), @minNgayTao DATE, @maxNgayTao DATE
AS
BEGIN
	SELECT maDonHang, ngayTao, hoTenNguoiNhan, sdtNguoiNhan, xa, huyen, tinh, chiTiet, tinhTrang, SUM(canNang) AS tongCanNang
	FROM DonHang AS D, GoiHang AS G
	WHERE D.maDonHang = G.donHang AND nguoiTaoDon = @sdt AND ngayTao >= @minNgayTao AND ngayTao <= @maxNgayTao
	GROUP BY D.maDonHang, ngayTao, hoTenNguoiNhan, sdtNguoiNhan, xa, huyen, tinh, chiTiet, tinhTrang
	HAVING SUM(canNang) >= @minCanNang
	ORDER BY ngayTao, SUM(canNang)
END;

EXEC getDonHang '0123456789', 2.0, '20110618', '20241201'  
