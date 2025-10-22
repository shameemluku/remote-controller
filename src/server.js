require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const acController = require('./controllers/acController');
const { initWebSocketServer } = require('./websocket/wsServer');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use('/api/ac', acController);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'IR Blast API is running' });
});

// Start HTTP Server and WebSocket Server on the same port
// Bind to 0.0.0.0 for Render.com compatibility
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 HTTP Server running on port ${PORT}`);
  console.log(`📡 Test at: http://localhost:${PORT}/health`);
});

// Start WebSocket Server using the same HTTP server
initWebSocketServer(server);
