// Basic Express.js server
const express = require('express');
const app = express();
const path = require("path");
const connectDb = require("./config/dbConnection");

//db config
// connectDb(); uncomment this after adding connection to DB

// Middleware
app.use(express.json());
app.use('/User', require('./routes/UserRoutes'));

// Routes (Add your routes here)
// Example: app.use('/api', require('./routes/apiRoutes'));

//server starting
app.get('/', (req, res) => {
    res.sendFile(path.join(process.cwd(), 'index.html')); // Adjust the path to match your file's location
});

// Start the server
const PORT = 8055;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});