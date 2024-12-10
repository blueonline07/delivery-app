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
    .query("SELECT COUNT(*) AS total FROM DonHang WHERE nguoiTaoDon = @phone");
    // Query filtered records
    const filteredRecords = await pool
    .request()
    .input("phone", sql.Char, phone)
    .input("searchValue", sql.NVarChar, `%${search.value}%`)
    .query(
      "SELECT COUNT(*) AS total FROM DonHang WHERE maDonHang LIKE @searchValue AND nguoiTaoDon = @phone"
    );

    const data = await pool
      .request()
      .input("user", sql.Char, phone)
      .input("searchValue", sql.NVarChar, `%${search.value}%`)
      .input("length", sql.Int, length)
      .input("start", sql.Int, start)
      .input("order", sql.NVarChar, columns[order[0].column].data)
      .input("dir", sql.NVarChar, order[0].dir)
      .query("EXEC fetch_orders @user, @searchValue, @start, @length, @order, @dir");

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

router.post("/", async (req, res) => {
  const { hoTenNguoiNhan, sdtNguoiNhan, tinh, huyen, xa, chiTiet, packages, phone } = req.body;
  try {

    const result = await pool
      .request()
      .input("sdtNguoiGui", sql.NVarChar, phone)
      .input("hoTenNguoiNhan", sql.NVarChar, hoTenNguoiNhan)
      .input("sdtNguoiNhan", sql.NVarChar, sdtNguoiNhan)
      .input("tinh", sql.NVarChar, tinh)
      .input("huyen", sql.NVarChar, huyen)
      .input("xa", sql.NVarChar, xa)
      .input("chiTiet", sql.NVarChar, chiTiet)
      .output("NewID", sql.NVarChar)
      .query(
        "EXEC insert_order @sdtNguoiGui, @sdtNguoiNhan, @hoTenNguoiNhan, @tinh, @huyen, @xa, @chiTiet, @NewID OUTPUT"
      );
    const newId = result.output.NewID;
    console.log(newId);
    packages.forEach(async (element) => {
      await pool
        .request()
        .input("description", sql.NVarChar, element.description)
        .input("weight", sql.Float, element.weight)
        .input("labels", sql.NVarChar, element.labels)
        .input("orderId", sql.NVarChar, newId)
        .query("EXEC add_pkg @orderId, @description, @weight, @labels");
    });
    
    console.log("HI")
    res.status(201).json({ message: "Order added successfully!" });
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
