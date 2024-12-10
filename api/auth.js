import express from 'express';
import sql from 'mssql';
import { pool } from '../db.js';
import crypto from 'crypto';


const router = express.Router();

router.post('', async (req, res) => {
  const { phone, password } = req.body;
  try {

    const hash = crypto.createHash('sha256').update(password).digest('hex');
    console.log(hash)
    const { recordset } = await pool
      .request()
      .input('sdt', sql.NVarChar, phone)
      .input('matKhau', sql.NVarChar, hash)
      .query('SELECT * FROM NguoiDung WHERE sdt = @sdt AND matKhau = @matKhau');
    if (recordset.length === 0) {
      return res.status(400).json({ message: 'Invalid phone or password' });
    }
    res.status(200).json({ message: 'Login successful', name: recordset[0].hoTen });
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

export default router;
