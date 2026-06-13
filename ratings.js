const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET all ratings for a specific washroom
router.get('/washroom/:id', (req, res) => {
  db.query(
    'SELECT * FROM ratings WHERE washroom_id = ? ORDER BY timestamp DESC',
    [req.params.id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// POST submit a new rating
// The DB trigger trg_update_avg_rating fires after INSERT and keeps
// washrooms.avg_rating in sync automatically.
router.post('/', (req, res) => {
  const { user_id, washroom_id, cleanliness, safety, amenities, review_text, photo_url } = req.body;

  if (!user_id || !washroom_id || cleanliness == null || safety == null || amenities == null) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const insertSQL = `
    INSERT INTO ratings (user_id, washroom_id, cleanliness, safety, amenities, review_text, photo_url)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    insertSQL,
    [user_id, washroom_id, cleanliness, safety, amenities, review_text || null, photo_url || null],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });

      // Fetch the freshly computed avg_rating from washrooms (updated by trigger)
      db.query(
        'SELECT avg_rating FROM washrooms WHERE washroom_id = ?',
        [washroom_id],
        (err2, rows) => {
          if (err2) return res.status(500).json({ error: err2.message });
          res.json({
            message:    'Rating submitted successfully!',
            rating_id:  result.insertId,
            avg_rating: rows[0]?.avg_rating ?? 0
          });
        }
      );
    }
  );
});

module.exports = router;
