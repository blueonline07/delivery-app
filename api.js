import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import OrderRouter from './api/orders.js';

const app = express();
const port = 8000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use('/api/orders', OrderRouter);
app.post('/api/login', (req, res) => {
  console.log(req.body);
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});