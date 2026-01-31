# -------------------------------
# PowerShell Script: Test Library Backend
# -------------------------------

# -------------------------------
# Helper: Print divider
function divider($text) {
    Write-Host "==================== $text ===================="
}

# -------------------------------
# 1️⃣ Register a new user
divider "Register User"
$registerBody = @{
    username = "admin"
    password = "pass123"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://127.0.0.1:3000/register `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $registerBody | ConvertTo-Json

# -------------------------------
# 2️⃣ Login
divider "Login"
$loginBody = @{
    username = "admin"
    password = "pass123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri http://127.0.0.1:3000/login `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $loginBody

$token = $response.token
Write-Host "Token:" $token

# -------------------------------
# 3️⃣ List books (should be empty initially)
divider "List Books"
Invoke-RestMethod -Uri http://127.0.0.1:3000/books -Method GET | ConvertTo-Json

# -------------------------------
# 4️⃣ Add a book (admin)
divider "Add Book"
$addBookBody = @{
    title = "Rust Book"
    author = "Steve"
    isbn = "12345"
    year = 2026
    genre = "Programming"
    total_copies = 5
} | ConvertTo-Json

Invoke-RestMethod -Uri http://127.0.0.1:3000/books `
    -Method POST `
    -Headers @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    } `
    -Body $addBookBody | ConvertTo-Json

# -------------------------------
# 5️⃣ Borrow a book
divider "Borrow Book"
$borrowBody = @{
    book_id = 1
    user_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri http://127.0.0.1:3000/borrow `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $borrowBody | ConvertTo-Json

# -------------------------------
# 6️⃣ Return a book
divider "Return Book"
$returnBody = @{
    book_id = 1
    user_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri http://127.0.0.1:3000/return `
    -Method POST `
    -Headers @{"Content-Type"="application/json"} `
    -Body $returnBody | ConvertTo-Json

# -------------------------------
# 7️⃣ Search books
divider "Search Books"
Invoke-RestMethod -Uri "http://127.0.0.1:3000/books/search?title=Rust&author=Steve" -Method GET | ConvertTo-Json

# -------------------------------
# 8️⃣ Admin: List Users
divider "Admin: List Users"
Invoke-RestMethod -Uri http://127.0.0.1:3000/admin/users `
    -Method GET `
    -Headers @{"Authorization" = "Bearer $token"} | ConvertTo-Json

# -------------------------------
# 9️⃣ Admin: List Lendings
divider "Admin: List Lendings"
Invoke-RestMethod -Uri http://127.0.0.1:3000/admin/lendings `
    -Method GET `
    -Headers @{"Authorization" = "Bearer $token"} | ConvertTo-Json

# -------------------------------
# 🔟 Admin: List Overdue
divider "Admin: List Overdue"
Invoke-RestMethod -Uri http://127.0.0.1:3000/admin/overdue `
    -Method GET `
    -Headers @{"Authorization" = "Bearer $token"} | ConvertTo-Json
