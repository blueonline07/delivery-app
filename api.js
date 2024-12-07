import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import OrderRouter from './api/orders.js';
import AuthRouter from './api/auth.js';

const app = express();
const port = 8080;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use('/api/orders', OrderRouter);
app.use('/api/login', AuthRouter);

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});