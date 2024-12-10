import express from "express";
import sql from "mssql";
import { pool } from "../db.js";
const router = express.Router();

router.post("/data", async (req, res) => {
  const { draw, start, length, search, order, columns, phone } = req.body;
  try {
    // Query total records
    const totalRecords = await pool
    .request()
    .input("phone", sql.Char, phone)
    .query("SELECT COUNT(*) AS total FROM DonHang WHERE nguoiTaoDon = @phone AND hoaDon IS NULL");
    // Query filtered records
    const filteredRecords = await pool
    .request()
    .input("phone", sql.Char, phone)
    .input("searchValue", sql.NVarChar, `%${search.value}%`)
    .query(
      "SELECT COUNT(*) AS total FROM DonHang WHERE maDonHang LIKE @searchValue AND nguoiTaoDon = @phone AND hoaDon IS NULL"
    );
    
    const data = await pool
      .request()
      .query(`
          SELECT * 
          FROM DonHang 
          WHERE nguoiTaoDon = '${phone}' 
            AND sdtNguoiNhan LIKE N'%${search.value}%' AND hoaDon IS NULL
          ORDER BY ${columns[order[0].column].data} ${order[0].dir} 
          OFFSET ${start} ROWS 
          FETCH NEXT ${length} ROWS ONLY;
      `);

    res.json({
      draw,
      recordsTotal: totalRecords.recordset[0].total,
      recordsFiltered: filteredRecords.recordset[0].total,
      data: data.recordset,
    });
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});
router.get("/bill/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool
      .request()
      .query(
        `SELECT HD.maHoaDon, HD.tongTien, HD.tinhTrang, DH.maDonHang, DH.hoTenNguoiNhan, DH.sdtNguoiNhan, DH.ngayTao, DH.gia, DH.tinh, DH.huyen, DH.xa, DH.chiTiet
         FROM HoaDon HD
         JOIN DonHang DH ON HD.maHoaDon = DH.hoaDon
         WHERE HD.maHoaDon = '${id}'`
      );
    res.status(200).json(result.recordset);
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});
router.post("/make", async (req, res) => {
  const selectedOrders = req.body
  try {

    const result = await pool.request()
      .query("SELECT TOP 1 maHoaDon FROM HoaDon WHERE maHoaDon LIKE 'HD%' ORDER BY maHoaDon DESC");
    const latestOrderID = result.recordset[0]?.maHoaDon;
    let hoadonID;
      // Kiểm tra kết quả và in ra
    if (latestOrderID) {
        hoadonID = latestOrderID.slice(2);
        let number = parseInt(hoadonID) + 1;
        hoadonID = "HD" + number.toString().padStart(8, "0");
    } else {
      hoadonID = "HD00000001";
    }
    const hoadon = await pool
      .request()
      .query(
        `INSERT INTO HoaDon VALUES
        ('${hoadonID}', 0, N'Chưa thanh toán')`
      );
    console.log(selectedOrders);
    selectedOrders.forEach(async (element) => {
      await pool
        .request()
        .query("UPDATE DonHang SET hoaDon = '" + hoadonID + "' WHERE maDonHang = '" + element + "'");
    });
    res.status(201).json({ hoadonID });
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

router.get("/transaction/:id/", async (req, res) => {
  const { id } = req.params;
  try {
    console.log(id);
    let response = await pool
      .request()
      .query(
        ` SELECT HD.maHoaDon, ND.hoTen , ND.sdt , SUM(DH.gia) as tongTien
          FROM HoaDon HD
          JOIN DonHang DH ON HD.maHoaDon = DH.hoaDon
          JOIN NguoiDung ND ON DH.nguoiTaoDon = ND.sdt
          WHERE HD.maHoaDon = '${id}'
          GROUP BY HD.maHoaDon, ND.hoTen , ND.sdt
          `
      );
    console.log(response.recordset);
    res.json(response.recordset);
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

router.post("/transaction/:id/", async (req, res) => {
  const { id } = req.params; // Mã hóa đơn
  const { soTien, hinhThuc, tinhTrang } = req.body; // Nhận thông tin từ request body
  const thoiGian = new Date(); // Lấy thời gian hiện tại
  console.log(id, soTien, hinhThuc, tinhTrang, thoiGian);
  try {
    const result = await pool.request()
      .query("SELECT TOP 1 maGiaoDich FROM GiaoDich WHERE maGiaoDich LIKE 'GD%' ORDER BY maGiaoDich DESC");
    const latestOrderID = result.recordset[0]?.maGiaoDich;
    let giaodichID;
      // Kiểm tra kết quả và in ra
    if (latestOrderID) {
        giaodichID = latestOrderID.slice(2);
        let number = parseInt(giaodichID) + 1;
        giaodichID = "GD" + number.toString().padStart(8, "0");
    } else {
      giaodichID = "GD00000001";
    }
    const response = await pool.request()
      .query(
        `INSERT INTO GiaoDich (maGiaoDich, hoaDon, soTien, phuongThuc, tinhTrang, thoiDiem)
         VALUES ('${giaodichID}', '${id}', ${soTien}, N'${hinhThuc}', N'${tinhTrang}', '${thoiGian.toISOString()}')`
      );

    console.log(response.recordset);
    res.json({ success: true, message: "Giao dịch thành công", data: response.recordset });
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error"+ error);
  }
});
export default router;
