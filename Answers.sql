const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = 3000;

// Database connection
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Connect to the database
connection.connect(err => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the MySQL database');
});

// 1. Retrieve all patients
app.get('/patients', (req, res) => {
  const query = 'SELECT patient_id, first_name, last_name, date_of_birth FROM patients';
  connection.query(query, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// 2. Retrieve all providers
app.get('/providers', (req, res) => {
  const query = 'SELECT first_name, last_name, provider_specialty FROM providers';
  connection.query(query, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// 3. Filter patients by First Name
app.get('/patients/filter', (req, res) => {
  const firstName = req.query.first_name;
  const query = 'SELECT * FROM patients WHERE first_name = ?';
  connection.query(query, [firstName], (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// 4. Retrieve all providers by their specialty
app.get('/providers/filter', (req, res) => {
  const specialty = req.query.specialty;
  const query = 'SELECT * FROM providers WHERE provider_specialty = ?';
  connection.query(query, [specialty], (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// Listen to the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});


