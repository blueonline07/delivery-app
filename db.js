import sql from "mssql";

// Mssql connection
const config = {
  user: "sa",
  password: "12345Qwerty@",
  server: "10.0.16.149",
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

export { pool };