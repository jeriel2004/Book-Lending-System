# 📚 Book Lending System  
### Internship Screening Project

A full-stack **Library Book Lending System** built from scratch using **Rust**, **SQLite**, and **plain HTML/JavaScript**, following strict constraints (**no web frameworks**) and focusing on correctness, security, and real-world backend design.

This project demonstrates **backend systems thinking**, **REST API design**, **database modeling**, and **role-based access control**.

---

## 🔍 Overview

This application implements a RESTful backend API and a simple HTML frontend for managing a library lending system.

It supports:
- Two user roles (**Admin** and **Lender**)
- Secure authentication
- Book inventory management
- Borrowing and returning workflows
- Administrative oversight including **overdue tracking**

The backend is implemented **without any web frameworks**, using **raw HTTP handling** to demonstrate low-level understanding of request routing, headers, and response construction.

---

## 🧱 Technology Stack

### Backend
- **Rust**
- **Hyper** (manual HTTP handling)
- **SQLx** (async database access)
- **SQLite**
- **bcrypt** (secure password hashing)
- **Serde / Serde JSON**
- **Chrono** (date & time handling)
- Manual **CORS** implementation

### Frontend
- Plain **HTML**
- **Vanilla JavaScript**
- Basic **CSS** (no frameworks)
- **Fetch API**
- `localStorage` for session token handling

> Frontend is intentionally minimal — **functionality over appearance**, as per instructions.

---

## 🔐 Security & Authentication

- Passwords are hashed using **bcrypt** before storage
- Plain-text passwords are **never stored**
- Token-based session management (**Bearer tokens**)
- Role-based authorization (**Admin vs Lender**)
- Protected admin-only routes
- Input validation and structured error handling for all endpoints

---

## ✨ Features Implemented

### 1️⃣ User Management
- User registration and login
- Two roles:
  - **Admin**
  - **Lender** (regular user)
- Secure password hashing (**bcrypt**)
- Session/token management
- Logout support

---

### 2️⃣ Book Management (Admin)
- Add new books
- View all books
- Track:
  - Title
  - Author
  - Available copies
- Automatic availability updates on borrow/return

---

### 3️⃣ Lending System
- Browse and search books
- Borrow books (only if available)
- Prevent duplicate borrowing
- Return borrowed books
- Due-date assignment
- Overdue detection
- Real-time availability tracking

---

### 4️⃣ Admin Dashboard
- View all users
- View all lending records
- View overdue books
- Real-time data refresh
- System-wide visibility
- Logout support

---

## 🌐 REST API Endpoints (Core)

### Authentication
- `POST /register`
- `POST /login`
- `DELETE /logout`

### Books
- `GET /books`
- `GET /books/search`
- `POST /admin/books` *(admin only)*

### Lending
- `POST /borrow`
- `POST /return`
- `GET /borrowed`

### Admin
- `GET /admin/users`
- `GET /admin/lendings`
- `GET /admin/overdue`

All responses use **proper HTTP status codes** and **JSON payloads**.

---

## 🗄️ Database Schema

### Users
- `id`
- `username`
- `password_hash`
- `role`

### Books
- `id`
- `title`
- `author`
- `available_copies`

### Lendings
- `id`
- `user_id`
- `book_id`
- `borrowed_at`
- `due_date`
- `returned`
- `returned_at`

### Sessions
- `user_id`
- `token`

---

## 🕒 Date & Time Handling

- Dates stored in **ISO format** in SQLite
- Converted and formatted in Rust using **chrono**
- Displayed as:
- dd/mm/yyyy hh:mm:ss


- Overdue detection is calculated **dynamically** based on the current system time

---

🧠 Design Decisions

This project intentionally avoids web frameworks to demonstrate raw HTTP handling and a clear understanding of low-level request routing and response construction.

SQLite was chosen for its portability, simplicity, and zero-configuration setup, making the application easy to run in any environment.

SQLx is used for asynchronous database access and compile-time checked SQL queries, reducing runtime errors and improving safety.

Routing is implemented manually to maintain explicit control over request handling and to keep the architecture transparent and easy to reason about.

The frontend is intentionally kept simple to emphasize backend correctness, security, and data integrity rather than UI polish.

Defensive error handling is implemented throughout the application to gracefully handle invalid input, failed database operations, and unauthorized access.

🏆 Bonus Considerations

The system uses efficient SQL queries with proper joins and filtering to minimize unnecessary database operations.

