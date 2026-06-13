const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET all washrooms with optional filters
// Supported query params: city_id, status, partner_type, accessibility
router.get('/', (req, res) => {
  const { city_id, status, accessibility, partner_type } = req.query;

  let query  = 'SELECT * FROM washrooms WHERE 1=1';
  const params = [];

  if (city_id)      { query += ' AND city_id = ?';       params.push(city_id); }
  if (status)       { query += ' AND status = ?';         params.push(status); }
  if (accessibility){ query += ' AND accessibility = ?';  params.push(accessibility); }
  if (partner_type) { query += ' AND partner_type = ?';   params.push(partner_type); }

  query += ' ORDER BY avg_rating DESC';

  db.query(query, params, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// GET single washroom by ID
router.get('/:id', (req, res) => {
  db.query(
    'SELECT * FROM washrooms WHERE washroom_id = ?',
    [req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length === 0) return res.status(404).json({ error: 'Washroom not found' });
      res.json(results[0]);
    }
  );
});

module.exports = router;
