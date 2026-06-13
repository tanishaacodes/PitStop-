#  PitStop : Washroom Mapping & Management System
**Always a Clean Stop Ahead**
PitStop is a map-based washroom finder that helps users locate clean, safe, and verified washroom facilities across Mumbai and Pune. By partnering with private establishments like cafes, restaurants, and petrol pumps, PitStop provides access to reliable facilities with real-time ratings and reviews.It is a full-stack web application for discovering, rating, and managing public washrooms across Mumbai and Pune.

# Created by
- Tanisha Mavle 
- Praniti Patil
- Sejal Pawale

# Features 
 - Map View — Interactive map powered by Leaflet.js showing nearby washroom locations
 - Filters — Filter by city, status (open/closed/maintenance), and partner type
 - Ratings & Reviews — Rate washrooms on cleanliness, safety, and amenities
 - Accessibility Info — View wheelchair accessibility and baby-changing station availability
 - User Profiles — Track your rating history and activity
 - Authentication — Secure login and signup with password reset support






## Project Structure

```
pitstop/
├── index.js                     # Express server (serves HTML + API)
├── db.js                        # MySQL connection pool
├── index.html                   # Single-page frontend (Leaflet maps)
├── package.json
├── .env                         # Your local env vars (copy from .env.example)
├── .env.example
├── database_backup_updated.sql  # Clean DB — Mumbai & Pune only
└── routes/
    ├── washrooms.js             # GET /api/washrooms, GET /api/washrooms/:id
    ├── ratings.js               # GET /api/ratings/washroom/:id, POST /api/ratings
    └── users.js                 # register, login, forgot-password, activity
```

---

## ⚡ Quick Setup

### 1. Database
```bash
mysql -u root -p -e "CREATE DATABASE pitstop;"
mysql -u root -p pitstop < database_backup_updated.sql
```

### 2. Environment
```bash
cp .env.example .env
# Fill in your MySQL password in .env
```

### 3. Install & Run
```bash
npm install
node index.js
```

### 4. Open the App
Visit **http://localhost:3000** in your browser.



##  What's in the Database

| Table | Contents |
|---|---|
| cities | Mumbai (id=1) and Pune (id=2) only |
| washrooms | 6 real locations — partner_type: restaurant, cafe, petrol_pump |
| ratings | Sample ratings for washrooms 1 and 2 |
| users | 3 sample users |

**DB trigger** `trg_update_avg_rating` fires after every INSERT into `ratings` and automatically recalculates `washrooms.avg_rating`.






##  Tech Stack

- **Backend:** Node.js, Express 5, mysql2 (pool), dotenv, cors
- **Frontend:** JavaScript, Leaflet.js, HTML, CSS 
- **Database:** MySQL 9.x with trigger for auto avg_rating updates
  
