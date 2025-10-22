require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { initializeFirebase } = require('./firebase/firebaseConfig');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Initialize Firebase
const firebaseApp = initializeFirebase();

if (!firebaseApp) {
  console.error('❌ Failed to start server: Firebase initialization failed');
  console.log('\n📝 Setup Instructions:');
  console.log('1. Go to Firebase Console: https://console.firebase.google.com/');
  console.log('2. Create a new project or select existing one');
  console.log('3. Go to Project Settings → Service Accounts');
  console.log('4. Click "Generate new private key"');
  console.log('5. Save the JSON file as "firebase-service-account.json" in project root');
  console.log('6. Create .env file with: FIREBASE_DATABASE_URL=https://your-project.firebaseio.com\n');
  process.exit(1);
}

// Routes
const acController = require('./controllers/acControllerFirebase');
app.use('/api/ac', acController);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    firebase: 'connected',
    message: 'IR Blast API is running with Firebase'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'IR Blast API with Firebase',
    version: '2.0.0',
    endpoints: {
      health: 'GET /health',
      setTemperature: 'POST /api/ac/temperature',
      setPower: 'POST /api/ac/power',
      setMode: 'POST /api/ac/mode',
      getDevices: 'GET /api/ac/devices',
      getCommandHistory: 'GET /api/ac/commands/:deviceId',
      getCommandStatus: 'GET /api/ac/commands/:deviceId/:commandId'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({
    success: false,
    error: err.message || 'Internal server error'
  });
});

// Start server
app.listen(PORT, () => {
  console.log('');
  console.log('🔥 ===============================================');
  console.log('🔥  IR Blast API with Firebase');
  console.log('🔥 ===============================================');
  console.log(`🚀 HTTP Server running on port ${PORT}`);
  console.log(`📡 Test at: http://localhost:${PORT}/health`);
  console.log(`🔥 Firebase Realtime Database connected`);
  console.log('🔥 ===============================================');
  console.log('');
  console.log('📱 Mobile devices will connect via Firebase SDK');
  console.log('📝 API Endpoints:');
  console.log(`   POST   http://localhost:${PORT}/api/ac/temperature`);
  console.log(`   POST   http://localhost:${PORT}/api/ac/power`);
  console.log(`   POST   http://localhost:${PORT}/api/ac/mode`);
  console.log(`   GET    http://localhost:${PORT}/api/ac/devices`);
  console.log('');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🔌 Shutting down server...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🔌 Shutting down server...');
  process.exit(0);
});
