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
    
    selectedOrders.forEach(async (element) => {
      await pool
        .request()
        .query("UPDATE DonHang SET hoaDon = '" + hoadonID + "' WHERE maDonHang = '" + element + "'");
    });
  //   const newId = result.output.NewID;
  //   console.log(newId);
  //   packages.forEach(async (element) => {
  //     await pool
  //       .request()
  //       .input("description", sql.NVarChar, element.description)
  //       .input("weight", sql.Float, element.weight)
  //       .input("labels", sql.NVarChar, element.labels)
  //       .input("orderId", sql.NVarChar, newId)
  //       .query("EXEC add_pkg @orderId, @description, @weight, @labels");
  //   });
    
  //   res.status(201).json({ message: "Order added successfully!" });
  // } catch (error) {
  //   console.error(error);
  //   res.status(500).send("Internal Server Error");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

router.put("/:id/", async (req, res) => {
  const { id } = req.params;
  const { receiverPhone, receiver, province, district, commune, detail } = req.body;
  try {
    await pool
      .request()
      .input("id", sql.NVarChar, id)
      .input("receiverPhone", sql.NVarChar, receiverPhone)
      .input("receiver", sql.NVarChar, receiver)
      .input("province", sql.NVarChar, province)
      .input("district", sql.NVarChar, district)
      .input("commune", sql.NVarChar, commune)
      .input("detail", sql.NVarChar, detail)
      .query(
        "EXEC update_order @id, @receiverPhone, @receiver, @province, @district, @commune, @detail"
      );

    res.json({ message: "Order updated successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});


export default router;
