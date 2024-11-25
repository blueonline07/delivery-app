import express from 'express';

const app = express();
const port = 3000;

// Middleware
app.use(express.static('views'));

// app.get('/', (req, res) => {
//   res.sendFile('index.html');
// });

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
