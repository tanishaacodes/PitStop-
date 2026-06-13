const express = require('express');
const router  = express.Router();
const db      = require('../db');

// POST /api/users/register
router.post('/register', (req, res) => {
  const { name, email, phone, city, password } = req.body;
  if (!name || !email || !password || !city) {
    return res.status(400).json({ error: 'Name, email, password and city are required' });
  }
  if (password.length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters' });
  }

  db.query('SELECT user_id FROM users WHERE email = ?', [email], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (rows.length > 0) return res.status(400).json({ error: 'Email already registered' });

    db.query(
      'INSERT INTO users (name, email, phone, city, password) VALUES (?, ?, ?, ?, ?)',
      [name, email, phone || null, city, password],
      (err2, result) => {
        if (err2) return res.status(500).json({ error: err2.message });
        res.json({
          message: 'Registered successfully!',
          user_id: result.insertId,
          name, email, phone: phone || null, city, is_verified: 0,
          join_date: new Date().toISOString()
        });
      }
    );
  });
});

// POST /api/users/login
router.post('/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  db.query('SELECT * FROM users WHERE email = ?', [email], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (rows.length === 0) return res.status(404).json({ error: 'No account found. Please sign up first.' });

    const user = rows[0];
    if (user.password !== password) return res.status(401).json({ error: 'Incorrect password' });

    // Never send the password to the client
    const { password: _pw, ...safeUser } = user;
    res.json({ message: 'Login successful!', user: safeUser });
  });
});

// POST /api/users/forgot-password
router.post('/forgot-password', (req, res) => {
  const { email, newPassword } = req.body;
  if (!email || !newPassword) {
    return res.status(400).json({ error: 'Email and new password are required' });
  }
  if (newPassword.length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters' });
  }

  db.query('SELECT user_id FROM users WHERE email = ?', [email], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    if (rows.length === 0) return res.status(404).json({ error: 'No account found with this email' });

    db.query('UPDATE users SET password = ? WHERE email = ?', [newPassword, email], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ message: 'Password reset successfully!' });
    });
  });
});

// GET /api/users/:id/activity  — must come BEFORE /:id
router.get('/:id/activity', (req, res) => {
  const sql = `
    SELECT r.rating_id, r.cleanliness, r.safety, r.amenities,
           r.review_text, r.timestamp,
           w.address, w.partner_type, w.status, w.avg_rating
    FROM   ratings r
    JOIN   washrooms w ON r.washroom_id = w.washroom_id
    WHERE  r.user_id = ?
    ORDER  BY r.timestamp DESC
  `;
  db.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// GET /api/users/:id
router.get('/:id', (req, res) => {
  db.query(
    'SELECT user_id, name, email, phone, city, join_date, is_verified FROM users WHERE user_id = ?',
    [req.params.id],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      if (rows.length === 0) return res.status(404).json({ error: 'User not found' });
      res.json(rows[0]);
    }
  );
});

// GET /api/users (admin use)
router.get('/', (req, res) => {
  db.query(
    'SELECT user_id, name, email, phone, city, join_date, is_verified FROM users',
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

module.exports = router;
