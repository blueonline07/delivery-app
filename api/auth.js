import express from 'express';
import sql from 'mssql';
import { pool } from '../db.js';
import crypto, { hash } from 'crypto';

const secret = 'haha'

const router = express.Router();

function hashPasswordSQLStyle(password, secret) {
  // Use UTF-16LE encoding to match SQL Server's NVARCHAR
  const combined = Buffer.from(password + secret, 'utf16le');
  return crypto.createHash('sha256').update(combined).digest('hex');
}

router.post('', async (req, res) => {
  const { phone, password } = req.body;
  try {
    const hash = hashPasswordSQLStyle(password, secret);
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
