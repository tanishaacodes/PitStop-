const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const washroomsRoute = require('./routes/washrooms');
const usersRoute     = require('./routes/users');
const ratingsRoute   = require('./routes/ratings');

const app = express();
app.use(cors());
app.use(express.json());

// Serve index.html at http://localhost:3000
app.use(express.static(__dirname));

app.use('/api/washrooms', washroomsRoute);
app.use('/api/users',     usersRoute);
app.use('/api/ratings',   ratingsRoute);

app.get('/health', (_req, res) => res.json({ status: 'ok' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`PitStop API running at http://localhost:${PORT}`);
});
