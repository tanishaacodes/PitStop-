# 🚻 PitStop – Washroom Mapping & Management System

**Always a Clean Stop Ahead**

PitStop is a full-stack web application for discovering, rating, and managing public washrooms across Mumbai and Pune.

---

## 📁 Project Structure

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

---

## 🗄️ What's in the Database

| Table | Contents |
|---|---|
| cities | Mumbai (id=1) and Pune (id=2) only |
| washrooms | 6 real locations — partner_type: restaurant, cafe, petrol_pump |
| ratings | Sample ratings for washrooms 1 and 2 |
| users | 3 sample users |

**DB trigger** `trg_update_avg_rating` fires after every INSERT into `ratings` and automatically recalculates `washrooms.avg_rating`.

---

## 🔌 API Reference

### Washrooms
| Method | Endpoint | Query params |
|---|---|---|
| GET | `/api/washrooms` | `city_id`, `status`, `partner_type`, `accessibility` |
| GET | `/api/washrooms/:id` | — |

### Ratings
| Method | Endpoint | Body |
|---|---|---|
| GET | `/api/ratings/washroom/:id` | — |
| POST | `/api/ratings` | `user_id`, `washroom_id`, `cleanliness`, `safety`, `amenities`, `review_text?` |

### Users
| Method | Endpoint | |
|---|---|---|
| POST | `/api/users/register` | `name`, `email`, `password`, `city`, `phone?` |
| POST | `/api/users/login` | `email`, `password` |
| POST | `/api/users/forgot-password` | `email`, `newPassword` |
| GET | `/api/users/:id` | — |
| GET | `/api/users/:id/activity` | — |

---

## 🛠️ Tech Stack

- **Backend:** Node.js, Express 5, mysql2 (pool), dotenv, cors
- **Frontend:** Vanilla JS, Leaflet.js, Google Fonts (Syne + DM Sans)
- **Database:** MySQL 9.x with trigger for auto avg_rating updates
