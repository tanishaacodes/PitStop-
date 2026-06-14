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
 - Low Rating Alerts — Washrooms with an average rating below 2.0 are flagged with a warning badge showing the number of times they've been flagged





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

## Getting Started
## Prerequisites
- Node.js(v16 or higher)
- MySQL (v8 or higher)

## Installation 


### 1. Clone the repository
```bash
git clone https://github.com/tanishaacodes/PitStop-.git
cd PitStop-
```

### 2. Install dependencies
```bash
npm install
```

### 3. Set up the database
- Open MySQL and create a new database:
```bash
CREATE DATABASE pitstop;
```
- Import the provided SQL file:
```bash
mysql -u root -p pitstop < database_backup_updated.sql
```
### 4. Configure environment variables
Create a .env file in the root directory:
```bash
DB_HOST=localhost
DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password
DB_NAME=pitstop
```
(Create a folder in vscode named routes and add files named washrooms.js, users.js and ratings.js to it)

### 5. Start the server
```bash
node index.js
```
### 6. Open the app
Open index.html directly in your browser, or serve it locally.
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
  
