import express from 'express';
import sql from 'mssql';

const router = express.Router();

// Mssql connection
const config = {
  user: 'sa',
  password: '12345Qwerty@',
  server: 'localhost',
  port: 1433,
  database: 'delivery',
  options: {
    encrypt: true, // or false depending on your setup
    trustServerCertificate: true, // Allow untrusted SSL certificates
  }
};

let pool;

sql.connect(config).then(p => {
  pool = p;
  console.log('Database connected');
}).catch(err => {
  console.error('Database connection test query error:', err);
});

router.post('/data', async (req, res) => {
  console.log(req.body);
  const { draw, start, length, search, order, columns } = req.body;
  try {
    // Query total records
    const totalRecords = await pool.request().query('SELECT COUNT(*) AS total FROM DonHang');
    // Query filtered records
    const filteredRecords = await pool.request()
      .input('searchValue', sql.NVarChar, `%${search.value}%`)
      .query('SELECT COUNT(*) AS total FROM DonHang WHERE maDonHang LIKE @searchValue');
    // Query records
    const data = await pool.request()
      .input('searchValue', sql.NVarChar, `%${search.value}%`)
      .input('length', sql.Int, length)
      .input('start', sql.Int, start)
      .query(
        `SELECT * FROM DonHang WHERE maDonHang LIKE @searchValue 
        ORDER BY ${columns[order[0].column].data} ${order[0].dir} 
        OFFSET @start ROWS FETCH NEXT @length ROWS ONLY`
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
    res.status(500).send('Internal Server Error');
  }
});


export default router;
