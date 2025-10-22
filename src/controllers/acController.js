const express = require('express');
const router = express.Router();
const { sendCommandToDevice } = require('../websocket/wsServer');

// Store connected devices (in production, use Redis or database)
const connectedDevices = new Map();

/**
 * POST /api/ac/temperature
 * Set AC temperature
 */
router.post('/temperature', async (req, res) => {
  try {
    const { temperature, deviceId } = req.body;

    // Validate temperature
    if (!temperature || temperature < 16 || temperature > 30) {
      return res.status(400).json({
        success: false,
        error: 'Temperature must be between 16 and 30 degrees'
      });
    }

    // Prepare command
    const command = {
      type: 'SET_TEMPERATURE',
      temperature: parseInt(temperature),
      timestamp: new Date().toISOString()
    };

    // Send command to mobile device via WebSocket
    const result = await sendCommandToDevice(deviceId, command);

    if (result.success) {
      res.json({
        success: true,
        message: `Temperature set to ${temperature}°C`,
        command: command
      });
    } else {
      res.status(500).json({
        success: false,
        error: result.error || 'Failed to send command to device'
      });
    }
  } catch (error) {
    console.error('Error setting temperature:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * POST /api/ac/power
 * Turn AC on/off
 */
router.post('/power', async (req, res) => {
  try {
    const { power, deviceId } = req.body;

    if (typeof power !== 'boolean') {
      return res.status(400).json({
        success: false,
        error: 'Power must be true (on) or false (off)'
      });
    }

    const command = {
      type: 'SET_POWER',
      power: power,
      timestamp: new Date().toISOString()
    };

    const result = await sendCommandToDevice(deviceId, command);

    if (result.success) {
      res.json({
        success: true,
        message: `AC turned ${power ? 'ON' : 'OFF'}`,
        command: command
      });
    } else {
      res.status(500).json({
        success: false,
        error: result.error || 'Failed to send command to device'
      });
    }
  } catch (error) {
    console.error('Error setting power:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * POST /api/ac/mode
 * Set AC mode (cool, heat, fan, dry, auto)
 */
router.post('/mode', async (req, res) => {
  try {
    const { mode, deviceId } = req.body;
    const validModes = ['cool', 'heat', 'fan', 'dry', 'auto'];

    if (!validModes.includes(mode?.toLowerCase())) {
      return res.status(400).json({
        success: false,
        error: `Mode must be one of: ${validModes.join(', ')}`
      });
    }

    const command = {
      type: 'SET_MODE',
      mode: mode.toLowerCase(),
      timestamp: new Date().toISOString()
    };

    const result = await sendCommandToDevice(deviceId, command);

    if (result.success) {
      res.json({
        success: true,
        message: `AC mode set to ${mode}`,
        command: command
      });
    } else {
      res.status(500).json({
        success: false,
        error: result.error || 'Failed to send command to device'
      });
    }
  } catch (error) {
    console.error('Error setting mode:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * GET /api/ac/devices
 * List connected devices
 */
router.get('/devices', (req, res) => {
  const { getConnectedDevices } = require('../websocket/wsServer');
  const devices = getConnectedDevices();
  
  res.json({
    success: true,
    deviceCount: devices.length,
    devices: devices
  });
});

module.exports = router;
