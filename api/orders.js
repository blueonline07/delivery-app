import express from "express";
import sql from "mssql";

const router = express.Router();

// Mssql connection
const config = {
  user: "sa",
  password: "12345Qwerty@",
  server: "localhost",
  port: 1433,
  database: "delivery",
  options: {
    encrypt: true, // or false depending on your setup
    trustServerCertificate: true, // Allow untrusted SSL certificates
  },
};

let pool;

sql
  .connect(config)
  .then((p) => {
    pool = p;
    console.log("Database connected");
  })
  .catch((err) => {
    console.error("Database connection test query error:", err);
  });

router.post("/data", async (req, res) => {
  const { draw, start, length, search, order, columns } = req.body;
  console.log(req.body);
  try {
    // Query total records
    const totalRecords = await pool
      .request()
      .query("SELECT COUNT(*) AS total FROM DonHang");
    // Query filtered records
    const filteredRecords = await pool
      .request()
      .input("searchValue", sql.NVarChar, `%${search.value}%`)
      .query(
        "SELECT COUNT(*) AS total FROM DonHang WHERE maDonHang LIKE @searchValue"
      );
    // Query records
    const data = await pool
      .request()
      .input("searchValue", sql.NVarChar, `%${search.value}%`)
      .input("length", sql.Int, length)
      .input("start", sql.Int, start)
      .input("order", sql.NVarChar, columns[order[0].column].data)
      .input("dir", sql.NVarChar, order[0].dir)
      .query(
        'EXEC fetch_orders @searchValue, @start, @length, @order, @dir'
      );
    // Respond to DataTables
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

router.post("/create", async (req, res) => {
  const { hoTenNguoiNhan, sdtNguoiNhan, tinh, huyen, xa, chiTiet } = req.body;
  console.log(req.body);
  try {
    const { recordset } = await pool
      .request()
      .input("sdtNguoiGui", sql.NVarChar, '0123456789')
      .input("hoTenNguoiNhan", sql.NVarChar, hoTenNguoiNhan)
      .input("sdtNguoiNhan", sql.NVarChar, sdtNguoiNhan)
      .input("tinh", sql.NVarChar, tinh)
      .input("huyen", sql.NVarChar, huyen)
      .input("xa", sql.NVarChar, xa)
      .input("chiTiet", sql.NVarChar, chiTiet)
      .query(
        "EXEC insert_order @sdtNguoiGui, @sdtNguoiNhan, @hoTenNguoiNhan, @tinh, @huyen, @xa, @chiTiet"
      );
    res.status(201).json({ message: "Order added successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

export default router;
