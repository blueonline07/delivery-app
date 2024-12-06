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