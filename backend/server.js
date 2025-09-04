const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { Server } = require('socket.io');
const http = require('http');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*", methods: ["GET", "POST"] }
});

const touristRoutes = require('./routes/tourists');
const alertRoutes = require('./routes/alerts').router;
const iotRoutes = require('./routes/iot')(io);


// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// MongoDB Connection
(async () => {
  const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/tourist_safety';
  try {
    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('MongoDB connected');
  } catch (err) {
    console.error('MongoDB connection failed:', err.message);
    console.error('API will continue running; database-dependent routes may fail until DB is available.');
  }
})();

mongoose.connection.on('error', (err) => {
  console.error('MongoDB error:', err.message);
});

// Routes
app.use('/api/tourists', touristRoutes);
app.use('/api/alerts', alertRoutes);
app.use('/api/iot', iotRoutes);

// WebSocket handling
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  socket.on('join_dashboard', () => {
    socket.join('dashboard');
  });

  socket.on('join_tourist', (digitalId) => {
    socket.join(`tourist_${digitalId}`);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, error: 'Something went wrong!' });
});

// Export io for use in routes
app.set('io', io);

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Tourist Safety Platform API running on port ${PORT}`);
});

module.exports = { app, io };