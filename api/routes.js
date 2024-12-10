import sql from 'mssql';
import { Router } from 'express';
import { pool } from '../db.js';

const router = Router();

router.post("/data", async (req, res) => {
  const { draw, start, length, search, order, columns, phone } = req.body;
  try {
    // Query total records
    const totalRecords = await pool
    .request()
    .input("ord_id", sql.Char, `${search.value}`)
    .input("phone", sql.Char, phone)
    .query("SELECT COUNT(*) AS total FROM Tuyen r, DonHang o WHERE r.donHang = o.maDonHang AND o.nguoiTaoDon = @phone");
    // Query filtered records
    const filteredRecords = await pool
    .request()
    .input("phone", sql.Char, phone)
    .input("ord_id", sql.NVarChar, `%${search.value}`)
    .query(
      "SELECT COUNT(*) AS total FROM Tuyen r, DonHang o WHERE r.donHang = o.maDonHang AND o.maDonHang LIKE @ord_id AND o.nguoiTaoDon = @phone"
    );

    const data = await pool.request()
    .input("user", sql.Char, phone)
    .input("searchValue", sql.NVarChar, `%${search.value}%`)
    .input("length", sql.Int, length)
    .input("start", sql.Int, start)
    .input("order", sql.NVarChar, columns[order[0].column].data)
    .input("dir", sql.NVarChar, order[0].dir)
    .query("SELECT r.stt, r.tinhBD, r.huyenBD, r.xaBD, r.chiTietBD, r.tinhKT, r.huyenKT, r.xaKT, r.chiTietKT, r.tinhTrang, r.quangDuong \
      FROM Tuyen r INNER JOIN DonHang o ON  r.donHang = o.maDonHang\
      WHERE o.nguoiTaoDon = @user AND o.maDonHang LIKE @searchValue \
      ORDER BY " + columns[order[0].column].data + " " + order[0].dir + " OFFSET @start ROWS FETCH NEXT @length ROWS ONLY");

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


export default router;