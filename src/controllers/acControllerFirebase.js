const express = require('express');
const router = express.Router();
const {
  sendCommand,
  getMostRecentDevice,
  getOnlineDevices,
  getCommandHistory,
  getCommandStatus
} = require('../firebase/database');

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

    // Get target device
    let targetDeviceId = deviceId;
    if (!targetDeviceId) {
      const recentDevice = await getMostRecentDevice();
      if (!recentDevice) {
        return res.status(404).json({
          success: false,
          error: 'No online devices found'
        });
      }
      targetDeviceId = recentDevice.deviceId;
    }

    // Prepare command
    const command = {
      type: 'SET_TEMPERATURE',
      temperature: parseInt(temperature)
    };

    // Send command via Firebase
    const result = await sendCommand(targetDeviceId, command);

    res.json({
      success: true,
      message: `Temperature set to ${temperature}°C`,
      deviceId: targetDeviceId,
      commandId: result.commandId,
      command: result.command
    });
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
        error: 'Power must be true or false'
      });
    }

    // Get target device
    let targetDeviceId = deviceId;
    if (!targetDeviceId) {
      const recentDevice = await getMostRecentDevice();
      if (!recentDevice) {
        return res.status(404).json({
          success: false,
          error: 'No online devices found'
        });
      }
      targetDeviceId = recentDevice.deviceId;
    }

    // Prepare command
    const command = {
      type: 'SET_POWER',
      power: power
    };

    // Send command via Firebase
    const result = await sendCommand(targetDeviceId, command);

    res.json({
      success: true,
      message: `AC power ${power ? 'ON' : 'OFF'}`,
      deviceId: targetDeviceId,
      commandId: result.commandId,
      command: result.command
    });
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
    if (!mode || !validModes.includes(mode.toLowerCase())) {
      return res.status(400).json({
        success: false,
        error: `Mode must be one of: ${validModes.join(', ')}`
      });
    }

    // Get target device
    let targetDeviceId = deviceId;
    if (!targetDeviceId) {
      const recentDevice = await getMostRecentDevice();
      if (!recentDevice) {
        return res.status(404).json({
          success: false,
          error: 'No online devices found'
        });
      }
      targetDeviceId = recentDevice.deviceId;
    }

    // Prepare command
    const command = {
      type: 'SET_MODE',
      mode: mode.toLowerCase()
    };

    // Send command via Firebase
    const result = await sendCommand(targetDeviceId, command);

    res.json({
      success: true,
      message: `AC mode set to ${mode.toUpperCase()}`,
      deviceId: targetDeviceId,
      commandId: result.commandId,
      command: result.command
    });
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
 * Get all connected devices
 */
router.get('/devices', async (req, res) => {
  try {
    const devices = await getOnlineDevices();
    
    res.json({
      success: true,
      count: devices.length,
      devices: devices
    });
  } catch (error) {
    console.error('Error getting devices:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * GET /api/ac/commands/:deviceId
 * Get command history for a device
 */
router.get('/commands/:deviceId', async (req, res) => {
  try {
    const { deviceId } = req.params;
    const limit = parseInt(req.query.limit) || 50;
    
    const history = await getCommandHistory(deviceId, limit);
    
    res.json({
      success: true,
      deviceId: deviceId,
      count: history.length,
      commands: history
    });
  } catch (error) {
    console.error('Error getting command history:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * GET /api/ac/commands/:deviceId/:commandId
 * Get status of a specific command
 */
router.get('/commands/:deviceId/:commandId', async (req, res) => {
  try {
    const { deviceId, commandId } = req.params;
    
    const result = await getCommandStatus(deviceId, commandId);
    
    res.json({
      success: true,
      deviceId: deviceId,
      commandId: commandId,
      ...result
    });
  } catch (error) {
    console.error('Error getting command status:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

module.exports = router;
