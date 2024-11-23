const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// PostgreSQL Connection Pool
const pool = new Pool({
  user: 'ldkhang', // Replace with your PostgreSQL username
  host: 'localhost', // Replace with your host
  database: 'test', // Replace with your database name
  password: '1201', // Replace with your PostgreSQL password
  port: 5432, // Default PostgreSQL port
});

// Server-side processing route
app.post('/api/data', async (req, res) => {
  console.log(req.body);
  const { draw, start, length, search, order, columns } = req.body;
  try {
    // Query total records
    const totalRecords = await pool.query('SELECT COUNT(*) AS total FROM users');
    // Query filtered records
    const filteredRecords = await pool.query('SELECT COUNT(*) AS total FROM users WHERE name ILIKE $1', [`%${search.value}%`]);
    // Query records
    const data = await pool.query(
      `SELECT * FROM users WHERE name ILIKE $1 OR country ILIKE $1 OR role ILIKE $1 ORDER BY ${columns[order[0].column].data} ${order[0].dir} LIMIT $2 OFFSET $3 `,
      [`%${search.value}%`, length, start]
    );
    // Respond to DataTables
    res.json({
      draw,
      recordsTotal: totalRecords.rows[0].total,
      recordsFiltered: filteredRecords.rows[0].total,
      data: data.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
