import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import OrderRouter from './api/orders.js';
import AuthRouter from './api/auth.js';
import RouteRouter from './api/routes.js';

const app = express();
const port = 8080;

// // Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use('/api/orders', OrderRouter);
app.use('/api/login', AuthRouter);
app.use('/api/routes', RouteRouter);

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});