A clean separation of concerns is maintained between authentication, book management, lending logic, and admin functionality.

The handler structure is modular, making the codebase easier to maintain and extend.

Authentication and authorization logic is reusable and centralized to avoid duplication and security flaws.

The architecture is designed to be easily extensible, allowing new features or endpoints to be added with minimal refactoring.

🧑‍💻 Author

Jeriel Jasper S
Computer Science & Mathematics
Focus: Backend Systems, Rust, Databases, API Design

📝 Notes on AI Usage

AI tools were used responsibly for:

Syntax assistance

Debugging suggestions

Documentation refinement

All logic, architectural decisions, and final implementation were fully understood and validated.

## ⚙️ Setup Instructions
### 1️ Clone Repository
```bash
git clone https://github.com/your-username/book-lending-system.git
cd book-lending-system
2️⃣ Build Backend
cargo build
3️⃣ Run Server
cargo run
Server runs at:

http://127.0.0.1:3000
🧪 Testing Overdue Books
To manually test overdue logic in SQLite:

UPDATE lendings
SET due_date = datetime('now', '-1 minute')
WHERE returned = 0;
Then refresh the Overdue Books section in the admin dashboard.


View all users
SELECT id, username, role FROM users;

View all books
SELECT id, title, author, total_copies, available_copies FROM books;

View all lending records
SELECT * FROM lendings;

👤 USER TESTING
Check password hashes (should NOT be plain text)
SELECT username, password_hash FROM users;


If you see readable passwords — red flag 🚨
bcrypt hashes should look like $2b$12$...

📚 BOOK MANAGEMENT TESTS
Insert test books
INSERT INTO books (
  title, author, isbn, year, genre, total_copies, available_copies
) VALUES
('Clean Code', 'Robert C. Martin', '9780132350884', 2008, 'Programming', 5, 5),
('The Pragmatic Programmer', 'Andrew Hunt', '9780201616224', 1999, 'Programming', 3, 3),
('Rust in Action', 'Tim McNamara', '9781617294556', 2021, 'Programming', 4, 4);

Verify insertion
SELECT * FROM books;

🔄 LENDING FLOW TESTS
Simulate borrowing a book
INSERT INTO lendings (
  user_id, book_id, borrowed_at, due_date, returned
)
VALUES (
  1,
  1,
  datetime('now'),
  datetime('now', '+7 days'),
  0
);

Decrease available copies (should match backend logic)
UPDATE books
SET available_copies = available_copies - 1
WHERE id = 1;

Check lending status
SELECT
  l.id,
  u.username,
  b.title,
  l.borrowed_at,
  l.due_date,
  l.returned
FROM lendings l
JOIN users u ON l.user_id = u.id
JOIN books b ON l.book_id = b.id;

🔁 RETURN BOOK TEST
Mark book as returned
UPDATE lendings
SET returned = 1,
    returned_at = datetime('now')
WHERE id = 1;

Restore available copies
UPDATE books
SET available_copies = available_copies + 1
WHERE id = 1;

⏰ OVERDUE TESTING (CRITICAL)
Force overdue (1 minute in the past)
UPDATE lendings
SET due_date = datetime('now', '-1 minute')
WHERE returned = 0;

Find overdue books
SELECT
  l.id,
  u.username,
  b.title,
  l.due_date
FROM lendings l
JOIN users u ON l.user_id = u.id
JOIN books b ON l.book_id = b.id
WHERE l.returned = 0
  AND l.due_date < datetime('now');


If this returns rows → overdue logic works ✅

🔎 SEARCH TESTS
Search books by title
SELECT * FROM books
WHERE title LIKE '%Rust%';

Search by author
SELECT * FROM books
WHERE author LIKE '%Martin%';

👑 ADMIN DASHBOARD QUERIES
View all users
SELECT id, username, role FROM users;

View all active lendings
SELECT
  l.id,
  u.username,
  b.title,
  l.borrowed_at,
  l.due_date
FROM lendings l
JOIN users u ON l.user_id = u.id
JOIN books b ON l.book_id = b.id
WHERE l.returned = 0;

View overdue lendings
SELECT
  u.username,
  b.title,
  l.due_date
FROM lendings l
JOIN users u ON l.user_id = u.id
JOIN books b ON l.book_id = b.id
WHERE l.returned = 0
  AND l.due_date < datetime('now');
---


