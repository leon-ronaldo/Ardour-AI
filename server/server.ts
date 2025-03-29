// Basic Express.js server
import express, { Request, Response } from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
// import connectDb from './config/dbConnection';

const app = express();

// DB config
// connectDb(); // Uncomment this after adding connection to DB

// Middleware
app.use(express.json());
import UserRoutes from './routes/UserRoutes';
app.use('/User', UserRoutes);



// Routes (Add your routes here)
// Example: app.use('/api', require('./routes/apiRoutes'));

// Server starting
app.get('/', (req: Request, res: Response) => {
    res.sendFile(path.join(process.cwd(), 'index.html')); // Adjust the path to match your file's location
});

// Start the server
const PORT = 8055;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});