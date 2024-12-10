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

-- Dem so don hang > X goi hang tu ngay .. -> ngay ...
CREATE OR ALTER FUNCTION ord_pkg_filter
(
    @start DATE, @end DATE, @minPkg INT
)
RETURNS @result TABLE
(
    id CHAR(10),
    val INT
)
AS
BEGIN
    DECLARE cur CURSOR FOR SELECT maDonHang FROM DonHang WHERE ngayTao >= @start AND ngayTao <= @end;

    OPEN cur;
    DECLARE @id CHAR(10);
    DECLARE @val INT;
    FETCH NEXT FROM cur INTO @id;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @val = COUNT(*) 
        FROM GoiHang p
        INNER JOIN DonHang o ON p.donHang = o.maDonHang
        WHERE o.maDonHang = @id;

        IF @val > @minPkg
            INSERT INTO @result VALUES (@id, @val)
        FETCH NEXT FROM cur INTO @id;
    END

    CLOSE cur;
    DEALLOCATE cur;
    RETURN;
END;



CREATE FUNCTION dbo.TinhSoGoiHangNhieuNhan (
    @maDonHang CHAR(10), @soluong INT
)
RETURNS INT
AS
BEGIN
    DECLARE @soGoiHang INT = 0;
    DECLARE @goiHang CHAR(10);
    DECLARE @maNhanList TABLE (maNhan CHAR(3));
    
    DECLARE cur CURSOR FOR
    SELECT goiHang
    FROM DuocGan
    WHERE donHang = @maDonHang
    GROUP BY goiHang;
    
    OPEN cur;
    FETCH NEXT FROM cur INTO @goiHang;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        INSERT INTO @maNhanList
        SELECT maNhan
        FROM DuocGan
        WHERE donHang = @maDonHang AND goiHang = @goiHang;
        IF (SELECT COUNT(*) FROM @maNhanList) > @soluong
        BEGIN
            SET @soGoiHang = @soGoiHang + 1;
        END
        DELETE FROM @maNhanList;
        
        FETCH NEXT FROM cur INTO @goiHang;
    END
    
    CLOSE cur;
    DEALLOCATE cur;
    
    RETURN @soGoiHang;
END;
GO